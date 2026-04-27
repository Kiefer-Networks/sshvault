#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// ---------------------------------------------------------------------------
// Drag-and-drop -> Flutter bridge.
// ---------------------------------------------------------------------------
// We register the toplevel GtkWindow as a drag-destination accepting
// `text/uri-list`. When files are dropped (or the user simply hovers a drag
// over the window) we forward the event to Dart through a single
// MethodChannel. Dart classifies the file content (private/public SSH key,
// vault export JSON, ssh_config) and routes the user to the correct import UI.
//
// MethodChannel name and method names are mirrored 1:1 in
// `lib/core/services/file_drop_service.dart`. Keep them in sync.
//
// Channel: `de.kiefer_networks.sshvault/drop`
//   - `dropFiles`    args: `List<String>` of absolute file paths
//   - `dragEnter`    args: none
//   - `dragLeave`    args: none

static const char kDropChannel[] = "de.kiefer_networks.sshvault/drop";

// The channel is owned by the FlView messenger; we hold one reference for
// outbound notifications (drag-motion / drag-leave / drag-data-received).
static FlMethodChannel* g_drop_channel = nullptr;

// ---------------------------------------------------------------------------
// HiDPI per-monitor scale tracking
// ---------------------------------------------------------------------------
// When the user drags the toplevel window between monitors with different
// scale factors (e.g. external 1x next to laptop 2x), GTK 3 does not always
// request a re-rasterize of the embedded FlView. We listen on:
//
//   - GdkScreen::monitors-changed  (monitor add/remove/reconfigure)
//   - per-GdkMonitor notify::scale-factor (the scale itself changed)
//
// On either event, we re-resolve the scale of the monitor under the window,
// poke the view with `gtk_widget_queue_resize`, and forward the new scale to
// Dart on the channel below so HiDpiService can update its provider.
//
// Channel: `de.kiefer_networks.sshvault/window`
//   - `monitorScaleChanged(double scale)` — outbound, called after a change.
static const char kWindowChannel[] = "de.kiefer_networks.sshvault/window";
static FlMethodChannel* g_window_channel = nullptr;
static FlView* g_view = nullptr;
static double g_last_known_scale = 0.0;

// Resolve the scale factor of the monitor currently under [window]. Falls
// back to the screen's primary monitor and then to 1.0 if neither is
// available (e.g. very early in startup, or tests).
static double resolve_window_scale(GtkWindow* window) {
  GdkWindow* gdk_window = gtk_widget_get_window(GTK_WIDGET(window));
  GdkDisplay* display = gtk_widget_get_display(GTK_WIDGET(window));
  if (display == nullptr) {
    return 1.0;
  }
  GdkMonitor* monitor = nullptr;
  if (gdk_window != nullptr) {
    monitor = gdk_display_get_monitor_at_window(display, gdk_window);
  }
  if (monitor == nullptr) {
    monitor = gdk_display_get_primary_monitor(display);
  }
  if (monitor == nullptr) {
    return 1.0;
  }
  return static_cast<double>(gdk_monitor_get_scale_factor(monitor));
}

// Single point that re-evaluates scale and notifies Dart. Idempotent — we
// debounce by skipping calls when the resolved scale matches the last one
// we forwarded.
static void notify_scale_change(GtkWindow* window) {
  if (g_view == nullptr || g_window_channel == nullptr) {
    return;
  }
  double scale = resolve_window_scale(window);
  if (scale == g_last_known_scale) {
    return;
  }
  g_last_known_scale = scale;

  // Force a re-layout pass on the FlView so GTK re-asks us for a new size at
  // the new scale.
  gtk_widget_queue_resize(GTK_WIDGET(g_view));

  // NOTE: `fl_view_set_pixel_ratio` is NOT part of the upstream
  // `flutter_linux` public API as of the Flutter SDK we build against (only
  // `fl_view_get_engine`, `fl_view_set_background_color`, … are exposed).
  // Pixel-ratio control on Linux flows entirely from GTK widget metrics, so
  // we rely on the queue_resize above plus the Dart-side
  // `WidgetsBinding.handleMetricsChanged()` to propagate the change. Leaving
  // this comment as a breadcrumb for if/when the API lands upstream.

  g_autoptr(FlValue) args = fl_value_new_float(scale);
  fl_method_channel_invoke_method(g_window_channel, "monitorScaleChanged",
                                  args, nullptr, nullptr, nullptr);
}

static void on_monitors_changed(GdkScreen* /*screen*/, gpointer user_data) {
  GtkWindow* window = GTK_WINDOW(user_data);
  notify_scale_change(window);
}

