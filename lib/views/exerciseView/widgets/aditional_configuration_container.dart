import 'package:flutter/material.dart';

class AditionalConfigurationContainer extends StatelessWidget {
  final bool expanded;
  final List<Widget> children;

  AditionalConfigurationContainer({
    this.expanded = false,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    final double height = expanded ? 90 : 0;
    return AnimatedContainer(
      child: SingleChildScrollView(
        child: Row(
          children: children,
        ),
      ),
      duration: const Duration(milliseconds: 200),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
