import 'package:flutter/material.dart';
import 'package:lyricaly/constants.dart';
import 'package:lyricaly/services/connectivity_handler.dart';
import 'package:lyricaly/services/lyric_bloc.dart';
import 'package:lyricaly/utilities/lyric_info.dart';

class TrackScreen extends StatefulWidget {
  final Track track;
  const TrackScreen({super.key, required this.track});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
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
          centerTitle: true,
          title: const Text(
            'Lyricaly',
            style: TextStyle(fontFamily: 'Kalam', fontSize: 35.0),
          ),
          actions: [
            StreamBuilder<bool>(
                stream: lyricBloc.wishSaveStream,
                builder: (context, snapshot) {
                  return IconButton(
                    onPressed: () {
                      lyricBloc.wishSaveEventSink.add(widget.track);
                      if (snapshot.data != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(snapshot.data!
                                ? 'Track Saved Successfully'
                                : 'Track Save Unsuccessful'),
                          ),
                        );
                      }
                    },
                    icon: Icon(snapshot.hasError ||
                            (snapshot.hasData && snapshot.data!)
                        ? Icons.bookmark_added
                        : Icons.bookmark_add_outlined),
                    color: Colors.white,
                    iconSize: 35.0,
                  );
                }),
          ],
          // centerTitle: true,
          backgroundColor: Colors.purple[900],
          elevation: 0.0,
        ),
        body: StreamBuilder<bool>(
            stream: _connectivity.myStream,
            builder: (context, AsyncSnapshot snapshot) {
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
                if (snapshot.data) {
                  lyricBloc.trackSink.add(widget.track);
                  return StreamBuilder(
                    stream: lyricBloc.trackEventStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      if (snapshot.hasData) {
                        Track track = snapshot.data;
                        return ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Track Name',
                                    style: kSubHeadingTextStyle,
                                  ),
                                  TrackDetailsWidget(text: track.trackName),
                                  Text(
                                    'Artist',
                                    style: kSubHeadingTextStyle,
                                  ),
                                  TrackDetailsWidget(text: track.artistName),
                                  Text(
                                    'Album Name',
                                    style: kSubHeadingTextStyle,
                                  ),
                                  TrackDetailsWidget(text: track.albumName),
                                  Text(
                                    'Rating',
                                    style: kSubHeadingTextStyle,
                                  ),
                                  TrackDetailsWidget(
                                      text: track.rating.toString()),
                                  Text(
                                    'Explicit',
                                    style: kSubHeadingTextStyle,
                                  ),
                                  TrackDetailsWidget(
                                      text: track.isExplicit.toString()),
                                  Text(
                                    'Lyrics',
                                    style: kSubHeadingTextStyle,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      track.lyrics ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return Center(
                          child: kCircularProgressIndicator,
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

class TrackDetailsWidget extends StatelessWidget {
  final String text;
  const TrackDetailsWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.purple[100],
          fontSize: 18.0,
        ),
      ),
    );
  }
}
