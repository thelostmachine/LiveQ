import 'package:flutter/material.dart';
import 'package:liveq/utils/song.dart';

import 'package:liveq/utils/services.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {

  List<Song> items = List();
  TextEditingController editingController = TextEditingController();

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
          child: Column(
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
                    return ListTile(
                      title: Text(items[index].trackName),
                      subtitle: Text(items[index].artist),
                      trailing: Text(items[index].service.name),
                      onTap: () => Navigator.of(context).pop(items[index]),
                    );
                  },
                )
              )
            ],
          )
        ),
      )
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