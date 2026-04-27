cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME} WIN32
  "crash_handler.cpp"
  "flutter_window.cpp"
  "main.cpp"
  "taskbar_helper.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the build version.
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
# COM + ITaskbarList3 + FlashWindowEx for taskbar_helper.
target_link_libraries(${BINARY_NAME} PRIVATE "ole32.lib" "shell32.lib" "user32.lib" "comctl32.lib")

# dbghelp.lib provides MiniDumpWriteDump for the crash-dump handler. We
# delay-load it (via /DELAYLOAD on MSVC) so dbghelp.dll only enters the
# process when an unhandled exception fires — keeping cold-start cost at
# zero on the happy path. delayimp.lib is required by the linker to
# resolve the delay-load helper thunks.
target_link_libraries(${BINARY_NAME} PRIVATE "dbghelp.lib")
if(MSVC)
  target_link_libraries(${BINARY_NAME} PRIVATE "delayimp.lib")
  target_link_options(${BINARY_NAME} PRIVATE "/DELAYLOAD:dbghelp.dll")
endif()

target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Force the WINDOWS subsystem in Release so a stray console window never appears
# when the app is launched from Explorer or a shortcut. Debug keeps CONSOLE so
# `flutter run`/IDE output stays visible. The entry point is `wWinMain` either
# way (defined in main.cpp), which matches the WINDOWS subsystem default.
set_target_properties(${BINARY_NAME} PROPERTIES WIN32_EXECUTABLE TRUE)
target_link_options(${BINARY_NAME} PRIVATE
    $<$<CONFIG:Release>:/SUBSYSTEM:WINDOWS>
    $<$<CONFIG:Profile>:/SUBSYSTEM:WINDOWS>
    $<$<CONFIG:Debug>:/SUBSYSTEM:CONSOLE>
)

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)
