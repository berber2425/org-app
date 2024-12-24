import 'dart:async';
import 'dart:math';
import 'package:org_app/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outlined,
  text,
  danger,
  highlighted,
}

enum AppButtonSize { small, medium, large }

class ShakeCurve extends Curve {
  const ShakeCurve({this.count = 3});
  final int count;
  @override
  double transformInternal(double t) => sin(count * pi * t);
}

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.prefixIcon,
    this.suffixIcon,
    this.isActive = true,
    this.isGroupActive = true,
    this.onInactivePressed,
    this.onLongPress,
    this.isFullWidth = false,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.subtitle,
    this.customBackgroundDecoration,
    this.customTextStyle,
    this.customIconSize,
    this.customIconTheme,
  });

  /// Butonun başlığı
  final Widget title;

  /// Sol taraftaki ikon (opsiyonel)
  final Widget? prefixIcon;

  /// Sağ taraftaki ikon (opsiyonel)
  final Widget? suffixIcon;

  /// Tıklama olayı
  final FutureOr<void> Function() onPressed;

  /// Pasif durumdayken tıklama olayı (opsiyonel)
  final VoidCallback? onInactivePressed;

  /// Uzun basma olayı (opsiyonel)
  final VoidCallback? onLongPress;

  /// Butonun aktif olup olmadığı (varsayılan: true)
  final bool isActive;

  /// Butonun grup içinde aktif olup olmadığı (varsayılan: true)
  final bool isGroupActive;

  /// Yükleniyor durumu (varsayılan: false)
  final bool isLoading;

  /// Tam genişlik kullanımı (varsayılan: false)
  final bool isFullWidth;

  /// Butonun görünüm stili (varsayılan: primary)
  final AppButtonVariant variant;

  /// Butonun boyutu (varsayılan: medium)
  final AppButtonSize size;

  /// Alt başlık (opsiyonel)
  final Widget? subtitle;

  /// Özel arkaplan dekorasyonu (opsiyonel)
  /// Eğer belirtilirse, variant'ın dekorasyonu yerine bu kullanılır
  final BoxDecoration? customBackgroundDecoration;

  /// Özel metin stili (opsiyonel)
  /// Eğer belirtilirse, varsayılan metin stili yerine bu kullanılır
  final TextStyle? customTextStyle;

  /// Özel ikon boyutu (opsiyonel)
  /// Eğer belirtilirse, size'a göre belirlenen ikon boyutu yerine bu kullanılır
  final double? customIconSize;

  /// Özel ikon teması (opsiyonel)
  /// Eğer belirtilirse, varsayılan ikon teması yerine bu kullanılır
  final IconThemeData? customIconTheme;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with TickerProviderStateMixin {
  late bool _isLoading = widget.isLoading;

  bool get isActive {
    return widget.isActive && widget.isGroupActive && !_isLoading;
  }

  Future<void> onTap() async {
    if (isActive) {
      setState(() => _isLoading = true);
      try {
        await widget.onPressed();
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      _shakeController.forward().then((_) => _shakeController.reverse());
      if (_isLoading) return;
      widget.onInactivePressed?.call();
    }
  }

  // Animasyon kontrolleri
  late final AnimationController _shakeController = AnimationController(
    duration: const Duration(milliseconds: 150),
    reverseDuration: const Duration(milliseconds: 200),
    vsync: this,
  );

  late final Animation<double> _shakeAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: _shakeController,
      curve: const ShakeCurve(count: 2),
      reverseCurve: const ShakeCurve(count: 1),
    ),
  );

  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 80),
    reverseDuration: const Duration(milliseconds: 80),
    vsync: this,
  );

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 1,
    end: 1.05,
  ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));

  @override
  void dispose() {
    _shakeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  // Boyut hesaplamaları
  double get height => switch (widget.size) {
    AppButtonSize.small => 32.0,
    AppButtonSize.medium => 40.0,
    AppButtonSize.large => 48.0,
  };

  double get iconSize => switch (widget.size) {
    AppButtonSize.small => 16.0,
    AppButtonSize.medium => 20.0,
    AppButtonSize.large => 24.0,
  };

  bool get isMiniPadding => widget.variant == AppButtonVariant.text;

  EdgeInsetsGeometry get padding => switch (widget.size) {
    AppButtonSize.small => EdgeInsets.symmetric(
      horizontal: isMiniPadding ? AppSpacing.xs : AppSpacing.md,
      vertical: AppSpacing.xs,
    ),
    AppButtonSize.medium => EdgeInsets.symmetric(
      horizontal: isMiniPadding ? AppSpacing.sm : AppSpacing.lg,
      vertical: AppSpacing.sm,
    ),
    AppButtonSize.large => EdgeInsets.symmetric(
      horizontal: isMiniPadding ? AppSpacing.md : AppSpacing.xl,
      vertical: AppSpacing.md,
    ),
  };

  // Stil hesaplamaları
  Color getBackgroundColor(ThemeData theme) => switch (widget.variant) {
    AppButtonVariant.primary => theme.colorScheme.primary,
    AppButtonVariant.secondary => AppColors.secondary.op(0.15),
    AppButtonVariant.danger => AppColors.error,
    AppButtonVariant.text => Colors.transparent,
    AppButtonVariant.outlined => Colors.transparent,
    AppButtonVariant.highlighted => Colors.transparent,
  };

  Color getForegroundColor(ThemeData theme) => switch (widget.variant) {
    AppButtonVariant.primary => Colors.white,
    AppButtonVariant.secondary => AppColors.secondary,
    AppButtonVariant.danger => Colors.white,
    AppButtonVariant.text => theme.colorScheme.primary,
    AppButtonVariant.outlined => theme.colorScheme.primary,
    AppButtonVariant.highlighted => Colors.white,
  };

  BoxDecoration getDecoration(ThemeData theme) => switch (widget.variant) {
    AppButtonVariant.primary => BoxDecoration(
      color: getBackgroundColor(theme),
      borderRadius: BorderRadius.circular(8),
    ),
    AppButtonVariant.secondary => BoxDecoration(
      color: getBackgroundColor(theme),
      borderRadius: BorderRadius.circular(8),
    ),
    AppButtonVariant.danger => BoxDecoration(
      color: getBackgroundColor(theme),
      borderRadius: BorderRadius.circular(8),
    ),
    AppButtonVariant.text => const BoxDecoration(),
    AppButtonVariant.outlined => BoxDecoration(
      color: getBackgroundColor(theme),
      border: Border.all(color: theme.colorScheme.primary),
      borderRadius: BorderRadius.circular(8),
    ),
    AppButtonVariant.highlighted => BoxDecoration(
      gradient: AppColors.highlightGradient,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.op(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.highlightShadow.op(0.25),
          blurRadius: 16,
          spreadRadius: 1,
          offset: const Offset(0, 2),
        ),
      ],
    ),
  };

  TextStyle getTextStyle(ThemeData theme) => switch (widget.size) {
    AppButtonSize.small => AppTypography.labelMedium,
    AppButtonSize.medium => AppTypography.labelLarge,
    AppButtonSize.large => AppTypography.titleLarge,
  }.copyWith(color: getForegroundColor(theme));

  Widget buildLoadingIndicator(Color color) {
    return SizedBox(
      width: iconSize * 0.8,
      height: iconSize * 0.8,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = getForegroundColor(theme);
    final textStyle = widget.customTextStyle ?? getTextStyle(theme);
    final decoration =
        widget.customBackgroundDecoration ?? getDecoration(theme);
    final effectiveIconSize = widget.customIconSize ?? iconSize;
    final effectiveIconTheme =
        widget.customIconTheme ??
        IconThemeData(color: foregroundColor, size: effectiveIconSize);

    Widget content = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.prefixIcon != null && !_isLoading) ...[
          IconTheme(data: effectiveIconTheme, child: widget.prefixIcon!),
          SizedBox(width: AppSpacing.xs),
        ],
        if (_isLoading) ...[
          buildLoadingIndicator(foregroundColor),
          SizedBox(width: AppSpacing.xs),
        ],
        Flexible(
          child: DefaultTextStyle(style: textStyle, child: widget.title),
        ),
        if (widget.subtitle != null) ...[
          SizedBox(width: AppSpacing.xs),
          DefaultTextStyle(
            style: textStyle.copyWith(
              color: foregroundColor.op(0.8),
              fontSize: textStyle.fontSize! * 0.8,
            ),
            child: widget.subtitle!,
          ),
        ],
        if (widget.suffixIcon != null && !_isLoading) ...[
          SizedBox(width: AppSpacing.xs),
          IconTheme(data: effectiveIconTheme, child: widget.suffixIcon!),
        ],
      ],
    );

    return AnimatedBuilder(
      animation: Listenable.merge([_shakeAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset(_shakeAnimation.value * 5, 0),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: widget.onLongPress,
          onTapDown: (_) => _scaleController.forward(),
          onTapUp: (_) => _scaleController.reverse(),
          onTapCancel: () => _scaleController.reverse(),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Opacity(
            opacity: isActive ? 1 : 0.6,
            child: Container(
              height: height,
              width: widget.isFullWidth ? double.infinity : null,
              padding: padding,
              decoration: decoration,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
