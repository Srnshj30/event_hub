import 'package:event_hub/screens/clubs_types.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    AppBar? appBarr;

    if(_selectedIndex== 0 ||_selectedIndex ==2){
      appBarr = AppBar(
        title: const Text('EventHub'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();
              },
              icon: const Icon(Icons.exit_to_app_outlined))
        ],
      );
    }
    else{
      appBarr = AppBar(
        title: const Text('Clubs Category'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().signOut();
              },
              icon: const Icon(Icons.exit_to_app_outlined))
        ],
      );
    }

    return Scaffold(
      appBar: appBarr,
      body: Center(
        child: _buildScreen(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return const Center(child: Text('Home Screen'));
      case 1:
        return const StackBoxes();
      case 2:
        return const Center(child: Text('Profile Screen'));
      default:
        return const Center(child: Text('Unknown Screen'));
    }
  }
}