import 'package:data_garansi/screens/print_screen.dart';
import 'package:flutter/material.dart';
import '../models/warranty.dart';
import '../db/database_helper.dart';

class InputDataScreen extends StatefulWidget {
  @override
  _InputDataScreenState createState() => _InputDataScreenState();
}

class _InputDataScreenState extends State<InputDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _warrantyDurationController = TextEditingController();
  String _selectedDamage = 'Ganti LCD';
  final _damageController = TextEditingController();

  Warranty? _lastSavedWarranty;

  String generateWarrantyCode(String name) {
    var now = DateTime.now();
    return "SDA${now.millisecondsSinceEpoch.toString().substring(8)}";
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        String name = _nameController.text;
        String phone = _phoneController.text;
        String damage = _selectedDamage == 'Kerusakan Lain'
            ? _damageController.text
            : _selectedDamage;
        int duration = int.parse(_warrantyDurationController.text);
        String warrantyCode = generateWarrantyCode(name);
        DateTime expiry = DateTime.now().add(Duration(days: duration));

        Warranty warranty = Warranty(
          warrantyCode: warrantyCode,
          name: name,
          phone: phone,
          damage: damage,
          warrantyDuration: duration,
          expiryDate: expiry,
        );

        int id = await DatabaseHelper.instance.insertWarranty(warranty);
        if (id > 0) {
          setState(() {
            _lastSavedWarranty = warranty;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data tersimpan, kode: $warrantyCode')),
          );
          _formKey.currentState!.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan data')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                  validator: (value) =>
                  value!.isEmpty ? 'Masukkan nama' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Nomor HP'),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value!.isEmpty ? 'Masukkan nomor HP' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedDamage,
                  items: ['Ganti LCD', 'Ganti Batrey', 'Kerusakan Lain']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedDamage = val!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Jenis Kerusakan'),
                ),
                if (_selectedDamage == 'Kerusakan Lain')
                  TextFormField(
                    controller: _damageController,
                    decoration: InputDecoration(labelText: 'Keterangan Kerusakan'),
                    validator: (value) =>
                    value!.isEmpty ? 'Masukkan keterangan kerusakan' : null,
                  ),
                TextFormField(
                  controller: _warrantyDurationController,
                  decoration: InputDecoration(labelText: 'Lama Garansi (hari)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? 'Masukkan lama garansi' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text('Simpan Data'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          if (_lastSavedWarranty != null)
            ElevatedButton.icon(
              onPressed: () {
                // Anda bisa navigasi ke halaman PrintScreen dan meneruskan data jika diperlukan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PrintScreen()),
                );
              },
              icon: Icon(Icons.print),
              label: Text('Print Nota Garansi'),
            ),
        ],
      ),
    );
  }
}
