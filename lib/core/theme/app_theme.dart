import 'package:flutter/material.dart';
import 'package:sshvault/core/constants/app_constants.dart';

abstract final class AppTheme {
  static const _seedColor = Color(0xFF1A1A2E);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    final defaultTextTheme = ThemeData.light().textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: defaultTextTheme.copyWith(
        bodyLarge: defaultTextTheme.bodyLarge?.copyWith(fontSize: 14),
        bodyMedium: defaultTextTheme.bodyMedium?.copyWith(fontSize: 12),
        bodySmall: defaultTextTheme.bodySmall?.copyWith(fontSize: 11),
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: defaultTextTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(AppConstants.alpha77),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minLeadingWidth: 40,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(
          colorScheme.surfaceContainerHigh,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withAlpha(
          AppConstants.alpha77,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha(AppConstants.alpha77),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha(AppConstants.alpha77),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withAlpha(AppConstants.alpha77),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurface.withAlpha(AppConstants.alpha179),
        ),
        selectedLabelTextStyle: defaultTextTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: defaultTextTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface.withAlpha(AppConstants.alpha179),
        ),
        indicatorColor: colorScheme.primary.withAlpha(AppConstants.alpha26),
        indicatorShape: const StadiumBorder(),
      ),
      drawerTheme: const DrawerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    final defaultTextTheme = ThemeData.dark().textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: defaultTextTheme.copyWith(
        bodyLarge: defaultTextTheme.bodyLarge?.copyWith(fontSize: 14),
        bodyMedium: defaultTextTheme.bodyMedium?.copyWith(fontSize: 12),
        bodySmall: defaultTextTheme.bodySmall?.copyWith(fontSize: 11),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: defaultTextTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minLeadingWidth: 40,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(AppConstants.alpha77),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(
          colorScheme.surfaceContainerHigh,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withAlpha(
          AppConstants.alpha77,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha(AppConstants.alpha77),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha(AppConstants.alpha77),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withAlpha(AppConstants.alpha77),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurface.withAlpha(AppConstants.alpha179),
        ),
        selectedLabelTextStyle: defaultTextTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: defaultTextTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface.withAlpha(AppConstants.alpha179),
        ),
        indicatorColor: colorScheme.primary.withAlpha(AppConstants.alpha26),
        indicatorShape: const StadiumBorder(),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Scales a [TextTheme] for responsive typography based on screen width.
///
/// Uses Material 3 window-size classes:
/// - Compact (< 600 dp): base sizes
/// - Medium (600–1200 dp): +1 dp
/// - Expanded (>= 1200 dp): +2 dp
TextTheme responsiveTextTheme(TextTheme base, double screenWidth) {
  final double scale;
  if (screenWidth >= 1200) {
    scale = 2;
  } else if (screenWidth >= 600) {
    scale = 1;
  } else {
    return base;
  }

  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontSize: (base.displayLarge!.fontSize ?? 57) + scale,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontSize: (base.displayMedium!.fontSize ?? 45) + scale,
    ),
    displaySmall: base.displaySmall?.copyWith(
      fontSize: (base.displaySmall!.fontSize ?? 36) + scale,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      fontSize: (base.headlineLarge!.fontSize ?? 32) + scale,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: (base.headlineMedium!.fontSize ?? 28) + scale,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: (base.headlineSmall!.fontSize ?? 24) + scale,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: (base.titleLarge!.fontSize ?? 22) + scale,
    ),
    titleMedium: base.titleMedium?.copyWith(
      fontSize: (base.titleMedium!.fontSize ?? 16) + scale,
    ),
    titleSmall: base.titleSmall?.copyWith(
      fontSize: (base.titleSmall!.fontSize ?? 14) + scale,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: (base.bodyLarge!.fontSize ?? 14) + scale,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: (base.bodyMedium!.fontSize ?? 12) + scale,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontSize: (base.bodySmall!.fontSize ?? 11) + scale,
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontSize: (base.labelLarge!.fontSize ?? 14) + scale,
    ),
    labelMedium: base.labelMedium?.copyWith(
      fontSize: (base.labelMedium!.fontSize ?? 12) + scale,
    ),
    labelSmall: base.labelSmall?.copyWith(
      fontSize: (base.labelSmall!.fontSize ?? 11) + scale,
    ),
  );
}
