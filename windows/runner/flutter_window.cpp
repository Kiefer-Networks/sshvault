#include "flutter_window.h"

#include <optional>
#include <string>
#include <vector>

#include <shellapi.h>
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"

namespace {

// Channel name shared with `lib/core/services/file_drop_service.dart`.
constexpr const char kDropChannelName[] = "de.kiefer_networks.sshvault/drop";

// Channel name shared with `lib/core/services/windows_instance_service.dart`.
// Receives `onSecondInstance(List<String> argv)` whenever a duplicate
// sshvault.exe forwards its argv to us via WM_COPYDATA.
constexpr const char kInstanceChannelName[] =
    "de.kiefer_networks.sshvault/instance";

// Magic identifier set on the COPYDATASTRUCT.dwData field by the secondary
// instance in `main.cpp`. Distinguishes our argv broadcast from any other
// WM_COPYDATA traffic the OS might route to the window.
constexpr ULONG_PTR kCopyDataMagic = 0x53534856;  // 'SSHV'

// UTF-16 -> UTF-8 conversion for shell-supplied paths.
std::string Utf16ToUtf8(const std::wstring& w) {
  if (w.empty()) return std::string();
  const int needed = ::WideCharToMultiByte(CP_UTF8, 0, w.data(),
                                           static_cast<int>(w.size()), nullptr,
                                           0, nullptr, nullptr);
  if (needed <= 0) return std::string();
  std::string out(static_cast<size_t>(needed), '\0');
  ::WideCharToMultiByte(CP_UTF8, 0, w.data(), static_cast<int>(w.size()),
                        out.data(), needed, nullptr, nullptr);
  return out;
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  // Method channel used to forward argv from a secondary sshvault.exe launch
  // into Dart. Constructed here (after the engine is up) so the Dart-side
  // listener — which is wired right after `runApp` — has a live channel by
  // the time the first WM_COPYDATA arrives.
  instance_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), kInstanceChannelName,
          &flutter::StandardMethodCodec::GetInstance());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  // Enable classic Win32 drag-and-drop. This delivers WM_DROPFILES with a
  // shell-managed HDROP that we unpack in MessageHandler.
  ::DragAcceptFiles(GetHandle(), TRUE);

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }
  instance_channel_ = nullptr;

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
    case WM_COPYDATA: {
      // Single-instance forwarding from a second sshvault.exe launch. The
      // payload is a null-terminated UTF-16 command-line string tagged with
      // our magic identifier so we don't react to unrelated WM_COPYDATA
      // traffic delivered to this HWND.
      auto* cds = reinterpret_cast<COPYDATASTRUCT*>(lparam);
      if (cds == nullptr || cds->dwData != kCopyDataMagic ||
          cds->lpData == nullptr || cds->cbData < sizeof(wchar_t)) {
        break;
      }

      // Bound the read to the buffer size and stop at the first embedded
      // null. Defensive: a malformed sender shouldn't crash the primary.
      const wchar_t* raw = static_cast<const wchar_t*>(cds->lpData);
      const size_t max_chars = cds->cbData / sizeof(wchar_t);
      std::wstring command_line;
      command_line.reserve(max_chars);
      for (size_t i = 0; i < max_chars; ++i) {
        if (raw[i] == L'\0') break;
        command_line.push_back(raw[i]);
      }

      // Raise our window so the user sees the result of the second launch.
      if (::IsIconic(hwnd)) {
        ::ShowWindow(hwnd, SW_RESTORE);
      } else {
        ::ShowWindow(hwnd, SW_SHOW);
      }
      ::SetForegroundWindow(hwnd);

      // Split into argv tokens. The first token is the executable path;
      // drop it so the Dart side gets the same shape as `main(args)`.
      std::vector<std::wstring> tokens = SplitCommandLine(command_line);
      flutter::EncodableList argv_value;
      if (tokens.size() > 1) {
        argv_value.reserve(tokens.size() - 1);
        for (size_t i = 1; i < tokens.size(); ++i) {
          argv_value.emplace_back(WideToUtf8(tokens[i]));
        }
      }

      if (instance_channel_) {
        instance_channel_->InvokeMethod(
            "onSecondInstance",
            std::make_unique<flutter::EncodableValue>(std::move(argv_value)));
      }

      // Returning TRUE acknowledges the WM_COPYDATA message per Win32 docs.
      return TRUE;
    }
    case WM_DROPFILES: {
      // The shell delivered one or more file paths dragged onto the window.
      // Unpack them, UTF-8 encode, and forward to Dart via the
      // `de.kiefer_networks.sshvault/drop` MethodChannel under `dropFiles`.
      // TODO(windows-dnd): WM_DRAG_ENTER / WM_DRAG_LEAVE require full OLE
      // IDropTarget registration (RegisterDragDrop) — out of scope here.
      HDROP hDrop = reinterpret_cast<HDROP>(wparam);
      if (hDrop != nullptr) {
        const UINT count = ::DragQueryFileW(hDrop, 0xFFFFFFFF, nullptr, 0);
        std::vector<std::string> paths;
        paths.reserve(count);
        for (UINT i = 0; i < count; ++i) {
          const UINT wlen = ::DragQueryFileW(hDrop, i, nullptr, 0);
          if (wlen == 0) continue;
          std::wstring buf(static_cast<size_t>(wlen) + 1, L'\0');
          const UINT got =
              ::DragQueryFileW(hDrop, i, buf.data(),
                               static_cast<UINT>(buf.size()));
          if (got == 0) continue;
          buf.resize(got);
          std::string utf8 = Utf16ToUtf8(buf);
          if (!utf8.empty()) paths.push_back(std::move(utf8));
        }
        ::DragFinish(hDrop);

        if (!paths.empty() && flutter_controller_ &&
            flutter_controller_->engine() != nullptr) {
          flutter::MethodChannel<flutter::EncodableValue> channel(
              flutter_controller_->engine()->messenger(), kDropChannelName,
              &flutter::StandardMethodCodec::GetInstance());
          flutter::EncodableList encoded;
          encoded.reserve(paths.size());
          for (const auto& p : paths) {
            encoded.push_back(flutter::EncodableValue(p));
          }
          channel.InvokeMethod(
              "dropFiles",
              std::make_unique<flutter::EncodableValue>(std::move(encoded)));
        }
      }
      return 0;
    }
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

