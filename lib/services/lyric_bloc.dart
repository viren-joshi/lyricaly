import 'dart:async';
import 'dart:convert';
import 'package:lyricaly/constants.dart';
import 'package:lyricaly/services/network_helper.dart';
import 'package:lyricaly/services/shared_preferences.dart';
import 'package:lyricaly/utilities/lyric_info.dart';

class LyricBloc {
  void dispose() {
    _eventStreamController.close();
    _chartStreamController.close();
    _trackStreamController.close();
    _trackEventController.close();
    _wishSaveEventController.close();
    _wishSaveController.close();
    _wishDisplayEventController.close();
    _wishDisplayController.close();
  }

  final _eventStreamController = StreamController<LyricRequests>();
  StreamSink<LyricRequests> get eventSink => _eventStreamController.sink;
  Stream<LyricRequests> get _eventStream => _eventStreamController.stream;

  final _chartStreamController = StreamController<LyricModel>();
  StreamSink<LyricModel> get _lyricSink => _chartStreamController.sink;
  Stream<LyricModel> get lyricStream => _chartStreamController.stream;

  final _trackStreamController = StreamController<Track>();
  StreamSink<Track> get trackSink => _trackStreamController.sink;
  Stream<Track> get _trackStream => _trackStreamController.stream;

  final _trackEventController = StreamController<Track>();
  StreamSink<Track> get _trackEventSink => _trackEventController.sink;
  Stream<Track> get trackEventStream => _trackEventController.stream;

  // Saving Songs
  final _wishSaveEventController = StreamController<Track>();
  StreamSink<Track> get wishSaveEventSink => _wishSaveEventController.sink;
  Stream<Track> get _wishSaveEventStream => _wishSaveEventController.stream;

  final _wishSaveController = StreamController<bool>();
  StreamSink<bool> get _wishSaveSink => _wishSaveController.sink;
  Stream<bool> get wishSaveStream => _wishSaveController.stream;

  // Displaying Saved Songs
  final _wishDisplayEventController = StreamController<void>();
  StreamSink<void> get wishDisplayEventSink => _wishDisplayEventController.sink;
  Stream<void> get _wishDisplayEventStream =>
      _wishDisplayEventController.stream;

  final _wishDisplayController = StreamController<LyricModel>();
  StreamSink<LyricModel> get _wishDisplaySink => _wishDisplayController.sink;
  Stream<LyricModel> get wishDisplayStream => _wishDisplayController.stream;

  LyricBloc() {
    _eventStream.listen((event) async {
      if (event == LyricRequests.requestInfo) {
        var response = await NetworkHelper.getChartTracks();
        if (response.containsKey('message')) {
          _lyricSink.addError(response['message']);
        } else {
          LyricModel lyricModel = LyricModel.fromJson(response);
          _lyricSink.add(lyricModel);
        }
      } else {}
    });

    _trackStream.listen((event) async {
      var response = await NetworkHelper.getTrackDetails(event.id);
      if (response.containsKey('message')) {
        _trackEventSink.addError(response['message']);
      } else {
        Track track = Track.fromJSON(response['body']['track']);
        var lyricResponse = await NetworkHelper.getTrackLyrics(event.id);
        if (lyricResponse.containsKey('message')) {
          _trackEventSink.addError(response['message']);
        } else {
          track.lyrics = lyricResponse['body']['lyrics']['lyrics_body'];
          _trackEventSink.add(track);
        }
      }
    });

    _wishSaveEventStream.listen((Track event) async {
      try {
        LyricModel lyricModel;
        String savedList = await SharedPrefManager.getSavedList();
        if (savedList != '') {
          Map<String, dynamic> decoded =
              jsonDecode(savedList) as Map<String, dynamic>;
          lyricModel = LyricModel.fromJson(decoded);
          lyricModel.trackList.add(event);
        } else {
          lyricModel = LyricModel(trackList: [event]);
        }
        savedList = lyricModel.toJSON();
        await SharedPrefManager.setSavedList(savedList);
        _wishSaveSink.add(true);
      } on Exception catch (e) {
        _wishSaveSink.add(false);
      }
    });

    _wishDisplayEventStream.listen((event) async {
      LyricModel lyricModel;
      String savedList = await SharedPrefManager.getSavedList();
      if (savedList != '') {
        Map<String, dynamic> decoded =
            jsonDecode(savedList) as Map<String, dynamic>;
        lyricModel = LyricModel.fromJson(decoded);
      } else {
        lyricModel = LyricModel(trackList: []);
      }
      _wishDisplaySink.add(lyricModel);
    });
  }
}
