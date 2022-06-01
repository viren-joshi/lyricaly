import 'package:flutter/material.dart';

class LyricTile extends StatelessWidget {
  final String trackName;
  final String albumName;
  final String artistName;
  final Function() onTap;
  const LyricTile(
      {super.key,
      required this.trackName,
      required this.albumName,
      required this.artistName,
      required this.onTap,});

  @override
  Widget build(BuildContext context) {
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
          trackName,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.indigo[200], fontSize: 17.0),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artistName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 15.0),
              // textAlign: TextAlign.start,
            ),
            Text(
              albumName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
              // textAlign: TextAlign.start,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
