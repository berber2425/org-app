// import 'dart:async';
// import 'dart:math';
// import 'dart:ui';
// import 'package:berber_mobile/src/utils/extensions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:sign_flutter/sign_flutter.dart';

// import '../../constants/app_colors.dart';
// import '../../constants/app_textstyle.dart';

// class ShakeCurve extends Curve {
//   const ShakeCurve({this.waveCount = 3});

//   final int waveCount;

//   @override
//   double transformInternal(double t) {
//     return sin(waveCount * pi * t);
//   }
// }

// enum ProgressLocation { none, center, prefix }

// enum ButtonVariant {
//   primary,
//   secondary,
//   tertiary,
//   danger,
//   text,
//   secondaryText,
//   icon,
//   like
// }

// enum ButtonSize {
//   small,
//   medium,
//   large,
// }

// class BerberButton extends StatefulWidget {
//   const BerberButton(
//       {super.key,
//       required this.onPressed,
//       required this.title,
//       this.prefixIcon,
//       this.suffixIcon,
//       this.buttonActive,
//       this.groupActive,
//       this.onInactivePressed,
//       this.progressLocation,
//       this.onLongPress,
//       this.expandTitle = false,
//       this.variant = ButtonVariant.primary,
//       this.size = ButtonSize.large,
//       this.backgroundDecoration,
//       this.iconSize,
//       this.textStyle,
//       this.iconTheme,
//       this.space,
//       this.subtitle,
//       this.isLoading,
//       this.padding})
//       : assert(subtitle == null || variant == ButtonVariant.primary,
//             "Subtitle can only be used with primary variant");

//   final ButtonSize size;
//   final ButtonVariant variant;
//   final Widget title;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final FutureOr<void> Function() onPressed;
//   final VoidCallback? onInactivePressed;
//   final Signal<bool>? buttonActive;
//   final Signal<bool>? groupActive;
//   final Signal<bool>? isLoading;
//   final ProgressLocation? progressLocation;
//   final VoidCallback? onLongPress;
//   final bool expandTitle;
//   final double? iconSize;
//   final double? space;

//   final Widget? subtitle;

//   final BoxDecoration Function(bool isHovering, bool hasFocus, bool isActive)?
//       backgroundDecoration;

//   final TextStyle Function(bool isHovering, bool hasFocus, bool isActive)?
//       textStyle;

//   final IconThemeData Function(bool isHovering, bool hasFocus, bool isActive)?
//       iconTheme;

//   final EdgeInsetsGeometry? padding;

//   @override
//   State<BerberButton> createState() => _BerberButtonState();
// }

// class _BerberButtonState extends State<BerberButton>
//     with TickerProviderStateMixin
//     implements Slot {
//   late Signal<bool> buttonActive = widget.buttonActive ?? true.signal;
//   late Signal<bool> groupActive = widget.groupActive ?? true.signal;

//   late final Signal<bool> _isLoading = widget.isLoading ?? false.signal;

//   bool _exActive = true;

//   bool get isActive {
//     return buttonActive.value && groupActive.value && !_isLoading.value;
//   }

//   final Signal<int> restoration = 0.signal;

//   Future<void> onTap() async {
//     if (isActive) {
//       _isLoading.value = true;
//       groupActive.value = false;
//       restoration.value++;
//       try {
//         await widget.onPressed();
//         _isLoading.value = false;
//         groupActive.value = true;
//         restoration.value++;
//       } catch (e) {
//         _isLoading.value = false;
//         groupActive.value = true;
//         restoration.value++;
//         rethrow;
//       }
//     } else {
//       shakeProgress();
//       if (_isLoading.value) {
//         return;
//       }
//       if (widget.onInactivePressed != null) {
//         widget.onInactivePressed!();
//       }
//     }
//   }

//   late AnimationController _shakeController;
//   late Animation<double> _shakeAnimation;
//   final Random _shakeRandom = Random();

//   late AnimationController _activeController;
//   late Animation<double> _activeAnimation;

//   late AnimationController _scaleController;
//   late Animation<double> _scaleAnimation;

//   shakeProgress() {
//     _shakeController.forward().then((value) {
//       _shakeController.reverse();
//     });
//   }

//   @override
//   void initState() {
//     _shakeController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       reverseDuration: const Duration(milliseconds: 200),
//       vsync: this,
//     );

//     _shakeAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _shakeController,
//       reverseCurve: const ShakeCurve(waveCount: 1),
//       curve: const ShakeCurve(waveCount: 2),
//     ));

