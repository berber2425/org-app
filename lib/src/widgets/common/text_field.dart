// import 'dart:math';

// import 'package:berber_mobile/src/constants/app_colors.dart';
// import 'package:berber_mobile/src/constants/app_textstyle.dart';
// import 'package:berber_mobile/src/constants/icons.dart';
// import 'package:berber_mobile/src/utils/extensions.dart';
// import 'package:berber_mobile/src/widgets/common/flex.dart';
// import 'package:berber_mobile/src/widgets/common/form.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'dart:ui' as ui;

// import 'package:sign_flutter/sign_flutter.dart';

// class ImgGenTextField extends StatefulWidget {
//   const ImgGenTextField(
//       {super.key,
//       this.controller,
//       this.style,
//       this.initialValue,
//       this.hintText,
//       this.errorText,
//       this.obscureText,
//       this.keyboardType,
//       this.enabled,
//       this.readOnly,
//       this.maxLines = 1,
//       this.minLines,
//       this.maxLength,
//       this.autocorrect,
//       this.autofocus,
//       this.enableSuggestions,
//       this.autovalidate,
//       this.maxLengthEnforced,
//       this.onChanged,
//       this.focusNode,
//       required this.title,
//       this.validator,
//       this.autofillHints,
//       this.onEditingComplete,
//       this.prefix,
//       this.suffixIcons,
//       this.onSubmitted,
//       this.titleStyle,
//       this.capitalizeTitle = true,
//       this.onTap,
//       this.value});

//   final TextStyle? style;
//   final VoidCallback? onEditingComplete;
//   final VoidCallback? onTap;
//   final Signal<String>? value;
//   final String title;
//   final TextEditingController? controller;
//   final String? hintText;
//   final String? errorText;
//   final bool? obscureText;
//   final TextInputType? keyboardType;
//   final bool? enabled;
//   final bool? readOnly;
//   final int? maxLines;
//   final int? minLines;
//   final int? maxLength;
//   final bool? autocorrect;
//   final bool? autofocus;
//   final bool? enableSuggestions;
//   final bool? autovalidate;
//   final bool? maxLengthEnforced;
//   final ValueChanged<String>? onChanged;
//   final FocusNode? focusNode;
//   final String? Function(String value)? validator;
//   final Iterable<String>? autofillHints;
//   final Widget? prefix;
//   final List<Widget>? suffixIcons;
//   final VoidCallback? onSubmitted;
//   final String? initialValue;
//   final TextStyle? titleStyle;
//   final bool capitalizeTitle;

//   @override
//   State<ImgGenTextField> createState() => _ImgGenTextFieldState();
// }

// class _ImgGenTextFieldState extends State<ImgGenTextField> with Slot<String> {
//   late FocusNode focusNode;
//   late TextEditingController controller =
//       widget.controller ?? TextEditingController(text: widget.initialValue);

//   static Widget _defaultContextMenuBuilder(
//       BuildContext context, EditableTextState editableTextState) {
//     return AdaptiveTextSelectionToolbar.editableText(
//       editableTextState: editableTextState,
//     );
//   }

//   WidgetStatesController widgetStatesController = WidgetStatesController();

//   void startScaleAnimation() {
//     throw UnimplementedError();
//   }

//   void _onTap() {
//     widgetStatesController.update(WidgetState.focused, true);
//     focusNode.requestFocus();
//     widget.onTap?.call();
//   }

//   late String? errorText = widget.errorText;

//   @override
//   void didUpdateWidget(covariant ImgGenTextField oldWidget) {
//     if (widget.errorText != oldWidget.errorText) {
//       errorText = widget.errorText;
//     }

//     if (widget.focusNode != oldWidget.focusNode) {
//       focusNode = widget.focusNode ?? focusNode;
//     }

//     if (widget.suffixIcons != oldWidget.suffixIcons) {
//       _suffixIcons = widget.suffixIcons;
//     }

//     if (widget.value != oldWidget.value) {
//       if (oldWidget.value != null) {
//         oldWidget.value!.removeSlot(this);
//       }
//       if (widget.value != null) {
//         widget.value!.addSlot(this);
//       }
//     }

//     super.didUpdateWidget(oldWidget);
//   }

//   static const animationDuration = Duration(milliseconds: 200);

//   bool stateHas(WidgetState state) {
//     return widgetStatesController.value.contains(state);
//   }

