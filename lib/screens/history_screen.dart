import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/warranty.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Warranty>> _warrantyHistory;

  @override
  void initState() {
    super.initState();
    _warrantyHistory = DatabaseHelper.instance.getWarrantyHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Warranty>>(
      future: _warrantyHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return Center(child: Text('Tidak ada data garansi'));
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Warranty warranty = snapshot.data![index];
            return ListTile(
              title: Text('${warranty.name} (${warranty.warrantyCode})'),
              subtitle: Text('Kadaluarsa: ${DateFormat("dd/MM/yyyy").format(warranty.expiryDate)}'),
              trailing: warranty.expiryDate.isBefore(DateTime.now())
                  ? Icon(Icons.error, color: Colors.red)
                  : Icon(Icons.check, color: Colors.green),
            );
          },
        );
      },
    );
  }
}
