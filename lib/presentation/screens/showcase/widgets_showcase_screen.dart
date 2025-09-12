import 'package:flutter/material.dart';
import '../../widgets/base/buttons/base_button.dart';
import '../../widgets/base/inputs/base_text_field.dart';
import '../../widgets/base/inputs/base_dropdown.dart';
import '../../widgets/base/inputs/base_checkbox.dart';
import '../../widgets/base/layout/base_card.dart';
import '../../widgets/base/layout/base_container.dart';
import '../../widgets/base/layout/base_scaffold.dart';
import '../../widgets/base/feedback/base_dialog.dart';
import '../../widgets/base/feedback/base_snackbar.dart';
import '../../widgets/base/state/base_loading.dart';
import '../../widgets/base/state/base_empty.dart';
import '../../widgets/base/state/base_error.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/design_system/typography.dart';
import '../../../core/design_system/colors.dart';

class WidgetsShowcaseScreen extends StatefulWidget {
  const WidgetsShowcaseScreen({super.key});

  @override
  State<WidgetsShowcaseScreen> createState() => _WidgetsShowcaseScreenState();
}

class _WidgetsShowcaseScreenState extends State<WidgetsShowcaseScreen> {
  bool _checkboxValue = false;
  String? _dropdownValue;
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();

  final List<BaseDropdownItem<String>> _dropdownItems = [
    const BaseDropdownItem(value: 'option1', label: 'Option 1'),
    const BaseDropdownItem(value: 'option2', label: 'Option 2'),
    const BaseDropdownItem(value: 'option3', label: 'Option 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldFactory.simple(
      title: 'Base Widgets Showcase',
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Buttons'),
            _buildButtonsSection(),
            AppSpacing.vSpaceXXL,
            
            _buildSectionTitle('Input Components'),
            _buildInputsSection(),
            AppSpacing.vSpaceXXL,
            
            _buildSectionTitle('Cards & Containers'),
            _buildCardsSection(),
            AppSpacing.vSpaceXXL,
            
            _buildSectionTitle('Feedback Components'),
            _buildFeedbackSection(),
            AppSpacing.vSpaceXXL,
            
            _buildSectionTitle('State Components'),
            _buildStateSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: AppSpacing.paddingVerticalMD,
      child: Text(
        title,
        style: AppTypography.h4.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildButtonsSection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Button Types', style: AppTypography.h6),
          AppSpacing.vSpaceMD,
          
          // Primary Buttons
          const Text('Primary Buttons', style: AppTypography.labelLarge),
          AppSpacing.vSpaceSM,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              BaseButtonFactory.primary(
                text: 'Small',
                size: BaseButtonSize.small,
                onPressed: () => _showSnackbar('Small Primary Button pressed'),
              ),
              BaseButtonFactory.primary(
                text: 'Medium',
                size: BaseButtonSize.medium,
                onPressed: () => _showSnackbar('Medium Primary Button pressed'),
              ),
              BaseButtonFactory.primary(
                text: 'Large',
                size: BaseButtonSize.large,
                onPressed: () => _showSnackbar('Large Primary Button pressed'),
              ),
            ],
          ),
          AppSpacing.vSpaceMD,
          
          // Secondary Buttons
          const Text('Secondary Buttons', style: AppTypography.labelLarge),
          AppSpacing.vSpaceSM,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              BaseButtonFactory.secondary(
                text: 'Secondary',
                onPressed: () => _showSnackbar('Secondary Button pressed'),
              ),
              BaseButtonFactory.outline(
                text: 'Outline',
                onPressed: () => _showSnackbar('Outline Button pressed'),
              ),
              BaseButtonFactory.text(
                text: 'Text',
                onPressed: () => _showSnackbar('Text Button pressed'),
              ),
            ],
          ),
          AppSpacing.vSpaceMD,
          
          // Button with Icons
          const Text('Buttons with Icons', style: AppTypography.labelLarge),
          AppSpacing.vSpaceSM,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              BaseButtonFactory.primary(
                text: 'Save',
                icon: Icons.save,
                onPressed: () => _showSnackbar('Save Button pressed'),
              ),
              BaseButtonFactory.danger(
                text: 'Delete',
                icon: Icons.delete,
                onPressed: () => _showConfirmDialog(),
              ),
              BaseButton(
                text: 'Loading',
                isLoading: _isLoading,
                onPressed: () => _simulateLoading(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputsSection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Input Components', style: AppTypography.h6),
          AppSpacing.vSpaceMD,
          
          // Text Fields
          BaseTextFieldFactory.text(
            label: 'Name',
            hintText: 'Enter your name',
            controller: _textController,
            onChanged: (value) => debugPrint('Text changed: $value'),
          ),
          AppSpacing.vSpaceMD,
          
          BaseTextFieldFactory.email(
            label: 'Email',
            hintText: 'Enter your email',
            isRequired: true,
          ),
          AppSpacing.vSpaceMD,
          
          BaseTextFieldFactory.password(
            label: 'Password',
            hintText: 'Enter your password',
            isRequired: true,
          ),
          AppSpacing.vSpaceMD,
          
          BaseTextFieldFactory.search(
            hintText: 'Search...',
            onChanged: (value) => debugPrint('Search: $value'),
          ),
          AppSpacing.vSpaceMD,
          
          // Dropdown
          BaseDropdownFactory.create<String>(
            label: 'Select Option',
            hintText: 'Choose an option',
            items: _dropdownItems,
            value: _dropdownValue,
            onChanged: (value) {
              setState(() {
                _dropdownValue = value;
              });
            },
          ),
          AppSpacing.vSpaceMD,
          
          // Checkbox
          BaseCheckboxFactory.simple(
            value: _checkboxValue,
            label: 'I agree to the terms and conditions',
            onChanged: (value) {
              setState(() {
                _checkboxValue = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BaseCardFactory.elevated(
                size: BaseCardSize.small,
                child: const Column(
                  children: [
                    Icon(Icons.favorite, color: AppColors.error),
                    AppSpacing.vSpaceXS,
                    Text('Elevated Card'),
                  ],
                ),
              ),
            ),
            AppSpacing.hSpaceMD,
            Expanded(
              child: BaseCardFactory.outlined(
                size: BaseCardSize.small,
                child: const Column(
                  children: [
                    Icon(Icons.star, color: AppColors.warning),
                    AppSpacing.vSpaceXS,
                    Text('Outlined Card'),
                  ],
                ),
              ),
            ),
            AppSpacing.hSpaceMD,
            Expanded(
              child: BaseCardFactory.filled(
                size: BaseCardSize.small,
                child: const Column(
                  children: [
                    Icon(Icons.thumb_up, color: AppColors.success),
                    AppSpacing.vSpaceXS,
                    Text('Filled Card'),
                  ],
                ),
              ),
            ),
          ],
        ),
        AppSpacing.vSpaceMD,
        
        // Card with Header and Actions
        BaseCardFactory.elevated(
          child: Column(
            children: [
              const BaseCardHeader(
                title: 'Card with Header',
                subtitle: 'This card has a header and actions',
                leading: Icon(Icons.info, color: AppColors.primary),
                trailing: Icon(Icons.more_vert),
              ),
              const Divider(),
              const Padding(
                padding: AppSpacing.paddingMD,
                child: Text(
                  'This is the content area of the card. You can put any widget here.',
                  style: AppTypography.bodyMedium,
                ),
              ),
              BaseCardActions(
                children: [
                  BaseButtonFactory.text(
                    text: 'Cancel',
                    onPressed: () {},
                  ),
                  BaseButtonFactory.primary(
                    text: 'Save',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Feedback Components', style: AppTypography.h6),
          AppSpacing.vSpaceMD,
          
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              BaseButtonFactory.primary(
                text: 'Show Dialog',
                onPressed: () => _showInfoDialog(),
              ),
              BaseButtonFactory.secondary(
                text: 'Show Snackbar',
                onPressed: () => _showSnackbar('This is a snackbar message'),
              ),
              BaseButtonFactory.outline(
                text: 'Success Snackbar',
                onPressed: () => BaseSnackbarFactory.success(
                  context: context,
                  message: 'Operation completed successfully!',
                ),
              ),
              BaseButtonFactory.danger(
                text: 'Error Snackbar',
                onPressed: () => BaseSnackbarFactory.error(
                  context: context,
                  message: 'Something went wrong!',
                  actionLabel: 'Retry',
                  onActionPressed: () => debugPrint('Retry pressed'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStateSection() {
    return BaseCardFactory.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('State Components', style: AppTypography.h6),
          AppSpacing.vSpaceMD,
          
          // Loading States
          const Text('Loading States', style: AppTypography.labelLarge),
          AppSpacing.vSpaceSM,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BaseLoadingFactory.circular(
                size: BaseLoadingSize.small,
                message: 'Small',
              ),
              BaseLoadingFactory.dots(
                size: BaseLoadingSize.medium,
                message: 'Dots',
              ),
              BaseLoadingFactory.spinner(
                size: BaseLoadingSize.large,
                message: 'Spinner',
              ),
            ],
          ),
          AppSpacing.vSpaceMD,
          
          BaseLoadingFactory.linear(
            message: 'Linear Progress',
          ),
          AppSpacing.vSpaceXL,
          
          // Empty States
          const Text('Empty States', style: AppTypography.labelLarge),
          AppSpacing.vSpaceSM,
          SizedBox(
            width: double.infinity,
            height: 280,
            child: BaseContainerFactory.outlined(
              padding: AppSpacing.paddingMD,
              child: BaseEmpty(
                type: BaseEmptyType.noData,
                size: BaseEmptySize.medium,
                title: 'No Data',
                subtitle: 'No items to display',
                actionLabel: 'Add Data',
                spacing: AppSpacing.md,
                onActionPressed: () => _showSnackbar('Add Data pressed'),
              ),
            ),
          ),
          AppSpacing.vSpaceMD,
          
          // Error States
          const Text('Error States', style: AppTypography.labelLarge),
          AppSpacing.vSpaceSM,
          SizedBox(
            width: double.infinity,
            height: 280,
            child: BaseContainerFactory.outlined(
              padding: AppSpacing.paddingMD,
              child: BaseError(
                type: BaseErrorType.network,
                size: BaseErrorSize.medium,
                title: 'Network Error',
                subtitle: 'Check connection',
                actionLabel: 'Retry',
                spacing: AppSpacing.md,
                onActionPressed: () => _showSnackbar('Retry pressed'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    BaseSnackbarFactory.info(
      context: context,
      message: message,
    );
  }

  void _showInfoDialog() {
    BaseDialogFactory.info(
      context: context,
      title: 'Information',
      content: 'This is an example of a base dialog component.',
    );
  }

  void _showConfirmDialog() {
    BaseDialogFactory.confirmation(
      context: context,
      title: 'Delete Item',
      content: 'Are you sure you want to delete this item? This action cannot be undone.',
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        BaseSnackbarFactory.success(
          context: context,
          message: 'Item deleted successfully!',
        );
      }
    });
  }

  void _simulateLoading() {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        BaseSnackbarFactory.success(
          context: context,
          message: 'Loading completed!',
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}