#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <string>
#include <vector>

#include "win32_window.h"

// A window that does nothing but host a Flutter view.
class FlutterWindow : public Win32Window {
 public:
  // Creates a new FlutterWindow hosting a Flutter view running |project|.
  explicit FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

 protected:
  // Win32Window:
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // The project to run.
  flutter::DartProject project_;

  // The Flutter instance hosted by this window.
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;

  // Method channel used to forward argv from a secondary instance into Dart.
  // Mirrors the Dart-side `de.kiefer_networks.sshvault/instance` channel.
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      instance_channel_;

  // Splits a UTF-16 command line into argv tokens, honouring double quoting.
  static std::vector<std::wstring> SplitCommandLine(const std::wstring& line);

  // Converts a wide string to UTF-8 for the method-channel payload.
  static std::string WideToUtf8(const std::wstring& wide);
};

#endif  // RUNNER_FLUTTER_WINDOW_H_