//   Color get surfaceColor {
//     if (errorText != null) {
//       return AppColors.surfaceWarning;
//     }

//     return AppColors.surfaceSecondary;
//   }

//   Color get borderColor {
//     if (errorText != null) {
//       return AppColors.brandRed;
//     }

//     if (stateHas(WidgetState.focused)) {
//       return AppColors.brandPrimary;
//     } else {
//       return Colors.transparent;
//     }
//   }

//   _focusListener() {
//     if (mounted) {
//       widgetStatesController.update(WidgetState.focused, focusNode.hasFocus);
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     focusNode = widget.focusNode ?? FocusNode();
//     focusNode.addListener(_focusListener);
//     if (widget.obscureText != null) {
//       _obscureText = widget.obscureText!;
//     }
//     controller.addListener(_listener);
//     if (widget.value != null) {
//       widget.value!.addSlot(this);
//     }
//     super.initState();
//   }

//   _listener() {
//     currentLines();
//     widget.value?.value = controller.text;
//   }

//   BoxConstraints _constraints = const BoxConstraints();

//   @override
//   void dispose() {
//     focusNode.removeListener(_focusListener);
//     controller.removeListener(_listener);
//     super.dispose();
//   }

//   bool _obscureText = false;

//   late List<Widget>? _suffixIcons = widget.suffixIcons;

//   _toggleObscureText() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }

//   final editableTextKey = GlobalKey<EditableTextState>();

//   bool isFarFromEditableText(PointerDownEvent e) {
//     final RenderBox renderBox =
//         editableTextKey.currentContext!.findRenderObject() as RenderBox;
//     final Offset local = renderBox.globalToLocal(e.position);
//     final Rect bounds = renderBox.paintBounds;
//     final Rect expandedBounds = bounds.inflate(10);
//     return !expandedBounds.contains(local);
//   }

//   int get iconCount {
//     int count = 0;
//     if (_suffixIcons != null) {
//       count += _suffixIcons!.length;
//     }
//     if (widget.obscureText == true) {
//       count += 1;
//     }
//     if (errorText != null) {
//       count += 1;
//     }
//     return count;
//   }

//   double errorHeight(BoxConstraints constraints) {
//     if (errorText != null) {
//       final textPainter = TextPainter(
//         text: TextSpan(
//           text: errorText,
//           style: textTheme(context).titleLarge,
//         ),
//         textDirection: ui.TextDirection.ltr,
//       )..layout(maxWidth: constraints.maxWidth);
//       return textPainter.size.height;
//     } else {
//       return 0;
//     }
//   }

//   bool _showSelection = false;

//   final prefHeight = 22.0.signal;

//   void currentLines() {
//     final rightIconCount = _suffixIcons?.length ?? 0;
//     const padding = 20;
//     final text = controller.text;
//     final textPainter = TextPainter(
//       text: TextSpan(text: text, style: textTheme(context).bodyLarge),
//       textDirection: ui.TextDirection.ltr,
//       maxLines: widget.maxLines,
//     );
//     textPainter.layout(
//         maxWidth: _constraints.maxWidth - rightIconCount * 24.0 - padding);
//     prefHeight.value = textPainter.size.height;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TapRegion(
//       onTapOutside: (e) {
//         // check after 100ms
//         Future.delayed(const Duration(milliseconds: 100), () {
//           if (focusNode.hasFocus &&
//               isFarFromEditableText(e) &&
//               (FocusManager.instance.primaryFocus != null &&
//                   FocusManager.instance.primaryFocus == focusNode)) {
//             focusNode.unfocus();
//           }
//         });
//       },
//       onTapInside: focusNode.hasFocus
//           ? null
//           : (_) {
//               _onTap();
//             },
//       child: Column(
//         children: [
//           LayoutBuilder(builder: (context, c) {
//             _constraints = c;
//             currentLines();
//             return ListenableBuilder(
//                 listenable:
//                     Listenable.merge([widgetStatesController, controller]),
//                 builder: (context, child) {
//                   return AnimatedContainer(
//                     duration: animationDuration,
//                     height: prefHeight.value + 41.5,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         border: Border.all(color: borderColor),
//                         color: surfaceColor),
//                     padding: const EdgeInsets.all(10.0),
//                     child: SingleChildScrollView(
//                       physics: const NeverScrollableScrollPhysics(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Builder(builder: (context) {
//                             TextStyle titleStyle =
//                                 textTheme(context).titleSmallBold.copyWith(
//                                       color: AppColors.textSecondary.op(0.87),
//                                     );

