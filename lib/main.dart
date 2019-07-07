import 'package:flutter/material.dart';
import 'package:buscador_gifs_flutter/ui/tela_principal.dart';
import 'package:buscador_gifs_flutter/ui/pagina_gif.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: TelaPrincipal(),
  theme: ThemeData(hintColor: Colors.green, primaryColor: Colors.white),
));
