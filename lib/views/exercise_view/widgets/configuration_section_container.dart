import 'package:flutter/material.dart';

typedef void OnChangedFunction(String value);

class ConfigurationSectionContainer extends StatefulWidget {
  final IconData icon;
  final OnChangedFunction onChanged;
  final String defaultValue;
  final String? isValid;

  ConfigurationSectionContainer({
    Key? key,
    required this.icon,
    required this.onChanged,
    this.defaultValue = '',
    this.isValid,
  }) : super(key: key);

  @override
  _ConfigurationSectionContainerState createState() =>
      _ConfigurationSectionContainerState();
}

class _ConfigurationSectionContainerState
    extends State<ConfigurationSectionContainer> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.defaultValue;
    super.initState();
  }

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
              widget.icon,
              size: 35,
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5),
            child: TextField(
              autofocus: false,
              keyboardType: TextInputType.number,
              onChanged: widget.onChanged,
              controller: _controller,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                errorText: widget.isValid,
                errorStyle: TextStyle(height: 0),
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

class ConfigurationExerciseName extends StatefulWidget {
  final String label;
  final OnChangedFunction onChanged;
  final String? defaultValue;
  final String? isValid;

  ConfigurationExerciseName({
    required this.label,
    required this.onChanged,
    this.defaultValue = '',
    this.isValid,
  });

  @override
  _ConfigurationExerciseNameState createState() =>
      _ConfigurationExerciseNameState();
}

class _ConfigurationExerciseNameState extends State<ConfigurationExerciseName> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.defaultValue as String;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      onChanged: widget.onChanged,
      controller: _controller,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.isValid,
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }
}
