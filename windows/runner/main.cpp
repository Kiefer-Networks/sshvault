#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <string>
#include <vector>

#include "crash_handler.h"
#include "flutter_window.h"
#include "utils.h"

namespace {

// Well-known mutex name used by the single-instance check. Bound to the app
// reverse-DNS identifier so it never collides with another app's mutex.
constexpr wchar_t kSingleInstanceMutexName[] =
    L"de.kiefer_networks.SSHVault.SingleInstance";

// Window class registered by `Win32Window::Create(L"sshvault", ...)`. The
// secondary instance uses this to find the first instance's HWND.
constexpr wchar_t kMainWindowClassName[] = L"sshvault";

// Custom WM_COPYDATA payload tag. Distinguishes our argv broadcast from any
// other WM_COPYDATA traffic the OS might route to the window.
constexpr ULONG_PTR kCopyDataMagic = 0x53534856;  // 'SSHV'

// Build a single space-separated UTF-16 argv string. Tokens that contain
// whitespace or quotes are wrapped in double quotes with embedded quotes
// escaped — symmetric with the argv parser on the Dart side.
std::wstring SerializeArgv(const std::wstring& command_line) {
  // The raw command line (as passed to wWinMain) already contains everything
  // we need, including original quoting. Forward it verbatim so the receiving
  // instance can apply its own argv splitter.
  return command_line;
}

// Forwards |argv| to the existing window via WM_COPYDATA, then raises it.
// Returns true on success.
bool ForwardToExistingInstance(const std::wstring& argv) {
  HWND hwnd = ::FindWindowW(kMainWindowClassName, nullptr);
  if (!hwnd) {
    return false;
  }

  // Raise the existing window before sending so the user perceives the launch
  // as instant. SW_RESTORE handles the case where the window is minimized.
  if (::IsIconic(hwnd)) {
    ::ShowWindow(hwnd, SW_RESTORE);
  } else {
    ::ShowWindow(hwnd, SW_SHOW);
  }
  ::SetForegroundWindow(hwnd);

  COPYDATASTRUCT cds = {};
  cds.dwData = kCopyDataMagic;
  // Size in bytes, including the trailing null so the receiver can treat the
  // payload as a null-terminated wide string.
  cds.cbData =
      static_cast<DWORD>((argv.size() + 1) * sizeof(wchar_t));
  cds.lpData = const_cast<wchar_t*>(argv.c_str());

  ::SendMessageW(hwnd, WM_COPYDATA, /*wParam=*/0,
                 reinterpret_cast<LPARAM>(&cds));
  return true;
}

}  // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // ── Crash-dump handler.
  //
  // Install the lightweight MiniDumpWriteDump-based unhandled-exception
  // filter as the very first thing we do — before COM init, before the
  // single-instance dance, before the Flutter engine is touched — so that
  // even early-boot crashes produce a .dmp under
  // %LOCALAPPDATA%\SSHVault\crashes that the user can email back for
  // debugging. The handler is delay-loaded (dbghelp.dll only enters the
  // process if a crash actually fires), so this call is essentially free
  // on the happy path.
  ::sshvault::InstallCrashHandler();

  // ── Single-instance enforcement.
  //
  // Create a named mutex; the call always succeeds, but GetLastError tells us
  // whether the mutex pre-existed. If it did, another SSHVault is already
  // running: forward our argv via WM_COPYDATA, raise the live window, and
  // exit cleanly without ever booting the Flutter engine a second time.
  HANDLE single_instance_mutex =
      ::CreateMutexW(nullptr, FALSE, kSingleInstanceMutexName);
  if (single_instance_mutex != nullptr &&
      ::GetLastError() == ERROR_ALREADY_EXISTS) {
    const std::wstring argv = SerializeArgv(command_line ? command_line : L"");
    ForwardToExistingInstance(argv);
    ::CloseHandle(single_instance_mutex);
    return EXIT_SUCCESS;
  }

  // Attach to console when present (e.g., 'flutter run' or launched from
  // cmd.exe) or create a new console when running with a debugger. In the
  // WINDOWS subsystem (Release) the process starts with no console, so when
  // there is no parent console to attach to we explicitly FreeConsole() to
  // make sure no stray console window is ever shown by Explorer launches.
  if (::AttachConsole(ATTACH_PARENT_PROCESS)) {
    // Successfully attached to the launching shell — leave it alone.
  } else if (::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  } else {
    ::FreeConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"sshvault", origin, size)) {
    if (single_instance_mutex != nullptr) {
      ::ReleaseMutex(single_instance_mutex);
      ::CloseHandle(single_instance_mutex);
    }
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();

  // Release the single-instance mutex so a subsequent launch can become the
  // primary instance.
  if (single_instance_mutex != nullptr) {
    ::ReleaseMutex(single_instance_mutex);
    ::CloseHandle(single_instance_mutex);
  }

  return EXIT_SUCCESS;
}
