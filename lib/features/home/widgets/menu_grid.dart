import 'package:flutter/material.dart';
// import '/features/absensi/pages/absensi_page.dart';
import '/features/home/presentation/absensi/presentation/absensi_screens.dart';

class MenuSection {
  final List<IconData> icons;
  final List<String> labels;

  MenuSection({required this.icons, required this.labels});
}

class MenuGrid extends StatefulWidget {
  const MenuGrid({super.key});

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  int _currentPage = 0;

  final sections = [
    MenuSection(
      icons: [
        Icons.timer,
        Icons.flight,
        Icons.calendar_month,
        Icons.check_circle,
        Icons.credit_card,
        Icons.receipt,
        Icons.account_balance,
        Icons.money,
      ],
      labels: [
        'Attendance',
        'Leaves',
        'Calendar',
        'Approval',
        'Salary',
        'Cash Receipt',
        'Account Balance',
        'Money',
      ],
    ),
    MenuSection(
      icons: [Icons.groups, Icons.apartment],
      labels: ['Team', 'Company'],
    ),
  ];

  // 👇 Method untuk handle klik menu
  void _handleMenuTap(String menuName) {
    // Gunakan switch untuk routing berdasarkan nama menu
    switch (menuName) {
      case 'Attendance':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AbsensiScreens()),
        );
        break;
      case 'Leaves':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LeavesPage()),
        );
        break;
      case 'Calendar':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CalendarPage()),
        );
        break;
      case 'Approval':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ApprovalPage()),
        );
        break;
      case 'Salary':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SalaryPage()),
        );
        break;
      case 'Cash Receipt':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CashReceiptPage()),
        );
        break;
      case 'Account Balance':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AccountBalancePage()),
        );
        break;
      case 'Money':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MoneyPage()),
        );
        break;
      case 'Team':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TeamPage()),
        );
        break;
      case 'Company':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CompanyPage()),
        );
        break;
      default:
        // Jika belum ada halaman, tampilkan snackbar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$menuName clicked')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Card(
        // color: Theme.of(context).colorScheme.surface,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            SizedBox(
              height: 280,
              child: PageView.builder(
                itemCount: sections.length,
                onPageChanged: (i) {
                  setState(() => _currentPage = i);
                },
                itemBuilder: (_, i) {
                  final section = sections[i];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MenuGrid(
                          icons: section.icons,
                          labels: section.labels,
                          onMenuTap:
                              _handleMenuTap, // 👈 Pass callback ke _MenuGrid
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  sections.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 10 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? Colors.blue
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  final List<IconData> icons;
  final List<String> labels;
  final Function(String)? onMenuTap; // 👈 Tambahkan parameter callback

  const _MenuGrid({required this.icons, required this.labels, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: icons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 90,
      ),
      itemBuilder: (_, i) {
        final baseColor = Colors.primaries[i % Colors.primaries.length];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            onMenuTap?.call(labels[i]); // 👈 Panggil callback dengan nama menu
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isDark
                    ? baseColor.withOpacity(0.5)
                    : baseColor.withOpacity(0.5),
                child: Icon(
                  icons[i],
                  size: 22,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                labels[i],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 👇 Contoh halaman-halaman tujuan (buat file terpisah untuk masing-masing)
// class AttendancePage extends StatelessWidget {
//   const AttendancePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Attendance')),
//       body: const Center(child: Text('Attendance Page')),
//     );
//   }
// }

class LeavesPage extends StatelessWidget {
  const LeavesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaves')),
      body: const Center(child: Text('Leaves Page')),
    );
  }
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const Center(child: Text('Calendar Page')),
    );
  }
}

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approval')),
      body: const Center(child: Text('Approval Page')),
    );
  }
}

class SalaryPage extends StatelessWidget {
  const SalaryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salary')),
      body: const Center(child: Text('Salary Page')),
    );
  }
}

class CashReceiptPage extends StatelessWidget {
  const CashReceiptPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cash Receipt')),
      body: const Center(child: Text('Cash Receipt Page')),
    );
  }
}

class AccountBalancePage extends StatelessWidget {
  const AccountBalancePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Balance')),
      body: const Center(child: Text('Account Balance Page')),
    );
  }
}

class MoneyPage extends StatelessWidget {
  const MoneyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Money')),
      body: const Center(child: Text('Money Page')),
    );
  }
}

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Team')),
      body: const Center(child: Text('Team Page')),
    );
  }
}

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Company')),
      body: const Center(child: Text('Company Page')),
    );
  }
}
