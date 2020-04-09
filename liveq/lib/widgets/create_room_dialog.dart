import 'package:flutter/material.dart';
import 'package:liveq/utils/utils.dart';

Future<void> createRoomDialog(
    BuildContext context, TextEditingController myController) async {
  return showDialog<void>(
    context: context,
    // barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: Text('Enter Room Name'),
        content: SingleChildScrollView(
          child: TextField(
            autofocus: true,
            controller: myController,
            decoration: InputDecoration(
                labelText: 'Room Name', hintText: "eg. John's Room"),
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
              onPressed: () async {
                String roomName = myController.text;
                String roomId = await client.CreateRoom(roomName);

                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/room',
                  arguments: RoomArguments(
                    roomName: roomName,
                    roomID: roomId,
                    host: true
                  ));
              })
        ],
      );
    },
  );
}
