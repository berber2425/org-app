// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:sign_flutter/sign_flutter.dart';

// class _FormScope extends InheritedWidget {
//   const _FormScope({
//     required super.child,
//     required ImgGenFormState formState,
//     required int generation,
//   })  : _formState = formState,
//         _generation = generation;

//   final ImgGenFormState _formState;

//   /// Incremented every time a form field has changed. This lets us know when
//   /// to rebuild the form.
//   final int _generation;

//   /// The [Form] associated with this widget.
//   ImgGenForm get form => _formState.widget;

//   @override
//   bool updateShouldNotify(_FormScope old) => _generation != old._generation;
// }

// class ImgGenForm extends StatefulWidget {
//   const ImgGenForm({
//     super.key,
//     required this.child,
//     this.data,
//     this.readOnly = false,
//     this.valid,
//   });

//   final Widget child;
//   final Map<String, dynamic>? data;
//   final bool readOnly;
//   final Signal<bool>? valid;

//   static ImgGenFormState of(BuildContext context) {
//     final _FormScope scope =
//         context.dependOnInheritedWidgetOfExactType<_FormScope>()!;
//     return scope._formState;
//   }

//   static ImgGenFormState? maybeOf(BuildContext context) {
//     if (context.mounted) {
//       return context
//           .dependOnInheritedWidgetOfExactType<_FormScope>()
//           ?._formState;
//     }
//     return null;
//   }

//   @override
//   ImgGenFormState createState() => ImgGenFormState();
// }

// class MockNotifier extends ChangeNotifier {
//   void notify() {
//     super.notifyListeners();
//   }
// }

// class ImgGenFormState extends State<ImgGenForm> {
//   final Set<ImgGenFormFieldState<dynamic, dynamic>> _fields =
//       <ImgGenFormFieldState<dynamic, dynamic>>{};

//   final MockNotifier _notifier = MockNotifier();

//   void notifyListeners() {
//     _notifier.notify();
//   }

//   void addListener(VoidCallback listener) {
//     _notifier.addListener(listener);
//   }

//   void removeListener(VoidCallback listener) {
//     _notifier.removeListener(listener);
//   }

//   @override
//   void dispose() {
//     _notifier.dispose();
//     super.dispose();
//   }

//   int _generation = 0;

//   late final Map<String, dynamic> _data = widget.data ?? {};

//   Map<String, dynamic> get data => _data;

//   final Set<ImgGenFormFieldState<dynamic, dynamic>> _errorFields = {};

//   late bool _readOnly = widget.readOnly;

//   set readOnly(bool value) {
//     if (_readOnly == value) {
//       return;
//     }

//     _readOnly = value;

//     for (final field in _fields) {
//       field._readOnly = value;
//     }
//     _setState();
//   }

//   void _register(ImgGenFormFieldState<dynamic, dynamic> field) {
//     field._readOnly = widget.readOnly;

//     _fields.add(field);

//     assert(() {
//       if (_data.containsKey(field.name)) {
//         throw FlutterError(
//             'There is already a field with name ${field.name} in the form');
//       }
//       return true;
//     }());

//     assert(() {
//       if (field.didChange != null) {
//         throw FlutterError(
//             'The field ${field.name} has already been registered');
//       }
//       return true;
//     }());

//     field.didChange = () {
//       setState(() {
//         _generation++;
//         if (field._error == null) {
//           _data[field.name] = field.value;
//           _errorFields.remove(field);
//         } else {
//           _data.remove(field.name);
//           _errorFields.add(field);
//         }
//         notifyListeners();
//         widget.valid?.value = !hasError;
//       });
//     };
//     _setState();
//   }

//   void unregister(ImgGenFormFieldState<dynamic, dynamic> field) {
//     _fields.remove(field);
//     field.didChange = null;
//     _setState();
//   }

//   Axis? _scrollDirection(ScrollController? controller) {
//     if (controller == null) {
//       return null;
//     }

