import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Get the initialized Supabase client
  final _supabase = Supabase.instance.client;

  // ==========================================
  // FINANCIAL ADVICE FUNCTIONS
  // ==========================================

  /// Fetches all financial advice, newest first
  Future<List<dynamic>> getFinancialAdvice() async {
    try {
      final data = await _supabase
          .from('financial_advice')
          .select()
          .order('created_at', ascending: false);
      return data;
    } catch (e) {
      print('Error fetching advice: $e');
      return [];
    }
  }

  // ==========================================
  // MICRO-LOAN FUNCTIONS
  // ==========================================

  /// Fetches all micro-loans that haven't been fully funded yet
  Future<List<dynamic>> getPendingLoans() async {
    try {
      final data = await _supabase
          .from('micro_loans')
          .select()
          .eq('status', 'Pending')
          .order('created_at', ascending: false);
      return data;
    } catch (e) {
      print('Error fetching loans: $e');
      return [];
    }
  }

  /// Creates a new request for a micro-loan
  Future<bool> requestLoan({
    required String borrowerId,
    required double amount,
    required String reason,
  }) async {
    try {
      await _supabase.from('micro_loans').insert({
        'borrower_id': borrowerId,
        'amount': amount,
        'reason': reason,
        'status': 'Pending',
      });
      return true; // Success!
    } catch (e) {
      print('Error requesting loan: $e');
      return false; // Failed
    }
  }

  /// Funds a loan (updates the lender_id and changes status to Active)
  Future<bool> fundLoan({
    required String loanId,
    required String lenderId,
  }) async {
    try {
      await _supabase
          .from('micro_loans')
          .update({'lender_id': lenderId, 'status': 'Active'})
          .eq('id', loanId);
      return true; // Success!
    } catch (e) {
      print('Error funding loan: $e');
      return false; // Failed
    }
  }
}


// 9c003de2-e227-48f2-8f8a-7129e25594df