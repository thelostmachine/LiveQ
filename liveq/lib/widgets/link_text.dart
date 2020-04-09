import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class LinkText extends StatefulWidget {

  final VoidCallback _handleTap;
  LinkText(this._handleTap)

  @override
  _LinkTextState createState() => _LinkTextState();
}

class LinkTextState extends State<LinkText> {
  TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = widget._handleTap;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'LINK',
        style: TextStyle(
          color: Colors.blueAccent,
        ),
        recognizer: _tapGestureRecognizer,
      ),
    );
  }
}