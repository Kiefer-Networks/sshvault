// Lightweight Windows crash-dump handler.
//
// Installs a top-level SEH (Structured Exception Handling) filter via
// SetUnhandledExceptionFilter(). When the app crashes, the filter writes a
// minidump file to %LOCALAPPDATA%\SSHVault\crashes\sshvault-<timestamp>.dmp
// using MiniDumpWriteDump from dbghelp.dll, then returns
// EXCEPTION_CONTINUE_SEARCH so the OS still surfaces the standard
// "<App> has stopped working" dialog.
//
// We deliberately do NOT bundle the full Crashpad library: a small SEH
// filter + MiniDumpWriteDump is enough to produce a dump the user can ZIP and
// email back for debugging, and it adds no measurable cold-start overhead
// because dbghelp.dll is delay-loaded.
//
// Privacy: the dump folder is per-user under %LOCALAPPDATA%. Nothing is ever
// uploaded; the app provides only "Open folder" and "Delete all" actions in
// the Settings → About screen.

#ifndef RUNNER_CRASH_HANDLER_H_
#define RUNNER_CRASH_HANDLER_H_

namespace sshvault {

// Installs the unhandled-exception filter. Safe to call once at process
// startup, ideally before any other initialization (COM, Flutter engine, …)
// so that early-boot crashes are also captured.
void InstallCrashHandler();

}  // namespace sshvault

#endif  // RUNNER_CRASH_HANDLER_H_
