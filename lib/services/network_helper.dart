import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

String apiKey = '81dff9e8b6b4940268e0ddd4dcac1fdf';
String domain = 'https://api.musixmatch.com/ws/1.1/';

class NetworkHelper {
  static Future<Map<String, dynamic>> getChartTracks() async {
    Uri url = Uri.parse('$domain/chart.tracks.get?apikey=$apiKey');
    http.Response response;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        Map<String, dynamic> decoded =
            jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['message']['header']['status_code'] == 200) {
          return decoded['message'];
        } else {
          return {'message': 'API / Server Error'};
        }
      } else {
        return {'message': 'API / Server Error'};
      }
    } on Exception catch (e) {
      return {'message': e.toString()};
      // Exception
    }
  }

  static Future<Map<String, dynamic>> getTrackDetails(int id) async {
    Uri url = Uri.parse('$domain/track.get?track_id=$id&apikey=$apiKey');
    http.Response response;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        Map<String, dynamic> decoded =
            jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['message']['header']['status_code'] == 200) {
          return decoded['message'];
        } else {
          return {'message': 'API / Server Error'};
        }
      } else {
        return {'message': 'API / Server Error'};
      }
    } on Exception catch (e) {
      return {'message': e.toString()};
      // Exception
    }
  }

  static Future<Map<String, dynamic>> getTrackLyrics(int id) async {
    Uri url = Uri.parse('$domain/track.lyrics.get?track_id=$id&apikey=$apiKey');
    http.Response response;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
        Map<String, dynamic> decoded =
            jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['message']['header']['status_code'] == 200) {
          return decoded['message'];
        } else {
          return {'message': 'API / Server Error'};
        }
      } else {
        return {'message': 'API / Server Error'};
      }
    } on Exception catch (e) {
      return {'message': e.toString()};
      // Exception
    }
  }
}
