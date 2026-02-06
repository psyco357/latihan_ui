import 'package:flutter/material.dart';
import '/features/home/components/app_bar_costom.dart';

class HistoryAbsensiPage extends StatelessWidget {
  const HistoryAbsensiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for history
    final historyData = [
      {
        'date': '2026-02-03',
        'type': 'Absen Masuk',
        'time': '08:30',
        'status': 'Tepat Waktu',
      },
      {
        'date': '2026-02-03',
        'type': 'Absen Keluar',
        'time': '17:00',
        'status': 'Tepat Waktu',
      },
      {
        'date': '2026-02-02',
        'type': 'Absen Masuk',
        'time': '08:15',
        'status': 'Tepat Waktu',
      },
      {
        'date': '2026-02-02',
        'type': 'Absen Keluar',
        'time': '17:05',
        'status': 'Tepat Waktu',
      },
      {
        'date': '2026-02-01',
        'type': 'Absen Masuk',
        'time': '09:00',
        'status': 'Terlambat',
      },
    ];

    return BasePage(
      title: 'History Absensi',
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final history = historyData[index];
          final isLate = history['status'] == 'Terlambat';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history['type'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${history['date']} - ${history['time']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isLate
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    history['status'] as String,
                    style: TextStyle(
                      color: isLate ? Colors.red : Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
