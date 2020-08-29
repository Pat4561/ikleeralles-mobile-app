import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ikleeralles/constants.dart';

class WebViewPage extends StatefulWidget {

  final String url;
  final String title;
  final Function(BuildContext, Map) onEventReceived;

  WebViewPage ({ this.url, this.title, this.onEventReceived });

  @override
  State<StatefulWidget> createState() {
    return WebViewPageState();
  }

}

class WebViewPageState extends State<WebViewPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 10), () {
      widget.onEventReceived(context, {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(url: widget.url,
      appBar: AppBar(
          title: Text(widget.title, style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: Fonts.ubuntu,
            fontSize: 18,
          )),
          centerTitle: true,
          backgroundColor: BrandColors.themeColor,
      ),
      javascriptChannels: <JavascriptChannel>[
        JavascriptChannel(
          name: 'MessageInvoker',
          onMessageReceived: (message) {
            Map jsonMap = json.decode(message.message);
            if (widget.onEventReceived != null)
              widget.onEventReceived(context, jsonMap);
          }
        )
      ].toSet(),
    );
  }

}