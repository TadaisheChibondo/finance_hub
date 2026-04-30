import 'package:flutter/material.dart';
import '../services/supabase_service.dart'; // Make sure this path points to your service file

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the service we wrote earlier
    final supabaseService = SupabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Database Test'),
        backgroundColor: Colors.green,
      ),
      // FutureBuilder automatically handles the loading state while waiting for the internet
      body: FutureBuilder<List<dynamic>>(
        future: supabaseService.getFinancialAdvice(),
        builder: (context, snapshot) {
          // If it's loading, show a spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // If there is an error or no data
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('No advice found in database.'));
          }

          // If we have data, build a list!
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
    );
  }
}
