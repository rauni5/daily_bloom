import 'package:flutter/material.dart';

/// Breakpoints for different layouts
class Breakpoints {
  static const double tablet = 700;
  static const double desktop = 1100;

  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet;
}

/// Wrap page bodies with this instead of
/// letting a single Column stretch edge-to-edge on desktop.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 900,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// available width. 1 column = phone, 2 = tablet, 3 = desktop/web.
int responsiveColumns(double width) {
  if (width >= Breakpoints.desktop) return 3;
  if (width >= Breakpoints.tablet) return 2;
  return 1;
}
