class LoanModel {
  final String id;
  final String borrowerId;
  final String? lenderId; // Nullable because it might not be funded yet
  final double amount;
  final String reason;
  final String status;
  final DateTime createdAt;

  LoanModel({
    required this.id,
    required this.borrowerId,
    this.lenderId,
    required this.amount,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  // A factory constructor to easily convert Supabase JSON into this Dart object
  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'],
      borrowerId: json['borrower_id'],
      lenderId: json['lender_id'],
      amount: (json['amount'] as num)
          .toDouble(), // Safely handle ints or doubles from DB
      reason: json['reason'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
