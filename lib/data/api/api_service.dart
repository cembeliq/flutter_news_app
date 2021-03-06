import 'dart:convert';

import 'package:dicoding_news_app/data/model/article.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String _baseUrl = 'https://newsapi.org/v2/';
  static final String _apiKey = '985267c5471f41fcbfe6dbeebd831ca6';
  static final String _category = 'business';
  static final String _country = 'id';

  Future<ArticleResult> topHeadlines() async {
    final response = await http.get(_baseUrl +
      "top-headlines?country=$_country&category=$_category&apiKey=$_apiKey"
    );

    if (response.statusCode == 200) {
      return ArticleResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load top headlines');
    }
  }

}