// Minimal command-line splitter mirroring CommandLineToArgvW just enough for
// our use case: tokens are separated by whitespace; double quotes group
// whitespace-bearing tokens; a backslash before a double quote escapes it.
// Backslashes outside of quotes are preserved verbatim, so paths like
// `C:\Program Files\sshvault\sshvault.exe` round-trip correctly.
std::vector<std::wstring> FlutterWindow::SplitCommandLine(
    const std::wstring& line) {
  std::vector<std::wstring> out;
  std::wstring current;
  bool in_quotes = false;
  bool have_token = false;

  for (size_t i = 0; i < line.size(); ++i) {
    const wchar_t c = line[i];

    // \" -> literal "
    if (c == L'\\' && i + 1 < line.size() && line[i + 1] == L'"') {
      current.push_back(L'"');
      ++i;
      have_token = true;
      continue;
    }

    if (c == L'"') {
      in_quotes = !in_quotes;
      have_token = true;
      continue;
    }

    if (!in_quotes && (c == L' ' || c == L'\t')) {
      if (have_token) {
        out.push_back(std::move(current));
        current.clear();
        have_token = false;
      }
      continue;
    }

    current.push_back(c);
    have_token = true;
  }

  if (have_token) {
    out.push_back(std::move(current));
  }
  return out;
}

std::string FlutterWindow::WideToUtf8(const std::wstring& wide) {
  return Utf16ToUtf8(wide);
}
