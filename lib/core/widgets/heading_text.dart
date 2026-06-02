import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? weight;
  final Color? color;
  final int? lines;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final TextDecoration? decoration;
  final double decorationThickness;
  final TextDecorationStyle? decorationStyle;
  final Color? decorationColor;
  final double? letterSpacing;
  final double? lineSpacing;
  final String? fontFamily;
  final Color? shadowColor;

  const HeadingText({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.weight,
    this.color,
    this.lines,
    this.fontStyle,
    this.textOverflow,
    this.textAlign,
    this.decoration = TextDecoration.none,
    this.decorationThickness = 1.0,
    this.decorationStyle = TextDecorationStyle.solid,
    this.decorationColor,
    this.letterSpacing,
    this.lineSpacing,
    this.fontFamily,
    this.shadowColor, 
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: lines,
      textAlign: textAlign,
      overflow: textOverflow,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Colors.white,
        fontWeight: weight ?? FontWeight.w400,
        fontStyle: fontStyle,
        fontFamily: fontFamily ?? 'LuckiestGuy',
        decoration: decoration,
        decorationThickness: decorationThickness,
        decorationStyle: decorationStyle ?? TextDecorationStyle.solid,
        decorationColor: decorationColor ?? color,
        letterSpacing: letterSpacing ?? -.5,
        height: lineSpacing,
        shadows: [
          Shadow(
            color: shadowColor ?? AppColors.textShadowBlackColor,
            offset: const Offset(1.8, 1.8),
            blurRadius: 2, 
          ),
        ],
      ),
    );
  }
}
