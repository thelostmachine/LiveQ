import 'package:flutter/material.dart';
import 'package:liveq/utils/player.dart';
import 'package:liveq/utils/song.dart';

import 'package:liveq/utils/services.dart';

class Search extends StatefulWidget {

  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {

  List<Song> items = List();
  TextEditingController editingController = TextEditingController();
  bool _isConnected;

  @override
  void initState() {
    super.initState();
    _isConnected = Player().isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Container(
          child: (_isConnected)
            ? searchWidget(context)
            : Center(child: Text('Please Connect to a Streaming Service first')), // This might not be necessary because guests shouldn't have to connect.
        ),
      )
    );
  }

  Widget searchWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (query) {
              search(query);
            },
            controller: editingController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
              ),
              hintText: 'Search for Songs',
              prefixIcon: Icon(Icons.search),
            ),
          )
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              Song track = items[index];

              return ListTile(
                title: Text(track.trackName),
                subtitle: Text(track.artist),
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                    maxWidth: 64,
                    maxHeight: 64,
                  ),
                  child: Image.network(track.imageUri)
                ),
                trailing: Text(track.service.name),
                onTap: () {
                  // Cache the image if it's being added to the queue so we don't have to make another network call
                  track.cacheImage();
                  Navigator.of(context).pop(track);
                },
              );
            },
          )
        )
      ],
    );
  }

  /// Searches a [query] using the [Service] specified
  void search(String query) async {
    List<Song> dummySongs = List();
    dummySongs.addAll(await Spotify().search(query));
    
    if (query.isNotEmpty) {
      List<Song> searchResults = List();

      dummySongs.forEach((s) {
          searchResults.add(s);
        }
      );

      setState(() {
        items.clear();
        items.addAll(searchResults);
      });
    } else {
      setState(() {
        items.clear();
      });
    }
  }
}