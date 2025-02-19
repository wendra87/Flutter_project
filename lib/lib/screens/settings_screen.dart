import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storeNameController = TextEditingController();
  final _storeAddressController = TextEditingController();
  final _storeContactController = TextEditingController();
  int _paperSize = 80;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storeNameController.text = prefs.getString('storeName') ?? 'Nama Toko';
      _storeAddressController.text = prefs.getString('storeAddress') ?? 'Alamat Toko';
      _storeContactController.text = prefs.getString('storeContact') ?? 'Kontak';
      _paperSize = prefs.getInt('paperSize') ?? 80;
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('storeName', _storeNameController.text);
    await prefs.setString('storeAddress', _storeAddressController.text);
    await prefs.setString('storeContact', _storeContactController.text);
    await prefs.setInt('paperSize', _paperSize);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengaturan disimpan'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _storeNameController,
            decoration: InputDecoration(labelText: 'Nama Toko'),
          ),
          TextField(
            controller: _storeAddressController,
            decoration: InputDecoration(labelText: 'Alamat Toko'),
          ),
          TextField(
            controller: _storeContactController,
            decoration: InputDecoration(labelText: 'Kontak'),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<int>(
            value: _paperSize,
            decoration: InputDecoration(labelText: 'Ukuran Kertas'),
            items: [58, 80, 100].map((val) {
              return DropdownMenuItem<int>(
                value: val,
                child: Text('$val mm'),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _paperSize = val!;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveSettings,
            child: Text('Simpan Pengaturan'),
          ),
        ],
      ),
    );
  }
}
