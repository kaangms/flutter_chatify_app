import 'package:flutter/material.dart';

class SocialLogInButton extends StatelessWidget {
  SocialLogInButton({
    Key? key,
    required this.buttonText,
    this.buttonColor: Colors.purple,
    this.textColor: Colors.white,
    this.radius: 16,
    this.height: 50,
    required this.butonIcon,
    required this.onPressed,
  }) : super(key: key);
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double height;
  final Widget butonIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
              ),
              primary: buttonColor),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              butonIcon,
              Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
              Opacity(opacity: 0, child: butonIcon)
            ],
          ),
        ),
      ),
    );
  }
}
