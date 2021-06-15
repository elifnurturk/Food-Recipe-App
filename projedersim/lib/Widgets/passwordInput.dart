import 'package:flutter/material.dart';
import 'package:projedersim/Colors.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key key,
    @required this.icon,
    @required this.hint,
    @required this.controller,
    @required this.validator,
    @required this.onSaved,
    this.inputType,
    this.inputAction,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextEditingController controller;
 // final FormFieldValidator<String> validator;
  final Function onSaved;
  final Function validator;


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
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Icon(
                  icon,
                  size: 28,
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
            obscureText: true,
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