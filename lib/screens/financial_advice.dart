import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class FinancialAdviceScreen extends StatelessWidget {
  const FinancialAdviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = SupabaseService();
    const bg = Color(0xFF0D0F14); // Matching your team's palette

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Smart Insights'),
        backgroundColor: const Color(0xFF161A23),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: supabase.getFinancialAdvice(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00E5A0)),
            );
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('No advice available yet.'));
          }

          final advice = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: advice.length,
            itemBuilder: (context, index) {
              return Card(
                color: const Color(0xFF1E2330),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.lightbulb,
                    color: Color(0xFFFFB547),
                  ),
                  title: Text(
                    advice[index]['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    advice[index]['content'],
                    style: const TextStyle(color: Color(0xFF8A90A2)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
