import 'package:flutter/material.dart';

// TODO: Adaptive size for different screen sizes
class NextButton extends StatelessWidget {
  final String _content;
  final VoidCallback _onTap;

  // NextButton(this._content);
  NextButton(this._content, this._onTap);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: RaisedButton(
        // onPressed: () {},
        onPressed: _onTap,
        textColor: Colors.white,
        color: Color(0xffed6c6c),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            '$_content',
            style: Theme.of(context).textTheme.button.merge(
                  TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
