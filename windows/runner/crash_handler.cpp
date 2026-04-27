// Implementation of the lightweight crash-dump handler — see crash_handler.h
// for design rationale and privacy notes.
//
// Strategy:
//   1. SetUnhandledExceptionFilter installs a single top-level SEH filter
//      that fires for any unhandled hardware/software exception (AV, /0,
//      stack overflow with reserved guard page, etc.). It runs on the
//      faulting thread.
//   2. The filter resolves the per-user crash folder
//      (%LOCALAPPDATA%\SSHVault\crashes), creates it if missing, builds a
//      timestamped filename, and asks dbghelp!MiniDumpWriteDump to write a
//      "small dump" (data segments + indirectly referenced memory) — that's
//      enough to recover a usable stack trace and locals without ballooning
//      file size.
//   3. We MUST avoid CRT allocations and complex C++ in here: by the time
//      the filter runs the heap may be corrupt. We stick to Win32 + the
//      faulting thread's own stack, and we use STATIC buffers for the
//      filename. dbghelp itself is delay-loaded so a normal launch never
//      pays its cost.
//   4. After the dump is written we lower the OS error UI and return
//      EXCEPTION_CONTINUE_SEARCH, which lets the default unhandled-exception
//      handler take over — typically Windows Error Reporting / the standard
//      "stopped working" dialog. This preserves the user-visible crash UX.
//
// We do not link dbghelp.lib directly; the function pointer is resolved with
// LoadLibrary/GetProcAddress in the filter so dbghelp.dll only enters the
// process if a crash actually happens.

#include "crash_handler.h"

#include <windows.h>

#include <dbghelp.h>
#include <shlobj.h>

#include <stdio.h>
#include <wchar.h>

