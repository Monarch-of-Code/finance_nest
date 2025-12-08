import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';

/// Custom dropdown selection widget
class AppDropdown<T> extends StatefulWidget {
  final String? hintText;
  final T? value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? textColor;
  final double? maxHeight;

  const AppDropdown({
    super.key,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.padding,
    this.borderRadius,
    this.textColor,
    this.maxHeight,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  bool _isExpanded = false;
  T? _selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _buttonKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(AppDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _selectedValue = widget.value;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _showOverlay();
        // Scroll to selected item after overlay is shown
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToSelected();
        });
      } else {
        _removeOverlay();
      }
    });
  }

  void _scrollToSelected() {
    final selectedValue = _selectedValue ?? widget.value;
    if (selectedValue == null) return;

    // Wait for the scroll controller to be attached
    if (!_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected();
      });
      return;
    }

    try {
      final selectedIndex = widget.items.indexWhere(
        (item) => item.value == selectedValue,
      );
      if (selectedIndex == -1) return;

      // Get actual item height from padding
      final padding =
          widget.padding ??
          const EdgeInsets.only(left: 24, right: 16, top: 16, bottom: 16);
      final itemHeight =
          padding.vertical + 20.0; // padding + approximate text height

      // Calculate scroll position to show selected item near the top (with some offset)
      final scrollPosition =
          (selectedIndex * itemHeight) - 8.0; // Small offset from top

      // Ensure scroll position is within bounds
      final maxScroll = _scrollController.position.maxScrollExtent;
      final clampedPosition = scrollPosition.clamp(0.0, maxScroll);

      _scrollController.jumpTo(clampedPosition);
    } catch (e) {
      // Ignore errors
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Invisible tap area to close dropdown when clicking outside
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown list
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            width: size.width,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap:
                    () {}, // Prevent tap from closing when clicking on dropdown
                child: _buildDropdownList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectItem(T? value) {
    setState(() {
      _selectedValue = value;
      _isExpanded = false;
    });
    _removeOverlay();
    widget.onChanged?.call(value);
  }

  String _getDisplayText() {
    final valueToUse = _selectedValue ?? widget.value;
    if (valueToUse != null) {
      try {
        final selectedItem = widget.items.firstWhere(
          (item) => item.value == valueToUse,
        );
        return selectedItem.label;
      } catch (e) {
        return widget.hintText ?? 'Select the category';
      }
    }
    return widget.hintText ?? 'Select the category';
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          key: _buttonKey,
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          ),
          padding:
              widget.padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _getDisplayText(),
                  style: AppFonts.bodyMedium.copyWith(
                    color: (_selectedValue ?? widget.value) != null
                        ? (widget.textColor ?? const Color(0xFF093030))
                        : Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: widget.textColor ?? const Color(0xFF093030),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownList() {
    final maxHeight = widget.maxHeight ?? 200.0;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.map((item) {
              final isSelected = (_selectedValue ?? widget.value) == item.value;
              return InkWell(
                onTap: () => _selectItem(item.value),
                child: Container(
                  width: double.infinity,
                  padding:
                      widget.padding ??
                      EdgeInsets.only(
                        left: 24, // More padding on left for right alignment
                        right: 16,
                        top: 16,
                        bottom: 16,
                      ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.caribbeanGreen
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 12,
                    ),
                  ),
                  child: Text(
                    item.label,
                    style: AppFonts.bodyMedium.copyWith(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF093030),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Dropdown item model
class DropdownItem<T> {
  final T value;
  final String label;

  const DropdownItem({required this.value, required this.label});
}
