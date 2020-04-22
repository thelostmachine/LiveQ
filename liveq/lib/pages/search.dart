import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:liveq/utils/song.dart';
import 'package:liveq/utils/services.dart';
import 'package:liveq/utils/utils.dart';
import 'package:liveq/widgets/songtile.dart';
import 'package:liveq/models/catalog.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => new _SearchState();
}

class _SearchState extends State<Search> {
  List<Song> items = List();
  TextEditingController _editingController = TextEditingController();
  SearchArguments args;
  Service _searchService;
  Set<Service> _allowedServices = {};

  @override
  void initState() {
    super.initState();
    // TODO: Quick hack to set args - reference: https://stackoverflow.com/questions/56262655/flutter-get-passed-arguments-from-navigator-in-widgets-states-initstate
    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context).settings.arguments;
      });
      if (args != null && args.searchService != null) {
        _searchService = Provider.of<CatalogModel>(context, listen: false)
            .fromString(args.searchService);
      }
      if (args != null && args.allowedServices != null) {
        _allowedServices.addAll(args.allowedServices
            .map((s) =>
                Provider.of<CatalogModel>(context, listen: false).fromString(s))
            .toList());
      }
    });
    // _player.setService(SoundCloud());
    // _player.searchService = SoundCloud();
    // _isConnected = true;
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
            child: _searchService != null
                ? searchWidget(context)
                // : Center(
                //     child: Text('Please connect to a streaming service first',
                //         style: Theme.of(context).textTheme.bodyText1),
                //   ), // This might not be necessary because guests shouldn't have to connect.
                : Container(),
          ),
          floatingActionButton: _getFAB(),
        ),
      ),
    );
  }

  Widget _getFAB() {
    return _searchService != null
        ? FloatingActionButton.extended(
            onPressed: _allowedServices.length <= 1
                ? null
                : () => _selectSearchService(),
            label: Text(_searchService.name),
            icon: _searchService.getImageIcon(),
            backgroundColor: Theme.of(context).disabledColor,
            // label: const Text('Spotify'),
            // icon: ImageIcon(
            //   AssetImage('assets/images/Spotify_Icon_RGB_Green.png'),
            // ),
          )
        : FloatingActionButton.extended(
            onPressed: null,
            label: Text('No Service'),
            icon: Icon(Icons.error_outline),
            backgroundColor: Theme.of(context).disabledColor,
          );
  }

  Future<void> _selectSearchService() async {
    // switch (
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Search Service'),
          children: <Widget>[
            _searchService != null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _searchService.getImageIcon(),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_searchService.name,
                                style: Theme.of(context).textTheme.subtitle1),
                            Text('Selected',
                                style: Theme.of(context).textTheme.caption),
                          ],
                        )
                      ],
                    ),
                  )
                : Container(),
            Divider(),

            // TODO: Temporary fix by manually setting width and setting shrinkWrap
            Container(
              width: 200,
              child: ListView.builder(
                // physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _allowedServices.length,
                itemBuilder: (BuildContext context, int index) {
                  return (_allowedServices.toList()[index].name !=
                              _searchService.name &&
                          _allowedServices.toList()[index].isConnected == true)
                      ? SimpleDialogOption(
                          onPressed: () {
                            setState(() {
                              _searchService = _allowedServices.toList()[index];
                              items.clear();
                              _editingController.clear();
                            });
                            Navigator.pop(
                                context, _allowedServices.toList()[index].name);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _allowedServices.toList()[index].getImageIcon(),
                                SizedBox(width: 16.0),
                                Text(_allowedServices.toList()[index].name,
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                          ),
                        )
                      : Container();
                },
              ),
            ),
          ],
        );
      },
    );
    //     ) {
    //   case Service.SPOTIFY:
    //     // ...
    //     break;
    //   case Service.SOUNDCLOUD:
    //     // ...
    //     break;
    // }
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
    List<Song> _searchResults = List();
    _searchResults.addAll(await _searchService.search(query));

    if (query.isNotEmpty) {
      setState(() {
        items.clear();
        items.addAll(_searchResults);
      });
    } else {
      setState(() {
        items.clear();
      });
    }
  }
}
