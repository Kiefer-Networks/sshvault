// Windows taskbar helper for SSHVault.
//
// Bridges the `de.kiefer_networks.sshvault/taskbar` Flutter MethodChannel to
// the `ITaskbarList3` COM interface (Windows 7+). Exposes:
//   - setProgress(state, value)        -> SetProgressState + SetProgressValue
//   - setThumbButtons([{id,...}])      -> ThumbBarSetImageList +
//                                        ThumbBarUpdateButtons (max 7)
//   - flashTaskbar()                   -> FlashWindowEx
//
// Button click events flow back to Dart via the same channel as
// `onThumbButtonClicked` with the button id as argument.

#ifndef RUNNER_TASKBAR_HELPER_H_
#define RUNNER_TASKBAR_HELPER_H_

#include <flutter/binary_messenger.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <memory>

struct ITaskbarList3;

namespace sshvault {

class TaskbarHelper {
 public:
  // Constructs the helper bound to |window|. Initializes COM lazily on the
  // first call (best-effort — failures degrade to no-ops).
  TaskbarHelper(HWND window, flutter::BinaryMessenger* messenger);
  ~TaskbarHelper();

  TaskbarHelper(const TaskbarHelper&) = delete;
  TaskbarHelper& operator=(const TaskbarHelper&) = delete;

  // Forward WM_COMMAND from the host window so we can dispatch
  // THBN_CLICKED (button-id-encoded) clicks back to Dart. Returns true when
  // the message was a thumb-button click and consumed.
  bool HandleWindowMessage(UINT message, WPARAM wparam, LPARAM lparam);

 private:
  // Lazily initializes the ITaskbarList3 instance. Returns true on success.
  bool EnsureTaskbar();

  // Handles a single MethodCall from the channel.
  void OnMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  HWND window_ = nullptr;
  ITaskbarList3* taskbar_ = nullptr;
  bool com_initialized_ = false;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
};

}  // namespace sshvault

#endif  // RUNNER_TASKBAR_HELPER_H_
