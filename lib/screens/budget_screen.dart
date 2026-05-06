import 'package:flutter/material.dart';

class BudgetingScreen extends StatefulWidget {
  @override
  _BudgetingScreenState createState() => _BudgetingScreenState();
}

class _BudgetingScreenState extends State<BudgetingScreen> {
  double totalBudget = 100.0;
  double spent = 45.0;

  List<Map<String, dynamic>> expenses = [
    {"title": "Food", "amount": 15.0},
    {"title": "Transport", "amount": 10.0},
    {"title": "Airtime", "amount": 20.0},
  ];

  void addExpense(String title, double amount) {
    setState(() {
      expenses.add({"title": title, "amount": amount});
      spent += amount;
    });
  }

  void showAddExpenseDialog() {
    String title = "";
    String amount = "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Category"),
              onChanged: (value) => title = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              onChanged: (value) => amount = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (title.isNotEmpty && amount.isNotEmpty) {
                addExpense(title, double.parse(amount));
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double remaining = totalBudget - spent;
    double progress = spent / totalBudget;

    return Scaffold(
      appBar: AppBar(title: Text("Budgeting")),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddExpenseDialog,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Budget Summary Card
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Total Budget: \$${totalBudget.toStringAsFixed(2)}"),
                    SizedBox(height: 8),
                    LinearProgressIndicator(value: progress),
                    SizedBox(height: 8),
                    Text("Spent: \$${spent.toStringAsFixed(2)}"),
                    Text("Remaining: \$${remaining.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Expense List
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return ListTile(
                    leading: Icon(Icons.money),
                    title: Text(expense["title"]),
                    trailing: Text("\$${expense["amount"]}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
