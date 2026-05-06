// lib/screens/expenses_list_screen.dart

import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'expense_detail_screen.dart';

class ExpensesListScreen extends StatefulWidget {
  @override
  _ExpensesListScreenState createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  List<Expense> _expenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFakeData();
  }

  void _loadFakeData() {
    // Create fake data immediately (no delay)
    final fakeExpenses = [
      Expense(
        id: '1',
        amount: 25.00,
        category: 'Food',
        date: DateTime.now(),
        note: 'Lunch at campus',
      ),
      Expense(
        id: '2',
        amount: 15.00,
        category: 'Transport',
        date: DateTime.now().subtract(Duration(days: 1)),
        note: 'Bus fare',
      ),
      Expense(
        id: '3',
        amount: 80.00,
        category: 'Shopping',
        date: DateTime.now().subtract(Duration(days: 2)),
        note: 'Groceries',
      ),
      Expense(
        id: '4',
        amount: 10.00,
        category: 'Food',
        date: DateTime.now().subtract(Duration(days: 3)),
        note: 'Coffee',
      ),
    ];

    // Update the state
    setState(() {
      _expenses = fakeExpenses;
      _isLoading = false;
    });
  }

  double _getTotalThisWeek() {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day - now.weekday + 1);
    double total = 0;
    for (var expense in _expenses) {
      if (expense.date.isAfter(startOfWeek)) {
        total += expense.amount;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Add Expense screen coming soon')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading expenses...'),
                ],
              ),
            )
          : _expenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No expenses yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Tap + to add your first expense', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.green.shade50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total spent this week:', style: TextStyle(fontSize: 16)),
                          Text(
                            '\$${_getTotalThisWeek().toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _expenses.length,
                        itemBuilder: (context, index) {
                          final expense = _expenses[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green.shade100,
                                child: Icon(_getCategoryIcon(expense.category), color: Colors.green),
                              ),
                              title: Text(expense.category, style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(_formatDate(expense.date)),
                              trailing: Text(
                                '\$${expense.amount.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ExpenseDetailScreen(expense: expense),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Icons.restaurant;
      case 'transport': return Icons.directions_bus;
      case 'shopping': return Icons.shopping_bag;
      case 'bills': return Icons.receipt;
      default: return Icons.attach_money;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}