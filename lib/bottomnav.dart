import 'package:flutter/material.dart';
import 'package:workspace/bookinghistory.dart';
import 'package:workspace/bookingscreen.dart';
import 'package:workspace/homescren.dart';
import 'package:workspace/profile.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0; // Keeps track of the selected index

  // List of screens for the BottomNavigationBar
  final List<Widget> _screens = [
    // Add your respective screens here
    HomeScreen(),

    BookingHistoryScreen(),
    ProfileScreen(),
    // ExploreScreen(),
    // Example Profile screen
  ];

  // Method to change the selected screen based on Bottom Navigation selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F2EE),

      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the selected index
        onTap: _onItemTapped, // Method to change selected screen
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF2D4436),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Booking History',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
