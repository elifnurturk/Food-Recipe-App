import 'package:flutter/material.dart';

import '../Colors.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key key,
    @required this.icon,
    @required this.hint,
    @required this.controller,
    @required this.validator,
    @required this.onSaved,
    @required this.minLines,
    @required this.maxLines,

    this.inputType,
    this.inputAction,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextEditingController controller;
  final Function onSaved;
  final Function validator;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: TextFormField(
            minLines: minLines,
            maxLines: maxLines,
            autocorrect: true,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 16.0),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                child: Icon(
                  icon,
                  size: 30,
                  color: textColor,
                ),
              ),
              hintText: hint,
              hintStyle: TextStyle(
                fontStyle: FontStyle.italic,
                color: textColor,
                fontSize: 15,
              ),
            ),
            keyboardType: inputType,
            textInputAction: inputAction,
            controller: controller,
            validator: validator,
            onSaved: onSaved,
          ),
        ),
      ),
    );
  }
}
