import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import 'app_button.dart';
import 'app_loader.dart';
import 'app_dropdown.dart';
import 'app_calendar.dart';
import 'app_input.dart';
import '../../app/providers/theme_provider.dart';

/// Showcase screen to display all reusable widgets
class WidgetShowcaseScreen extends ConsumerStatefulWidget {
  const WidgetShowcaseScreen({super.key});

  @override
  ConsumerState<WidgetShowcaseScreen> createState() =>
      _WidgetShowcaseScreenState();
}

class _WidgetShowcaseScreenState extends ConsumerState<WidgetShowcaseScreen> {
  @override
  Widget build(BuildContext context) {
    final themeModeState = ref.watch(themeModeProvider);
    final isDark = themeModeState.mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Showcase'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                ThemeModeNotifier.toggleTheme();
              });
              // Invalidate to force rebuild
              ref.invalidate(themeModeProvider);
            },
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              'Buttons',
              style: AppFonts.headlineLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All button variants in ${isDark ? "Dark" : "Light"} mode',
              style: AppFonts.bodyMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Primary Buttons - All Sizes
            _buildSection(context, 'Primary Buttons', [
              // Small
              Text(
                'Small (sm)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                text: 'Log In',
                size: ButtonSize.sm,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Small Primary pressed')),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Medium
              Text(
                'Medium (md)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                text: 'Sign Up',
                size: ButtonSize.md,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Medium Primary pressed')),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Large
              Text(
                'Large (lg)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                text: 'Continue',
                size: ButtonSize.lg,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Large Primary pressed')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Full width
              PrimaryButton(
                text: 'Full Width Button',
                size: ButtonSize.md,
                isFullWidth: true,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Full width pressed')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Disabled state
              PrimaryButton(
                text: 'Disabled Button',
                size: ButtonSize.md,
                onPressed: null,
              ),
            ]),

            const SizedBox(height: 48),

            // Secondary Buttons - All Sizes
            _buildSection(context, 'Secondary Buttons (Light Green)', [
              // Small
              Text(
                'Small (sm)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                text: 'Button',
                size: ButtonSize.sm,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Small Secondary pressed')),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Medium
              Text(
                'Medium (md)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                text: 'Cancel',
                size: ButtonSize.md,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Medium Secondary pressed')),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Large
              Text(
                'Large (lg)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              SecondaryButton(
                text: 'Submit',
                size: ButtonSize.lg,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Large Secondary pressed')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Full width
              SecondaryButton(
                text: 'Full Width Button',
                size: ButtonSize.md,
                isFullWidth: true,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Full width pressed')),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Disabled state
              SecondaryButton(
                text: 'Disabled',
                size: ButtonSize.md,
                onPressed: null,
              ),
            ]),

            const SizedBox(height: 48),

            // Font Weight Variants
            _buildSection(context, 'Font Weight Variants', [
              SecondaryButton(
                text: 'Regular Weight',
                size: ButtonSize.md,
                fontWeight: ButtonFontWeight.regular,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Regular pressed')),
                  );
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Medium Weight',
                size: ButtonSize.md,
                fontWeight: ButtonFontWeight.medium,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Medium pressed')),
                  );
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'SemiBold Weight',
                size: ButtonSize.md,
                fontWeight: ButtonFontWeight.semiBold,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('SemiBold pressed')),
                  );
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                text: 'Bold Weight',
                size: ButtonSize.md,
                fontWeight: ButtonFontWeight.bold,
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Bold pressed')));
                },
              ),
            ]),

            const SizedBox(height: 48),

            // Custom Width Buttons
            _buildSection(context, 'Custom Width Buttons', [
              AppButton(
                text: 'Custom 150px',
                size: ButtonSize.md,
                width: 150,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Custom 250px',
                size: ButtonSize.md,
                width: 250,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Custom 300px',
                size: ButtonSize.md,
                width: 300,
                onPressed: () {},
              ),
            ]),

            const SizedBox(height: 48),

            // Custom Styling Examples
            _buildSection(context, 'Custom Styling Examples', [
              AppButton(
                text: 'Custom Colors',
                size: ButtonSize.md,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Custom Border Radius',
                size: ButtonSize.md,
                borderRadius: 15,
                backgroundColor: Colors.purple,
                textColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Custom Padding',
                size: ButtonSize.md,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              AppButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Custom Child', style: TextStyle(color: Colors.white)),
                  ],
                ),
                size: ButtonSize.md,
                backgroundColor: Colors.orange,
                onPressed: () {},
              ),
            ]),

            const SizedBox(height: 48),

            // Loaders
            _buildSection(context, 'Loaders', [
              Text(
                'Loading State (3 dots animation)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLoader(state: LoaderState.loading, size: 60),
                  const SizedBox(width: 24),
                  AppLoader(state: LoaderState.loading, size: 80),
                  const SizedBox(width: 24),
                  AppLoader(state: LoaderState.loading, size: 100),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Success State (Checkmark)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLoader(state: LoaderState.success, size: 60),
                  const SizedBox(width: 24),
                  AppLoader(state: LoaderState.success, size: 80),
                  const SizedBox(width: 24),
                  AppLoader(state: LoaderState.success, size: 100),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Error State (Cross)',
                style: AppFonts.titleMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLoader(state: LoaderState.error, size: 60),
                  const SizedBox(width: 24),
                  AppLoader(state: LoaderState.error, size: 80),
                  const SizedBox(width: 24),
                  AppLoader(state: LoaderState.error, size: 100),
                ],
              ),
            ]),

            const SizedBox(height: 48),

            // Dropdown
            _buildDropdownSection(context),

            const SizedBox(height: 48),

            // Calendar
            _buildCalendarSection(context),

            const SizedBox(height: 48),

            // Input Fields
            _buildInputSection(context),

            const SizedBox(height: 48),

            // Color Reference
            _buildColorReference(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return _buildSection(context, 'Input Fields', [
      // Text Input
      AppInput(
        type: InputType.text,
        hintText: 'Enter your name',
        labelText: 'Full Name',
        showLabel: true,
        onChanged: (value) {},
      ),
      const SizedBox(height: 16),
      // Email Input
      AppInput(
        type: InputType.email,
        hintText: 'Enter your email',
        labelText: 'Email Address',
        showLabel: true,
        onChanged: (value) {},
      ),
      const SizedBox(height: 16),
      // Phone Input
      AppInput(
        type: InputType.phone,
        hintText: 'Enter phone number',
        labelText: 'Phone Number',
        showLabel: true,
        onChanged: (value) {},
      ),
      const SizedBox(height: 16),
      // Number Input
      AppInput(
        type: InputType.number,
        hintText: 'Enter amount',
        labelText: 'Amount',
        showLabel: true,
        decimalPlaces: 2,
        minValue: 0,
        maxValue: 1000000,
        onChanged: (value) {},
      ),
      const SizedBox(height: 16),
      // Password Input
      AppInput(
        type: InputType.password,
        hintText: 'Enter password',
        labelText: 'Password',
        showLabel: true,
        onChanged: (value) {},
      ),
      const SizedBox(height: 16),
      // DOB Input
      AppInput(
        type: InputType.dob,
        hintText: 'Select date of birth',
        labelText: 'Date of Birth',
        showLabel: true,
        onDateSelected: (date) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: ${date.toString().split(' ')[0]}'),
            ),
          );
        },
      ),
      const SizedBox(height: 16),
      // Textarea
      AppInput(
        type: InputType.textarea,
        hintText: 'Enter your message',
        labelText: 'Message',
        showLabel: true,
        minLines: 4,
        maxLines: 6,
        onChanged: (value) {},
      ),
    ]);
  }

  Widget _buildCalendarSection(BuildContext context) {
    return _buildSection(context, 'Calendar', [
      Text(
        'Calendar Button (Click to show/hide)',
        style: AppFonts.titleMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 16),
      AppCalendarButton(
        hintText: 'Select date',
        onDateSelected: (date) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected date: ${date.toString().split(' ')[0]}'),
            ),
          );
        },
      ),
      const SizedBox(height: 32),
      Text(
        'Calendar (Direct Display)',
        style: AppFonts.titleMedium.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 16),
      AppCalendar(
        onDateSelected: (date) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected date: ${date.toString().split(' ')[0]}'),
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildDropdownSection(BuildContext context) {
    return _buildSection(context, 'Dropdown Selection', [
      AppDropdown<String>(
        hintText: 'Select the category',
        items: const [
          DropdownItem(value: 'food', label: 'Food'),
          DropdownItem(value: 'transport', label: 'Transport'),
          DropdownItem(value: 'groceries', label: 'Groceries'),
          DropdownItem(value: 'rent', label: 'Rent'),
          DropdownItem(value: 'gifts', label: 'Gifts'),
          DropdownItem(value: 'medicine', label: 'Medicine'),
          DropdownItem(value: 'entertainment', label: 'Entertainment'),
          DropdownItem(value: 'saving', label: 'Saving'),
        ],
        onChanged: (value) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Selected: $value')));
        },
      ),
      const SizedBox(height: 16),
      AppDropdown<String>(
        hintText: 'Select the category',
        value: 'food',
        items: const [
          DropdownItem(value: 'food', label: 'Food'),
          DropdownItem(value: 'transport', label: 'Transport'),
          DropdownItem(value: 'groceries', label: 'Groceries'),
          DropdownItem(value: 'rent', label: 'Rent'),
          DropdownItem(value: 'gifts', label: 'Gifts'),
          DropdownItem(value: 'medicine', label: 'Medicine'),
          DropdownItem(value: 'entertainment', label: 'Entertainment'),
          DropdownItem(value: 'saving', label: 'Saving'),
        ],
        onChanged: (value) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Selected: $value')));
        },
      ),
    ]);
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.titleLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildColorReference(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Reference',
          style: AppFonts.titleLarge.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildColorBox('Caribbean Green (Active)', AppColors.caribbeanGreen),
        const SizedBox(height: 8),
        _buildColorBox('Light Green (Inactive)', AppColors.lightGreen),
        const SizedBox(height: 8),
        _buildColorBox('Cyprus (Text)', AppColors.cyprus),
        const SizedBox(height: 8),
        _buildColorBox('Dark Text (#093030)', const Color(0xFF093030)),
      ],
    );
  }

  Widget _buildColorBox(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppFonts.bodyMedium),
              Text(
                '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                style: AppFonts.bodySmall.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
