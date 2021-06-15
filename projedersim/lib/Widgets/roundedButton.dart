import 'package:flutter/material.dart';
import 'package:projedersim/Colors.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.buttonName,
    @required this.onPressed,

  }) : super(key: key);

  final String buttonName;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: FlatButton(
        onPressed: onPressed,
        child: Text(buttonName),
      ),
    );
  }
}