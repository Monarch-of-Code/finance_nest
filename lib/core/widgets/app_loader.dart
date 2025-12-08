import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Loader state variants
enum LoaderState { loading, success, error }

/// Custom loader widget with loading, success, and error states
class AppLoader extends StatefulWidget {
  final LoaderState state;
  final double size;
  final Color? backgroundColor;
  final Color? successColor;
  final Color? errorColor;

  const AppLoader({
    super.key,
    required this.state,
    this.size = 60,
    this.backgroundColor,
    this.successColor,
    this.errorColor,
  });

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // All elements use the same color based on theme
    // Light mode: Caribbean Green, Dark mode: Light Green
    final elementColor =
        widget.backgroundColor ??
        (isDark ? AppColors.lightGreen : AppColors.caribbeanGreen);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: elementColor, width: 4.0),
        ),
        child: Center(child: _buildContent(elementColor)),
      ),
    );
  }

  Widget _buildContent(Color contentColor) {
    switch (widget.state) {
      case LoaderState.loading:
        return _buildLoadingAnimation(contentColor);
      case LoaderState.success:
        return _buildSuccessCheckmark(contentColor);
      case LoaderState.error:
        return _buildErrorCross(contentColor);
    }
  }

  /// Builds the 3-dot loading animation
  Widget _buildLoadingAnimation(Color dotColor) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = (_animationController.value + delay) % 1.0;
            final opacity = (animationValue < 0.5)
                ? animationValue * 2
                : 2 - (animationValue * 2);
            final scale =
                0.5 +
                (animationValue < 0.5 ? animationValue : 1 - animationValue);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity.clamp(0.3, 1.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  /// Builds custom checkmark (success state)
  Widget _buildSuccessCheckmark(Color contentColor) {
    final color = widget.successColor ?? contentColor;
    return CustomPaint(
      size: Size(widget.size * 0.6, widget.size * 0.6),
      painter: _CheckmarkPainter(color: color),
    );
  }

  /// Builds custom cross/X mark (error state)
  Widget _buildErrorCross(Color contentColor) {
    final color = widget.errorColor ?? contentColor;
    return CustomPaint(
      size: Size(widget.size * 0.6, widget.size * 0.6),
      painter: _CrossPainter(color: color),
    );
  }
}

/// Custom painter for checkmark
class _CheckmarkPainter extends CustomPainter {
  final Color color;
  static const double _strokeWidth = 4.0;

  _CheckmarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Draw checkmark: start from left, curve down, then up-right
    final startX = size.width * 0.2;
    final startY = size.height * 0.5;
    final midX = size.width * 0.45;
    final midY = size.height * 0.7;
    final endX = size.width * 0.8;
    final endY = size.height * 0.3;

    path.moveTo(startX, startY);
    path.lineTo(midX, midY);
    path.lineTo(endX, endY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for cross/X mark
class _CrossPainter extends CustomPainter {
  final Color color;
  static const double _strokeWidth = 4.0;

  _CrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Draw X: diagonal from top-left to bottom-right, then top-right to bottom-left
    final margin = size.width * 0.2;

    // First diagonal: top-left to bottom-right
    path.moveTo(margin, margin);
    path.lineTo(size.width - margin, size.height - margin);

    // Second diagonal: top-right to bottom-left
    path.moveTo(size.width - margin, margin);
    path.lineTo(margin, size.height - margin);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
