import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'advice_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('budgetBox');

  // Initialize Supabase
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const AdviceListScreen(),
    );
  }
}
