import 'package:flutter/material.dart';

class LoanApplyScreen extends StatefulWidget {
  const LoanApplyScreen({super.key});

  @override
  State<LoanApplyScreen> createState() => _LoanApplyScreenState();
}

class _LoanApplyScreenState extends State<LoanApplyScreen> {
  // Form controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  // Dropdown values
  String _selectedTerm = '30 days';
  final List<String> _termOptions = ['15 days', '30 days', '60 days'];

  // Calculation results
  double _calculatedInterest = 0;
  double _calculatedTotal = 0;
  bool _showCalculation = false;

  // Interest rate (5%)
  static const double interestRate = 0.05;

  void _calculateLoan() {
    if (_amountController.text.isEmpty) {
      setState(() {
        _showCalculation = false;
      });
      return;
    }

    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _showCalculation = false;
      });
      return;
    }

    // Get term in days
    int termDays = 30; // default
    if (_selectedTerm == '15 days') termDays = 15;
    if (_selectedTerm == '30 days') termDays = 30;
    if (_selectedTerm == '60 days') termDays = 60;

    // Calculate interest (5% flat)
    double interest = amount * interestRate;
    double total = amount + interest;

    setState(() {
      _calculatedInterest = interest;
      _calculatedTotal = total;
      _showCalculation = true;
    });
  }

  void _submitLoan() {
    // Validate amount
    if (_amountController.text.isEmpty) {
      _showError('Please enter an amount');
      return;
    }

    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount greater than 0');
      return;
    }

    if (_reasonController.text.trim().isEmpty) {
      _showError('Please enter a reason for the loan');
      return;
    }

    // Calculate due date
    int termDays = 30;
    if (_selectedTerm == '15 days') termDays = 15;
    if (_selectedTerm == '30 days') termDays = 30;
    if (_selectedTerm == '60 days') termDays = 60;

    DateTime dueDate = DateTime.now().add(Duration(days: termDays));

    // Format due date
    String formattedDueDate = '${dueDate.month}/${dueDate.day}/${dueDate.year}';

    // Show success dialog (UI only - no backend)
    _showSuccessDialog(amount, _calculatedTotal, formattedDueDate);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessDialog(double amount, double total, String dueDate) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Loan Application Submitted'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('✅ Your loan has been approved by Finance Hub!'),
            const SizedBox(height: 16),
            Text('Amount: \$${amount.toStringAsFixed(2)}'),
            Text('Interest (5%): \$${_calculatedInterest.toStringAsFixed(2)}'),
            Text('Total to repay: \$${total.toStringAsFixed(2)}'),
            Text('Due date: $dueDate'),
            const SizedBox(height: 16),
            const Text(
              '⚠️ This is a school project demonstration.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Text(
              'No real money is lent or owed.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Loan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Disclaimer Card
            Card(
              color: Colors.yellow.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade800),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'School project demo. No real money involved.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Amount Field
            const Text(
              'Loan Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount (e.g., 200)',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => _calculateLoan(),
            ),
            const SizedBox(height: 16),

            // Reason Field
            const Text(
              'Reason for Loan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g., Buy textbooks, pay tuition, emergency',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Term Dropdown
            const Text(
              'Repayment Term',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTerm,
                  isExpanded: true,
                  items: _termOptions.map((String term) {
                    return DropdownMenuItem(
                      value: term,
                      child: Text(term),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedTerm = newValue;
                        _calculateLoan();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Calculation Card (shows when valid amount entered)
            if (_showCalculation) ...[
              Card(
                color: Colors.green.shade50,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Loan Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Principal amount:'),
                          Text(
                            '\$${double.tryParse(_amountController.text)?.toStringAsFixed(2) ?? "0"}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Interest (5% flat):'),
                          Text(
                            '\$${_calculatedInterest.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total to repay:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${_calculatedTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Submit Button
            ElevatedButton(
              onPressed: _submitLoan,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Apply for Loan',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}