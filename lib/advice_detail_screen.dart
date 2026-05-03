import 'package:flutter/material.dart';
import 'article.dart';

class AdviceDetailScreen extends StatelessWidget {
  final Article article;

  const AdviceDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              article.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5, // better readability
              ),
            ),
          ),
        ),
      ),
    );
  }
}