//                             if (widget.titleStyle != null) {
//                               titleStyle = titleStyle.copyWith(
//                                   color: widget.titleStyle!.color,
//                                   fontSize: widget.titleStyle!.fontSize,
//                                   fontWeight: widget.titleStyle!.fontWeight,
//                                   background: widget.titleStyle!.background,
//                                   decoration: widget.titleStyle!.decoration,
//                                   decorationColor:
//                                       widget.titleStyle!.decorationColor,
//                                   decorationStyle:
//                                       widget.titleStyle!.decorationStyle,
//                                   letterSpacing:
//                                       widget.titleStyle!.letterSpacing,
//                                   wordSpacing: widget.titleStyle!.wordSpacing,
//                                   height: widget.titleStyle!.height,
//                                   shadows: widget.titleStyle!.shadows,
//                                   backgroundColor:
//                                       widget.titleStyle!.backgroundColor,
//                                   fontFamily: widget.titleStyle!.fontFamily,
//                                   fontFamilyFallback:
//                                       widget.titleStyle!.fontFamilyFallback,
//                                   fontStyle: widget.titleStyle!.fontStyle,
//                                   overflow: widget.titleStyle!.overflow,
//                                   textBaseline: widget.titleStyle!.textBaseline,
//                                   debugLabel: widget.titleStyle!.debugLabel,
//                                   foreground: widget.titleStyle!.foreground,
//                                   decorationThickness:
//                                       widget.titleStyle!.decorationThickness,
//                                   fontFeatures: widget.titleStyle!.fontFeatures,
//                                   fontVariations:
//                                       widget.titleStyle!.fontVariations,
//                                   leadingDistribution:
//                                       widget.titleStyle!.leadingDistribution,
//                                   locale: widget.titleStyle!.locale,
//                                   inherit: widget.titleStyle!.inherit);
//                             }

