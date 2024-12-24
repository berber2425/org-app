import 'package:org_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.isActive = true,
    this.size = 20.0,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final bool isActive;
  final double size;

  bool get isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isActive ? () => onChanged?.call(value) : null,
        child: Opacity(
          opacity: isActive ? 1.0 : 0.5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      isSelected
                          ? null
                          : Border.all(
                            color: AppColors.textSecondary,
                            width: 1.5,
                          ),
                  gradient: isSelected ? AppColors.highlightGradient : null,
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: AppColors.highlightShadow.op(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child:
                    isSelected
                        ? Center(
                          child: Container(
                            width: size * 0.4,
                            height: size * 0.4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                        : null,
              ),
              if (label != null) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
