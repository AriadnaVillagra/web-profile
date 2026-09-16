import 'package:flutter/material.dart';

import '../theme/neobrutalism_theme.dart';

class NeoCard extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const NeoCard({
    super.key,
    required this.child,
    this.backgroundColor = NeoColors.cardBg,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
  });

  @override
  State<NeoCard> createState() => _NeoCardState();
}

class _NeoCardState extends State<NeoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(
            _isHovered ? -3.0 : 0.0,
            _isHovered ? -3.0 : 0.0,
            0.0,
          ),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: NeoStyle.border(width: 3.5),
            boxShadow: NeoStyle.hardShadow(
              offset: _isHovered ? const Offset(8, 8) : const Offset(5, 5),
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
