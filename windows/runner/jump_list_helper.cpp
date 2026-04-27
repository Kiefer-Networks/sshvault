// Windows Jump List integration for SSHVault.
//
// Implements the `de.kiefer_networks.sshvault/jumplist` MethodChannel exposed
// to Dart by `lib/core/services/jump_list_service.dart`. Three methods are
// supported:
//
//   - `setItems(List<Map<String,Object?>>)`
//       Rebuilds the application-defined jump list using
//       `ICustomDestinationList`. Items with `kind == "task"` go into the
//       OS Tasks section (`AddUserTasks`); items with `kind == "favorite"`
//       go into a custom category called "Favorites" (`AppendCategory`).
//
//   - `markRecent(String serverId, String name)`
//       Calls `SHAddToRecentDocs(SHARD_APPIDINFO)` so Windows fills in its
//       built-in "Recent" category for free. The OS keeps the list trimmed
//       and persisted for us.
//
//   - `clear()`
//       Calls `ICustomDestinationList::DeleteList` to remove the
//       application-specific list.
//
// To wire this helper in, add the following two lines to
// `flutter_window.cpp::OnCreate()` after the engine has been registered:
//
//     #include "jump_list_helper.h"          // (in flutter_window.cpp)
//     RegisterJumpListChannel(flutter_controller_->engine()->messenger());
//
// and add `"jump_list_helper.cpp"` to the `add_executable` source list in
// `windows/runner/CMakeLists.txt`. The file is otherwise self-contained.
//
// This file is intentionally header-free for inline usage; a tiny shim
// `jump_list_helper.h` declares only `RegisterJumpListChannel`.
//
// Reference docs:
//   https://learn.microsoft.com/windows/win32/api/shobjidl_core/nn-shobjidl_core-icustomdestinationlist
//   https://learn.microsoft.com/windows/win32/shell/jump-lists

#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <flutter/binary_messenger.h>

#include <objbase.h>
#include <propkey.h>
#include <propvarutil.h>
#include <shlobj.h>
#include <shlobj_core.h>
#include <shobjidl.h>
#include <windows.h>

#include <memory>
#include <string>
#include <variant>
#include <vector>

