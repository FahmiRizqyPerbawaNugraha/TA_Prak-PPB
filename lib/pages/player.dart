import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PlayerPage extends StatelessWidget {
  final String teamId;
  final ApiService apiService = ApiService();

  PlayerPage({Key? key, required this.teamId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Players')),
      body: Stack(
        children: [
          
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), 
                fit: BoxFit.cover, 
              ),
            ),
          ),
          // Konten Utama
          FutureBuilder(
            future: apiService.getPlayers(teamId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                return Center(child: Text('No players found for this team.'));
              } else {
                final players = snapshot.data as List;
                return PageView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white, 
                              width: 4.0,
                            ),
                            borderRadius: BorderRadius.circular(10), 
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: player['strThumb'] != null
                                ? Image.network(
                                    player['strThumb'],
                                    height: 300,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 100,
                                  ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          player['strPlayer'] ?? 'Unknown Player',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, 
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          player['strPosition'] ?? 'Unknown Position',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, 
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
