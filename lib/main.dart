import 'package:flutter/material.dart';
import 'package:latihan_ui/features/auth/presentation/login_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/state_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => StateTheme())],
      child: Consumer<StateTheme>(
        builder: (context, stateTheme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Latihan UI',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: stateTheme.themeMode,
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