static void on_monitor_scale_factor_changed(GObject* /*monitor*/,
                                            GParamSpec* /*pspec*/,
                                            gpointer user_data) {
  GtkWindow* window = GTK_WINDOW(user_data);
  notify_scale_change(window);
}

// `configure-event` fires when the window is moved or resized. Dragging
// between monitors goes through here too, so we use it as a cheap
// "the relevant monitor may have changed" probe.
static gboolean on_window_configure(GtkWidget* widget,
                                    GdkEvent* /*event*/,
                                    gpointer /*user_data*/) {
  notify_scale_change(GTK_WINDOW(widget));
  return FALSE;  // never consume — let GTK do its default work.
}

// `drag-data-received` is the GTK signal that fires once the user actually
// releases the mouse over the drop target. We decode the URI list here, keep
// only `file://` URIs (skipping anything else, e.g. http, x-special/gnome),
// and post the resulting absolute paths to Dart in one method call.
static void on_drag_data_received(GtkWidget* /*widget*/,
                                  GdkDragContext* context,
                                  gint /*x*/, gint /*y*/,
                                  GtkSelectionData* data, guint /*info*/,
                                  guint time, gpointer /*user_data*/) {
  if (g_drop_channel == nullptr) {
    gtk_drag_finish(context, FALSE, FALSE, time);
    return;
  }

  gchar** uris = gtk_selection_data_get_uris(data);
  if (uris == nullptr) {
    gtk_drag_finish(context, FALSE, FALSE, time);
    return;
  }

  g_autoptr(FlValue) paths = fl_value_new_list();
  for (gchar** p = uris; *p != nullptr; ++p) {
    if (!g_str_has_prefix(*p, "file://")) {
      continue;
    }
    g_autoptr(GError) err = nullptr;
    g_autofree gchar* filename = g_filename_from_uri(*p, nullptr, &err);
    if (filename == nullptr) {
      g_warning("Drop: failed to decode URI %s: %s", *p,
                err ? err->message : "unknown");
      continue;
    }
    fl_value_append_take(paths, fl_value_new_string(filename));
  }
  g_strfreev(uris);

  if (fl_value_get_length(paths) > 0) {
    fl_method_channel_invoke_method(g_drop_channel, "dropFiles", paths,
                                    nullptr, nullptr, nullptr);
  }

  gtk_drag_finish(context, TRUE, FALSE, time);
}

// `drag-motion` fires repeatedly while a drag hovers over the widget. We only
// need the leading edge for the overlay, but invoking the channel each tick is
// cheap and the Dart side is idempotent.
static gboolean on_drag_motion(GtkWidget* /*widget*/,
                               GdkDragContext* /*context*/,
                               gint /*x*/, gint /*y*/, guint /*time*/,
                               gpointer /*user_data*/) {
  if (g_drop_channel != nullptr) {
    g_autoptr(FlValue) empty = fl_value_new_null();
    fl_method_channel_invoke_method(g_drop_channel, "dragEnter", empty,
                                    nullptr, nullptr, nullptr);
  }
  return FALSE;  // let GTK do its default highlighting
}

static void on_drag_leave(GtkWidget* /*widget*/, GdkDragContext* /*context*/,
                          guint /*time*/, gpointer /*user_data*/) {
  if (g_drop_channel != nullptr) {
    g_autoptr(FlValue) empty = fl_value_new_null();
    fl_method_channel_invoke_method(g_drop_channel, "dragLeave", empty,
                                    nullptr, nullptr, nullptr);
  }
}

// Set up the GTK drag destination and the MethodChannel used to ferry events
// to Dart. Called once per `activate`, after the FlView has been created and
// added to the window so we can resolve the binary messenger.
static void register_drag_and_drop(GtkWindow* window, FlView* view) {
  // Accept text/uri-list (the format used by Nautilus, Dolphin, Thunar, etc.)
  // with full default handling: highlight, motion tracking, and drop.
  GtkTargetEntry targets[] = {
      {const_cast<gchar*>("text/uri-list"), 0, 0},
  };
  gtk_drag_dest_set(GTK_WIDGET(window), GTK_DEST_DEFAULT_ALL, targets,
                    G_N_ELEMENTS(targets), GDK_ACTION_COPY);

  g_signal_connect(window, "drag-data-received",
                   G_CALLBACK(on_drag_data_received), nullptr);
  g_signal_connect(window, "drag-motion", G_CALLBACK(on_drag_motion), nullptr);
  g_signal_connect(window, "drag-leave", G_CALLBACK(on_drag_leave), nullptr);

  if (g_drop_channel == nullptr) {
    FlBinaryMessenger* messenger =
        fl_engine_get_binary_messenger(fl_view_get_engine(view));
    g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
    g_drop_channel = fl_method_channel_new(messenger, kDropChannel,
                                           FL_METHOD_CODEC(codec));
  }
}

