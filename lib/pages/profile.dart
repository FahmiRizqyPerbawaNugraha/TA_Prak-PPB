import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; 

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }
  
  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Guest';
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), 
      (Route<dynamic> route) => false, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Stack(
        children: [
          // Gambar sebagai latar belakang
          Positioned.fill(
            child: Image.asset(
              'assets/lapangan.png', // Pastikan nama file benar dan berada di folder assets
              fit: BoxFit.cover, // Menyesuaikan gambar dengan ukuran layar
            ),
          ),
          // Konten di atas gambar
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60, 
                  backgroundImage: AssetImage('assets/profilepicture.png'), 
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome, $_username!', 
                  style: TextStyle(
                    fontSize: 24, 
                    color: Colors.white, // Pastikan teks terlihat di atas background
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Football App', 
                  style: TextStyle(
                    fontSize: 18, 
                    color: Colors.white, 
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _logout, 
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
