import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../db/database_helper.dart';
import '../models/warranty.dart';
import 'package:intl/intl.dart';

class ScanBarcodeScreen extends StatefulWidget {
  @override
  _ScanBarcodeScreenState createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  Warranty? _scannedWarranty;

  Future<void> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      if (barcode != "-1") { // jika bukan dibatalkan
        Warranty? warranty = await DatabaseHelper.instance.getWarrantyByCode(barcode);
        setState(() {
          _scannedWarranty = warranty;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saat scan: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _scanBarcode,
          child: Text('Scan Barcode'),
        ),
        if (_scannedWarranty != null)
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Kode Garansi: ${_scannedWarranty!.warrantyCode}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Nama: ${_scannedWarranty!.name}'),
                Text('No HP: ${_scannedWarranty!.phone}'),
                Text('Kerusakan: ${_scannedWarranty!.damage}'),
                Text('Kadaluarsa: ${DateFormat("dd/MM/yyyy").format(_scannedWarranty!.expiryDate)}'),
                Text(
                  _scannedWarranty!.expiryDate.isAfter(DateTime.now())
                      ? 'Garansi Aktif'
                      : 'Garansi Kadaluarsa',
                  style: TextStyle(
                    color: _scannedWarranty!.expiryDate.isAfter(DateTime.now()) ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
