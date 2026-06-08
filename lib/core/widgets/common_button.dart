import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  final String title;
  final Function()? onPressed;
  final bool isTransparent;
  final bool isEnabled;
  final Color? bgColor;
  final Color? borderColor;
  final Color textColor;
  final Widget? icon;
  final Widget? trailingIcon;
  final double fontSize;
  final bool isLoading;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final FontWeight textWeight;
  final String? fontFamily;
  final Color? shadowColor;

  const CommonButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isTransparent = false,
    this.bgColor,
    this.borderColor,
    this.textColor = Colors.white,
    this.icon,
    this.trailingIcon,
    this.horizontalPadding = 0,
    this.verticalPadding = 13,
    this.fontSize = 17,
    this.isEnabled = true,
    this.isLoading = false,
    this.borderRadius = 16,
    this.textWeight = FontWeight.w400,
    this.fontFamily,
    this.shadowColor,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color buttonBgColor = widget.bgColor ?? AppColors.greenColor;
    final Color buttonBorderColor = widget.borderColor ?? Colors.white;

    return GestureDetector(
      onTap: widget.isLoading || !widget.isEnabled ? null : widget.onPressed,
      onTapDown: (_) {
        if (!widget.isLoading && widget.isEnabled) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.horizontalPadding > 0 ? null : double.infinity,
        decoration: BoxDecoration(
          color: widget.isTransparent
              ? Colors.transparent
              : _isPressed
                  ? Color.alphaBlend(
                      Colors.black.withValues(alpha: 0.12),
                      buttonBgColor,
                    )
                  : buttonBgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: buttonBorderColor, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius - 2),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ===== MAIN CONTENT =====
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: widget.verticalPadding,
                  horizontal:
                      widget.horizontalPadding > 0
                          ? widget.horizontalPadding
                          : 16,
                ),
                child: widget.isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widget.fontSize,
                                color: widget.textColor,
                                fontWeight: widget.textWeight,
                                fontFamily:
                                    widget.fontFamily ?? 'LuckiestGuy',
                                // ===== TEXT STROKE EFFECT =====
                                shadows: [
                                  Shadow(
                                    blurRadius: 0,
                                    offset: const Offset(-2, -2),
                                    color:
                                        widget.shadowColor ??
                                        AppColors.textshadowGreen,
                                  ),
                                  // Top-Right
                                  Shadow(
                                    blurRadius: 0,
                                    offset: const Offset(2, -2),
                                    color:
                                        widget.shadowColor ??
                                        AppColors.textshadowGreen,
                                  ),
                                  // Bottom-Right
                                  Shadow(
                                    blurRadius: 0,
                                    offset: const Offset(2, 2),
                                    color:
                                        widget.shadowColor ??
                                        AppColors.textshadowGreen,
                                  ),
                                  // Bottom-Left
                                  Shadow(
                                    blurRadius: 0,
                                    offset: const Offset(-2, 2),
                                    color:
                                        widget.shadowColor ??
                                        AppColors.textshadowGreen,
                                  ),
                                  // Left
                                  Shadow(
                                    blurRadius: 0,
                                    offset: const Offset(-2, 0),
                                    color:
                                        widget.shadowColor ??
                                        AppColors.textshadowGreen,
                                  ),
                                  // Right
                                  Shadow(
                                    blurRadius: 0,
                                    offset: const Offset(2, 0),
                                    color:
                                        widget.shadowColor ??
                                        AppColors.textshadowGreen,
                                  ),
                                  // Top
                                  Shadow(
                                    blurRadius: 0,
                                    offset: const Offset(0, -2),
                                    color:
                                        widget.shadowColor ??
                                        AppColors.textshadowGreen,
                                  ),
                                  // Bottom
                                  Shadow(
                                    blurRadius: 0,
                                    offset: const Offset(0, 2),
                                    color:
                                        widget.shadowColor ??
                                        AppColors.textshadowGreen,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (widget.trailingIcon != null) ...[
                            const SizedBox(width: 8),
                            widget.trailingIcon!,
                          ],
                        ],
                      ),
              ),

              // ===== BOTTOM SHADOW EFFECT =====
              if (!widget.isTransparent)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              // ===== TOP SHINE EFFECT =====
              if (!widget.isTransparent)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Transform.rotate(
                    angle: -39.44 * (3.14159265 / 180),
                    child: Container(
                      width: 11,
                      height: 4.5, 
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