namespace {

constexpr const char kJumpListChannelName[] =
    "de.kiefer_networks.sshvault/jumplist";

// User-visible name of the custom category that holds the user's favorite
// hosts. Localization is intentionally English-only here — the OS shows the
// app's primary language for the category title regardless of UI language.
constexpr const wchar_t kFavoritesCategoryTitle[] = L"Favorites";

// UTF-8 -> UTF-16 conversion (the standard codec hands us std::string).
std::wstring Utf8ToWide(const std::string& s) {
  if (s.empty()) return std::wstring();
  const int needed = ::MultiByteToWideChar(CP_UTF8, 0, s.data(),
                                           static_cast<int>(s.size()), nullptr,
                                           0);
  if (needed <= 0) return std::wstring();
  std::wstring out(static_cast<size_t>(needed), L'\0');
  ::MultiByteToWideChar(CP_UTF8, 0, s.data(), static_cast<int>(s.size()),
                        out.data(), needed);
  return out;
}

// Path to the running sshvault.exe — used as the launch target for every
// jump-list entry.
std::wstring GetExecutablePath() {
  std::wstring buf(MAX_PATH, L'\0');
  for (;;) {
    const DWORD written =
        ::GetModuleFileNameW(nullptr, buf.data(),
                             static_cast<DWORD>(buf.size()));
    if (written == 0) return std::wstring();
    if (written < buf.size()) {
      buf.resize(written);
      return buf;
    }
    // Truncated — grow and try again.
    buf.resize(buf.size() * 2);
  }
}

// Build an `IShellLinkW` for `sshvault.exe args` with the given title.
HRESULT MakeShellLink(const std::wstring& exe, const std::wstring& args,
                      const std::wstring& title,
                      const std::wstring& description,
                      const std::wstring& iconPath, IShellLinkW** out) {
  if (!out) return E_POINTER;
  *out = nullptr;

  Microsoft::WRL::ComPtr<IShellLinkW> link;
  // Use raw CoCreateInstance to avoid a dependency on WRL when toolchain
  // doesn't pull it in. We manage the COM pointer manually.
  IShellLinkW* raw_link = nullptr;
  HRESULT hr = ::CoCreateInstance(CLSID_ShellLink, nullptr, CLSCTX_INPROC_SERVER,
                                  IID_PPV_ARGS(&raw_link));
  if (FAILED(hr)) return hr;

  raw_link->SetPath(exe.c_str());
  raw_link->SetArguments(args.c_str());
  if (!description.empty()) {
    raw_link->SetDescription(description.c_str());
  }
  if (!iconPath.empty()) {
    raw_link->SetIconLocation(iconPath.c_str(), 0);
  } else {
    // Default to the executable's own icon (index 0).
    raw_link->SetIconLocation(exe.c_str(), 0);
  }

  // Set the title via the PKEY_Title property store. Without this, the
  // Windows shell falls back to the file name of the link target — which
  // would be "sshvault" for every entry and is useless for distinguishing
  // hosts.
  IPropertyStore* prop_store = nullptr;
  hr = raw_link->QueryInterface(IID_PPV_ARGS(&prop_store));
  if (SUCCEEDED(hr) && prop_store != nullptr) {
    PROPVARIANT pv;
    if (SUCCEEDED(::InitPropVariantFromString(title.c_str(), &pv))) {
      prop_store->SetValue(PKEY_Title, pv);
      prop_store->Commit();
      ::PropVariantClear(&pv);
    }
    prop_store->Release();
  }

  *out = raw_link;  // Caller takes ownership.
  return S_OK;
}

struct ParsedItem {
  std::wstring kind;     // "task" or "favorite"
  std::wstring label;
  std::wstring description;
  std::wstring args;
  std::wstring iconPath;
};

// Decode one map from the `setItems` payload.
bool DecodeItem(const flutter::EncodableValue& v, ParsedItem* out) {
  const auto* map = std::get_if<flutter::EncodableMap>(&v);
  if (!map) return false;

  auto get_str = [&](const char* key) -> std::wstring {
    auto it = map->find(flutter::EncodableValue(key));
    if (it == map->end()) return std::wstring();
    const auto* s = std::get_if<std::string>(&it->second);
    return s ? Utf8ToWide(*s) : std::wstring();
  };

  out->kind = get_str("kind");
  out->label = get_str("label");
  out->description = get_str("description");
  out->args = get_str("args");
  out->iconPath = get_str("iconPath");
  return !out->label.empty() && !out->kind.empty();
}

HRESULT BuildAndCommitList(const std::vector<ParsedItem>& items) {
  ICustomDestinationList* list = nullptr;
  HRESULT hr = ::CoCreateInstance(CLSID_DestinationList, nullptr,
                                  CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&list));
  if (FAILED(hr) || !list) return hr;

  UINT slots = 0;
  IObjectArray* removed = nullptr;
  hr = list->BeginList(&slots, IID_PPV_ARGS(&removed));
  if (FAILED(hr)) {
    list->Release();
    return hr;
  }

  const std::wstring exe = GetExecutablePath();

  // Tasks section.
  IObjectCollection* tasks = nullptr;
  hr = ::CoCreateInstance(CLSID_EnumerableObjectCollection, nullptr,
                          CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&tasks));
  if (SUCCEEDED(hr) && tasks != nullptr) {
    for (const auto& it : items) {
      if (it.kind != L"task") continue;
      IShellLinkW* link = nullptr;
      if (SUCCEEDED(MakeShellLink(exe, it.args, it.label, it.description,
                                  it.iconPath, &link)) &&
          link != nullptr) {
        tasks->AddObject(link);
        link->Release();
      }
    }
    IObjectArray* tasks_arr = nullptr;
    if (SUCCEEDED(tasks->QueryInterface(IID_PPV_ARGS(&tasks_arr)))) {
      list->AddUserTasks(tasks_arr);
      tasks_arr->Release();
    }
    tasks->Release();
  }

  // Favorites custom category.
  IObjectCollection* favs = nullptr;
  hr = ::CoCreateInstance(CLSID_EnumerableObjectCollection, nullptr,
                          CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&favs));
  if (SUCCEEDED(hr) && favs != nullptr) {
    UINT count = 0;
    for (const auto& it : items) {
      if (it.kind != L"favorite") continue;
      IShellLinkW* link = nullptr;
      if (SUCCEEDED(MakeShellLink(exe, it.args, it.label, it.description,
                                  it.iconPath, &link)) &&
          link != nullptr) {
        favs->AddObject(link);
        link->Release();
        ++count;
      }
    }
    if (count > 0) {
      IObjectArray* favs_arr = nullptr;
      if (SUCCEEDED(favs->QueryInterface(IID_PPV_ARGS(&favs_arr)))) {
        list->AppendCategory(kFavoritesCategoryTitle, favs_arr);
        favs_arr->Release();
      }
    }
    favs->Release();
  }

  hr = list->CommitList();
  if (removed) removed->Release();
  list->Release();
  return hr;
}

