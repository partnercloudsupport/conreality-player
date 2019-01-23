/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart' as gRPC;

import 'game.dart';
import 'game_loading_screen.dart';
import 'game_error_screen.dart';
import 'game_screen.dart';
import 'keys.dart' show refreshChatKey;

import 'src/api.dart' as API;
import 'src/cache.dart' show Cache;
import 'src/client.dart' show Client;
import 'src/connection.dart' show Connection;

////////////////////////////////////////////////////////////////////////////////

class GameLoader extends StatefulWidget {
  GameLoader({Key key, this.game}) : super(key: key);

  final Game game;

  @override
  State<GameLoader> createState() => GameLoaderState();
}

////////////////////////////////////////////////////////////////////////////////

class GameLoaderState extends State<GameLoader> {
  Future<API.GameInformation> _response;

  @override
  void initState() {
    super.initState();
    _response = Future.sync(() => _loadGame());
  }

  @override
  Widget build(final BuildContext context) {
    final game = widget.game;
    return FutureBuilder<API.GameInformation>(
      future: _response,
      builder: (final BuildContext context, final AsyncSnapshot<API.GameInformation> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return GameLoadingScreen(game: game);
          case ConnectionState.done:
            return (snapshot.hasError) ?
              GameErrorScreen(game: game, error: snapshot.error) :
              GameScreen(game: game, info: snapshot.data);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<API.GameInformation> _loadGame() async {
  final Cache cache = await Cache.instance;
  await cache.clear();

  final Connection conn = await Connection.instance;
  final Client client = Client(conn);
  await client.ping();

  final API.GameInformation info = await client.rpc.getGameInfo(API.Nothing());

  final API.PlayerList players = await client.rpc.listPlayers(API.UnitID()..value = Int64(0));
  for (final API.Player player in players.values) {
    cache.putPlayer(player);
  }

  final gRPC.ResponseStream<API.Message> messages = client.rpc.receiveMessages(API.Nothing());
  messages.forEach((final API.Message message) {
    cache.putMessage(message);
    refreshChatKey.currentState?.reload();
  });

  //await cache.setPlayerID(2);
  //print(await cache.getPlayer(2));

  return info;
}
