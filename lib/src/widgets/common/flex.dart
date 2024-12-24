// import 'package:flutter/material.dart';

// final class GapData {
//   final double? vertical;
//   final double? horizontal;

//   const GapData({this.vertical, this.horizontal});
// }

// class GapScope extends InheritedWidget {
//   const GapScope({super.key, required this.gap, required super.child});

//   GapScope.vertical(double gap, {super.key, required super.child})
//       : gap = GapData(vertical: gap);

//   GapScope.horizontal(double gap, {super.key, required super.child})
//       : gap = GapData(horizontal: gap);

//   GapScope.all(double gap, {super.key, required super.child})
//       : gap = GapData(vertical: gap, horizontal: gap);

//   final GapData gap;

//   static GapData of(BuildContext context) {
//     final GapScope? scope =
//         context.dependOnInheritedWidgetOfExactType<GapScope>();
//     return scope?.gap ?? const GapData();
//   }

//   @override
//   bool updateShouldNotify(GapScope oldWidget) => gap != oldWidget.gap;
// }

// class GRow extends Row {
//   GRow(
//       {super.key,
//       super.mainAxisAlignment,
//       super.crossAxisAlignment,
//       super.mainAxisSize,
//       super.textDirection,
//       super.verticalDirection,
//       super.textBaseline,
//       required List<Widget> children,
//       this.gap})
//       : super(children: (() {
//           List<Widget> ch = [];
//           for (int i = 0; i < children.length; i++) {
//             ch.add(children[i]);
//             if (i != children.length - 1 && children[i] is! Gap) {
//               ch.add(_gap(gap));
//             }
//           }
//           return ch;
//         })());

//   final double? gap;

//   static Widget _gap(double? gap) {
//     return Builder(builder: (context) {
//       return SizedBox(width: gap ?? GapScope.of(context).horizontal);
//     });
//   }
// }

// class GColumn extends Column {
//   GColumn(
//       {super.key,
//       super.mainAxisAlignment,
//       super.crossAxisAlignment,
//       super.mainAxisSize,
//       super.textDirection,
//       super.verticalDirection,
//       super.textBaseline,
//       required List<Widget> children,
//       this.gap})
//       : super(children: (() {
//           List<Widget> ch = [];
//           for (int i = 0; i < children.length; i++) {
//             ch.add(children[i]);
//             if (i != children.length - 1 && children[i] is! Gap) {
//               ch.add(_gap(gap));
//             }
//           }
//           return ch;
//         })());

//   final double? gap;

//   static Widget _gap(double? gap) {
//     return Builder(builder: (context) {
//       return SizedBox(height: gap ?? GapScope.of(context).vertical);
//     });
//   }
// }

// class Gap extends StatelessWidget {
//   const Gap({super.key, this.gap});

//   final double? gap;

//   Flex? _findFlex(BuildContext context) {
//     Flex? flex;
//     context.visitAncestorElements((element) {
//       if (element.widget is Flex) {
//         flex = element.widget as Flex;
//         return false;
//       }
//       return true;
//     });

//     return flex;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Flex? flex = _findFlex(context);

//     if (flex == null) {
//       return const SizedBox();
//     }
//     return SizedBox(
//       width: flex.direction == Axis.horizontal
//           ? gap ?? GapScope.of(context).horizontal
//           : 0,
//       height: flex.direction == Axis.vertical
//           ? gap ?? GapScope.of(context).vertical
//           : 0,
//     );
//   }
// }
