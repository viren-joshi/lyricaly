import 'dart:convert';

class LyricModel {
  List<Track> trackList;

  LyricModel({required this.trackList});

  factory LyricModel.fromJson(Map<String, dynamic> json) {
    return LyricModel(
      trackList: List<Track>.from(
        json['body']['track_list'].map((x) => Track.fromJSON(x['track'])),
      ),
    );
  }

  String toJSON() {
    List<Map<String, dynamic>> trackMapList = [];
    for (Track track in trackList) {
      trackMapList.add(track.toMap());
    }
    Map<String, dynamic> json = {
      'body': {'track_list': trackMapList}
    };
    print(json);
    print(jsonEncode(json));
    return jsonEncode(json);
  }
}

class Track {
  int id;
  String trackName;
  String albumName;
  String artistName;
  bool isExplicit;
  int rating;
  String? lyrics;

  Track({
    required this.id,
    required this.trackName,
    required this.albumName,
    required this.artistName,
    required this.isExplicit,
    required this.rating,
    this.lyrics,
  });

  factory Track.fromJSON(Map<String, dynamic> json) => Track(
        id: json['track_id'],
        trackName: json['track_name'],
        albumName: json['album_name'],
        artistName: json['artist_name'],
        isExplicit: json['explicit'] == 0 ? false : true,
        rating: json['track_rating'],
        lyrics: json['lyrics_body'],
      );

  Map<String, dynamic> toMap() => {
        'track': {
          'track_id': id,
          'track_name': trackName,
          'artist_name': artistName,
          'track_rating': rating,
          'explicit': isExplicit,
          'album_name': albumName,
        }
      };
}