//                             return Text(
//                                 widget.capitalizeTitle
//                                     ? widget.title.toUpperCase()
//                                     : widget.title,
//                                 style: titleStyle);
//                           }),
//                           LayoutBuilder(builder: (context, c) {
//                             return Stack(
//                               children: [
//                                 SizedBox(
//                                   width: double.infinity,
//                                   height: prefHeight.value,
//                                 ),
//                                 AnimatedBuilder(
//                                   animation: controller,
//                                   builder: (context, child) {
//                                     return AnimatedOpacity(
//                                       opacity: controller.text.isEmpty ? 1 : 0,
//                                       duration: animationDuration,
//                                       child: child,
//                                     );
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 0.0),
//                                     child: Text(
//                                       widget.hintText ?? widget.title,
//                                       style:
//                                           textTheme(context).bodyLarge.subtitle,
//                                     ),
//                                   ),
//                                 ),
//                                 prefHeight.builder((value) {
//                                   return AnimatedPositioned(
//                                     duration: animationDuration,
//                                     curve: Curves.easeInOut,
//                                     bottom: 0,
//                                     left: widget.prefix != null ? 24 : 0,
//                                     height: prefHeight.value,
//                                     right: iconCount * 24.0,
//                                     child: SingleChildScrollView(
//                                       controller: ScrollController(
//                                           initialScrollOffset: 0),
//                                       physics:
//                                           const NeverScrollableScrollPhysics(),
//                                       child: Column(
//                                         children: [
//                                           SizedBox(
//                                             width: double.infinity,
//                                             child: EditableText(
//                                               key: editableTextKey,
//                                               onEditingComplete: () {
//                                                 widget.onEditingComplete
//                                                     ?.call();
//                                                 if (widget.onEditingComplete ==
//                                                     null) {
//                                                   FocusManager
//                                                       .instance.primaryFocus
//                                                       ?.nextFocus();
//                                                 }
//                                               },
//                                               onSubmitted: (_) {
//                                                 widget.onSubmitted?.call();
//                                               },
//                                               selectionControls:
//                                                   MaterialTextSelectionControls(),
//                                               onSelectionChanged: (v, s) {
//                                                 SchedulerBinding.instance
//                                                     .addPostFrameCallback(
//                                                         (timeStamp) {
//                                                   setState(() {
//                                                     _showSelection =
//                                                         !v.isCollapsed;
//                                                   });
//                                                 });
//                                               },
//                                               showSelectionHandles:
//                                                   _showSelection,
//                                               selectionColor: AppColors
//                                                   .brandPrimary
//                                                   .op(0.3),
//                                               focusNode: focusNode,
//                                               controller: controller,
//                                               readOnly:
//                                                   widget.readOnly ?? false,
//                                               onChanged: (v) {
//                                                 if (widget.validator != null) {
//                                                   setState(() {
//                                                     errorText =
//                                                         widget.validator!(v);
//                                                   });
//                                                 }
//                                                 if (widget.onChanged != null) {
//                                                   widget.onChanged!(v);
//                                                 }
//                                               },
//                                               obscureText: _obscureText,
//                                               keyboardType: widget.keyboardType,
//                                               maxLines: widget.maxLines,
//                                               minLines: widget.minLines,
//                                               autofocus:
//                                                   widget.autofocus ?? false,
//                                               autocorrect:
//                                                   widget.autocorrect ?? true,
//                                               enableSuggestions:
//                                                   widget.enableSuggestions ??
//                                                       true,
//                                               cursorColor:
//                                                   AppColors.brandPrimary,
//                                               style: textTheme(context)
//                                                   .bodyLarge
//                                                   .copyWith(
//                                                     color: widget.style?.color,
//                                                     fontSize:
//                                                         widget.style?.fontSize,
//                                                     fontWeight: widget
//                                                         .style?.fontWeight,
//                                                     background: widget
//                                                         .style?.background,
//                                                     decoration: widget
//                                                         .style?.decoration,
//                                                     decorationColor: widget
//                                                         .style?.decorationColor,
//                                                     decorationStyle: widget
//                                                         .style?.decorationStyle,
//                                                     letterSpacing: widget
//                                                         .style?.letterSpacing,
//                                                     wordSpacing: widget
//                                                         .style?.wordSpacing,
//                                                     height:
//                                                         widget.style?.height,
//                                                   ),
//                                               backgroundCursorColor:
//                                                   AppColors.brandPrimary,
//                                               contextMenuBuilder:
//                                                   _defaultContextMenuBuilder,
//                                               autofillHints:
//                                                   widget.autofillHints,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                                 Positioned(
//                                   right: 0,
//                                   child: AnimatedDefaultTextStyle(
//                                     duration: animationDuration,
//                                     style: TextStyle(
//                                         color: errorText != null
//                                             ? AppColors.brandRed
//                                             : AppColors.brandPrimary),
//                                     child: IconTheme(
//                                       data: IconThemeData(
//                                           color: errorText != null
//                                               ? AppColors.brandRed
//                                               : AppColors.brandPrimary),
//                                       child: Row(
//                                         spacing: 8,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           if (_suffixIcons != null)
//                                             ..._suffixIcons!
//                                                 .map((e) => SizedBox(
//                                                       width: 20,
//                                                       height: 20,
//                                                       child: e,
//                                                     )),
//                                           if (widget.obscureText == true)
//                                             SizedBox(
//                                               height: 20,
//                                               width: 20,
//                                               child: InkResponse(
//                                                 onTap: _toggleObscureText,
//                                                 radius: 24,
//                                                 child:
//                                                     ImgGenIcons.pwdVisibility(
//                                                         !_obscureText),
//                                               ),
//                                             ),
//                                           if (errorText != null)
//                                             SizedBox(
//                                                 height: 18,
//                                                 width: 18,
//                                                 child: ImgGenIcons.close()),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 if (widget.prefix != null)
//                                   Positioned(
//                                     bottom: 0,
//                                     left: 0,
//                                     width: 24,
//                                     child: widget.prefix!,
//                                   ),
//                               ],
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   );
//                 });
//           }),
//           LayoutBuilder(builder: (context, c) {
//             return AnimatedContainer(
//               duration: animationDuration,
//               height: errorText != null ? errorHeight(c) : 0,
//               child: errorText != null
//                   ? Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: Text(
//                         errorText!,
//                         style: textTheme(context).bodyMedium.copyWith(
//                               color: AppColors.brandRed,
//                             ),
//                       ),
//                     )
//                   : null,
//             );
//           })
//         ],
//       ),
//     );
//   }

//   @override
//   void onValue(String value) {
//     if (controller.text != value) {
//       controller.text = value;
//     }
//   }
// }

