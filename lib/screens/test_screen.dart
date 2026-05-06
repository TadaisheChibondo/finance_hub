import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';
import '../services/supabase_service.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Database Test'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: supabaseService.getFinancialAdvice(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('No advice found in database.'));
          }

          final adviceList = snapshot.data!;
          return ListView.builder(
            itemCount: adviceList.length,
            itemBuilder: (context, index) {
              final advice = adviceList[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const Icon(Icons.lightbulb, color: Colors.amber),
                  title: Text(
                    advice['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(advice['content']),
                ),
              );
            },
          );
        },
      ),
      // NEW: The temporary button to test writing to the database
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // 1. Grab the provider we injected in main.dart
          final loanProvider = Provider.of<LoanProvider>(
            context,
            listen: false,
          );

          // 2. IMPORTANT: Paste the UUID of the student you created in Supabase here!
          const testBorrowerId = '9c003de2-e227-48f2-8f8a-7129e25594df';

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sending loan request...')),
          );

          // 3. Fire the request through the provider
          final success = await loanProvider.requestLoan(
            testBorrowerId,
            15.50,
            'Emergency printing funds',
          );

          // 4. Give UI feedback
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Success! Check Supabase Data.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed. Check debug console.')),
            );
          }
        },
        icon: const Icon(Icons.send),
        label: const Text('Test Loan'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
