import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import 'app_dropdown.dart';

/// Calendar widget that can be shown directly or triggered by a button
class AppCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? selectedDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool showTitle;
  final String? title;

  const AppCalendar({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.selectedDate,
    this.minDate,
    this.maxDate,
    this.showTitle = true,
    this.title,
  });

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _currentDate;
  late DateTime _displayedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate ?? DateTime.now();
    _displayedMonth = DateTime(_currentDate.year, _currentDate.month);
    _selectedDate = widget.selectedDate ?? widget.initialDate;
  }

  @override
  void didUpdateWidget(AppCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _selectedDate = widget.selectedDate;
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected?.call(date);
  }

  void _changeMonth(int month) {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, month);
    });
  }

  void _changeYear(int year) {
    setState(() {
      _displayedMonth = DateTime(year, _displayedMonth.month);
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDay = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    
    // Get the weekday of the first day (1 = Monday, 7 = Sunday)
    int firstDayWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday
    
    List<DateTime> days = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstDayWeekday; i++) {
      days.add(DateTime(firstDay.year, firstDay.month, 0 - (firstDayWeekday - i - 1)));
    }
    
    // Add all days of the month
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, i));
    }
    
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final currentYear = DateTime.now().year;
    final years = List.generate(100, (index) => currentYear - 50 + index);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.lightGreen,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTitle) ...[
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.title ?? 'Calendar',
                  style: AppFonts.titleLarge.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          // Month and Year selectors
          Row(
            children: [
              Expanded(
                child: AppDropdown<int>(
                  hintText: monthNames[_displayedMonth.month - 1],
                  value: _displayedMonth.month,
                  textColor: AppColors.caribbeanGreen,
                  maxHeight: 200,
                  items: List.generate(12, (index) {
                    return DropdownItem(
                      value: index + 1,
                      label: monthNames[index],
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) _changeMonth(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppDropdown<int>(
                  hintText: _displayedMonth.year.toString(),
                  value: _displayedMonth.year,
                  textColor: AppColors.caribbeanGreen,
                  maxHeight: 200,
                  items: years.map((year) {
                    return DropdownItem(
                      value: year,
                      label: year.toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) _changeYear(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Days of week header
          _buildDaysOfWeekHeader(),
          const SizedBox(height: 8),
          // Calendar grid
          _buildCalendarGrid(days),
        ],
      ),
    );
  }

  Widget _buildDaysOfWeekHeader() {
    final dayHeaders = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Row(
      children: List.generate(7, (index) {
        final isWeekend = index >= 5; // Sat and Sun
        return Expanded(
          child: Center(
            child: Text(
              dayHeaders[index],
              style: AppFonts.bodySmall.copyWith(
                color: isWeekend ? Colors.black : AppColors.lightBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalendarGrid(List<DateTime> days) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        final isCurrentMonth = date.month == _displayedMonth.month;
        final isSelected = _selectedDate != null &&
            date.year == _selectedDate!.year &&
            date.month == _selectedDate!.month &&
            date.day == _selectedDate!.day;
        final isToday = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;

        if (!isCurrentMonth) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () => _selectDate(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.caribbeanGreen : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: AppFonts.bodyMedium.copyWith(
                  color: isSelected
                      ? Colors.white
                      : (isToday
                          ? AppColors.caribbeanGreen
                          : const Color(0xFF093030)),
                  fontWeight: isSelected || isToday
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Calendar button that shows/hides the calendar
class AppCalendarButton extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? selectedDate;
  final String? hintText;
  final bool isFullWidth;
  final double? width;

  const AppCalendarButton({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.selectedDate,
    this.hintText,
    this.isFullWidth = false,
    this.width,
  });

  @override
  State<AppCalendarButton> createState() => _AppCalendarButtonState();
}

class _AppCalendarButtonState extends State<AppCalendarButton> {
  bool _showCalendar = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? widget.initialDate;
  }

  @override
  void didUpdateWidget(AppCalendarButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _selectedDate = widget.selectedDate;
    }
  }

  String _getDisplayText() {
    if (_selectedDate != null) {
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
        'Dec'
      ];
      return '${months[_selectedDate!.month - 1]} ${_selectedDate!.day}, ${_selectedDate!.year}';
    }
    return widget.hintText ?? 'Select date';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showCalendar = !_showCalendar;
            });
          },
          child: Container(
            width: widget.isFullWidth ? double.infinity : widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _getDisplayText(),
                    style: AppFonts.bodyMedium.copyWith(
                      color: _selectedDate != null
                          ? const Color(0xFF093030)
                          : Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _showCalendar
                      ? Icons.keyboard_arrow_up
                      : Icons.calendar_today,
                  color: const Color(0xFF093030),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (_showCalendar) ...[
          const SizedBox(height: 8),
          AppCalendar(
            initialDate: _selectedDate ?? widget.initialDate,
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _showCalendar = false;
              });
              widget.onDateSelected?.call(date);
            },
          ),
        ],
      ],
    );
  }
}

