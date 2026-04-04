import 'package:flutter/material.dart';

/// Design-system spacing tokens used throughout the app.
///
/// Based on a 4-dp base grid with a few intermediary values (2, 6, 10)
/// that are already established in the codebase.
abstract final class Spacing {
  // --- raw values ---
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 28;
  static const double xxxxl = 32;
  static const double fabClearance = 80;

  // --- common EdgeInsets ---
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);
  static const EdgeInsets paddingAllXxl = EdgeInsets.all(xxl);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllXxxl = EdgeInsets.all(xxxxl);

  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets paddingHorizontalXxl = EdgeInsets.symmetric(
    horizontal: xxl,
  );
  static const EdgeInsets paddingHorizontalXxxl = EdgeInsets.symmetric(
    horizontal: xxxxl,
  );
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalXxs = EdgeInsets.symmetric(
    horizontal: xxs,
  );

  static const EdgeInsets paddingHorizontalLgVerticalSm = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );

  // --- common SizedBox spacers ---
  static const SizedBox verticalXxs = SizedBox(height: xxs);
  static const SizedBox verticalXs = SizedBox(height: xs);
  static const SizedBox verticalSm = SizedBox(height: sm);
  static const SizedBox verticalMd = SizedBox(height: md);
  static const SizedBox verticalLg = SizedBox(height: lg);
  static const SizedBox verticalXl = SizedBox(height: xl);
  static const SizedBox verticalXxl = SizedBox(height: xxl);
  static const SizedBox verticalXxxl = SizedBox(height: xxxxl);

  static const SizedBox horizontalXxs = SizedBox(width: xxs);
  static const SizedBox horizontalXs = SizedBox(width: xs);
  static const SizedBox horizontalSm = SizedBox(width: sm);
  static const SizedBox horizontalMd = SizedBox(width: md);
  static const SizedBox horizontalLg = SizedBox(width: lg);
  static const SizedBox horizontalXxl = SizedBox(width: xxl);
}
