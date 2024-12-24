import 'package:org_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:sign_flutter/sign_flutter.dart';
import '../../theme/theme.dart';

/// Select Card varyantları
enum AppSelectCardVariant {
  /// Gradient arkaplan ile vurgulu stil
  highlighted,

  /// Düz arkaplan rengi ile dolu stil
  filled,

  /// Kenarlıklı stil
  outlined,
}

class AppSelectCard<T> extends StatefulWidget {
  const AppSelectCard({
    super.key,
    required this.value,
    required this.selected,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.variant = AppSelectCardVariant.filled,
    this.onTap,
  });

  /// Kartın değeri
  final T value;

  /// Seçili değer sinyali
  final Signal<T> selected;

  /// Başlık
  final String title;

  /// Alt başlık (opsiyonel)
  final String? subtitle;

  /// Sol taraftaki widget (opsiyonel)
  final Widget? leading;

  /// Sağ taraftaki widget (opsiyonel)
  final Widget? trailing;

  /// Kartın görünüm stili (varsayılan: filled)
  final AppSelectCardVariant variant;

  /// Tıklama olayı (opsiyonel)
  final VoidCallback? onTap;

  @override
  State<AppSelectCard<T>> createState() => _AppSelectCardState<T>();
}

class _AppSelectCardState<T> extends State<AppSelectCard<T>>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  //bool _isPressed = false;

  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  );

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 1.0,
    end: 0.98,
  ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlotBuilder<T>(
      signal: widget.selected,
      builder: (selectedValue) {
        final isSelected = selectedValue == widget.value;

        // Stil değişkenleri
        BoxDecoration getDecoration() {
          switch (widget.variant) {
            case AppSelectCardVariant.highlighted:
              return BoxDecoration(
                gradient: isSelected ? AppColors.highlightGradient : null,

                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color:
                      isSelected
                          ? Colors.transparent
                          : AppColors.outlineVariant,
                  width: 1,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppColors.highlightShadow.op(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                            spreadRadius: 2,
                          ),
                        ]
                        : null,
              );

            case AppSelectCardVariant.outlined:
              return BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.outlineVariant,
                  width: 1.5,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppColors.primary.op(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              );

            case AppSelectCardVariant.filled:
              return BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color:
                      isSelected ? AppColors.primary : AppColors.outlineVariant,
                  width: 1,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: AppColors.primary.op(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              );
          }
        }

        Color getTextColor() {
          if (isSelected) {
            switch (widget.variant) {
              case AppSelectCardVariant.highlighted:
              case AppSelectCardVariant.filled:
                return Colors.white;
              case AppSelectCardVariant.outlined:
                return AppColors.primary;
            }
          }
          return AppColors.textPrimary;
        }

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTapDown: (_) {
              //setState(() => _isPressed = true);
              _scaleController.forward();
            },
            onTapUp: (_) {
              //setState(() => _isPressed = false);
              _scaleController.reverse();
            },
            onTapCancel: () {
              //setState(() => _isPressed = false);
              _scaleController.reverse();
            },
            onTap: () {
              widget.onTap?.call();
              widget.selected.value = widget.value;
            },
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder:
                        (context, child) => Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: getDecoration(),
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          if (widget.leading != null) ...[
                            AnimatedScale(
                              duration: const Duration(milliseconds: 200),
                              scale: isSelected ? 1.05 : 1.0,
                              child: widget.leading!,
                            ),
                            const SizedBox(width: AppSpacing.lg),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultTextStyle(
                                  style: AppTypography.titleMedium.copyWith(
                                    color: getTextColor(),
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                  ),
                                  child: Text(widget.title),
                                ),
                                if (widget.subtitle != null) ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  DefaultTextStyle(
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: getTextColor().op(0.8),
                                    ),
                                    child: Text(widget.subtitle!),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (widget.trailing != null) ...[
                            const SizedBox(width: AppSpacing.lg),
                            widget.trailing!,
                          ] else if (isSelected) ...[
                            const SizedBox(width: AppSpacing.lg),
                            AnimatedScale(
                              duration: const Duration(milliseconds: 200),
                              scale: isSelected ? 1.0 : 0.0,
                              child: Icon(
                                Icons.check_circle,
                                color:
                                    widget.variant ==
                                            AppSelectCardVariant.outlined
                                        ? AppColors.primary
                                        : Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedContainer(
                      duration: kThemeAnimationDuration,
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                        color:
                            _isHovered
                                ? AppColors.primary.op(0.1)
                                : Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppMultiSelectCard<T> extends StatelessWidget {
  const AppMultiSelectCard({
    super.key,
    required this.value,
    required this.selectedValues,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.variant = AppSelectCardVariant.filled,
  });

  /// Kartın değeri
  final T value;

  /// Seçili değerler sinyali
  final Signal<List<T>> selectedValues;

  /// Başlık
  final String title;

  /// Alt başlık (opsiyonel)
  final String? subtitle;

  /// Sol taraftaki widget (opsiyonel)
  final Widget? leading;

  /// Sağ taraftaki widget (opsiyonel)
  final Widget? trailing;

  /// Kartın görünüm stili (varsayılan: filled)
  final AppSelectCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return SlotBuilder<List<T>>(
      signal: selectedValues,
      builder: (selectedValues) {
        // Seçili durumu kontrol eden Signal
        final isSelectedSignal = Signal<bool>(selectedValues.contains(value));

        return AppSelectCard<bool>(
          value: true,
          selected: isSelectedSignal,
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          variant: variant,
          onTap: () {
            final newValues = List<T>.from(selectedValues);
            if (selectedValues.contains(value)) {
              newValues.remove(value);
            } else {
              newValues.add(value);
            }
            this.selectedValues.value = newValues;
          },
        );
      },
    );
  }
}
