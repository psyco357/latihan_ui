import 'package:flutter/material.dart';
import '/features/home/components/app_bar_costom.dart';

class SelesaiLemburPage extends StatelessWidget {
  const SelesaiLemburPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Selesai Lembur',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.done_all, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'Selesai Lembur',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Silakan tekan tombol di bawah untuk menyelesaikan lembur',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement selesai lembur logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lembur selesai!'),
                      backgroundColor: Color(0xFFFF9800),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Selesai Lembur',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
