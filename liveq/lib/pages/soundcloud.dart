import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SoundCloud extends StatefulWidget {
  final String trackUrl;
  // get baseUrl {
  //   String url = trackUrl.replaceFirst(':', '%3A');
  //   print(url);
  //   return 'https://w.soundcloud.com/player/?url=$url&color=%23ff5500&auto_play=true&hide_related=true&show_comments=false&show_user=true&show_reposts=false&show_teaser=false&visual=false';
  // }
  SoundCloud(this.trackUrl);

  @override
  SoundCloudState createState() => SoundCloudState();
}

class SoundCloudState extends State<SoundCloud> {
  // String _fileText;
  String filePath = 'assets/test.html';
  WebViewController _webViewController;
  bool playing = false;

  // final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SoundCloud')),
      body: WebView(
        userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:74.0) Gecko/20100101 Firefox/74.0",
        initialUrl: '',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _loadHtmlFromAssets();
        },
        onPageFinished: (url) {
          _loadSong();
          // _webViewController.evaluateJavascript('test()');
          // _setVolume();
          // _play();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (playing) ? _pause() : _play(),
      ),
    );
  }

  _loadSong() async {
    _webViewController.evaluateJavascript('loadSong(\"${widget.trackUrl}\")');
  }

  _setVolume() async {
    _webViewController.evaluateJavascript('setVolume()');
  }

  _pause() async {
    setState(() {
      playing = false;
    });
    _webViewController.evaluateJavascript('pause()');
  }
  
  _play() async {
    setState(() {
      playing = true;
    });
    _webViewController.evaluateJavascript('play()');
  }

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    await _webViewController.loadUrl(Uri.dataFromString(
      fileHtmlContents,
      mimeType: 'text/html', encoding: Encoding.getByName('utf-8')
      ).toString());
  }

  // @override
  // Widget build(BuildContext context) {
  //   rootBundle.loadString('assets/soundcloud.html').then((value) {
  //     setState(() {
  //       _fileText = value;
  //     });
  //   });

  //   return WebviewScaffold(
  //     appBar: AppBar(
  //       title: Text('SoundCloud'),
  //     ),
  //     url: Uri.dataFromString(
  //       _fileText,
  //       mimeType: 'text/html',
  //       encoding: Encoding.getByName('utf-8')
  //     ).toString(),
  //     withJavascript: true,
  //     javascriptChannels: Set.from([
  //       JavascriptChannel(
  //         name: 'Print',
  //         onMessageReceived: (JavascriptMessage message) {
  //           print(message.message);
  //         }
  //       )
  //     ]),
  //     bottomNavigationBar: BottomAppBar(
  //       // child: Row(
  //       //   children: <Widget>[
  //       child:    RaisedButton(
  //             child: Text('New'),
  //             onPressed: () => flutterWebviewPlugin.evalJavascript('setSong(${widget.trackUrl})')
  //           ),
  //       //     RaisedButton(
  //       //       child:Text('Done'),
  //       //       onPressed: () => flutterWebviewPlugin.close(),
  //       //       // onPressed: () => Navigator.pop(context),
  //       //     )
  //       //   ],
  //       // )
  //     ),
  //   );
  // }
}