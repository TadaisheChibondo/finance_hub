import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ─── Colour tokens ────────────────────────────────────────────────────────────
const _bg = Color(0xFF0D0F14);
const _card = Color(0xFF1E2330);
const _cardAlt = Color(0xFF252B3A);
const _green = Color(0xFF00E5A0);
const _red = Color(0xFFFF5C5C);
const _textPrimary = Color(0xFFEEF0F6);
const _textSecondary = Color(0xFF8A90A2);
const _divider = Color(0xFF2A3045);

class BudgetingScreen extends StatefulWidget {
  const BudgetingScreen({super.key});

  @override
  State<BudgetingScreen> createState() => _BudgetingScreenState();
}

class _BudgetingScreenState extends State<BudgetingScreen> {
  final _box = Hive.box('budgetBox');

  // ─── HIVE LOGIC ───
  void _addExpense(String title, double amount) {
    // 1. Get current list of expenses (or empty list if none exist)
    List<dynamic> currentExpenses = _box.get('expenses', defaultValue: []);

    // 2. Add the new expense to the top of the list
    currentExpenses.insert(0, {
      "title": title,
      "amount": amount,
      "date": DateTime.now().toIso8601String(), // Save the exact time
    });

    // 3. Update the total spent amount
    double currentSpent = _box.get('spentThisMonth', defaultValue: 0.0);

    // 4. Save everything back to the database!
    _box.put('expenses', currentExpenses);
    _box.put('spentThisMonth', currentSpent + amount);
  }

  void _showAddExpenseDialog() {
    String title = "";
    String amountStr = "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Add Expense",
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: _textPrimary),
              decoration: InputDecoration(
                labelText: "Category (e.g. Food)",
                labelStyle: const TextStyle(color: _textSecondary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _divider),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: _green),
                ),
              ),
              onChanged: (value) => title = value,
            ),
            const SizedBox(height: 12),
            TextField(
              style: const TextStyle(color: _textPrimary),
              decoration: InputDecoration(
                labelText: "Amount (\$)",
                labelStyle: const TextStyle(color: _textSecondary),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _divider),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: _green),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) => amountStr = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: _textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: _bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (title.isNotEmpty && amountStr.isNotEmpty) {
                final amount = double.tryParse(amountStr);
                if (amount != null && amount > 0) {
                  _addExpense(title, amount);
                  Navigator.pop(context);
                }
              }
            },
            child: const Text(
              "Add",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditBudgetDialog() {
    String limitStr = "";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        title: const Text(
          "Set Monthly Limit",
          style: TextStyle(color: _textPrimary),
        ),
        content: TextField(
          style: const TextStyle(color: _textPrimary),
          decoration: const InputDecoration(
            labelText: "Amount (\$)",
            labelStyle: TextStyle(color: _textSecondary),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) => limitStr = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: _bg,
            ),
            onPressed: () {
              final limit = double.tryParse(limitStr);
              if (limit != null && limit > 0) {
                _box.put('monthlyLimit', limit); // Updates Hive instantly!
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          "Budgeting",
          style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700),
        ),
        backgroundColor: _bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: _textPrimary),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _green,
        foregroundColor: _bg,
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
      // ─── LIVE UI UPDATER ───
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (context, box, child) {
          // Pull live data
          final double totalBudget = box.get(
            'monthlyLimit',
            defaultValue: 890.00,
          );
          final double spent = box.get('spentThisMonth', defaultValue: 0.0);
          final List<dynamic> expenses = box.get('expenses', defaultValue: []);

          final double remaining = totalBudget - spent;
          final double progress = totalBudget > 0
              ? (spent / totalBudget).clamp(0.0, 1.0)
              : 0.0;
          final bool isOverBudget = spent > totalBudget;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Budget Summary Card
                Container(
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isOverBudget ? _red.withOpacity(0.5) : _divider,
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Total Budget",
                                style: TextStyle(
                                  color: _textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // THE NEW EDIT BUTTON
                              GestureDetector(
                                onTap: _showEditBudgetDialog,
                                child: const Icon(
                                  Icons.edit,
                                  color: _green,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "\$${totalBudget.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: _cardAlt,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isOverBudget ? _red : _green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Spent",
                                style: TextStyle(
                                  color: _textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "\$${spent.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Remaining",
                                style: TextStyle(
                                  color: _textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "\$${remaining.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: isOverBudget ? _red : _green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                const Text(
                  "Recent Expenses",
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Expense List
                Expanded(
                  child: expenses.isEmpty
                      ? const Center(
                          child: Text(
                            "No expenses yet. Tap + to add one!",
                            style: TextStyle(color: _textSecondary),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final expense = expenses[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: _card,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: _divider),
                              ),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _cardAlt,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.receipt_long_outlined,
                                    color: _textSecondary,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  expense["title"],
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Text(
                                  "-\$${expense["amount"].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
