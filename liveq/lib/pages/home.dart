import 'package:flutter/material.dart';
import 'package:liveq/widgets/lq_next_button.dart';
import 'package:liveq/utils/utils.dart';

class Home extends StatelessWidget {
  final myController = TextEditingController();

  Home({Key key}) : super(key: key);

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Enter Room Code'),
          content: SingleChildScrollView(
            child: TextField(
              autofocus: true,
              controller: myController,
              decoration: InputDecoration(
                  labelText: 'Room Code', hintText: "eg. 12345678"),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            FlatButton(
                child: const Text('SUBMIT'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/room');
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'LiveQ',
              style: Theme.of(context).textTheme.headline4.merge(
                    TextStyle(fontWeight: FontWeight.bold),
                  ),
            ),
            SizedBox(height: 150),
            NextButton('JOIN A ROOM', () => _showDialog(context)),
            // NextButton('JOIN A ROOM', () => Navigator.pushNamed(context, ''),
            NextButton('CREATE NEW ROOM', () => {}),
            // NextButton('CREATE NEW ROOM',
            //     Navigator.pushNamed(context, ServicesPageRoute)),
          ],
        ),
      ),
    );
  }
}
