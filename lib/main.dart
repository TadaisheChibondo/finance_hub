import 'package:flutter/material.dart';
import 'screens/add_expense_screen.dart';

void main() {
  runApp(const MyFinanceApp());
}

class MyFinanceApp extends StatelessWidget {
  const MyFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Hub',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const AddExpenseScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
