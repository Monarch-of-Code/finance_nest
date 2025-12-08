import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';

/// Unified button size variants for all buttons
enum ButtonSize {
  sm, // Small
  md, // Medium
  lg, // Large
}

/// Font weight variants
enum ButtonFontWeight {
  regular, // FontWeight.w400
  medium, // FontWeight.w500
  semiBold, // FontWeight.w600
  bold, // FontWeight.w700
}

/// Button style variants
enum AppButtonStyle {
  primary, // Caribbean Green background
  secondary, // Light Green background
}

/// Highly customizable button widget
class AppButton extends StatelessWidget {
  // Content
  final String? text;
  final Widget? child; // Custom child widget (for CSS-like customization)
  final IconData? icon;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  // Actions
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  // Size & Layout
  final ButtonSize size;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  // Styling
  final AppButtonStyle buttonStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final double? borderRadius;
  final double? elevation;
  final BorderSide? border;
  final Gradient? gradient;

  // Typography
  final ButtonFontWeight fontWeight;
  final double? fontSize;
  final Color? textColor;
  final double? letterSpacing;
  final double? lineHeight;

  // Custom styling (CSS-like)
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final ButtonStyle? materialButtonStyle; // Material ButtonStyle override

  const AppButton({
    super.key,
    this.text,
    this.child,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.onPressed,
    this.onLongPress,
    this.size = ButtonSize.md,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.buttonStyle = AppButtonStyle.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderRadius,
    this.elevation,
    this.border,
    this.gradient,
    this.fontWeight = ButtonFontWeight.semiBold,
    this.fontSize,
    this.textColor,
    this.letterSpacing,
    this.lineHeight,
    this.decoration,
    this.textStyle,
    this.materialButtonStyle,
  }) : assert(
         text != null || child != null || icon != null,
         'Either text, child, or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null || onLongPress != null;

    // Get size-specific values
    final sizeConfig = _getSizeConfig(size);

    // Determine colors
    final bgColor =
        backgroundColor ??
        (buttonStyle == AppButtonStyle.primary
            ? (isEnabled ? AppColors.caribbeanGreen : AppColors.lightGreen)
            : AppColors.lightGreen);

    final fgColor =
        foregroundColor ??
        (buttonStyle == AppButtonStyle.primary
            ? (isEnabled ? const Color(0xFF093030) : AppColors.cyprus)
            : AppColors.cyprus);

    final disabledBgColor = disabledBackgroundColor ?? bgColor;
    final disabledFgColor = disabledForegroundColor ?? fgColor;

    // Determine text style
    final defaultTextStyle = _getTextStyle(
      size: size,
      fontWeight: fontWeight,
      color: textColor ?? fgColor,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      lineHeight: lineHeight,
    );

    final finalTextStyle = textStyle ?? defaultTextStyle;

    // Build content
    Widget content = _buildContent(
      text: text,
      child: child,
      icon: icon,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      textStyle: finalTextStyle,
    );

    // Button dimensions
    final buttonWidth = isFullWidth
        ? double.infinity
        : (width ?? sizeConfig.width);
    final buttonHeight = height ?? sizeConfig.height;
    final buttonPadding = padding ?? sizeConfig.padding;
    final buttonBorderRadius = borderRadius ?? sizeConfig.borderRadius;

    // Build button with custom decoration if provided
    Widget button;
    if (decoration != null || gradient != null) {
      // Use Container with custom decoration for CSS-like styling
      button = Container(
        width: buttonWidth,
        height: buttonHeight,
        margin: margin,
        decoration:
            decoration ??
            BoxDecoration(
              gradient: gradient,
              color: gradient == null ? bgColor : null,
              borderRadius: BorderRadius.circular(buttonBorderRadius),
              border: border != null
                  ? Border.all(
                      color: border!.color,
                      width: border!.width,
                      style: border!.style,
                    )
                  : null,
            ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            onLongPress: isEnabled ? onLongPress : null,
            borderRadius: BorderRadius.circular(buttonBorderRadius),
            child: Container(
              padding: buttonPadding,
              alignment: Alignment.center,
              child: content,
            ),
          ),
        ),
      );
    } else {
      // Use standard ElevatedButton
      button = SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          onLongPress: isEnabled ? onLongPress : null,
          style:
              materialButtonStyle ??
              ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: fgColor,
                disabledBackgroundColor: disabledBgColor,
                disabledForegroundColor: disabledFgColor,
                elevation: elevation ?? 0,
                padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonBorderRadius),
                  side: border ?? BorderSide.none,
                ),
              ),
          child: content,
        ),
      );
    }

    // Apply margin if provided
    if (margin != null && decoration == null && gradient == null) {
      return Container(margin: margin, child: button);
    }

    return button;
  }

  Widget _buildContent({
    String? text,
    Widget? child,
    IconData? icon,
    Widget? leadingIcon,
    Widget? trailingIcon,
    TextStyle? textStyle,
  }) {
    // If custom child provided, use it
    if (child != null) return child;

    // Build icon + text combination
    if (icon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textStyle?.color),
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    // Build leading icon + text
    if (leadingIcon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leadingIcon,
          const SizedBox(width: 8),
          Text(text, style: textStyle),
        ],
      );
    }

    // Build text + trailing icon
    if (trailingIcon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text, style: textStyle),
          const SizedBox(width: 8),
          trailingIcon,
        ],
      );
    }

    // Just icon
    if (icon != null) {
      return Icon(icon, color: textStyle?.color);
    }

    // Just text
    if (text != null) {
      return Text(text, style: textStyle, textAlign: TextAlign.center);
    }

    return const SizedBox.shrink();
  }

  _SizeConfig _getSizeConfig(ButtonSize size) {
    switch (size) {
      case ButtonSize.sm:
        return _SizeConfig(
          fontSize: 14,
          height: 40,
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: 30,
        );
      case ButtonSize.md:
        return _SizeConfig(
          fontSize: 16,
          height: 45,
          width: 207,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          borderRadius: 30,
        );
      case ButtonSize.lg:
        return _SizeConfig(
          fontSize: 20,
          height: 50,
          width: 250,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          borderRadius: 30,
        );
    }
  }

  TextStyle _getTextStyle({
    required ButtonSize size,
    required ButtonFontWeight fontWeight,
    required Color color,
    double? fontSize,
    double? letterSpacing,
    double? lineHeight,
  }) {
    final sizeConfig = _getSizeConfig(size);
    final fontSizeValue = fontSize ?? sizeConfig.fontSize;

    FontWeight fontWeightValue;
    switch (fontWeight) {
      case ButtonFontWeight.regular:
        fontWeightValue = FontWeight.w400;
        break;
      case ButtonFontWeight.medium:
        fontWeightValue = FontWeight.w500;
        break;
      case ButtonFontWeight.semiBold:
        fontWeightValue = FontWeight.w600;
        break;
      case ButtonFontWeight.bold:
        fontWeightValue = FontWeight.w700;
        break;
    }

    return AppFonts.poppins(
      fontSize: fontSizeValue,
      fontWeight: fontWeightValue,
      color: color,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );
  }
}

