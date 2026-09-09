import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/glass_theme.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const GlassAppBar({super.key, required this.title, this.actions, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final glass = GlassTheme.of(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blurSigma, sigmaY: glass.blurSigma),
        child: Container(
          decoration: BoxDecoration(
            color: glass.tint,
            border: Border(bottom: BorderSide(color: glass.border)),
          ),
          child: AppBar(
            title: Text(title),
            leading: leading,
            actions: actions,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}