//     _activeController = AnimationController(
//       duration: const Duration(milliseconds: 200),
//       vsync: this,
//       value: isActive ? 1 : 0,
//     );

//     _activeAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _activeController,
//       curve: Curves.easeInOut,
//     ));

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 80),
//       reverseDuration: const Duration(milliseconds: 80),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 1,
//       end: 1.05,
//     ).animate(CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.easeInOut,
//     ));

//     _exActive = isActive;

//     _signal = [buttonActive, groupActive, _isLoading, restoration].multiSignal;

//     _signal.addSlot(this);

//     super.initState();
//   }

//   late final MultiSignal _signal;

//   @override
//   void onValue(value) {
//     if (mounted) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         setState(() {});
//       });
//     }
//   }

//   @override
//   void didUpdateWidget(covariant BerberButton oldWidget) {
//     setState(() {});

//     super.didUpdateWidget(oldWidget);
//   }

//   StreamSubscription<bool>? _activeSubscription;
//   StreamSubscription<bool>? _groupActiveSubscription;
//   StreamSubscription<bool>? _isLoadingSubscription;
//   StreamSubscription<int>? _restorationSubscription;

//   _listener() {
//     if (_exActive && !isActive) {
//       _activeController.reverse();
//     } else if (!_exActive && isActive) {
//       _activeController.forward();
//     }
//     _exActive = isActive;
//   }

//   @override
//   void dispose() {
//     _shakeController.dispose();
//     _activeController.dispose();
//     _scaleController.dispose();
//     for (var element in [
//       _activeSubscription,
//       _groupActiveSubscription,
//       _isLoadingSubscription,
//       _restorationSubscription
//     ]) {
//       element?.cancel();
//     }
//     super.dispose();
//   }

//   final _rowKey = GlobalKey();

//   double get size {
//     switch (widget.size) {
//       case ButtonSize.small:
//         return 40;
//       case ButtonSize.medium:
//         return 48;
//       case ButtonSize.large:
//         return 56;
//     }
//   }

//   final WidgetStatesController _controller = WidgetStatesController();

//   bool stateHas(WidgetState state) {
//     return _controller.value.contains(state);
//   }

//   _onHover(bool isHovering) {
//     _controller.update(WidgetState.hovered, isHovering);
//   }

//   _onTapDown() {
//     _controller.update(WidgetState.focused, true);
//     _scaleController.forward().then((value) {
//       _scaleController.reverse();
//     });
//   }

//   _onTapUp() {
//     _controller.update(WidgetState.focused, false);
//   }

//   _onTapCancel() {
//     _controller.update(WidgetState.focused, false);
//   }

//   double get iconSize {
//     if (widget.iconSize != null) {
//       return widget.iconSize!;
//     }
//     switch (widget.size) {
//       case ButtonSize.small:
//         return 16;
//       case ButtonSize.medium:
//         return 20;
//       case ButtonSize.large:
//         return 24;
//     }
//   }

//   double get fontSize {
//     switch (widget.size) {
//       case ButtonSize.small:
//         return 12;
//       case ButtonSize.medium:
//         return 14;
//       case ButtonSize.large:
//         return 16;
//     }
//   }

//   double get padding {
//     if (widget.variant == ButtonVariant.icon) {
//       return 0;
//     }
//     switch (widget.size) {
//       case ButtonSize.small:
//         return 5;
//       case ButtonSize.medium:
//         return 10;
//       case ButtonSize.large:
//         return 14;
//     }
//   }

//   Widget _withDecoration(Widget child, double value) {
//     BoxDecoration? decoration;
//     TextStyle? textStyle;
//     IconThemeData? iconTheme;

//     if (widget.backgroundDecoration != null) {
//       decoration = widget.backgroundDecoration!(stateHas(WidgetState.hovered),
//           stateHas(WidgetState.focused), isActive);
//     }

//     if (widget.textStyle != null) {
//       textStyle = widget.textStyle!(stateHas(WidgetState.hovered),
//           stateHas(WidgetState.focused), isActive);
//     }

//     double v = lerpDouble(0.6, 1, value)!;

//     switch (widget.variant) {
//       case ButtonVariant.primary:
//         decoration ??= BoxDecoration(
//             borderRadius: BorderRadius.circular(1000),
//             gradient: Gradient.lerp(AppColors.primaryInactiveGradient,
//                 AppColors.primaryGradient, value));

//         textStyle ??= textTheme(context).buttonLarge.copyWith(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: AppColors.supportBlack.op(v),
//             );

//         iconTheme ??= IconThemeData(
//           color: AppColors.supportBlack.op(v),
//           size: iconSize,
//         );

