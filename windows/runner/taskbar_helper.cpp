// See header for design notes.
#include "taskbar_helper.h"

#include <objbase.h>
#include <shobjidl.h>
#include <commctrl.h>

#include <cstdint>
#include <string>
#include <vector>

namespace sshvault {

namespace {

constexpr const char kChannelName[] = "de.kiefer_networks.sshvault/taskbar";

// Reserve a stable command-id range for our 7 thumb buttons so we can map a
// WM_COMMAND identifier back to the Dart-supplied logical id.
constexpr WORD kThumbButtonCmdBase = 0xF100;
constexpr int kMaxThumbButtons = 7;

// Logical button ids (set via setThumbButtons) keyed by command index.
struct ThumbButtonState {
  std::string id;
};

ThumbButtonState g_buttons[kMaxThumbButtons];

TBPFLAG ProgressStateFromString(const std::string& s) {
  if (s == "normal") return TBPF_NORMAL;
  if (s == "paused") return TBPF_PAUSED;
  if (s == "error") return TBPF_ERROR;
  if (s == "indeterminate") return TBPF_INDETERMINATE;
  return TBPF_NOPROGRESS;
}

double ReadDouble(const flutter::EncodableValue* v, double fallback) {
  if (!v) return fallback;
  if (std::holds_alternative<double>(*v)) return std::get<double>(*v);
  if (std::holds_alternative<int32_t>(*v)) {
    return static_cast<double>(std::get<int32_t>(*v));
  }
  if (std::holds_alternative<int64_t>(*v)) {
    return static_cast<double>(std::get<int64_t>(*v));
  }
  return fallback;
}

std::string ReadString(const flutter::EncodableValue* v) {
  if (v && std::holds_alternative<std::string>(*v)) {
    return std::get<std::string>(*v);
  }
  return std::string();
}

bool ReadBool(const flutter::EncodableValue* v, bool fallback) {
  if (v && std::holds_alternative<bool>(*v)) return std::get<bool>(*v);
  return fallback;
}

}  // namespace

TaskbarHelper::TaskbarHelper(HWND window,
                             flutter::BinaryMessenger* messenger)
    : window_(window) {
  channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          messenger, kChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  channel_->SetMethodCallHandler(
      [this](const auto& call, auto result) {
        OnMethodCall(call, std::move(result));
      });
}

TaskbarHelper::~TaskbarHelper() {
  if (taskbar_ != nullptr) {
    taskbar_->Release();
    taskbar_ = nullptr;
  }
  if (com_initialized_) {
    ::CoUninitialize();
    com_initialized_ = false;
  }
}

bool TaskbarHelper::EnsureTaskbar() {
  if (taskbar_ != nullptr) return true;
  if (!com_initialized_) {
    HRESULT hr = ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED |
                                                COINIT_DISABLE_OLE1DDE);
    // RPC_E_CHANGED_MODE / S_FALSE both mean COM is already initialized for
    // this thread (the Flutter host already did it). We only call
    // CoUninitialize if we did initialize.
    if (SUCCEEDED(hr) && hr != S_FALSE) {
      com_initialized_ = true;
    }
  }
  HRESULT hr = ::CoCreateInstance(CLSID_TaskbarList, nullptr,
                                  CLSCTX_INPROC_SERVER,
                                  IID_PPV_ARGS(&taskbar_));
  if (FAILED(hr) || taskbar_ == nullptr) {
    taskbar_ = nullptr;
    return false;
  }
  if (FAILED(taskbar_->HrInit())) {
    taskbar_->Release();
    taskbar_ = nullptr;
    return false;
  }
  return true;
}

bool TaskbarHelper::HandleWindowMessage(UINT message, WPARAM wparam,
                                        LPARAM /*lparam*/) {
  if (message != WM_COMMAND) return false;
  const WORD cmd = LOWORD(wparam);
  if (cmd < kThumbButtonCmdBase ||
      cmd >= kThumbButtonCmdBase + kMaxThumbButtons) {
    return false;
  }
  const int idx = cmd - kThumbButtonCmdBase;
  if (g_buttons[idx].id.empty()) return false;
  if (!channel_) return true;
  channel_->InvokeMethod(
      "onThumbButtonClicked",
      std::make_unique<flutter::EncodableValue>(g_buttons[idx].id));
  return true;
}

