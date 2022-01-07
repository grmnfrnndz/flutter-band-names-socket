import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names_app/src/services/services.dart';
import 'src/pages/pages.dart';

void main() => runApp(State());

class State extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => SocketService(), lazy: false,)
      ],
      child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'status': (BuildContext context) => StatusPage(),
      },
    );
  }
}