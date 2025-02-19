import 'package:flutter/material.dart';
import 'input_data_screen.dart';
import 'history_screen.dart';
import 'backup_screen.dart';
import 'print_screen.dart';
import 'settings_screen.dart';
import 'scan_barcode_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    InputDataScreen(),
    HistoryScreen(),
    BackupScreen(),
    PrintScreen(),
    SettingsScreen(),
    ScanBarcodeScreen(),
  ];

  final List<String> _titles = [
    'Input Data',
    'History',
    'Backup',
    'Print',
    'Settings',
    'Scan Barcode'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.input), label: 'Input'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.backup), label: 'Backup'),
          BottomNavigationBarItem(icon: Icon(Icons.print), label: 'Print'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
        ],
      ),
    );
  }
}
