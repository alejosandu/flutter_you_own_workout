import 'package:flutter/material.dart';

typedef void OnChangedFunction(String value);

class NameTextField extends StatefulWidget {
  final String label;
  final OnChangedFunction onChanged;
  final String? defaultValue;
  final String? isValid;

  NameTextField({
    required this.label,
    required this.onChanged,
    this.defaultValue = '',
    this.isValid,
  });

  @override
  _NameTextFieldState createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
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
