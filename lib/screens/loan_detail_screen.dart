import 'package:flutter/material.dart';

class LoanDetailScreen extends StatelessWidget {
  // Parameters received from Loan History Screen
  final String loanId;
  final double amount;
  final double totalRepayment;
  final String reason;
  final String status;
  final Timestamp? dueDate;
  final Timestamp? appliedAt;
  final double interest;
  final int termDays;

  const LoanDetailScreen({
    super.key,
    required this.loanId,
    required this.amount,
    required this.totalRepayment,
    required this.reason,
    required this.status,
    this.dueDate,
    this.appliedAt,
    required this.interest,
    required this.termDays,
  });

  // Helper function to format date
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Not available';
    DateTime date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Helper function to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'repaid':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  // Helper function to get status icon
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.check_circle;
      case 'repaid':
        return Icons.done_all;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Details'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== STATUS CARD ==========
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getStatusColor(status),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getStatusIcon(status),
                    size: 50,
                    color: _getStatusColor(status),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(status),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    status.toLowerCase() == 'approved'
                        ? 'Your loan has been approved'
                        : status.toLowerCase() == 'repaid'
                            ? 'This loan has been fully repaid'
                            : status.toLowerCase() == 'rejected'
                                ? 'This loan was not approved'
                                : 'Loan is being processed',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getStatusColor(status),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ========== LOAN AMOUNT SECTION ==========
            const Text(
              'Loan Amount',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const Divider(height: 30, thickness: 1),

            // ========== LOAN DETAILS GRID ==========
            const Text(
              'Loan Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Detail Row 1: Loan ID
            _buildDetailRow(
              icon: Icons.tag,
              label: 'Loan ID',
              value: loanId,
            ),
            const SizedBox(height: 12),

            // Detail Row 2: Reason
            _buildDetailRow(
              icon: Icons.description,
              label: 'Reason',
              value: reason,
            ),
            const SizedBox(height: 12),

            // Detail Row 3: Term
            _buildDetailRow(
              icon: Icons.calendar_month,
              label: 'Term',
              value: '$termDays days',
            ),
            const SizedBox(height: 12),

            // Divider
            const Divider(height: 24, thickness: 1),

            // ========== REPAYMENT DETAILS ==========
            const Text(
              'Repayment Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Detail Row 4: Interest
            _buildDetailRow(
              icon: Icons.trending_up,
              label: 'Interest (5%)',
              value: '\$${interest.toStringAsFixed(2)}',
              valueColor: Colors.orange,
            ),
            const SizedBox(height: 12),

            // Detail Row 5: Total Repayment
            _buildDetailRow(
              icon: Icons.attach_money,
              label: 'Total to Repay',
              value: '\$${totalRepayment.toStringAsFixed(2)}',
              valueColor: const Color(0xFF2E7D32),
              valueBold: true,
              valueSize: 20,
            ),
            const SizedBox(height: 12),

            // Detail Row 6: Due Date (if available)
            if (dueDate != null)
              _buildDetailRow(
                icon: Icons.event,
                label: 'Due Date',
                value: _formatDate(dueDate),
                valueColor:
                    dueDate != null && _isOverdue(dueDate!) ? Colors.red : null,
              ),
            const SizedBox(height: 12),

            // Detail Row 7: Applied Date
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Applied On',
              value: _formatDate(appliedAt),
            ),

            const Divider(height: 24, thickness: 1),

            // ========== DISCLAIMER ==========
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.amber, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '⚠️ School Project Demo\nNo real money is lent or owed.',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each detail row
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
    double valueSize = 16,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: valueSize,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // Check if date is overdue (only for display)
  bool _isOverdue(Timestamp dueDate) {
    DateTime due = dueDate.toDate();
    DateTime now = DateTime.now();
    return due.isBefore(now);
  }
}
