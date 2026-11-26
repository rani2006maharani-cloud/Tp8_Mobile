
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController namaController = TextEditingController();

  String namaTersimpan = '';

  @override
  void initState() {
    super.initState();
    loadNama();
  }

  // Mengambil nama yang sudah disimpan
  Future<void> loadNama() async {
    final prefs = await SharedPreferences.getInstance();

    final nama = prefs.getString('nama_pengguna') ?? '';

    if (!mounted) return;

    setState(() {
      namaTersimpan = nama;
      namaController.text = nama;
    });
  }

  // Menyimpan nama pengguna
  Future<void> saveNama() async {
    final nama = namaController.text.trim();

    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan nama terlebih dahulu'),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nama_pengguna', nama);

    if (!mounted) return;

    setState(() {
      namaTersimpan = nama;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nama berhasil disimpan'),
      ),
    );
  }

  // Menghapus nama pengguna
  Future<void> deleteNama() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('nama_pengguna');

    if (!mounted) return;

    setState(() {
      namaTersimpan = '';
      namaController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nama berhasil dihapus'),
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text('Shared Preferences'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              const Text(
                'Simpan Nama Pengguna',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Masukkan nama kamu di bawah ini',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Pengguna',
                  hintText: 'Masukkan nama kamu',
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: saveNama,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Simpan Nama'),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  children: [
                    const Text(
                      'Nama Tersimpan:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      namaTersimpan.isEmpty
                          ? 'Belum ada nama tersimpan'
                          : namaTersimpan,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed:
                      namaTersimpan.isEmpty ? null : deleteNama,
                  child: const Text('Hapus Nama'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
