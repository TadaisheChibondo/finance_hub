import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // NEW: Import Supabase

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

  runApp(const FinanceHubApp());
}

class FinanceHubApp extends StatelessWidget {
  const FinanceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Hub',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const Scaffold(
        body: Center(
          child: Text('Offline & Online Databases Initialized. UI Pending.'),
        ),
      ),
    );
  }
}
