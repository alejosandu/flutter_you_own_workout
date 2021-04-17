import 'package:flutter/material.dart';

typedef void DismissedFunction<T>(item);

class DismissibleContainer extends StatelessWidget {
  final dynamic index;
  final DismissedFunction onDismissed;
  final Widget child;

  DismissibleContainer({
    this.index,
    required this.child,
    required this.onDismissed,
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
        padding: EdgeInsets.only(left: 20),
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 50,
        ),
        color: Colors.red,
      ),
    );
  }
}
