import 'package:flutter/material.dart';
import 'package:liveq/utils/client.dart';

import 'package:liveq/utils/utils.dart';

Future<void> joinRoomDialog(
    BuildContext context, TextEditingController myController) async {
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
                labelText: 'Room Code', hintText: "eg. abcd1234"),
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
                String roomId = myController.text;
                String roomName = await client.JoinRoom(roomId);
                print('joining room $roomName');

                Navigator.pop(context);
                if (roomName.startsWith('Error')) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Unable to join Room. Incorrect Key'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      );
                    });
                } else {
                  Navigator.pushNamed(
                    context,
                    '/room',
                    arguments: RoomArguments(
                      roomName: roomName,
                      roomID: roomId,
                      host: false
                    ),
                  );
                }
              })
        ],
      );
    },
  );
}

Future<void> createRoomDialog(
    BuildContext context, TextEditingController myController) async {
  return showDialog<void>(
    context: context,
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
                print('creating $roomName');
                String roomId = await client.CreateRoom(roomName);

                print('create room with id $roomId');

                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/room',
                  arguments: RoomArguments(
                    roomName: roomName,
                    roomID: roomId,
                    host: true
                  ),
                );
              })
        ],
      );
    },
  );
}