void HandleSetItems(const flutter::EncodableValue& args,
                    flutter::MethodResult<flutter::EncodableValue>& result) {
  const auto* list = std::get_if<flutter::EncodableList>(&args);
  if (!list) {
    result.Error("INVALID_ARGS", "setItems expects a List<Map>");
    return;
  }

  std::vector<ParsedItem> parsed;
  parsed.reserve(list->size());
  for (const auto& v : *list) {
    ParsedItem p;
    if (DecodeItem(v, &p)) parsed.push_back(std::move(p));
  }

  const HRESULT hr = BuildAndCommitList(parsed);
  if (FAILED(hr)) {
    char buf[64];
    std::snprintf(buf, sizeof(buf), "0x%08lX", static_cast<unsigned long>(hr));
    result.Error("JUMPLIST_FAILED", buf);
    return;
  }
  result.Success();
}

void HandleMarkRecent(const flutter::EncodableValue& args,
                      flutter::MethodResult<flutter::EncodableValue>& result) {
  const auto* map = std::get_if<flutter::EncodableMap>(&args);
  if (!map) {
    result.Error("INVALID_ARGS", "markRecent expects {serverId, name}");
    return;
  }
  auto get = [&](const char* k) -> std::wstring {
    auto it = map->find(flutter::EncodableValue(k));
    if (it == map->end()) return L"";
    const auto* s = std::get_if<std::string>(&it->second);
    return s ? Utf8ToWide(*s) : L"";
  };
  const std::wstring serverId = get("serverId");
  const std::wstring name = get("name");
  if (serverId.empty()) {
    result.Error("INVALID_ARGS", "serverId is required");
    return;
  }

  // SHARDAPPIDINFOLINK lets us point Windows at a synthetic shell link
  // whose target carries the server-id arg. The OS persists it under
  // the app's recent docs and surfaces it as a "Recent" jump-list entry.
  IShellLinkW* link = nullptr;
  const std::wstring exe = GetExecutablePath();
  if (SUCCEEDED(MakeShellLink(exe, serverId, name.empty() ? serverId : name,
                              L"", L"", &link)) &&
      link != nullptr) {
    SHARDAPPIDINFOLINK info = {};
    info.psl = link;
    info.pszAppID = L"de.kiefer_networks.sshvault";
    ::SHAddToRecentDocs(SHARD_APPIDINFOLINK, &info);
    link->Release();
  }
  result.Success();
}

void HandleClear(flutter::MethodResult<flutter::EncodableValue>& result) {
  ICustomDestinationList* list = nullptr;
  HRESULT hr = ::CoCreateInstance(CLSID_DestinationList, nullptr,
                                  CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&list));
  if (SUCCEEDED(hr) && list != nullptr) {
    list->DeleteList(nullptr);
    list->Release();
  }
  ::SHAddToRecentDocs(SHARD_APPIDINFO, nullptr);
  result.Success();
}

}  // namespace

// Public entry point — call once after the Flutter engine is up to register
// the jump-list method channel.
extern "C" void RegisterJumpListChannel(
    flutter::BinaryMessenger* messenger) {
  if (!messenger) return;

  static std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      channel;
  channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      messenger, kJumpListChannelName,
      &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
             result) {
        const std::string& method = call.method_name();
        const flutter::EncodableValue* args = call.arguments();
        const flutter::EncodableValue empty;
        const flutter::EncodableValue& a = args ? *args : empty;

        if (method == "setItems") {
          HandleSetItems(a, *result);
        } else if (method == "markRecent") {
          HandleMarkRecent(a, *result);
        } else if (method == "clear") {
          HandleClear(*result);
        } else {
          result->NotImplemented();
        }
      });
}
