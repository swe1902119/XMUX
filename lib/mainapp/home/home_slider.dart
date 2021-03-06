import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart'
    if (dart.library.html) 'package:xmux/components/svg_web.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xmux/components/simple_slider.dart';
import 'package:xmux/globals.dart';
import 'package:xmux/modules/xmux_api/xmux_api_v2.dart';
import 'package:xmux/redux/redux.dart';

class HomeSlider extends StatefulWidget {
  @override
  State createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  Widget _buildSlider(News n) => Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(imageUrl: n.imageURL, fit: BoxFit.fill),
          FlatButton(
              onPressed: n.uri.isEmpty
                  ? null
                  : () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (_) => WebViewPage(n.uri))),
              child: null),
        ],
      );

  @override
  void initState() {
    store.dispatch(UpdateHomepageNewsAction());
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      StoreConnector<MainAppState, List<Widget>>(
        converter: (store) =>
            store.state.uiState.homepageNews
                ?.map((n) => _buildSlider(n))
                ?.toList()
                ?.reversed
                ?.toList() ??
            [SvgPicture.asset('res/home/news.svg')],
        builder: (_, pages) => SimpleSlider(
          pages: pages,
          autoPlayDuration: Duration(seconds: 4),
        ),
      );
}

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage(this.url);

  @override
  State<StatefulWidget> createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call_made),
            onPressed: () => launch(widget.url, forceWebView: false),
          )
        ],
      ),
      body: WebView(
        initialUrl: widget.url,
        onWebViewCreated: (c) => controller = c,
      ),
    );
  }
}
