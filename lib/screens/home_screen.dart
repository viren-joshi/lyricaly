import 'package:flutter/material.dart';
import 'package:lyricaly/constants.dart';
import 'package:lyricaly/screens/saved_track_screen.dart';
import 'package:lyricaly/screens/track_screen.dart';
import 'package:lyricaly/services/connectivity_handler.dart';
import 'package:lyricaly/services/lyric_bloc.dart';
import 'package:lyricaly/utilities/lyric_info.dart';
import 'package:lyricaly/widgets/lyric_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LyricBloc lyricBloc = LyricBloc();
  final ConnectivityHandler _connectivity = ConnectivityHandler();

  @override
  void initState() {
    _connectivity.initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purple[900],
        appBar: AppBar(
          title: const Text(
            'Lyricaly',
            style: TextStyle(fontFamily: 'Kalam', fontSize: 35.0),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedTracksScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.bookmark),
              color: Colors.white,
              iconSize: 35.0,
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.purple[900],
          elevation: 0.0,
        ),
        body: StreamBuilder<bool>(
            stream: _connectivity.myStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: kCircularProgressIndicator,
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error',
                    style: kErrorTextStyle,
                  ),
                );
              } else {
                if (snapshot.data!) {
                  lyricBloc.eventSink.add(LyricRequests.requestInfo);
                  return StreamBuilder<LyricModel>(
                    // initialData: LyricModel(trackList: []),
                    stream: lyricBloc.lyricStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: kCircularProgressIndicator,
                        );
                      } else {
                        List<Track> trackList = snapshot.data!.trackList;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          itemCount: trackList.length,
                          itemBuilder: (context, int index) {
                            return LyricTile(
                              trackName: trackList[index].trackName,
                              albumName: trackList[index].albumName,
                              artistName: trackList[index].artistName,
                              onTap: () {
                                // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TrackScreen(track: trackList[index]),
                                  ),
                                );
                                // _connectivity.disposeStream();
                              },
                            );
                          },
                        );
                      }
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'NO INTERNET CONNECTION',
                      style: kErrorTextStyle,
                    ),
                  );
                }
              }
            }),
      ),
    );
  }

  @override
  void dispose() {
    lyricBloc.dispose();
    super.dispose();
  }
}
