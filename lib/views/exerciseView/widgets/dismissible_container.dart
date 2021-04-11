import 'package:flutter/material.dart';

class DismissibleContainer extends StatelessWidget {
  final dynamic index;
  final Function onDismissed;
  final Widget child;

  DismissibleContainer({
    this.index,
    this.child,
    this.onDismissed(index),
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(index),
      child: child,
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        onDismissed(index);
      },
      background: Container(
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        color: Colors.red,
      ),
    );
  }
}
