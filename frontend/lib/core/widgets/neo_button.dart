import 'package:flutter/material.dart';

import '../theme/neobrutalism_theme.dart';

class NeoButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const NeoButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor = NeoColors.accent,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.borderRadius = 8.0,
  });

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext me) {
    // Si se presiona, la sombra "desaparece" y el botón se desplaza hacia la posición de la sombra
    final double offsetVal = _isPressed ? 0.0 : (_isHovered ? 6.0 : 4.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.translationValues(
            _isPressed ? 4.0 : (_isHovered ? -2.0 : 0.0),
            _isPressed ? 4.0 : (_isHovered ? -2.0 : 0.0),
            0.0,
          ),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: NeoStyle.border(),
            boxShadow: offsetVal > 0
                ? NeoStyle.hardShadow(offset: Offset(offsetVal, offsetVal))
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
