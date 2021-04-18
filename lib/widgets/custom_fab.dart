import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

typedef void OnTapFunction();

class FabAction {
  final Widget child;
  final String label;
  final OnTapFunction? onTap;

  FabAction({
    required this.child,
    required this.label,
    this.onTap,
  });
}

class CustomFab extends StatelessWidget {
  final AnimatedIconData icon;
  final List<FabAction> children;

  CustomFab({
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SpeedDial(
      animatedIcon: icon,
      backgroundColor: theme.accentColor,
      foregroundColor: theme.buttonColor,
      children: children
          .map((action) => SpeedDialChild(
                child: action.child,
                label: action.label,
                onTap: action.onTap,
              ))
          .toList(),
    );
  }
}
