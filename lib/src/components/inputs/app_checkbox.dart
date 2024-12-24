import 'package:org_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.isActive = true,
    this.size = 20.0,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isActive ? () => onChanged?.call(!value) : null,
        child: Opacity(
          opacity: isActive ? 1.0 : 0.5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border:
                      value
                          ? null
                          : Border.all(
                            color: AppColors.textSecondary,
                            width: 1.5,
                          ),
                  gradient: value ? AppColors.highlightGradient : null,
                  boxShadow:
                      value
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
                    value
                        ? Center(
                          child: Icon(
                            Icons.check,
                            size: size * 0.7,
                            color: Colors.white,
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
