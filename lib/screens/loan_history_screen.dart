import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loan_apply_screen.dart';
import 'loan_detail_screen.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  // Current logged in user
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  // Refresh when coming back from apply screen
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  // Get color based on loan status
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

  // Get icon based on loan status
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

  // Format date for display
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'No date';
    DateTime date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Check if date is overdue
  bool _isOverdue(Timestamp dueDate) {
    DateTime due = dueDate.toDate();
    DateTime now = DateTime.now();
    return due.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    // If no user is logged in
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loan History'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Please login to view loans',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan History'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          // Add New Loan Button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Navigate to Loan Apply screen
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoanApplyScreen(),
                ),
              );
              // If loan was added successfully, refresh the list
              if (result == true && mounted) {
                setState(() {});
              }
            },
            tooltip: 'Apply for new loan',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('loans')
            .where('userId', isEqualTo: _currentUser!.uid)
            .orderBy('appliedAt', descending: true) // Most recent first
            .snapshots(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2E7D32),
              ),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // No loans state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.credit_off,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No loans yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to apply for your first loan',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // Data loaded - show list
          final loans = snapshot.data!.docs;

          // Separate active/approved loans from past loans
          final activeLoans = loans.where((loan) {
            final status =
                (loan.data() as Map<String, dynamic>)['status'] ?? '';
            return status.toLowerCase() == 'approved';
          }).toList();

          final pastLoans = loans.where((loan) {
            final status =
                (loan.data() as Map<String, dynamic>)['status'] ?? '';
            return status.toLowerCase() != 'approved';
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            color: const Color(0xFF2E7D32),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Active Loans Section
                if (activeLoans.isNotEmpty) ...[
                  const Text(
                    'Active Loans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...activeLoans.map((loan) => _buildLoanCard(loan)),
                  const SizedBox(height: 16),
                ],

                // Past Loans Section
                if (pastLoans.isNotEmpty) ...[
                  const Text(
                    'Past Loans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...pastLoans.map((loan) => _buildLoanCard(loan)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // Build a single loan card
  Widget _buildLoanCard(QueryDocumentSnapshot loan) {
    final data = loan.data() as Map<String, dynamic>;

    final String loanId = data['loanId'] ?? loan.id;
    final double amount = (data['amount'] ?? 0).toDouble();
    final double totalRepayment = (data['totalRepayment'] ?? amount).toDouble();
    final String reason = data['reason'] ?? 'No reason provided';
    final String status = data['status'] ?? 'pending';
    final Timestamp? dueDate = data['dueDate'];
    final Timestamp? appliedAt = data['appliedAt'];

    bool isOverdue = dueDate != null &&
        status.toLowerCase() == 'approved' &&
        _isOverdue(dueDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to Loan Detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoanDetailScreen(
                loanId: loanId,
                amount: amount,
                totalRepayment: totalRepayment,
                reason: reason,
                status: status,
                dueDate: dueDate,
                appliedAt: appliedAt,
                interest: data['interest'] ?? 0,
                termDays: data['termDays'] ?? 0,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Amount and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(status),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(status),
                          size: 14,
                          color: _getStatusColor(status),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Reason
              Text(
                reason,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Due date or applied date
              Row(
                children: [
                  Icon(
                    dueDate != null ? Icons.calendar_today : Icons.access_time,
                    size: 14,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dueDate != null
                        ? 'Due: ${_formatDate(dueDate)}'
                        : 'Applied: ${_formatDate(appliedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'OVERDUE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Total repayment (for active loans)
              if (status.toLowerCase() == 'approved') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total to repay:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '\$${totalRepayment.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ],

              // Repaid amount (for repaid loans)
              if (status.toLowerCase() == 'repaid') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Repaid amount:',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '\$${totalRepayment.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