// Connect HiDPI signal handlers and create the outbound MethodChannel that
// pushes monitor-scale changes to Dart. Called once per `activate`.
static void register_hidpi_tracking(GtkWindow* window, FlView* view) {
  if (g_window_channel == nullptr) {
    FlBinaryMessenger* messenger =
        fl_engine_get_binary_messenger(fl_view_get_engine(view));
    g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
    g_window_channel = fl_method_channel_new(messenger, kWindowChannel,
                                             FL_METHOD_CODEC(codec));
  }
  g_view = view;

  // Per-screen monitor add/remove/reconfigure events.
  GdkScreen* screen = gtk_window_get_screen(window);
  if (screen != nullptr) {
    g_signal_connect(screen, "monitors-changed",
                     G_CALLBACK(on_monitors_changed), window);
  }

  // Per-monitor scale-factor changes. Iterate the current monitors so we
  // catch the case where the user just changes the scale factor in
  // settings (no monitor add/remove), and also for monitors that come and
  // go later — `monitors-changed` will re-trigger the scan path.
  GdkDisplay* display = gtk_widget_get_display(GTK_WIDGET(window));
  if (display != nullptr) {
    int n_monitors = gdk_display_get_n_monitors(display);
    for (int i = 0; i < n_monitors; ++i) {
      GdkMonitor* monitor = gdk_display_get_monitor(display, i);
      if (monitor == nullptr) continue;
      g_signal_connect(monitor, "notify::scale-factor",
                       G_CALLBACK(on_monitor_scale_factor_changed), window);
    }
  }

  // `configure-event` catches the window crossing a monitor boundary even
  // when scale-factor doesn't change on either monitor (we still want Dart
  // to learn the new value, and `notify_scale_change` is idempotent).
  g_signal_connect(window, "configure-event",
                   G_CALLBACK(on_window_configure), nullptr);
}

// Called when first Flutter frame received.
static void first_frame_cb(MyApplication* self, FlView* view) {
  gtk_widget_show(gtk_widget_get_toplevel(GTK_WIDGET(view)));
  // Send an initial scale so the Dart side starts with the correct value
  // even if the user never crosses a monitor boundary in this session.
  GtkWindow* window = GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(view)));
  if (window != nullptr) {
    notify_scale_change(window);
  }
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "SSHVault");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    // Force min / max / close buttons regardless of the GTK
    // gtk-decoration-layout setting so users always get the expected window
    // controls on Linux desktops (some themes default to close-only).
    gtk_header_bar_set_decoration_layout(header_bar,
                                         "icon:minimize,maximize,close");
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "SSHVault");
  }

  gtk_window_set_default_size(window, 1280, 720);

  // Set the window icon for GNOME window switcher / taskbar
  g_autoptr(GError) icon_error = nullptr;
  g_autofree gchar* exe_path = g_file_read_link("/proc/self/exe", nullptr);
  if (exe_path != nullptr) {
    g_autofree gchar* exe_dir = g_path_get_dirname(exe_path);
    g_autofree gchar* icon_path =
        g_build_filename(exe_dir, "data", "flutter_assets", "assets",
                         "images", "app_icon.png", nullptr);
    GdkPixbuf* icon = gdk_pixbuf_new_from_file(icon_path, &icon_error);
    if (icon != nullptr) {
      gtk_window_set_icon(window, icon);
      g_object_unref(icon);
    }
  }

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(
      project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  GdkRGBA background_color;
  // Background defaults to black, override it here if necessary, e.g. #00000000
  // for transparent.
  gdk_rgba_parse(&background_color, "#000000");
  fl_view_set_background_color(view, &background_color);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  // Show the window when Flutter renders.
  // Requires the view to be realized so we can start rendering.
  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb),
                           self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  // Set up Linux drag-and-drop so users can drop SSH key files / vault
  // exports / ssh_config files onto the window to trigger the import flow.
  register_drag_and_drop(window, view);

  // Hook GDK monitor signals so we can keep the embedded Flutter view
  // re-rasterized when the window is dragged across monitors with different
  // scale factors. See `register_hidpi_tracking` for details.
  register_hidpi_tracking(window, view);

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application,
                                                  gchar*** arguments,
                                                  int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line =
      my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID, "flags",
                                     G_APPLICATION_NON_UNIQUE, nullptr));
}