/// Size configuration helper
class _SizeConfig {
  final double fontSize;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  _SizeConfig({
    required this.fontSize,
    required this.height,
    required this.width,
    required this.padding,
    required this.borderRadius,
  });
}

/// Primary button - Caribbean Green style
class PrimaryButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isFullWidth;
  final double? width;
  final ButtonFontWeight fontWeight;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final IconData? icon;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;

  const PrimaryButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = ButtonSize.md,
    this.isFullWidth = false,
    this.width,
    this.fontWeight = ButtonFontWeight.semiBold,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.decoration,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      child: child,
      icon: icon,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      onPressed: onPressed,
      size: size,
      isFullWidth: isFullWidth,
      width: width,
      buttonStyle: AppButtonStyle.primary,
      fontWeight: fontWeight,
      margin: margin,
      padding: padding,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      decoration: decoration,
      textStyle: textStyle,
    );
  }
}

/// Secondary button - Light Green style
class SecondaryButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isFullWidth;
  final double? width;
  final ButtonFontWeight fontWeight;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final IconData? icon;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;

  const SecondaryButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.size = ButtonSize.md,
    this.isFullWidth = false,
    this.width,
    this.fontWeight = ButtonFontWeight.regular,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.leadingIcon,
    this.trailingIcon,
    this.icon,
    this.decoration,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      child: child,
      icon: icon,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      onPressed: onPressed,
      size: size,
      isFullWidth: isFullWidth,
      width: width,
      buttonStyle: AppButtonStyle.secondary,
      fontWeight: fontWeight,
      margin: margin,
      padding: padding,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: borderRadius,
      decoration: decoration,
      textStyle: textStyle,
    );
  }
}
