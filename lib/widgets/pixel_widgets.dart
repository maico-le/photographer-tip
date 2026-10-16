import 'package:flutter/material.dart';
import '../theme/pixel_theme.dart';

/// Retro Pixel Card with 0px radius, 2px border, and solid offset shadow
class PixelCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double shadowOffset;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool hasShadow;

  const PixelCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = PixelThemeData.borderWidth,
    this.shadowOffset = PixelThemeData.shadowOffset,
    this.padding = const EdgeInsets.all(12),
    this.margin,
    this.onTap,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? const Color(0xFF141416);
    final bg = backgroundColor ?? Colors.white;

    final container = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: border, width: borderWidth),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: border,
                  offset: Offset(shadowOffset, shadowOffset),
                  blurRadius: 0,
                  spreadRadius: 0,
                )
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}

/// Retro Pixel Button with mechanical stepped press effect
class PixelButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final bool isPrimary;
  final bool isSmall;

  const PixelButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.isPrimary = false,
    this.isSmall = false,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final border = widget.borderColor ?? const Color(0xFF141416);
    final defaultBg = widget.isPrimary ? const Color(0xFFD9222A) : Colors.white;
    final bg = !enabled ? Colors.grey.shade400 : (widget.backgroundColor ?? defaultBg);

    final effectivePadding = widget.isSmall
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 6)
        : widget.padding;

    const offset = PixelThemeData.shadowOffset;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: enabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: Duration.zero,
        margin: EdgeInsets.only(
          top: _isPressed ? offset : 0,
          left: _isPressed ? offset : 0,
          right: _isPressed ? 0 : offset,
          bottom: _isPressed ? 0 : offset,
        ),
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: border, width: PixelThemeData.borderWidth),
          boxShadow: enabled && !_isPressed
              ? [
                  BoxShadow(
                    color: border,
                    offset: const Offset(offset, offset),
                    blurRadius: 0,
                    spreadRadius: 0,
                  )
                ]
              : null,
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            fontSize: widget.isSmall ? 11 : 13,
            color: widget.textColor ?? (widget.isPrimary ? Colors.white : const Color(0xFF141416)),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Compact retro badge / tag
class PixelBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final IconData? icon;
  final Widget? iconWidget;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const PixelBadge({
    super.key,
    required this.label,
    this.backgroundColor = const Color(0xFF141416),
    this.textColor = Colors.white,
    this.borderColor,
    this.icon,
    this.iconWidget,
    this.fontSize = 11.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: borderColor ?? const Color(0xFF141416),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconWidget != null) ...[
            iconWidget!,
            const SizedBox(width: 4),
          ] else if (icon != null) ...[
            Icon(icon, size: fontSize + 1, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Retro Lightroom slider bar visualization
class PixelSliderBar extends StatelessWidget {
  final String label;
  final double value; // Can be negative e.g. -60 to +40, or 0 to 100
  final double min;
  final double max;
  final String? displayValue;
  final Color activeColor;

  const PixelSliderBar({
    super.key,
    required this.label,
    required this.value,
    this.min = -100,
    this.max = 100,
    this.displayValue,
    this.activeColor = const Color(0xFFD9222A),
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(min, max);
    final zeroPos = (0 - min) / (max - min); // Fraction where 0 sits
    final currentPos = (clamped - min) / (max - min);

    final isZero = value == 0;
    final leftPos = min < 0 ? (value >= 0 ? zeroPos : currentPos) : 0.0;
    final barWidth = min < 0 ? (currentPos - zeroPos).abs() : currentPos;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4D57),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E9EC),
                borderRadius: BorderRadius.zero,
                border: Border.all(color: const Color(0xFF141416), width: 1.2),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalW = constraints.maxWidth;
                  final leftPx = leftPos * totalW;
                  final widthPx = (barWidth * totalW).clamp(2.0, totalW);

                  return Stack(
                    children: [
                      // Center tick mark if bidirectional
                      if (min < 0 && max > 0)
                        Positioned(
                          left: zeroPos * totalW - 0.75,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 1.5,
                            color: const Color(0xFF888B96),
                          ),
                        ),
                      // Active fill bar
                      if (!isZero)
                        Positioned(
                          left: leftPx,
                          top: 1,
                          bottom: 1,
                          width: widthPx,
                          child: Container(
                            color: activeColor,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            child: Text(
              displayValue ?? (value > 0 ? '+$value' : '$value'),
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF141416),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
