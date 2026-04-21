import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// The main function must be async to initialize the database before the app runs
void main() async {
  // 1. Crucial step: ensures Flutter is ready to execute background code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize the local Hive database for the device
  await Hive.initFlutter();

  // 3. Open the specific 'box' (table) that will store the budget offline
  await Hive.openBox('budgetBox');

  runApp(const FinanceHubApp());
}

class FinanceHubApp extends StatelessWidget {
  const FinanceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Hub',
      theme: ThemeData(
        primarySwatch: Colors.green, // A solid financial theme color
      ),
      // A temporary placeholder screen until the team builds the real UI
      home: const Scaffold(
        body: Center(child: Text('Database Initialized. UI Pending.')),
      ),
    );
  }
}
