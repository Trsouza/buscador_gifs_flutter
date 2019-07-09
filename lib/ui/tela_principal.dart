import 'dart:convert';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:buscador_gifs_flutter/ui/pagina_gif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // é necessario http: ^0.12.0+2

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  String _buscar;
  int _offset;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_buscar == null || _buscar.isEmpty)
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=puFzOmwguocXx3YzOFMYKL49pfe3mjgl&limit=25&rating=G");
    else
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=puFzOmwguocXx3YzOFMYKL49pfe3mjgl&q=$_buscar&limit=19&offset=$_offset&rating=G&lang=pt");
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
    // print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: "Pesquise Aqui!",
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (texto){
                setState(() {
                 _buscar = texto; 
                 _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _crearTabelaGif(context, snapshot);
                  }
                }),
          ),
        ],
      ),
    );
  }

int _getContagem(List dados){
  if(_buscar == null){
    return dados.length;
    }
  else{
   return dados.length+1;
   }

}

  Widget _crearTabelaGif(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      // gridDelegate - especifica como os elementos serão exibidos na tela
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0, // espaçamento na vertical
      ),
      itemCount: _getContagem(snapshot.data["data"]),
      //itemBuilder , função que constroi os itens na tela
      itemBuilder: (context, index) {
        if(_buscar == null || index < snapshot.data["data"].length){
        return GestureDetector(
          // child: FadeInImage.memoryNetwork( // fara as imagens serem exibidas mais lentamente/suavemente
          //   placeholder: kTransparentImage,
          //    image: snapshot.data["data"][index]["images"]["fixed_height"]
          //       ["url"], // essas palavras em cochete são do json da APi
          //   height: 300.0,
          //   fit: BoxFit.cover,
          // ),
          child: Image.network(
            snapshot.data["data"][index]["images"]["fixed_height"]
                ["url"], // essas palavras em cochete são do json da APi
            height: 300.0,
            fit: BoxFit.cover,
            ),
          onTap: (){  // chamará a nova tela
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => PaginaGIf(snapshot.data["data"][index]))
            );
          },
          onLongPress: (){
            Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
          },
        );
        } else{
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0,),
                  Text("Carregar mais", 
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                    ),
                ],
              ),
              onTap: () {
                setState(() {
                 _offset+=19;
                });
              },
              ),
            );
        }
      },
    );
  }
}
