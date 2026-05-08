import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/loan_provider.dart';

class FinancialAdviceScreen extends StatefulWidget {
  const FinancialAdviceScreen({super.key});

  @override
  State<FinancialAdviceScreen> createState() => _FinancialAdviceScreenState();
}

class _FinancialAdviceScreenState extends State<FinancialAdviceScreen> {
  bool _isLoading = true;
  List<Map<String, String>> _insights = [];

  @override
  void initState() {
    super.initState();
    _generateSmartInsights();
  }

  Future<void> _generateSmartInsights() async {
    try {
      // 1. Gather all the user's LIVE data!
      final box = Hive.box('budgetBox');
      final monthlyLimit = box.get('monthlyLimit', defaultValue: 0.0);
      final spent = box.get('spentThisMonth', defaultValue: 0.0);

      final currentUser = Supabase.instance.client.auth.currentUser;
      final userName =
          currentUser?.userMetadata?['full_name']?.split(' ')[0] ?? 'Student';

      // Fetch balance from Supabase
      final response = await Supabase.instance.client
          .from('students')
          .select('balance')
          .eq('id', currentUser?.id ?? '')
          .maybeSingle();
      final balance = response?['balance'] ?? 0.0;

      // Get Loans
      final loanProvider = Provider.of<LoanProvider>(context, listen: false);
      final activeLoans = loanProvider.pendingLoans;
      final loanText = activeLoans.isNotEmpty
          ? 'They currently owe \$${activeLoans.first.amount} on an emergency loan.'
          : 'They have 0 active loans.';

      // 2. Build the exact prompt for Gemini
      final prompt =
          '''
      You are an expert, empathetic financial advisor for a university student named $userName.
      Analyze their current live financial data:
      - Total Monthly Budget Limit: \$$monthlyLimit
      - Amount Spent So Far This Month: \$$spent
      - Current Wallet Balance: \$$balance
      - Loan Status: $loanText

      Write exactly 3 short, highly personalized, and actionable financial insights based ONLY on this data.
      Format your response strictly as a list separated by the "|" character, like this:
      Title 1: Advice 1 | Title 2: Advice 2 | Title 3: Advice 3
      Make the advice sound modern, encouraging, and tailored to a university student.
      ''';

      // 3. Call the Gemini API
      final model = GenerativeModel(
        model:
            'gemini-2.5-flash', // <-- Swapped to the current, active 2026 model!
        apiKey: 'AIzaSyAfwh-dqap0mCxbt31iDJyS0GBEaGBz_4M',
      );

      final content = [Content.text(prompt)];
      final aiResponse = await model.generateContent(content);

      // 4. Parse the AI's response into beautiful UI cards
      if (aiResponse.text != null) {
        final splitInsights = aiResponse.text!.split('|');
        final List<Map<String, String>> parsedInsights = [];

        for (var item in splitInsights) {
          final parts = item.split(':');
          if (parts.length >= 2) {
            parsedInsights.add({
              'title': parts[0].trim(),
              'body': parts.sublist(1).join(':').trim(),
            });
          }
        }

        setState(() {
          _insights = parsedInsights;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Gemini Error: $e');
      setState(() {
        _isLoading = false;
        _insights = [
          {'title': 'Debug Error', 'body': e.toString()},
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0D0F14);
    const card = Color(0xFF1E2330);
    const textPrimary = Color(0xFFEEF0F6);
    const textSecondary = Color(0xFF8A90A2);
    const purple = Color(0xFFBF8FFF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text(
          'Gemini AI Advisor',
          style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: purple),
                  const SizedBox(height: 16),
                  Text(
                    'Analyzing your finances...',
                    style: TextStyle(
                      color: purple.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _insights.length,
              itemBuilder: (context, index) {
                final insight = _insights[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: purple.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: purple.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: purple,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              insight['title'] ?? 'Insight',
                              style: const TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              insight['body'] ?? '',
                              style: const TextStyle(
                                color: textSecondary,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
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
