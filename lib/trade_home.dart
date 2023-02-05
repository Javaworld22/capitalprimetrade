import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradeHome extends StatefulWidget{

  final String url;
  final String title;

  TradeHome(this.url, this.title);

  @override
  TradeHomeState createState() =>
      TradeHomeState(this.url, this.title);
}

class TradeHomeState extends State<TradeHome>{

  final String url;
  final String title;
  late WebViewController _controller;
  late bool canGo;
  var _progress = 0.0;

  TradeHomeState(this.url, this.title);


  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
         onWillPop: ()async{
           if(await _controller.canGoBack()){
             _controller.goBack();
           }else{
             return true;
           }
          return false;
         },
      child: Scaffold(
         appBar: AppBar(
           toolbarHeight: 40,
           backgroundColor: const Color.fromRGBO(2, 37, 79, 1),
           actions: [
             IconButton(
                 onPressed: ()async{
                   if(canGo = await _controller.canGoBack()){
                     _controller.goBack();
                   }
                 },
                 icon: const Icon(Icons.arrow_back),
             ),
             IconButton(
               onPressed: ()async{
                   _controller.reload();
               },
               icon: const Icon(Icons.refresh),
             ),
           ],
           //title: const Image(image: AssetImage('assets/images/cropped_CXE.png')),//Text(this.title),
         ),
        body: Column(children: [
          // Container(
          //   height: MediaQuery.of(context).viewPadding.top,
          // ),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.black,

          ),
          Expanded(
              child: WebView(
                  initialUrl: this.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller){
                    _controller = controller;
          },
                onProgress: (progress){
                    setState(() {
                      _progress = progress/100;
                    });
                },
              )
          )
        ])
    ),
    );
  }

}