// class ImgGenTextFormField extends ImgGenFormField<String> {
//   const ImgGenTextFormField(
//       {super.key,
//       this.capitalizeTitle = true,
//       this.controller,
//       this.hintText,
//       this.labelText,
//       this.errorText,
//       this.obscureText,
//       this.keyboardType,
//       this.enabled,
//       this.readOnly,
//       this.maxLines = 1,
//       this.minLines,
//       this.maxLength,
//       this.autocorrect,
//       this.autofocus,
//       this.enableSuggestions,
//       this.autovalidate,
//       this.maxLengthEnforced,
//       this.onChanged,
//       super.focusNode,
//       required this.title,
//       required this.validator,
//       this.titleStyle,
//       this.autofillHints,
//       this.valid,
//       this.onEditingComplete,
//       this.onSubmitted,
//       this.initialValue,
//       this.suffixIcons,
//       this.style,
//       this.onTap,
//       this.value});

//   final TextStyle? style;
//   final VoidCallback? onEditingComplete;
//   final Signal<String>? value;
//   final String title;
//   final TextEditingController? controller;
//   final String? hintText;
//   final String? labelText;
//   final String? errorText;
//   final bool? obscureText;
//   final TextInputType? keyboardType;
//   final bool? enabled;
//   final bool? readOnly;
//   final int? maxLines;
//   final int? minLines;
//   final int? maxLength;
//   final bool? autocorrect;
//   final bool? autofocus;
//   final bool? enableSuggestions;
//   final bool? autovalidate;
//   final bool? maxLengthEnforced;
//   final ValueChanged<String>? onChanged;
//   final String? Function(String value) validator;
//   final Iterable<String>? autofillHints;
//   final Signal<bool>? valid;
//   final VoidCallback? onSubmitted;
//   final String? initialValue;
//   final TextStyle? titleStyle;
//   final bool capitalizeTitle;
//   final List<Widget>? suffixIcons;

//   final VoidCallback? onTap;
//   @override
//   ImgGenFormFieldState<String, ImgGenFormField<String>> createState() {
//     return ImgGenTextFormFieldState();
//   }
// }

// class ImgGenTextFormFieldState
//     extends ImgGenFormFieldState<String, ImgGenTextFormField> {
//   late TextEditingController controller;

//   Signal<bool>? valid;

//   @override
//   void initState() {
//     valid = widget.valid;
//     controller = widget.controller ?? TextEditingController(text: widget.initialValue);
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant ImgGenTextFormField oldWidget) {
//     if (widget.controller != oldWidget.controller) {
//       controller = widget.controller ?? TextEditingController();
//     }

//     if (widget.valid != oldWidget.valid) {
//       valid = widget.valid;
//       valid?.value = !hasError;
//     }

//     super.didUpdateWidget(oldWidget);
//   }

//   late int id = Random().nextInt(10000);

//   @override
//   Widget buildForm(BuildContext context) {
//     widget.valid?.value = !hasError;
//     return ImgGenTextField(
//       value: widget.value,
//       initialValue: widget.initialValue,
//       key: ValueKey(id),
//       title: widget.title,
//       controller: controller,
//       hintText: widget.hintText,
//       titleStyle: widget.titleStyle,
//       errorText: error,
//       style: widget.style,
//       obscureText: widget.obscureText,
//       keyboardType: widget.keyboardType,
//       enabled: widget.enabled,
//       readOnly: widget.readOnly,
//       onTap: widget.onTap,
//       onEditingComplete: widget.onEditingComplete,
//       maxLines: widget.maxLines,
//       minLines: widget.minLines,
//       maxLength: widget.maxLength,
//       autocorrect: widget.autocorrect,
//       autofocus: widget.autofocus,
//       enableSuggestions: widget.enableSuggestions,
//       autovalidate: widget.autovalidate,
//       maxLengthEnforced: widget.maxLengthEnforced,
//       onSubmitted: widget.onSubmitted,
//       suffixIcons: widget.suffixIcons,
//       onChanged: (v) {
//         if (widget.onChanged != null) {
//           widget.onChanged!(v);
//         }
//         value = v;
//       },
//       focusNode: focusNode,
//       autofillHints: widget.autofillHints,
//       capitalizeTitle: widget.capitalizeTitle,
//     );
//   }

//   @override
//   String get initialValue => controller.text;

//   @override
//   String get name =>
//       "TextFormField-${widget.title.toLowerCase()}-$id";

//   @override
//   reset() {
//     controller.clear();
//   }

//   @override
//   String? validate(Map<String, dynamic> data) {
//     return widget.validator(controller.text);
//   }
// }
