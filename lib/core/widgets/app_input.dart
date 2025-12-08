import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import 'app_calendar.dart';

/// Input type variants
enum InputType { text, email, phone, number, password, dob, textarea }

/// Custom input widget with multiple types
class AppInput extends StatefulWidget {
  final InputType type;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<DateTime>? onDateSelected;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? placeholderColor;
  final bool obscureText;
  final bool showLabel;
  final String? phoneFormat; // e.g., "+1 (XXX) XXX-XXXX"
  final int? decimalPlaces; // For number input
  final double? minValue;
  final double? maxValue;

  const AppInput({
    super.key,
    required this.type,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.onChanged,
    this.onDateSelected,
    this.validator,
    this.controller,
    this.enabled = true,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.textInputAction,
    this.focusNode,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.placeholderColor,
    this.obscureText = false,
    this.showLabel = false,
    this.phoneFormat,
    this.decimalPlaces,
    this.minValue,
    this.maxValue,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late TextEditingController _controller;
  bool _obscureText = true;
  bool _showCalendar = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _obscureText = widget.type == InputType.password;
    if (widget.type == InputType.dob && widget.initialValue != null) {
      try {
        _selectedDate = DateTime.parse(widget.initialValue!);
      } catch (e) {
        // Invalid date format
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _showCalendar = false;
      _controller.text = _formatDate(date);
    });
    widget.onDateSelected?.call(date);
    widget.onChanged?.call(_formatDate(date));
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String? _validateInput(String? value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }

    if (value == null || value.isEmpty) {
      return null; // Let required validation be handled by FormField
    }

    switch (widget.type) {
      case InputType.email:
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case InputType.phone:
        final phoneRegex = RegExp(r'^[0-9+\-\s()]+$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case InputType.number:
        final number = double.tryParse(value);
        if (number == null) {
          return 'Please enter a valid number';
        }
        if (widget.minValue != null && number < widget.minValue!) {
          return 'Value must be at least ${widget.minValue}';
        }
        if (widget.maxValue != null && number > widget.maxValue!) {
          return 'Value must be at most ${widget.maxValue}';
        }
        break;
      default:
        break;
    }
    return null;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case InputType.phone:
        return [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]'))];
      case InputType.number:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            final text = newValue.text;
            // Allow empty
            if (text.isEmpty) return newValue;

            // Check if it's a valid number format
            final decimalPlaces = widget.decimalPlaces ?? 2;
            final parts = text.split('.');

            // Only allow one decimal point
            if (parts.length > 2) return oldValue;

            // If there's a decimal part, check decimal places
            if (parts.length == 2 && parts[1].length > decimalPlaces) {
              return oldValue;
            }

            // Check if it's a valid number
            final number = double.tryParse(text);
            if (number == null && text != '.' && text != '-') {
              return oldValue;
            }

            return newValue;
          }),
        ];
      default:
        return null;
    }
  }

  TextInputType? _getKeyboardType() {
    switch (widget.type) {
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.phone:
        return TextInputType.phone;
      case InputType.number:
        return TextInputType.numberWithOptions(
          decimal: widget.decimalPlaces != null,
        );
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = widget.backgroundColor ?? AppColors.lightGreen;
    // Always use cyprus color for input text to maintain consistency across themes
    final textColor = widget.textColor ?? AppColors.cyprus;
    // Label color should be theme-aware: lightGreen in dark mode, cyprus in light mode
    final labelColor = isDark ? AppColors.lightGreen : AppColors.cyprus;
    final placeholderColor =
        widget.placeholderColor ?? AppColors.cyprus.withValues(alpha: 0.6);
    final borderRadius = widget.borderRadius ?? 24.0;

    // DOB input with calendar
    if (widget.type == InputType.dob) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showLabel && widget.labelText != null) ...[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                widget.labelText!,
                style: AppFonts.bodyMedium.copyWith(color: labelColor),
              ),
            ),
            const SizedBox(height: 8),
          ],
          GestureDetector(
            onTap: widget.enabled
                ? () {
                    setState(() {
                      _showCalendar = !_showCalendar;
                    });
                  }
                : null,
            child: Container(
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate != null
                          ? _formatDate(_selectedDate!)
                          : (widget.hintText ?? 'Select date of birth'),
                      style: AppFonts.bodyMedium.copyWith(
                        color: _selectedDate != null
                            ? textColor
                            : placeholderColor,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today, color: textColor, size: 20),
                ],
              ),
            ),
          ),
          if (_showCalendar) ...[
            const SizedBox(height: 8),
            AppCalendar(
              initialDate: _selectedDate,
              selectedDate: _selectedDate,
              onDateSelected: _selectDate,
              showTitle: false,
            ),
          ],
        ],
      );
    }

    // Password input with eye icon
    if (widget.type == InputType.password) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showLabel && widget.labelText != null) ...[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                widget.labelText!,
                style: AppFonts.bodyMedium.copyWith(color: labelColor),
              ),
            ),
            const SizedBox(height: 8),
          ],
          TextFormField(
            controller: _controller,
            enabled: widget.enabled,
            obscureText: _obscureText,
            maxLength: widget.maxLength,
            textInputAction: widget.textInputAction,
            focusNode: widget.focusNode,
            validator: _validateInput,
            onChanged: widget.onChanged,
            keyboardType: _getKeyboardType(),
            inputFormatters: _getInputFormatters(),
            style: TextStyle(
              color:
                  textColor, // Always use cyprus color, never inherit from theme
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
              height: 1.43,
              decorationColor: textColor, // Ensure decoration color matches
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppFonts.bodyMedium.copyWith(color: placeholderColor),
              filled: true,
              fillColor: bgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              counterText: '',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: textColor,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
          ),
        ],
      );
    }

    // Textarea
    if (widget.type == InputType.textarea) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showLabel && widget.labelText != null) ...[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                widget.labelText!,
                style: AppFonts.bodyMedium.copyWith(color: labelColor),
              ),
            ),
            const SizedBox(height: 8),
          ],
          TextFormField(
            controller: _controller,
            enabled: widget.enabled,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines ?? 5,
            minLines: widget.minLines ?? 3,
            textInputAction: widget.textInputAction,
            focusNode: widget.focusNode,
            validator: _validateInput,
            onChanged: widget.onChanged,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color:
                  textColor, // Always use cyprus color, never inherit from theme
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
              height: 1.43,
              decorationColor: textColor, // Ensure decoration color matches
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppFonts.bodyMedium.copyWith(color: placeholderColor),
              filled: true,
              fillColor: bgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              counterText: '',
            ),
          ),
        ],
      );
    }

    // Regular text inputs (text, email, phone, number)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabel && widget.labelText != null) ...[
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              widget.labelText!,
              style: AppFonts.bodyMedium.copyWith(color: labelColor),
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          validator: _validateInput,
          onChanged: widget.onChanged,
          keyboardType: _getKeyboardType(),
          inputFormatters: _getInputFormatters(),
          style: TextStyle(
            color:
                textColor, // Always use cyprus color, never inherit from theme
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
            height: 1.43,
            decorationColor: textColor, // Ensure decoration color matches
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppFonts.bodyMedium.copyWith(color: placeholderColor),
            filled: true,
            fillColor: bgColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            counterText: '',
          ),
        ),
      ],
    );
  }
}
