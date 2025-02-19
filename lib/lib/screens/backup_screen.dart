import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../db/database_helper.dart';
import '../models/warranty.dart';
import 'package:intl/intl.dart';

class BackupScreen extends StatefulWidget {
  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isBackingUp = false;

  Future<void> _backupData() async {
    setState(() {
      _isBackingUp = true;
    });
    List<Warranty> warranties = await DatabaseHelper.instance.getAllWarranties();
    var excel = Excel.createExcel();
    Sheet sheet = excel['Garansi'];
    sheet.appendRow(['ID', 'Warranty Code', 'Nama', 'No HP', 'Kerusakan', 'Lama Garansi', 'Kadaluarsa']);
    for (var w in warranties) {
      sheet.appendRow([
        w.id,
        w.warrantyCode,
        w.name,
        w.phone,
        w.damage,
        w.warrantyDuration,
        DateFormat('dd/MM/yyyy').format(w.expiryDate)
      ]);
    }
    Directory? directory;
    if (Platform.isAndroid)
      directory = await getExternalStorageDirectory();
    else
      directory = await getApplicationDocumentsDirectory();
    String outputFile = "${directory!.path}/warranty_backup.xlsx";
    File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup berhasil: $outputFile'))
    );
    setState(() {
      _isBackingUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isBackingUp
          ? CircularProgressIndicator()
          : ElevatedButton(
        onPressed: _backupData,
        child: Text('Backup Data ke Excel'),
      ),
    );
  }
}
