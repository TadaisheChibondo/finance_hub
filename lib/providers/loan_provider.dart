import 'package:flutter/material.dart';
import '../models/loan_model.dart';
import '../services/supabase_service.dart';

class LoanProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  List<LoanModel> _pendingLoans = [];
  bool _isLoading = false;

  // Getters for the UI to read the data
  List<LoanModel> get pendingLoans => _pendingLoans;
  bool get isLoading => _isLoading;

  /// Fetches the latest pending loans from the database
  Future<void> fetchPendingLoans() async {
    _isLoading = true;
    notifyListeners(); // Tells the UI to show a loading spinner

    final rawData = await _supabaseService.getPendingLoans();

    // Map the raw JSON data into our clean LoanModel objects
    _pendingLoans = rawData.map((data) => LoanModel.fromJson(data)).toList();

    _isLoading = false;
    notifyListeners(); // Tells the UI to hide the spinner and show the new data
  }

  /// Sends a new loan request to the database
  Future<bool> requestLoan(
    String borrowerId,
    double amount,
    String reason,
  ) async {
    final success = await _supabaseService.requestLoan(
      borrowerId: borrowerId,
      amount: amount,
      reason: reason,
    );

    if (success) {
      // If it worked, immediately fetch the updated list so the UI refreshes
      await fetchPendingLoans();
    }
    return success;
  }
}
