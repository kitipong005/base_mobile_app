import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.neutral100,
      onSurfaceVariant: AppColors.neutral700,
      outline: AppColors.border,
      outlineVariant: AppColors.neutral300,
      shadow: AppColors.shadow,
    ),

    // Typography
    textTheme: AppTypography.textTheme,
    
    // App Bar Theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      titleTextStyle: AppTypography.h5,
      toolbarTextStyle: AppTypography.bodyMedium,
      iconTheme: IconThemeData(
        color: AppColors.onSurface,
        size: AppSpacing.iconMD,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // Card Theme
    cardTheme: const CardThemeData(
      elevation: 2,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMD,
      ),
      margin: EdgeInsets.zero,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: AppColors.shadow,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.neutral300,
        disabledForegroundColor: AppColors.neutral500,
        textStyle: AppTypography.buttonMedium,
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        minimumSize: const Size(0, AppSpacing.buttonHeightMD),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSM,
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.neutral400,
        textStyle: AppTypography.buttonMedium,
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        minimumSize: const Size(0, AppSpacing.buttonHeightMD),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSM,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.neutral400,
        backgroundColor: Colors.transparent,
        textStyle: AppTypography.buttonMedium,
        padding: AppSpacing.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        minimumSize: const Size(0, AppSpacing.buttonHeightMD),
        side: const BorderSide(color: AppColors.primary),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSM,
        ),
      ),
    ),

    // Icon Button Theme
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.onSurface,
        disabledForegroundColor: AppColors.neutral400,
        backgroundColor: Colors.transparent,
        padding: AppSpacing.paddingSM,
        minimumSize: const Size(AppSpacing.buttonHeightMD, AppSpacing.buttonHeightMD),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSM,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSM,
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSM,
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSM,
        borderSide: BorderSide(color: AppColors.borderFocus, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSM,
        borderSide: BorderSide(color: AppColors.borderError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSM,
        borderSide: BorderSide(color: AppColors.borderError, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: AppSpacing.borderRadiusSM,
        borderSide: BorderSide(color: AppColors.neutral300),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTypography.bodyMedium,
      labelStyle: AppTypography.labelMedium,
      errorStyle: AppTypography.bodySmall,
      helperStyle: AppTypography.bodySmall,
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusXS,
      ),
      side: const BorderSide(color: AppColors.border, width: 2),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.border;
      }),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.onPrimary;
        }
        return AppColors.neutral400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.neutral300;
      }),
    ),

    // Slider Theme
    sliderTheme: const SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.neutral300,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primaryLight,
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTypography.bodySmall,
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.neutral200,
      circularTrackColor: AppColors.neutral200,
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),

    // Dialog Theme
    dialogTheme: const DialogThemeData(
      elevation: 8,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.surface,
      titleTextStyle: AppTypography.h5,
      contentTextStyle: AppTypography.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusLG,
      ),
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      elevation: 8,
      shadowColor: AppColors.shadow,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLG),
        ),
      ),
    ),

    // Snack Bar Theme
    snackBarTheme: const SnackBarThemeData(
      elevation: 6,
      backgroundColor: AppColors.neutral800,
      contentTextStyle: AppTypography.bodyMedium,
      actionTextColor: AppColors.primaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Tab Bar Theme
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.neutral600,
      labelStyle: AppTypography.labelLarge,
      unselectedLabelStyle: AppTypography.labelMedium,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),

    // List Tile Theme
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      titleTextStyle: AppTypography.bodyLarge,
      subtitleTextStyle: AppTypography.bodyMedium,
      leadingAndTrailingTextStyle: AppTypography.labelMedium,
      iconColor: AppColors.neutral600,
      textColor: AppColors.onSurface,
    ),

    // Chip Theme
    chipTheme: const ChipThemeData(
      elevation: 0,
      pressElevation: 2,
      backgroundColor: AppColors.neutral100,
      selectedColor: AppColors.primary,
      secondarySelectedColor: AppColors.primaryLight,
      labelStyle: AppTypography.labelMedium,
      secondaryLabelStyle: AppTypography.labelMedium,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusCircle,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.neutral800,
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      textStyle: AppTypography.bodySmall,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
    ),

    // Scaffold background color
    scaffoldBackgroundColor: AppColors.background,

    // Splash color
    splashColor: AppColors.primaryLight,
    highlightColor: AppColors.primaryLight,

    // Focus color
    focusColor: AppColors.primaryLight,

    // Hover color
    hoverColor: AppColors.primaryLight,
  );

  // Dark Theme (you can implement this later)
  static ThemeData get darkTheme => lightTheme.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    // Add dark theme customizations here
  );
}