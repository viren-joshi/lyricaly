import 'package:flutter/material.dart';

enum LyricRequests {
  requestList,
  requestLyrics,
  requestInfo,
}

final kSubHeadingTextStyle = TextStyle(
    color: Colors.indigo[200],
    fontSize: 20.0,
    fontFamily: 'ShadowsIntoLight',
    fontWeight: FontWeight.bold);

final kCircularProgressIndicator = CircularProgressIndicator(
  color: Colors.purple.shade200,
);

final kErrorTextStyle = TextStyle(color: Colors.red[200], fontSize: 18.0);