void TaskbarHelper::OnMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const std::string& name = call.method_name();

  if (name == "setProgress") {
    const auto* args =
        std::get_if<flutter::EncodableMap>(call.arguments());
    if (!args) {
      result->Error("bad_args", "expected a map");
      return;
    }
    std::string state = "none";
    double value = 0.0;
    auto it = args->find(flutter::EncodableValue("state"));
    if (it != args->end()) state = ReadString(&it->second);
    auto vit = args->find(flutter::EncodableValue("value"));
    if (vit != args->end()) value = ReadDouble(&vit->second, 0.0);

    if (!EnsureTaskbar()) {
      result->Success();  // best-effort no-op
      return;
    }
    const TBPFLAG flag = ProgressStateFromString(state);
    taskbar_->SetProgressState(window_, flag);
    if (flag == TBPF_NORMAL || flag == TBPF_PAUSED || flag == TBPF_ERROR) {
      if (value < 0.0) value = 0.0;
      if (value > 1.0) value = 1.0;
      taskbar_->SetProgressValue(window_,
                                 static_cast<ULONGLONG>(value * 1000.0),
                                 1000ULL);
    }
    result->Success();
    return;
  }

  if (name == "setThumbButtons") {
    const auto* list =
        std::get_if<flutter::EncodableList>(call.arguments());
    if (!list) {
      result->Error("bad_args", "expected a list");
      return;
    }
    if (!EnsureTaskbar()) {
      result->Success();
      return;
    }

    THUMBBUTTON tbb[kMaxThumbButtons] = {};
    int count = 0;
    for (const auto& entry : *list) {
      if (count >= kMaxThumbButtons) break;
      const auto* m = std::get_if<flutter::EncodableMap>(&entry);
      if (!m) continue;

      std::string id;
      std::string tooltip;
      bool enabled = true;
      auto idIt = m->find(flutter::EncodableValue("id"));
      if (idIt != m->end()) id = ReadString(&idIt->second);
      auto tt = m->find(flutter::EncodableValue("tooltip"));
      if (tt != m->end()) tooltip = ReadString(&tt->second);
      auto en = m->find(flutter::EncodableValue("enabled"));
      if (en != m->end()) enabled = ReadBool(&en->second, true);

      g_buttons[count].id = id;
      tbb[count].dwMask = THB_TOOLTIP | THB_FLAGS;
      tbb[count].iId = kThumbButtonCmdBase + count;
      tbb[count].dwFlags = enabled ? THBF_ENABLED : THBF_DISABLED;

      // UTF-8 -> UTF-16 for the tooltip. Truncate to fit szTip[260].
      if (!tooltip.empty()) {
        const int wlen = ::MultiByteToWideChar(
            CP_UTF8, 0, tooltip.data(), static_cast<int>(tooltip.size()),
            nullptr, 0);
        if (wlen > 0) {
          std::wstring wide(static_cast<size_t>(wlen), L'\0');
          ::MultiByteToWideChar(CP_UTF8, 0, tooltip.data(),
                                static_cast<int>(tooltip.size()), wide.data(),
                                wlen);
          const size_t copy =
              wide.size() < (sizeof(tbb[count].szTip) / sizeof(WCHAR)) - 1
                  ? wide.size()
                  : (sizeof(tbb[count].szTip) / sizeof(WCHAR)) - 1;
          memcpy(tbb[count].szTip, wide.data(), copy * sizeof(WCHAR));
          tbb[count].szTip[copy] = L'\0';
        }
      }

      ++count;
    }
    // Clear remaining slots' logical ids.
    for (int i = count; i < kMaxThumbButtons; ++i) g_buttons[i].id.clear();

    if (count == 0) {
      // No buttons — pass an empty array to clear.
      taskbar_->ThumbBarUpdateButtons(window_, 0, nullptr);
    } else {
      // First call uses ThumbBarAddButtons; subsequent updates reuse the
      // same array via ThumbBarUpdateButtons. AddButtons may fail with
      // E_INVALIDARG when called twice — fall through to UpdateButtons in
      // that case which is the documented refresh path.
      HRESULT hr = taskbar_->ThumbBarAddButtons(
          window_, static_cast<UINT>(count), tbb);
      if (FAILED(hr)) {
        taskbar_->ThumbBarUpdateButtons(window_, static_cast<UINT>(count),
                                        tbb);
      }
    }
    result->Success();
    return;
  }

  if (name == "flashTaskbar") {
    FLASHWINFO info = {};
    info.cbSize = sizeof(info);
    info.hwnd = window_;
    info.dwFlags = FLASHW_TRAY | FLASHW_TIMERNOFG;
    info.uCount = 3;
    info.dwTimeout = 0;
    ::FlashWindowEx(&info);
    result->Success();
    return;
  }

  result->NotImplemented();
}

}  // namespace sshvault
