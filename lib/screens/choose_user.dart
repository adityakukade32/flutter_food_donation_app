import 'package:flutter/material.dart';
import 'package:flutterapk/screens/ngo_screen.dart';
import 'donar_screen.dart';

class chooseUser extends StatefulWidget {
  const chooseUser({super.key});

  @override
  State<chooseUser> createState() => _chooseUserState();
}

class _chooseUserState extends State<chooseUser> {
  bool _isLoading = false;

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text('Food Waste Management'),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose Your Role',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    _navigateToDonor();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.volunteer_activism, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Donor', style: TextStyle(fontSize: 22, color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _navigateToNgo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.group, color: Colors.white),
                      SizedBox(width: 10),
                      Text('NGO', style: TextStyle(fontSize: 22, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container( // Full-screen loader
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: Center(
                child: SizedBox(
                  width: 50, // Slightly larger loader
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToDonor() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2)); // Minimum 2-second delay
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonarScreen()),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToNgo() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2)); // Minimum 2-second delay
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NgoScreen()),
    );
    setState(() {
      _isLoading = false;
    });
  }
}