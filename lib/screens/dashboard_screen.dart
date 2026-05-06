import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // MOCK DATA - Friend will replace with Hive later
  String _userName = "Alex";
  double _balance = 500.00;
  Map<String, dynamic>? _activeLoan;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // TODO: Friend will replace this with Hive data
    setState(() {
      _userName = "Alex";
      _balance = 500.00;
      _activeLoan =
          null; // Change to {"amount": 200, "dueDate": "May 21"} to test loan warning
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Hub", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        actions: [
          // TODO: Friend will connect logout to Hive
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Temporary navigation - friend will replace with actual logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logout will be connected to Hive"),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, $_userName",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  const Text(
                    "Current Balance",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    "\$${_balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_activeLoan != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Active loan: \$${_activeLoan!['amount']} due by ${_activeLoan!['dueDate']}",
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Friend will navigate to Add Expense screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Add Expense screen coming soon"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Expense"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Friend will navigate to Loan Apply screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Loan Apply screen coming soon"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.credit_card),
                  label: const Text("Apply Loan"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
