import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class MarvelService {
  final String _baseUrl = 'https://gateway.marvel.com:443/v1/public';
  final String _publicKey = dotenv.env['MARVEL_PUBLIC_KEY']!;
  final String _privateKey = dotenv.env['MARVEL_PRIVATE_KEY']!;

  Future<List<dynamic>> getCharacters(
      {int limit = 100, int offset = 0, String? searchQuery}) async {
    return _fetchData(
        'characters', limit, offset, searchQuery, 'nameStartsWith');
  }

  Future<List<dynamic>> getComics(
      {int limit = 100, int offset = 0, String? searchQuery}) async {
    return _fetchData('comics', limit, offset, searchQuery, 'titleStartsWith');
  }

  Future<List<dynamic>> getSeries(
      {int limit = 100, int offset = 0, String? searchQuery}) async {
    return _fetchData('series', limit, offset, searchQuery, 'titleStartsWith');
  }

  Future<List<dynamic>> getEvents(
      {int limit = 100, int offset = 0, String? searchQuery}) async {
    return _fetchData('events', limit, offset, searchQuery, 'nameStartsWith');
  }

  Future<List<dynamic>> getCreators(
      {int limit = 100, int offset = 0, String? searchQuery}) async {
    return _fetchData('creators', limit, offset, searchQuery, 'nameStartsWith');
  }

  Future<List<dynamic>> getStories(
      {int limit = 100, int offset = 0, String? searchQuery}) async {
    return _fetchData('stories', limit, offset, searchQuery, 'titleStartsWith');
  }

  Future<List<dynamic>> _fetchData(String endpoint, int limit, int offset,
      String? searchQuery, String searchParam) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = md5
        .convert(utf8.encode('$timestamp$_privateKey$_publicKey'))
        .toString();

    var queryParameters = {
      'limit': '$limit',
      'offset': '$offset',
      'ts': timestamp,
      'apikey': _publicKey,
      'hash': hash,
    };

    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParameters[searchParam] = searchQuery;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint')
          .replace(queryParameters: queryParameters),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['results'];
    } else {
      throw Exception('Failed to load $endpoint');
    }
  }
}
