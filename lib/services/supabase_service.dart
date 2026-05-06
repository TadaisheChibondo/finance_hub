// lib/services/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetches pending loans from the database
  Future<List<Map<String, dynamic>>> getPendingLoans() async {
    final response = await _client
        .from('micro_loans') // FIXED: changed from 'loans' to 'micro_loans'
        .select()
        .eq('status', 'Pending') // FIXED: Capitalized to match the DB default
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetches financial advice items from the database
  Future<List<Map<String, dynamic>>> getFinancialAdvice() async {
    final response = await _client.from('financial_advice').select();
    return List<Map<String, dynamic>>.from(response);
  }

  /// Submits a new loan request to the database
  Future<bool> requestLoan({
    required String borrowerId,
    required double amount,
    required String reason,
  }) async {
    try {
      await _client.from('micro_loans').insert({
        // FIXED: changed from 'loans' to 'micro_loans'
        'borrower_id': borrowerId,
        'amount': amount,
        'reason': reason,
        'status': 'Pending', // FIXED: Capitalized to match the DB default
      });
      // Note: Removed 'created_at' from the insert because Supabase handles that automatically!

      return true;
    } catch (e) {
      print('Error requesting loan: $e');
      return false;
    }
  }
}
