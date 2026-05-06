import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

// Backend Providers
import 'providers/loan_provider.dart';

// UI Screens
import 'screens/test_screen.dart'; // Kept your test screen just in case!
import 'screens/expenses_list_screen.dart'; // Your team's new UI screen

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
      debugShowCheckedModeBanner:
          false, // Team added this to make the UI look clean!
      // Switched from your TestScreen to the team's new UI!
      home: ExpensesListScreen(),
    );
  }
}
