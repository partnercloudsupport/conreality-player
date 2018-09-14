/* This is free and unencumbered software released into the public domain. */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

import 'chat.dart';
import 'compass.dart';
import 'game.dart';
import 'map.dart';

////////////////////////////////////////////////////////////////////////////////

class StartScreen extends StatefulWidget {
  StartScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  StartState createState() => StartState();
}

////////////////////////////////////////////////////////////////////////////////

class StartState extends State<StartScreen> {
  static const platform = MethodChannel('app.conreality.org/start');

  int _counter = 0;

  void _incrementCounter() {
    setState(() { _counter++; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: StartDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class StartDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> allDrawerItems = <Widget>[
      Divider(),

      ListTile(
        leading: Icon(Icons.chat),
        title: Text('Chat'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return ChatScreen(title: 'Demo Chat'); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.navigation),
        title: Text('Compass'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return CompassScreen(title: 'Demo Compass'); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.gamepad),
        title: Text('Game'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return GameScreen(title: 'Demo Game'); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.map),
        title: Text('Map'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return MapScreen(title: 'Demo Map'); // TODO
              }
            )
          );
        },
      ),

      ListTile(
        leading: Icon(Icons.report),
        title: Text('Send feedback'),
        onTap: () {
          launch('https://github.com/conreality/conreality-player/issues/new');
        },
      ),

      AboutListTile(
        icon: FlutterLogo(), // TODO
        applicationVersion: 'September 2018',
        applicationIcon: FlutterLogo(), // TODO
        applicationLegalese: 'This is free and unencumbered software released into the public domain.',
        aboutBoxChildren: <Widget>[],
      ),
    ];
    return Drawer(child: ListView(primary: false, children: allDrawerItems));
  }
}
