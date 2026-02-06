import 'package:flutter/material.dart';
import '/features/home/components/app_bar_costom.dart';
import 'package:latihan_ui/core/constants/lokasi/presentation/lokasi_screens.dart';

class LokasiPage extends StatelessWidget {
  const LokasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(title: 'Lokasi', body: const LocationWidget());
  }
}
