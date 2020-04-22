import 'package:flutter/material.dart';

import 'package:liveq/utils/utils.dart';

Future<void> joinRoomDialog(
    BuildContext context, TextEditingController myController) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        // title: Text('Enter Room Code'),
        content: SingleChildScrollView(
          child: TextFormField(
            autofocus: true,
            controller: myController,
            decoration: InputDecoration(
              labelText: 'Room Code',
              hintText: "eg. abcd1234",
              icon: Icon(Icons.vpn_key),
              // errorText: (myController.text.length != 8 &&
              //         myController.text.isNotEmpty)
              //     ? 'Room code should have exactly 8 characters'
              //     : null,
            ),
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

                if (roomName.startsWith('Error')) {
                  showDialog(
                      context: context,
                      // barrierDismissible: false,
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
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/room',
                    arguments: RoomArguments(
                        roomName: roomName, roomID: roomId, host: false),
                  );
                }
                // client.key = 'test_roomId';
                // Navigator.pop(context);
                // Navigator.pushNamed(
                //   context,
                //   '/room',
                //   arguments: RoomArguments(
                //     roomName: 'test_roomName',
                //     roomID: myController.text,
                //     host: false,
                //   ),
                // );
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
          child: TextFormField(
            autofocus: true,
            controller: myController,
            decoration: InputDecoration(
              labelText: 'Room Name',
              hintText: "eg. John's Room",
              icon: Icon(Icons.person),
            ),
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
                      roomName: roomName, roomID: roomId, host: true),
                );
                // client.key = 'test_roomId';
                // Navigator.pop(context);
                // Navigator.pushNamed(
                //   context,
                //   '/room',
                //   arguments: RoomArguments(
                //     roomName: myController.text,
                //     roomID: 'test_roomId',
                //     host: true,
                //   ),
                // );
              })
        ],
      );
    },
  );
}
