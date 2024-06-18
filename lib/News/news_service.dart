import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class NewsService {
  static const String _apiKey = 'be9f24ba8bee4540ad7f3e224ea92326';
  static const String _baseUrl =
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$_apiKey';

  Future<List<Article>> fetchNews() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['articles'];
      List<Article> articles =
          jsonData.map((json) => Article.fromJson(json)).toList();
      _saveToLocalStorage(jsonData);
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<Article>> fetchNewsFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? newsData = prefs.getString('newsData');
    if (newsData != null) {
      final List<dynamic> jsonData = json.decode(newsData);
      return jsonData.map((json) => Article.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  void _saveToLocalStorage(List<dynamic> jsonData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('newsData', json.encode(jsonData));
  }
}