namespace sshvault {

namespace {

// Function-pointer signature matches the public dbghelp prototype. We resolve
// it from dbghelp.dll at crash time rather than import-link the .lib, which
// would force eager loading of dbghelp on every launch.
using MiniDumpWriteDumpFn = BOOL(WINAPI*)(HANDLE hProcess, DWORD ProcessId,
                                          HANDLE hFile, MINIDUMP_TYPE DumpType,
                                          PMINIDUMP_EXCEPTION_INFORMATION ExceptionParam,
                                          PMINIDUMP_USER_STREAM_INFORMATION UserStreamParam,
                                          PMINIDUMP_CALLBACK_INFORMATION CallbackParam);

// %LOCALAPPDATA%\SSHVault\crashes — keep in sync with crash_dump_service.dart
// so the Dart "Open folder" / list APIs find the same files.
constexpr wchar_t kAppFolderName[] = L"SSHVault";
constexpr wchar_t kCrashSubfolder[] = L"crashes";

// Resolve %LOCALAPPDATA%\SSHVault\crashes into |out| (capacity |out_chars|),
// creating any missing directories. Returns false if the path can't be
// resolved or created. Uses only signal-safe Win32 APIs.
bool BuildCrashFolder(wchar_t* out, size_t out_chars) {
  wchar_t local_app_data[MAX_PATH] = {0};
  if (FAILED(::SHGetFolderPathW(nullptr, CSIDL_LOCAL_APPDATA, nullptr,
                                SHGFP_TYPE_CURRENT, local_app_data))) {
    return false;
  }

  // <LOCALAPPDATA>\SSHVault — ensure it exists.
  if (_snwprintf_s(out, out_chars, _TRUNCATE, L"%s\\%s", local_app_data,
                   kAppFolderName) < 0) {
    return false;
  }
  ::CreateDirectoryW(out, nullptr);  // ERROR_ALREADY_EXISTS is fine.

  // <LOCALAPPDATA>\SSHVault\crashes — ensure it exists too.
  if (_snwprintf_s(out, out_chars, _TRUNCATE, L"%s\\%s\\%s", local_app_data,
                   kAppFolderName, kCrashSubfolder) < 0) {
    return false;
  }
  ::CreateDirectoryW(out, nullptr);
  return true;
}

// Write a sortable timestamp YYYYMMDD-HHMMSS into |out|. Local time is fine
// here — the file lives on the user's disk and they read it themselves.
void FormatTimestamp(wchar_t* out, size_t out_chars) {
  SYSTEMTIME st = {};
  ::GetLocalTime(&st);
  _snwprintf_s(out, out_chars, _TRUNCATE,
               L"%04u%02u%02u-%02u%02u%02u",
               st.wYear, st.wMonth, st.wDay,
               st.wHour, st.wMinute, st.wSecond);
}

LONG WINAPI UnhandledExceptionFilter(EXCEPTION_POINTERS* exception_info) {
  // Build the target path: <crash_folder>\sshvault-<timestamp>.dmp.
  wchar_t crash_folder[MAX_PATH] = {0};
  if (!BuildCrashFolder(crash_folder, MAX_PATH)) {
    return EXCEPTION_CONTINUE_SEARCH;
  }

  wchar_t timestamp[32] = {0};
  FormatTimestamp(timestamp, sizeof(timestamp) / sizeof(wchar_t));

  wchar_t dump_path[MAX_PATH] = {0};
  if (_snwprintf_s(dump_path, MAX_PATH, _TRUNCATE,
                   L"%s\\sshvault-%s.dmp", crash_folder, timestamp) < 0) {
    return EXCEPTION_CONTINUE_SEARCH;
  }

  HANDLE file = ::CreateFileW(dump_path, GENERIC_WRITE, 0, nullptr,
                              CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
  if (file == INVALID_HANDLE_VALUE) {
    return EXCEPTION_CONTINUE_SEARCH;
  }

  // Resolve MiniDumpWriteDump from dbghelp.dll on demand. The link step uses
  // /DELAYLOAD:dbghelp.dll, but we still LoadLibrary explicitly so that even
  // if the delay-load thunk is skipped (e.g. dbghelp pre-loaded by a plugin)
  // we always end up with a valid HMODULE without throwing a delay-load
  // exception inside our own filter.
  HMODULE dbghelp = ::LoadLibraryW(L"dbghelp.dll");
  if (dbghelp == nullptr) {
    ::CloseHandle(file);
    return EXCEPTION_CONTINUE_SEARCH;
  }

  auto write_dump = reinterpret_cast<MiniDumpWriteDumpFn>(
      ::GetProcAddress(dbghelp, "MiniDumpWriteDump"));
  if (write_dump == nullptr) {
    ::CloseHandle(file);
    return EXCEPTION_CONTINUE_SEARCH;
  }

  MINIDUMP_EXCEPTION_INFORMATION mei = {};
  mei.ThreadId = ::GetCurrentThreadId();
  mei.ExceptionPointers = exception_info;
  mei.ClientPointers = FALSE;

  // Small dump: data segments give us module globals, indirectly referenced
  // memory pulls in objects pointed to from the captured stack/registers.
  // That combination is enough to recover a stack trace with locals, while
  // keeping dump size in the low MB range (vs hundreds of MB for a full
  // process snapshot).
  const MINIDUMP_TYPE dump_type = static_cast<MINIDUMP_TYPE>(
      MiniDumpWithDataSegs | MiniDumpWithIndirectlyReferencedMemory);

  write_dump(::GetCurrentProcess(), ::GetCurrentProcessId(), file, dump_type,
             exception_info ? &mei : nullptr, nullptr, nullptr);

  ::CloseHandle(file);
  // Intentionally leak |dbghelp| — we're in an unhandled-exception filter
  // about to terminate; FreeLibrary risks reentering CRT cleanup that may
  // already be unsafe.

  // Suppress the "no disk in drive" / critical-error popup so the only thing
  // the user sees is the standard Windows "stopped working" dialog produced
  // by the default handler.
  ::SetErrorMode(SEM_FAILCRITICALERRORS);

  // Returning CONTINUE_SEARCH lets the OS-default handler (Windows Error
  // Reporting) run, which preserves the user-visible crash UX. EXECUTE_HANDLER
  // would silently terminate the process — bad UX and confuses users into
  // thinking the app vanished.
  return EXCEPTION_CONTINUE_SEARCH;
}

}  // namespace

void InstallCrashHandler() {
  // Replace any previously-installed top-level filter. Returning the previous
  // pointer is intentional: we discard it because we want our handler to be
  // the single source of truth for crash dumps in this process.
  ::SetUnhandledExceptionFilter(&UnhandledExceptionFilter);
}

}  // namespace sshvault