//         break;
//       case ButtonVariant.secondary:
//         decoration ??= BoxDecoration(
//           borderRadius: BorderRadius.circular(size / 4),
//           color: AppColors.surfaceSubtitle.op(v),
//         );

//         textStyle ??= textTheme(context).buttonLarge.copyWith(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: AppColors.brandPrimary.op(v),
//             );

//         iconTheme ??= IconThemeData(
//           color: AppColors.brandPrimary.op(v),
//           size: iconSize,
//         );

//         break;
//       case ButtonVariant.tertiary:
//         decoration ??= BoxDecoration(
//           borderRadius: BorderRadius.circular(1000),
//           color: AppColors.brandPrimary.op(v),
//         );

//         textStyle ??= textTheme(context).buttonLarge.copyWith(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: AppColors.supportBlack.op(v),
//             );

//         iconTheme ??= IconThemeData(
//           color: AppColors.supportBlack.op(v),
//           size: iconSize,
//         );

//         break;
//       case ButtonVariant.danger:
//         decoration ??= BoxDecoration(
//           borderRadius: BorderRadius.circular(size / 4),
//           color: AppColors.surfaceWarning.op(v),
//         );

//         textStyle ??= textTheme(context).buttonLarge.copyWith(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: AppColors.brandRed.op(v),
//             );

//         iconTheme ??= IconThemeData(
//           color: AppColors.brandRed.op(v),
//           size: iconSize,
//         );

//         break;

//       case ButtonVariant.text:
//         decoration ??= const BoxDecoration();

//         textStyle ??= textTheme(context).buttonLarge.copyWith(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: AppColors.brandPrimary.op(v),
//             );

//         iconTheme ??= IconThemeData(
//           color: AppColors.brandPrimary.op(v),
//           size: iconSize,
//         );

//         break;

//       case ButtonVariant.secondaryText:
//         decoration ??= const BoxDecoration();

//         textStyle ??= textTheme(context).buttonLarge.copyWith(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: AppColors.supportWhite.op(v),
//             );

//         iconTheme ??= IconThemeData(
//           color: AppColors.supportWhite.op(v),
//           size: iconSize,
//         );

//         break;

//       case ButtonVariant.icon:
//         decoration ??= const BoxDecoration();

//         textStyle ??= textTheme(context).buttonLarge.copyWith(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: AppColors.brandPrimary.op(v),
//             );

//         iconTheme ??= IconThemeData(
//           color: AppColors.brandPrimary.op(v),
//           size: iconSize,
//         );

//         break;

//       case ButtonVariant.like:
//         decoration ??= BoxDecoration(
//           borderRadius: BorderRadius.circular(size / 4),
//           color: AppColors.brandPrimary.op(v),
//         );

//         textStyle ??= textTheme(context).buttonLarge.copyWith(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w900,
//               color: AppColors.brandPrimary.op(v),
//             );

//         iconTheme ??= IconThemeData(
//           color: AppColors.brandPrimary.op(v),
//           size: iconSize,
//         );

//         break;
//     }
//     return Container(
//       decoration: decoration,
//       // width: widget.variant == ButtonVariant.icon ? size : null,
//       // height: widget.variant == ButtonVariant.icon ? size : null,
//       // alignment: widget.variant == ButtonVariant.icon ? Alignment.center : null,
//       child: DefaultTextStyle(
//         style: textStyle,
//         child: IconTheme(
//           data: iconTheme,
//           child: Padding(
//             padding: widget.padding ?? EdgeInsets.all(padding),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }

//   ProgressLocation _getDefaultLocation() {
//     switch (widget.variant) {
//       case ButtonVariant.icon:
//         return ProgressLocation.center;
//       default:
//         if (widget.prefixIcon == null && widget.suffixIcon == null) {
//           return ProgressLocation.center;
//         }
//         return ProgressLocation.prefix;
//     }
//   }

//   late ProgressLocation progressLocation =
//       widget.progressLocation ?? _getDefaultLocation();

//   Widget get indicator {
//     return Builder(
//         key: const ValueKey("btn-indicator"),
//         builder: (context) {
//           final s = iconSize * 0.6;
//           return Align(
//             alignment: Alignment.center,
//             child: SizedBox(
//               width: s,
//               height: s,
//               child: AspectRatio(
//                 aspectRatio: 1,
//                 child: CircularProgressIndicator(
//                     strokeWidth: 1.5,
//                     backgroundColor: Colors.transparent,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       IconTheme.of(context).color!,
//                     )),
//               ),
//             ),
//           );
//         });
//   }