//     if (!controller.hasClients) {
//       return null;
//     }

//     return controller.position.axis;
//   }

//   void validate() {
//     Map<String, Offset> positions = {};
//     ScrollController? controller;
//     for (final field in _fields) {
//       field._validate(_data);
//       if (field.showError) {
//         final position = field._positionInScroll();
//         if (position != null) {
//           positions[field.name] = position;
//         }
//         controller ??= field._scrollController();
//       }
//     }

//     if (positions.isEmpty) {
//       return;
//     }

//     if (controller == null) {
//       return;
//     }

//     if (!controller.hasClients) {
//       return;
//     }

//     final direction = _scrollDirection(controller);

//     if (direction != null) {
//       double first = double.infinity;
//       String firstId = '';

//       for (final field in positions.entries) {
//         switch (direction) {
//           case Axis.horizontal:
//             if (field.value.dx < first) {
//               first = field.value.dx;
//               firstId = field.key;
//             }
//           case Axis.vertical:
//             if (field.value.dy < first) {
//               first = field.value.dy;
//               firstId = field.key;
//             }
//         }
//       }

//       final item = _fields.firstWhere((element) => element.name == firstId);
//       item._ensureVisible();
//     }
//   }

//   bool get hasError {
//     for (final field in _fields) {
//       if (!field._isValid) {
//         return true;
//       }
//     }
//     return false;
//   }

//   _setState() {
//     _generation++;
//     setState(() {});
//     widget.valid?.value = !hasError;
//     notifyListeners();
//   }

//   final _keyboardVisibilityController = KeyboardVisibilityController();

//   @override
//   Widget build(BuildContext context) {
//     return KeyboardVisibilityProvider(
//       controller: _keyboardVisibilityController,
//       child: _FormScope(
//         formState: this,
//         generation: _generation,
//         child: widget.child,
//       ),
//     );
//   }
// }

// abstract class ImgGenFormField<T> extends StatefulWidget {
//   const ImgGenFormField({super.key, this.focusNode});

//   static ImgGenFormField<T> basic<T>({
//     Key? key,
//     required Widget Function(BuildContext context, T value, String? error,
//             {required void Function(T) onChanged})
//         builder,
//     String? name,
//     required T value,
//     required String? Function(T) validator,
//   }) {
//     final k = key ?? UniqueKey();
//     return _BasicFormField<T>(
//       key: k,
//       builder: builder,
//       name: name ?? k.toString(),
//       value: value,
//       validator: validator,
//     );
//   }

//   final FocusNode? focusNode;

//   @override
//   ImgGenFormFieldState<T, ImgGenFormField<T>> createState();
// }

// abstract class ImgGenFormFieldState<T, S extends ImgGenFormField<T>>
//     extends State<S> {
//   Offset? _positionInScroll() {
//     final RenderObject? renderObject = context.findRenderObject();

//     if (renderObject is RenderBox) {
//       return renderObject.localToGlobal(Offset.zero);
//     }

//     return null;
//   }

//   ScrollController? _scrollController() {
//     final controller = Scrollable.maybeOf(context)?.widget.controller;

//     if (controller == null) {
//       return null;
//     }

//     if (!controller.hasClients) {
//       return null;
//     }

//     return controller;
//   }

//   late FocusNode focusNode = widget.focusNode ?? FocusNode();

//   String? validate(Map<String, dynamic> data);

//   _validate(Map<String, dynamic> data) {
//     _showError = true;
//     _error = validate(data);
//     didChange?.call();
//     setState(() {});
//   }

//   reset();

//   String get name;

//   T get value => _value;

//   late T _value;

//   T get initialValue;

//   String? _error;

//   set value(T value) {
//     if (readOnly) {
//       return;
//     }

//     if (value == _value) {
//       return;
//     }

//     _value = value;

//     final currentValid = _error == null;

//     _error = validate(ImgGenForm.maybeOf(context)?._data ?? {});

