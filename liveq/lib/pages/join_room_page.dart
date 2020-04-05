import 'package:flutter/material.dart';

// import 'package:liveq/widgets/lq_next_button.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({Key key}) : super(key: key);

  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LiveQ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Enter Room Code",
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Code cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.text,
              // style: new TextStyle(
              //   fontFamily: "Poppins",
              // ),
            ),
            SizedBox(height: 150),
            // NextButton('NEXT'),
            // NextButton('NEXT', Navigator.pushNamed(context, RoomPageRoute, arguments: 'guest');),
          ],
        ),
      ),
    );
  }
}
