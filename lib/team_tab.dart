/* This is free and unencumbered software released into the public domain. */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'api.dart' as API;
import 'cache.dart';
import 'player_screen.dart';

////////////////////////////////////////////////////////////////////////////////

class TeamTab extends StatefulWidget {
  TeamTab({Key key, this.client}) : super(key: key);

  final API.Client client;

  @override
  State<TeamTab> createState() => TeamState();
}

////////////////////////////////////////////////////////////////////////////////

class TeamState extends State<TeamTab> {
  Future<List<Player>> _data;

  @override
  void initState() {
    super.initState();
    _data = Future.sync(() => _load());
  }

  Future<List<Player>> _load() async {
    final Cache cache = await Cache.instance;
    return cache.listPlayers();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder<List<Player>>(
      future: _data,
      builder: (final BuildContext context, final AsyncSnapshot<List<Player>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.grey,
                size: 300.0,
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) return Text(snapshot.error.toString()); // GrpcError
            return TeamList(snapshot.data);
        }
        assert(false, "unreachable");
        return null; // unreachable
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class TeamList extends StatelessWidget {
  final List<Player> players;

  TeamList(this.players);

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.body1.copyWith(color: theme.textTheme.caption.color, fontSize: 12.0);
    return ListView.separated(
      padding: EdgeInsets.all(8.0),
      itemCount: players.length,
      itemBuilder: (final BuildContext context, final int index) {
        final player = players[index];
        return ListTile(
          leading: CircleAvatar(child: Text(player.nick.substring(0, 1))),
          title: Row(
            children: <Widget>[
              Text(player.nick),
              Container(
                child: Text(player.rank != null && player.rank.isNotEmpty ? player.rank : "No rank", style: style),
                padding: EdgeInsets.only(left: 16.0),
                alignment: Alignment.topLeft,
              ),
            ],
          ),
          subtitle: Row(
            children: <Widget>[
              Container(
                child: Icon(player?.headset == true ? MdiIcons.headset : MdiIcons.headsetOff, color: Colors.white70, size: 16.0),
                padding: EdgeInsets.all(0.0),
                alignment: Alignment.topLeft,
              ),
              Container(
                child: Icon(MdiIcons.heartPulse, color: player?.heartrate != null ? Colors.red : Colors.white70, size: 16.0),
                padding: EdgeInsets.only(left: 8.0),
                alignment: Alignment.topLeft,
              ),
              Container(
                child: Text((player?.heartrate ?? "N/A").toString()),
                padding: EdgeInsets.only(left: 4.0),
                alignment: Alignment.topLeft,
              ),
              Container(
                child: Icon(MdiIcons.walk, color: Colors.white70, size: 16.0),
                padding: EdgeInsets.only(left: 8.0),
                alignment: Alignment.topLeft,
              ),
              Container(
                child: Text(player?.distance != null ? "${player.distance.toInt()}m" : "N/A"),
                padding: EdgeInsets.only(left: 4.0),
                alignment: Alignment.topLeft,
              ),
            ],
          ),
          trailing: GestureDetector(
            child: Icon(Icons.info, color: Theme.of(context).disabledColor),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) {
                    return PlayerScreen(player: player);
                  }
                )
              );
            }
          ),
        );
      },
      separatorBuilder: (final BuildContext context, final int index) {
        return Divider();
      },
    );
  }
}
