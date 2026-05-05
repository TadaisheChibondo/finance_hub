import 'package:flutter/material.dart';
import 'screens/expenses_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Hub',
      theme: ThemeData(primarySwatch: Colors.green),
      home: ExpensesListScreen(), // YOUR SCREEN ONLY
      debugShowCheckedModeBanner: false,
    );
  }
}