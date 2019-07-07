import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PaginaGIf extends StatelessWidget {
  final Map _dadoGif;
  PaginaGIf(this._dadoGif);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dadoGif["title"],
        style: TextStyle(color: Colors.white, fontSize: 22.0),),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.share),
          onPressed: () {
              Share.share(_dadoGif["images"]["fixed_height"]["url"]);
          },
          )
        ],
    ),
    backgroundColor: Colors.black,
    body: Center(
      child: Image.network(_dadoGif["images"]["fixed_height"]["url"]),
    
    ),
    );
  }
}