//   Widget get space {
//     return SizedBox(
//       width: widget.space ?? size / 7,
//     );
//   }

//   TextStyle subtitleTextStyle(BuildContext context) {
//     return textTheme(context)
//         .titleSmall
//         .copyWith(fontWeight: FontWeight.bold, color: AppColors.supportWhite);
//   }

//   @override
//   Widget build(BuildContext context) {
//     _listener();
//     return MouseRegion(
//       onEnter: (_) => _onHover(true),
//       onExit: (_) => _onHover(false),
//       child: GestureDetector(
//         onTap: onTap,
//         onTapDown: (_) => _onTapDown(),
//         onTapUp: (_) => _onTapUp(),
//         onTapCancel: _onTapCancel,
//         onLongPress: widget.onLongPress,
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minWidth: widget.expandTitle ? double.infinity : 0,
//             maxWidth: MediaQuery.of(context).size.width,
//           ),
//           child: AnimatedBuilder(
//               animation:
//                   Listenable.merge([_activeController, _scaleController]),
//               child: widget.variant == ButtonVariant.icon
//                   ? AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 200),
//                       child: !_isLoading.value ? widget.title : indicator,
//                     )
//                   : Builder(builder: (context) {
//                       Widget c = Row(
//                           key: _rowKey,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           textBaseline: TextBaseline.ideographic,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             if (progressLocation == ProgressLocation.prefix ||
//                                 widget.prefixIcon != null) ...[
//                               SizedBox(
//                                 width: iconSize,
//                                 height: iconSize,
//                                 child: progressLocation ==
//                                         ProgressLocation.prefix
//                                     ? AnimatedSwitcher(
//                                         duration:
//                                             const Duration(milliseconds: 200),
//                                         child: !_isLoading.value
//                                             ? SizedBox(
//                                                 height: iconSize,
//                                                 width: iconSize,
//                                                 child: widget.prefixIcon)
//                                             : indicator,
//                                       )
//                                     : SizedBox(
//                                         height: iconSize,
//                                         width: iconSize,
//                                         child: widget.prefixIcon ??
//                                             const SizedBox()),
//                               ),
//                               space,
//                             ],
//                             Builder(builder: (ctx) {
//                               Widget child = widget.title;

//                               if (progressLocation == ProgressLocation.center) {
//                                 child = Stack(
//                                   alignment: Alignment.center,
//                                   fit: StackFit.passthrough,
//                                   children: [
//                                     AnimatedOpacity(
//                                       duration:
//                                           const Duration(milliseconds: 200),
//                                       opacity: _isLoading.value ? 0 : 1,
//                                       child: child,
//                                     ),
//                                     AnimatedOpacity(
//                                       duration:
//                                           const Duration(milliseconds: 200),
//                                       opacity: !_isLoading.value ? 0 : 1,
//                                       child: indicator,
//                                     ),
//                                   ],
//                                 );
//                               }

//                               child = AnimatedBuilder(
//                                   animation: _shakeAnimation,
//                                   child: child,
//                                   builder: (context, child) {
//                                     // transform and rotate
//                                     return Transform.rotate(
//                                       angle: _shakeRandom.nextBool()
//                                           ? _shakeAnimation.value * 0.05
//                                           : -_shakeAnimation.value * 0.05,
//                                       child: Transform.translate(
//                                         offset: Offset(
//                                             _shakeAnimation.value * 5, 0),
//                                         child: child,
//                                       ),
//                                     );
//                                   });

//                               return widget.expandTitle
//                                   ? Expanded(child: child)
//                                   : child;
//                             }),
//                             if (widget.suffixIcon != null ||
//                                 progressLocation ==
//                                     ProgressLocation.prefix) ...[
//                               space,
//                               widget.suffixIcon ??
//                                   SizedBox(
//                                     width: iconSize,
//                                     height: iconSize,
//                                   ),
//                             ],
//                           ]);

//                       if (widget.subtitle != null) {
//                         c = Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             c,
//                             const SizedBox(height: 1),
//                             DefaultTextStyle(
//                               style: subtitleTextStyle(context),
//                               child: widget.subtitle!,
//                             ),
//                           ],
//                         );
//                       }

//                       return c;
//                     }),
//               builder: (context, ch) {
//                 return Transform.scale(
//                     alignment: Alignment.center,
//                     scale: _scaleAnimation.value,
//                     child: _withDecoration(ch!, _activeAnimation.value));
//               }),
//         ),
//       ),
//     );
//   }
// }
