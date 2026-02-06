import 'package:flutter/material.dart';
import '/features/home/components/app_bar_costom.dart';
import 'pages/absen_masuk_page.dart';
import 'pages/absen_keluar_page.dart';
import 'pages/mulai_lembur_page.dart';
import 'pages/selesai_lembur_page.dart';
import 'pages/history_absensi_page.dart';
import 'pages/lokasi.dart';

class AbsensiScreens extends StatelessWidget {
  const AbsensiScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Absen Masuk',
        'icon': Icons.login,
        'color': const Color(0xFF4CAF50),
        'page': const AbsenMasukPage(),
      },
      {
        'title': 'Absen Keluar',
        'icon': Icons.logout,
        'color': const Color(0xFFF44336),
        'page': const AbsenKeluarPage(),
      },
      {
        'title': 'Mulai Lembur',
        'icon': Icons.work,
        'color': const Color(0xFF2196F3),
        'page': const MulaiLemburPage(),
      },
      {
        'title': 'Selesai Lembur',
        'icon': Icons.done_all,
        'color': const Color(0xFFFF9800),
        'page': const SelesaiLemburPage(),
      },
      {
        'title': 'History Absensi',
        'icon': Icons.history,
        'color': const Color(0xFF9C27B0),
        'page': const HistoryAbsensiPage(),
      },
      {
        'title': 'Lokasi',
        'icon': Icons.location_on,
        'color': const Color.fromARGB(255, 64, 39, 176),
        'page': const LokasiPage(),
      },
    ];

    return BasePage(
      title: 'Absensi',
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => item['page'] as Widget,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
