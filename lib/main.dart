import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: AbsensiApp()));
}

class AbsensiApp extends StatefulWidget {
  @override
  _AbsensiAppState createState() => _AbsensiAppState();
}

class _AbsensiAppState extends State<AbsensiApp> {
  final TextEditingController _namaController = TextEditingController();
  String _status = 'Hadir'; // Default status

  Future<void> kirimAbsensi() async {
    final url = Uri.parse(
      'http://10.0.2.2:8000/api/absen',
    ); // 10.0.2.2 buat emulator Android yaa
    final response = await http.post(
      url,
      body: {'nama': _namaController.text, 'status': _status},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Absensi berhasil dikirim!')));
      _namaController.clear(); // Clear input setelah kirim
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim absensi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absensi Kehadiran')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              items:
                  ['Hadir', 'Tidak Hadir'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Status Kehadiran',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: kirimAbsensi,
              child: Text('Kirim Absensi'),
            ),
          ],
        ),
      ),
    );
  }
}
