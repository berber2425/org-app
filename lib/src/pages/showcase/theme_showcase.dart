import 'package:org_app/src/constants/icons.dart';
import 'package:org_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_flutter/sign_flutter.dart';
import '../../components/buttons/app_button.dart';
import '../../components/inputs/app_form_field.dart';
import '../../theme/theme.dart';
import '../../components/inputs/app_checkbox.dart';
import '../../components/inputs/app_radio.dart';
import '../../components/inputs/app_select_card.dart';

class ThemeShowcase extends StatefulWidget {
  const ThemeShowcase({super.key});

  @override
  State<ThemeShowcase> createState() => _ThemeShowcaseState();
}

class _ThemeShowcaseState extends State<ThemeShowcase> {
  late final Signal<String> _selectedCard;
  late final Signal<List<String>> _selectedServices;

  @override
  void initState() {
    super.initState();
    _selectedCard = Signal<String>('1');
    _selectedServices = Signal<List<String>>(['1']);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(title, style: AppTypography.headlineMedium),
        ),
        ...children,
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildColorBox(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(name, style: AppTypography.bodySmall),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tema & Componentler')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Renkler
            _buildSection('Renkler', [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    _buildColorBox('Primary', AppColors.primary),
                    const SizedBox(width: AppSpacing.md),
                    _buildColorBox('Secondary', AppColors.secondary),
                    const SizedBox(width: AppSpacing.md),
                    _buildColorBox('Error', AppColors.error),
                    const SizedBox(width: AppSpacing.md),
                    _buildColorBox('Background', AppColors.background),
                    const SizedBox(width: AppSpacing.md),
                    _buildColorBox('Surface', AppColors.surface),
                  ],
                ),
              ),
            ]),

            // Tipografi
            _buildSection('Tipografi', [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Display Large', style: AppTypography.displayLarge),
                    Text('Display Medium', style: AppTypography.displayMedium),
                    Text('Display Small', style: AppTypography.displaySmall),
                    Text('Headline Large', style: AppTypography.headlineLarge),
                    Text(
                      'Headline Medium',
                      style: AppTypography.headlineMedium,
                    ),
                    Text('Title Large', style: AppTypography.titleLarge),
                    Text('Body Large', style: AppTypography.bodyLarge),
                    Text('Body Medium', style: AppTypography.bodyMedium),
                    Text('Body Small', style: AppTypography.bodySmall),
                    Text('Label Large', style: AppTypography.labelLarge),
                    Text('Label Medium', style: AppTypography.labelMedium),
                    Text('Label Small', style: AppTypography.labelSmall),
                  ],
                ),
              ),
            ]),

            // Butonlar
            _buildSection('Butonlar', [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    AppButton(
                      title: const Text('Primary Button'),
                      onPressed: () {},
                      variant: AppButtonVariant.primary,
                    ),
                    AppButton(
                      title: const Text('Satın Al'),
                      onPressed: () {},
                      variant: AppButtonVariant.highlighted,
                      prefixIcon: const Icon(Icons.shopping_cart),
                    ),
                    AppButton(
                      title: const Text('Secondary Button'),
                      onPressed: () {},
                      variant: AppButtonVariant.secondary,
                    ),
                    AppButton(
                      title: const Text('Danger Button'),
                      onPressed: () {},
                      variant: AppButtonVariant.danger,
                    ),
                    AppButton(
                      title: const Text('Outlined Button'),
                      onPressed: () {},
                      variant: AppButtonVariant.outlined,
                    ),
                    AppButton(
                      title: const Text('Text Button'),
                      onPressed: () {},
                      variant: AppButtonVariant.text,
                    ),
                    AppButton(
                      title: const Text('Loading Button'),
                      onPressed: () {},
                      isLoading: true,
                    ),
                    AppButton(
                      title: const Text('Disabled Button'),
                      onPressed: () {},
                      isActive: false,
                    ),
                    AppButton(
                      title: const Text('Icon Button'),
                      onPressed: () {},
                      prefixIcon: const Icon(Icons.add),
                    ),
                    AppButton(
                      title: const Text('With Subtitle'),
                      subtitle: const Text('Alt başlık'),
                      onPressed: () {},
                      variant: AppButtonVariant.primary,
                    ),
                    AppButton(
                      title: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16),
                          const SizedBox(width: AppSpacing.xs),
                          const Text('Custom Title'),
                        ],
                      ),
                      onPressed: () {},
                      variant: AppButtonVariant.primary,
                    ),
                    // Özelleştirilmiş butonlar
                    const Text(
                      'Özelleştirilmiş Butonlar',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppButton(
                      title: const Text('Google ile Giriş Yap'),
                      onPressed: () {},
                      variant: AppButtonVariant.outlined,
                      prefixIcon: SvgPicture.asset(ImgGenIconNames.google),
                      customBackgroundDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.op(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      customTextStyle: AppTypography.labelLarge.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                      customIconSize: 20,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      title: const Text('Facebook ile Devam Et'),
                      onPressed: () {},
                      variant: AppButtonVariant.primary,
                      prefixIcon: const Icon(Icons.facebook),
                      customBackgroundDecoration: BoxDecoration(
                        color: const Color(0xFF1877F2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1877F2).op(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      customTextStyle: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      customIconSize: 24,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      title: const Text('Apple ID ile Giriş'),
                      onPressed: () {},
                      variant: AppButtonVariant.primary,
                      prefixIcon: const Icon(Icons.apple),
                      customBackgroundDecoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.op(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      customTextStyle: AppTypography.labelLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      customIconSize: 24,
                    ),
                  ],
                ),
              ),
            ]),

            // Form Fields
            _buildSection('Form Fields', [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: AppForm(
                  child: Column(
                    children: [
                      AppTextFormField(
                        label: 'Normal Input',
                        hint: 'Enter some text',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextFormField(
                        label: 'Password Input',
                        hint: 'Enter password',
                        obscureText: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextFormField(
                        label: 'With Icon',
                        hint: 'Search something',
                        prefixIcon: const Icon(Icons.search),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextFormField(
                        label: 'With Error',
                        hint: 'Type something',
                        validator: (value) => 'This field has an error',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextFormField(
                        label: 'Disabled Input',
                        hint: 'Cannot type here',
                        enabled: false,
                      ),
                    ],
                  ),
                ),
              ),
            ]),

            // Form Alanları
            _buildSection('Form Alanları', [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox örnekleri
                    const Text('Checkbox', style: AppTypography.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.lg,
                      runSpacing: AppSpacing.md,
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            bool value = false;
                            return AppCheckbox(
                              value: value,
                              onChanged: (v) => setState(() => value = v),
                              label: 'Normal Checkbox',
                            );
                          },
                        ),
                        const AppCheckbox(
                          value: true,
                          onChanged: null,
                          label: 'Seçili & Pasif',
                          isActive: false,
                        ),
                        const AppCheckbox(
                          value: false,
                          onChanged: null,
                          label: 'Seçili Değil & Pasif',
                          isActive: false,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Radio örnekleri
                    const Text(
                      'Radio Buttons',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.lg,
                      runSpacing: AppSpacing.md,
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            int groupValue = 1;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppRadio<int>(
                                  value: 1,
                                  groupValue: groupValue,
                                  onChanged:
                                      (v) => setState(() => groupValue = v!),
                                  label: 'Seçenek 1',
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                AppRadio<int>(
                                  value: 2,
                                  groupValue: groupValue,
                                  onChanged:
                                      (v) => setState(() => groupValue = v!),
                                  label: 'Seçenek 2',
                                ),
                              ],
                            );
                          },
                        ),
                        const AppRadio<int>(
                          value: 1,
                          groupValue: 1,
                          onChanged: null,
                          label: 'Seçili & Pasif',
                          isActive: false,
                        ),
                        const AppRadio<int>(
                          value: 2,
                          groupValue: 1,
                          onChanged: null,
                          label: 'Seçili Değil & Pasif',
                          isActive: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),

            // Select Cards
            _buildSection('Select Cards', [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Single Select örneği
                    const Text(
                      'Single Select',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Seçili değeri göster
                    SlotBuilder<String>(
                      signal: _selectedCard,
                      builder:
                          (selectedValue) => Text(
                            'Seçili Kart: $selectedValue',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Highlighted stil - Tam versiyon
                    const Text(
                      'Highlighted - Full',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppSelectCard<String>(
                      value: '1',
                      selected: _selectedCard,
                      title: 'Berber Shop',
                      subtitle: 'Kadıköy Şubesi',
                      variant: AppSelectCardVariant.highlighted,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: const Icon(Icons.store, color: Colors.white),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Filled stil - Sadece başlık
                    const Text(
                      'Filled - Only Title',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppSelectCard<String>(
                      value: '2',
                      selected: _selectedCard,
                      title: 'Beauty Salon',
                      variant: AppSelectCardVariant.filled,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Filled stil - Başlık ve alt başlık
                    const Text(
                      'Filled - With Subtitle',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppSelectCard<String>(
                      value: '3',
                      selected: _selectedCard,
                      title: 'Nail Art',
                      subtitle: 'Şişli Şubesi',
                      variant: AppSelectCardVariant.filled,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Outlined stil - Leading icon ile
                    const Text(
                      'Outlined - With Leading',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppSelectCard<String>(
                      value: '4',
                      selected: _selectedCard,
                      title: 'Spa Center',
                      variant: AppSelectCardVariant.outlined,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.accent,
                        child: const Icon(Icons.spa, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Outlined stil - Trailing icon ile
                    const Text(
                      'Outlined - With Trailing',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppSelectCard<String>(
                      value: '5',
                      selected: _selectedCard,
                      title: 'Massage Center',
                      variant: AppSelectCardVariant.outlined,
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Multi Select örneği
                    const Text(
                      'Multi Select',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Seçili değerleri göster
                    SlotBuilder<List<String>>(
                      signal: _selectedServices,
                      builder:
                          (selectedValues) => Text(
                            'Seçili Servisler: ${selectedValues.isEmpty ? "Yok" : selectedValues.join(", ")}',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Highlighted stil - Tam versiyon
                    const Text(
                      'Highlighted - Full',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppMultiSelectCard<String>(
                      value: '1',
                      selectedValues: _selectedServices,
                      title: 'Saç Kesimi',
                      subtitle: '45 dakika',
                      variant: AppSelectCardVariant.highlighted,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: const Icon(
                          Icons.content_cut,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text('150₺', style: AppTypography.titleMedium),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Filled stil - Sadece başlık
                    const Text(
                      'Filled - Only Title',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppMultiSelectCard<String>(
                      value: '2',
                      selectedValues: _selectedServices,
                      title: 'Sakal Tıraşı',
                      variant: AppSelectCardVariant.filled,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Outlined stil - Leading ve subtitle
                    const Text(
                      'Outlined - With Leading & Subtitle',
                      style: AppTypography.labelMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppMultiSelectCard<String>(
                      value: '3',
                      selectedValues: _selectedServices,
                      title: 'Saç Boyama',
                      subtitle: '120 dakika',
                      variant: AppSelectCardVariant.outlined,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.accent,
                        child: const Icon(
                          Icons.color_lens,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
