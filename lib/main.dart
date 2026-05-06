import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

// Your custom imports
import 'providers/loan_provider.dart';
import 'screens/test_screen.dart'; // Restored the test screen import

void main() async {
  // 1. Ensures Flutter is ready to execute background code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Hive (The Offline Budgeting Engine)
  await Hive.initFlutter();
  await Hive.openBox('budgetBox');

  // 3. Initialize Supabase (The Online Loans & Advice Engine)
  await Supabase.initialize(
    url: 'https://hvcaxyzzziqmotrkjbzz.supabase.co',
    anonKey: 'sb_publishable_A3r5J0XMWoBBb-h5ZPkXtg_X8Tlpysi',
  );

  runApp(
    MultiProvider(
      providers: [
        // This makes the LoanProvider available anywhere in the app
        ChangeNotifierProvider(create: (_) => LoanProvider()),
      ],
      child: const FinanceHubApp(),
    ),
  );
}

class FinanceHubApp extends StatelessWidget {
  const FinanceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Hub',
      theme: ThemeData(primarySwatch: Colors.green),
      // Restored the live TestScreen instead of the dummy Scaffold
      home: const TestScreen(),
    );
  }
}
