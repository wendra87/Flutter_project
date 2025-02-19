import 'package:flutter/material.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:intl/intl.dart';
import '../models/warranty.dart';

class PrintScreen extends StatefulWidget {
  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    printerManager.scanResults.listen((devices) {
      setState(() {
        _devices = devices;
      });
    });
    printerManager.startScan(Duration(seconds: 2));
  }

  Future<void> _printTicket(PrinterBluetooth printer) async {
    printerManager.selectPrinter(printer);
    final profile = await CapabilityProfile.load();
    final ticket = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // Header Nota
    bytes += ticket.text('Nama Toko', styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += ticket.text('Alamat Toko', styles: PosStyles(align: PosAlign.center));
    bytes += ticket.text('Kontak: 08123456789', styles: PosStyles(align: PosAlign.center));
    bytes += ticket.hr();

    // Contoh detail nota (gunakan dummy data, atau ambil data dari input)
    Warranty dummyWarranty = Warranty(
      warrantyCode: 'SDA12345678',
      name: 'John Doe',
      phone: '08123456789',
      damage: 'Ganti LCD',
      warrantyDuration: 30,
      expiryDate: DateTime.now().add(Duration(days: 30)),
    );
    bytes += ticket.text('Kode Garansi: ${dummyWarranty.warrantyCode}', styles: PosStyles(bold: true));
    bytes += ticket.text('Nama: ${dummyWarranty.name}');
    bytes += ticket.text('No HP: ${dummyWarranty.phone}');
    bytes += ticket.text('Kerusakan: ${dummyWarranty.damage}');
    bytes += ticket.text('Lama Garansi: ${dummyWarranty.warrantyDuration} hari');
    bytes += ticket.text('Kadaluarsa: ${DateFormat('dd/MM/yyyy').format(dummyWarranty.expiryDate)}');

    // Cetak barcode (menggunakan format CODE39)
    bytes += ticket.barcode(Barcode.code39(dummyWarranty.warrantyCode));

    // Footer Nota
    bytes += ticket.hr();
    bytes += ticket.text('Terima kasih', styles: PosStyles(align: PosAlign.center));
    bytes += ticket.cut();

    final result = await printerManager.printTicket(bytes);
    if (result.msg != 'Success') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Print gagal: ${result.msg}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Pilih Printer Bluetooth:'),
        Expanded(
          child: ListView.builder(
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_devices[index].name ?? ''),
                subtitle: Text(_devices[index].address ?? ''),
                onTap: () {
                  _printTicket(_devices[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
