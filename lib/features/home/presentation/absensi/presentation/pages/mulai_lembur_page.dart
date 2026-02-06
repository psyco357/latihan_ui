import 'package:flutter/material.dart';
import '/features/home/components/app_bar_costom.dart';

class MulaiLemburPage extends StatelessWidget {
  const MulaiLemburPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Mulai Lembur',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.work, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'Mulai Lembur',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Silakan tekan tombol di bawah untuk memulai lembur',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement mulai lembur logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lembur dimulai!'),
                      backgroundColor: Color(0xFF2196F3),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mulai Lembur',
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
