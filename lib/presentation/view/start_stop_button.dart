import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Function() onPressed;

  const BigButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        ),
        onPressed: onPressed,
        child: Column(
          children: [
            icon,
            SizedBox(height: 5),
            Text(label, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
