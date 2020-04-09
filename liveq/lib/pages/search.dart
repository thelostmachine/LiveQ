import 'package:flutter/material.dart';
import 'package:liveq/utils/player.dart';
import 'package:liveq/utils/song.dart';
import 'package:liveq/widgets/songtile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {
  List<Song> items = List();
  TextEditingController _editingController = TextEditingController();
  bool _isConnected;
  Player _player = Player();

  @override
  void initState() {
    super.initState();
    // _player.setService(SoundCloud());
    _isConnected = _player.isConnected();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xFF274D85),
                size: 25,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: TextField(
              onChanged: (query) {
                search(query);
              },
              autofocus: true,
              controller: _editingController,
              cursorColor: Color(0xFF274D85),
              decoration: InputDecoration(
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD9EAF1).withOpacity(0.7),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD9EAF1).withOpacity(0.7),
                  ),
                ),
                hintText: 'Search for Songs',
              ),
            ),
          ),
          body: Container(
            child: (_isConnected)
                ? searchWidget(context)
                : Center(
                    child: Text('Please connect to a streaming service first',
                        style: Theme.of(context).textTheme.bodyText1),
                  ), // This might not be necessary because guests shouldn't have to connect.
          ),
          floatingActionButton: _getFAB(),
          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: null,
          //   label: Text('Spotify'),
          //   icon: ImageIcon(
          //     AssetImage('assets/images/Spotify_Icon_RGB_Green.png'),
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget _getFAB() {
    if (_player.searchService != null) {
      return FloatingActionButton.extended(
        onPressed: null,
        // label: Text('Spotify'),
        // icon: ImageIcon(
        //   AssetImage('assets/images/Spotify_Icon_RGB_Green.png'),
        // ),
        label: Text(_player.searchService.name),
        icon: ImageIcon(AssetImage(_player.searchService.iconImagePath)),
        backgroundColor: Theme.of(context).primaryColor,
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: null,
        label: Text('No Service'),
        icon: Icon(Icons.error_outline),
        backgroundColor: Theme.of(context).primaryColor,
      );
    }
  }

  Widget searchWidget(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return SongTile(
            song: items[index],
            onTap: () => Navigator.of(context).pop(items[index]));
      },
    );
  }

  /// Searches a [query] using the [Service] specified
  void search(String query) async {
    List<Song> dummySongs = List();
    dummySongs.addAll(await _player.search(query));

    if (query.isNotEmpty) {
      List<Song> searchResults = List();

      dummySongs.forEach((s) {
        searchResults.add(s);
      });

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
