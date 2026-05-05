// lib/models/expense.dart

class Expense {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String? note;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  // Convert Expense to Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date,
      'note': note,
    };
  }

  // Create Expense from Map (from Firebase)
  factory Expense.fromMap(Map<String, dynamic> map, String id) {
    return Expense(
      id: id,
      amount: map['amount']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      date: (map['date'] as DateTime?) ?? DateTime.now(),
      note: map['note'],
    );
  }
}