import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://www.thesportsdb.com/api/v1/json/3';

  Future<List<dynamic>> getLeagues() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/all_leagues.php'))
          .timeout(const Duration(seconds: 10));
      return _processResponse(response)['leagues'];
    } catch (e) {
      print('Error in getLeagues: $e');
      throw Exception('Failed to load leagues');
    }
  }
  
  Future<List<dynamic>> getClubs(String league) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search_all_teams.php?l=$league'))
          .timeout(const Duration(seconds: 10));
      final clubs = _processResponse(response)['teams'];

      
      clubs.forEach((club) => print('Club: ${club['strTeam']} | ID: ${club['idTeam']}'));

      return clubs;
    } catch (e) {
      print('Error in getClubs: $e');
      throw Exception('Failed to load clubs');
    }
  }

  Future<List<dynamic>> getPlayers(String teamId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/lookup_all_players.php?id=$teamId'))
          .timeout(const Duration(seconds: 10));
      final data = _processResponse(response);

      if (data['player'] == null || (data['player'] as List).isEmpty) {
        print('No players found for teamId: $teamId');
        return []; 
      }

      print('Players for team $teamId: ${data['player']}');
      return data['player'];
    } catch (e) {
      print('Error in getPlayers: $e');
      throw Exception('Failed to load players');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to load data');
    }
  }
}
