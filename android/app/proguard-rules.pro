# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep dartssh2 native bindings
-keep class com.example.dartssh2.** { *; }

# Keep notification channel metadata
-keep class androidx.core.app.NotificationCompat { *; }
