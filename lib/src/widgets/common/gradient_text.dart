import 'package:flutter/widgets.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
    this.textAlign,
    this.maxLines,
    this.fontSize,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? fontSize;

  double _calculateFontSize(String text, double maxWidth, double maxHeight) {
    double fontSize = 35; // Başlangıç font boyutu
    double step = 1.0; // Her adımda ne kadar arttırıp azaltılacağı

    while (true) {
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
        maxLines: 2,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: maxWidth);

      if (textPainter.didExceedMaxLines ||
          textPainter.height > maxHeight ||
          textPainter.width > maxWidth) {
        fontSize -= step;
      } else {
        break;
      }

      if (fontSize <= 0) {
        fontSize = 1; // Minimum font boyutu
        break;
      }
    }

    return fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = _calculateFontSize(
          text,
          constraints.maxWidth,
          constraints.maxHeight,
        );
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback:
              (bounds) => gradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
          child: Text(
            text,
            style:
                style?.copyWith(fontSize: fontSize) ??
                TextStyle(fontSize: fontSize),
            textAlign: textAlign,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines ?? 2,
          ),
        );
      },
    );
  }
}
