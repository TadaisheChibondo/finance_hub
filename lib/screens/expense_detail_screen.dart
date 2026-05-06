// lib/screens/expense_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/expense.dart';  // ADD THIS LINE

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({Key? key, required this.expense}) : super(key: key);

  Future<void> _deleteExpense(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Replace with backendService.deleteExpense(expense.id)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Expense deleted (simulated)')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Details'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.shade100,
                child: Icon(
                  _getCategoryIcon(expense.category),
                  size: 50,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 24),
            _buildDetailRow('Amount', '\$${expense.amount.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            _buildDetailRow('Category', expense.category),
            SizedBox(height: 16),
            _buildDetailRow('Date', _formatDate(expense.date)),
            SizedBox(height: 16),
            _buildDetailRow('Note', expense.note ?? 'No note'),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => _deleteExpense(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Delete Expense', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 16)),
        ),
      ],
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