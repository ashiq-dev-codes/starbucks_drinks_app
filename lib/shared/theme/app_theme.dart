import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // No fontFamily set: the RN source registers its Poppins fonts under
  // "PoppinsBold"/"PoppinsRegular"/"PoppinsSemiBold" but every style references
  // "poppins-bold"/"poppins-regular"/"poppins-semiBold" (constants/Font.ts) —
  // a key mismatch that makes the custom font silently fail to load on every
  // platform, so the real app renders in the system default font.
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: NoSplash.splashFactory,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.whiteColor,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
    );
  }
}
