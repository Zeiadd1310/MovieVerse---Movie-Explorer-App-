import 'package:flutter/material.dart';
import 'package:movie_verse_app/core/constants/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.text,
    required this.width,
    required this.height,
    required this.style,
    required this.radius,
    this.icon,
    this.color,
    this.borderColor,
    this.iconSize,
    this.isLoading = false,
    this.loadingColor,
  });

  final VoidCallback? onTap;
  final String text;
  final double width;
  final double height;
  final TextStyle style;
  final double radius;
  final IconData? icon;
  final Color? color;
  final Color? borderColor;
  final double? iconSize;
  final bool isLoading;
  final Color? loadingColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? kButtonsColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor ?? Colors.black.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: loadingColor ?? Colors.black,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: Colors.white, size: iconSize ?? 20),
                      const SizedBox(width: 8),
                    ],
                    Text(text, style: style),
                  ],
                ),
        ),
      ),
    );
  }
}
