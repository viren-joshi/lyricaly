import 'package:flutter/material.dart';
import 'package:lyricaly/constants.dart';
import 'package:lyricaly/screens/track_screen.dart';
import 'package:lyricaly/services/lyric_bloc.dart';
import 'package:lyricaly/utilities/lyric_info.dart';

class SavedTracksScreen extends StatelessWidget {
  final LyricBloc lyricBloc = LyricBloc();
  SavedTracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void a;
    lyricBloc.wishDisplayEventSink.add(a);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purple[900],
        appBar: AppBar(
          backgroundColor: Colors.purple[900],
          centerTitle: true,
          title: const Text(
            'Lyricaly',
            style: TextStyle(fontFamily: 'Kalam', fontSize: 35.0),
          ),
        ),
        body: StreamBuilder(
          stream: lyricBloc.wishDisplayStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              LyricModel lyricModel = snapshot.data!;
              if (lyricModel.trackList.isEmpty) {
                return Center(
                  child: Text(
                    'NO SAVED SONGS',
                    style: TextStyle(color: Colors.blue[200], fontSize: 18.0),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: lyricModel.trackList.length,
                  itemBuilder: (context, index) {
                    Track track = lyricModel.trackList[index];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        tileColor: Colors.black87,
                        leading: Icon(
                          Icons.lyrics,
                          color: Colors.purple[100],
                        ),
                        title: Text(
                          track.trackName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.indigo[200], fontSize: 17.0),
                        ),
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TrackScreen(track: track),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(
                child: kCircularProgressIndicator,
              );
            }
          },
        ),
      ),
    );
  }
}