//     if (currentValid) {
//       // current state is valid
//       if (_error != null) {
//         _showError = true;
//       }
//     }

//     didChange?.call();
//     setState(() {});
//   }

//   bool _showError = false;

//   String? get error => _showError ? _error : null;

//   bool get _isValid =>
//       validate(ImgGenForm.maybeOf(context)?._data ?? {}) == null;

//   bool get showError => error != null;

//   bool get hasError => _error != null;

//   void Function()? didChange;

//   bool _readOnly = false;

//   bool get readOnly => _readOnly;

//   bool _registered = false;

//   @mustCallSuper
//   @override
//   initState() {
//     _value = initialValue;
//     whenMounted(() {
//       final form = ImgGenForm.maybeOf(context);
//       form?._register(this);
//       _error = validate(form?._data ?? {});
//       _registered = true;
//       setState(() {});
//     });
//     _isFocused = focusNode.hasFocus;
//     focusNode.addListener(_focusListener);
//     super.initState();
//   }

//   bool _isFocused = false;

//   void _focusListener() {
//     if (_isFocused) {
//       // already focused
//       if (!focusNode.hasFocus) {
//         // on focus lost
//         _validate(ImgGenForm.maybeOf(context)?._data ?? {});
//       } else {
//         // on focus gained
//       }
//     } else {
//       // not focused

//       if (focusNode.hasFocus) {
//         _showError = false;
//         _isFocused = true;
//         Duration duration;
//         if (ImgGenForm.maybeOf(context)
//                 ?._keyboardVisibilityController
//                 .isVisible ==
//             false) {
//           duration = const Duration(milliseconds: 500);
//         } else {
//           duration = const Duration(milliseconds: 100);
//         }
//         SchedulerBinding.instance.addPostFrameCallback((_) {
//           Future.delayed(duration).then((_) {
//             _ensureVisible();
//           });
//         });
//       }
//     }

//     didChange?.call();
//     setState(() {});
//   }

//   _ensureVisible() {
//     Scrollable.ensureVisible(context,
//         alignment: 0.5, duration: const Duration(milliseconds: 250));
//   }

//   @mustCallSuper
//   @override
//   dispose() {
//     final form = ImgGenForm.maybeOf(context);
//     form?.unregister(this);
//     focusNode.removeListener(_focusListener);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_registered) {
//       return const SizedBox();
//     }
//     return buildForm(context);
//   }

//   Widget buildForm(BuildContext context);

//   Future<void> whenMounted(Function callback) async {
//     if (mounted) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         callback();
//         _isFocused = focusNode.hasFocus;
//       });
//     } else {
//       sc() {
//         SchedulerBinding.instance.addPostFrameCallback((_) {
//           if (mounted) {
//             callback();
//             _isFocused = focusNode.hasFocus;
//           } else {
//             sc();
//           }
//         });
//       }

//       sc();
//     }
//   }
// }

// class _BasicFormField<T> extends ImgGenFormField<T> {
//   final Widget Function(BuildContext context, T value, String? error,
//       {required void Function(T) onChanged}) builder;

//   final String name;

//   final T value;

//   final String? Function(T) validator;

//   const _BasicFormField({
//     super.key,
//     required this.builder,
//     required this.name,
//     required this.value,
//     required this.validator,
//   });

//   @override
//   _BasicFormFieldState<T> createState() => _BasicFormFieldState<T>();
// }

// class _BasicFormFieldState<T>
//     extends ImgGenFormFieldState<T, _BasicFormField<T>> {
//   @override
//   String get name => widget.name;

//   @override
//   String? validate(Map<String, dynamic> data) {
//     return widget.validator(value);
//   }

//   @override
//   Widget buildForm(BuildContext context) {
//     return widget.builder(context, value, showError ? error : null,
//         onChanged: (value) {
//       this.value = value;
//     });
//   }

//   @override
//   reset() {
//     value = widget.value;
//   }

//   @override
//   T get initialValue => widget.value;
// }
