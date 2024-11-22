import 'package:flutter/material.dart';
import 'package:ta_ppb/pages/player.dart';
import '../services/api_service.dart';

class ClubPage extends StatelessWidget {
  final String league;
  final ApiService apiService = ApiService();

  ClubPage({Key? key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clubs in $league')),
      body: FutureBuilder(
        future: apiService.getClubs(league),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No clubs found for $league.'));
          } else {
            final clubs = snapshot.data as List;
            return ListView.builder(
              itemCount: clubs.length,
              itemBuilder: (context, index) {
                final club = clubs[index];
                return ListTile(
                  title: Text(club['strTeam'] ?? 'Unknown Club'),
                  onTap: () {
                    print('Selected club ID: ${club['idTeam']}'); 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerPage(
                          teamId: club['idTeam'], 
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
