import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:sign_flutter/sign_flutter.dart';
import '../../theme/theme.dart';

// Form Widget
class AppForm extends StatefulWidget {
  const AppForm({
    super.key,
    required this.child,
    this.data,
    this.readOnly = false,
    this.onValidChange,
  });

  final Widget child;
  final Map<String, dynamic>? data;
  final bool readOnly;
  final void Function(bool isValid)? onValidChange;

  static AppFormState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppFormState>();
  }

  @override
  AppFormState createState() => AppFormState();
}

class AppFormState extends State<AppForm> {
  final Set<AppFormFieldState> _fields = {};
  final Set<AppFormFieldState> _errorFields = {};
  late final Map<String, dynamic> _data = widget.data ?? {};
  late bool _readOnly = widget.readOnly;

  Map<String, dynamic> get data => _data;
  bool get hasError => _errorFields.isNotEmpty;

  void _register(AppFormFieldState field) {
    _fields.add(field);
    field._readOnly = _readOnly;
    field.didChange = () {
      setState(() {
        if (field._error == null) {
          _data[field.name] = field.value;
          _errorFields.remove(field);
        } else {
          _data.remove(field.name);
          _errorFields.add(field);
        }
        widget.onValidChange?.call(!hasError);
      });
    };
  }

  void _unregister(AppFormFieldState field) {
    _fields.remove(field);
    _errorFields.remove(field);
    field.didChange = null;
  }

  void validate() {
    for (final field in _fields) {
      field._validate();
    }
    widget.onValidChange?.call(!hasError);
  }

  set readOnly(bool value) {
    if (_readOnly == value) return;
    _readOnly = value;
    for (final field in _fields) {
      field._readOnly = value;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityProvider(child: widget.child);
  }
}

// Form Field Base Class
abstract class AppFormField<T> extends StatefulWidget {
  const AppFormField({
    super.key,
    this.focusNode,
    this.onChanged,
    this.validator,
  });

  final FocusNode? focusNode;
  final ValueChanged<T>? onChanged;
  final String? Function(T value)? validator;

  @override
  AppFormFieldState<T, AppFormField<T>> createState();
}

abstract class AppFormFieldState<T, F extends AppFormField<T>>
    extends State<F> {
  late FocusNode focusNode = widget.focusNode ?? FocusNode();
  String? _error;
  bool _showError = false;
  bool _readOnly = false;
  bool _isFocused = false;
  T? _value;
  VoidCallback? didChange;

  String get name;
  T get value => _value as T;
  bool get hasError => _error != null;
  bool get showError => _showError && hasError;
  String? get error => showError ? _error : null;
  bool get readOnly => _readOnly;

  set value(T val) {
    if (_readOnly) return;
    if (val == _value) return;

    _value = val;
    _error = widget.validator?.call(val);
    didChange?.call();
    setState(() {});
  }

  void _validate() {
    _showError = true;
    _error = widget.validator?.call(value);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_handleFocusChange);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final form = AppForm.of(context);
      if (form != null) form._register(this);
    });
  }

  @override
  void dispose() {
    final form = AppForm.of(context);
    if (form != null) form._unregister(this);
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_isFocused && !focusNode.hasFocus) {
      _validate();
    }
    _isFocused = focusNode.hasFocus;
    setState(() {});
  }
}

// Text Form Field Implementation
class AppTextFormField extends AppFormField<String> {
  const AppTextFormField({
    super.key,
    super.focusNode,
    super.onChanged,
    super.validator,
    this.initialValue,
    this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.onSubmitted,
    this.onEditingComplete,
    this.controller,
    this.valid,
    this.autofillHints,
  });

  final String? initialValue;
  final String? label;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final TextEditingController? controller;
  final Signal<bool>? valid;
  final List<String>? autofillHints;

  @override
  AppTextFormFieldState createState() => AppTextFormFieldState();
}

class AppTextFormFieldState
    extends AppFormFieldState<String, AppTextFormField> {
  late final TextEditingController _controller;
  bool _obscureText = false;

  @override
  String get name => widget.label ?? 'text-field-${Random().nextInt(10000)}';

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _value = widget.initialValue ?? '';
    _controller = widget.controller ?? TextEditingController(text: _value);
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    value = _controller.text;
    widget.onChanged?.call(_controller.text);
  }

  void _toggleObscureText() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    widget.valid?.value = !hasError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelMedium.copyWith(
              color: showError ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        MouseRegion(
          cursor:
              widget.enabled
                  ? SystemMouseCursors.text
                  : SystemMouseCursors.basic,
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color:
                  widget.enabled
                      ? theme.inputDecorationTheme.fillColor
                      : AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                width: 1,
                color:
                    showError
                        ? AppColors.error
                        : focusNode.hasFocus
                        ? theme.colorScheme.primary
                        : Colors.transparent,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Row(
                children: [
                  if (widget.prefix != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: widget.prefix,
                    ),
                  ],
                  if (widget.prefixIcon != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: IconTheme(
                        data: IconThemeData(
                          color:
                              showError
                                  ? AppColors.error
                                  : theme.colorScheme.primary,
                          size: 20,
                        ),
                        child: widget.prefixIcon!,
                      ),
                    ),
                  ],
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: focusNode,
                      style: AppTypography.bodyMedium,
                      obscureText: _obscureText,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      autofillHints: widget.autofillHints,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      maxLength: widget.maxLength,
                      autofocus: widget.autofocus,
                      readOnly: widget.readOnly || readOnly,
                      enabled: widget.enabled,
                      onSubmitted: widget.onSubmitted,
                      onEditingComplete: widget.onEditingComplete,
                      cursorColor: theme.colorScheme.primary,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: false,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.md,
                        ),
                        counterText: '',
                        isDense: true,
                      ),
                    ),
                  ),
                  if (widget.obscureText) ...[
                    IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      onPressed: _toggleObscureText,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                  if (widget.suffix != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: widget.suffix,
                    ),
                  ],
                  if (widget.suffixIcon != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: IconTheme(
                        data: IconThemeData(
                          color:
                              showError
                                  ? AppColors.error
                                  : theme.colorScheme.primary,
                          size: 20,
                        ),
                        child: widget.suffixIcon!,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            error!,
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
