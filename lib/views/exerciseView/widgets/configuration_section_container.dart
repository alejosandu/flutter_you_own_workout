import 'package:flutter/material.dart';

class ConfigurationSectionContainer extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;

  ConfigurationSectionContainer({
    Key key,
    @required this.icon,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: Icon(
              icon,
              size: 35,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5),
            child: TextField(
              autofocus: false,
              keyboardType: TextInputType.number,
              controller: controller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                ),
              ),
            ),
          )
        ],
      ),
      height: 90,
      width: 90,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.primaryColor,
          width: 1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
