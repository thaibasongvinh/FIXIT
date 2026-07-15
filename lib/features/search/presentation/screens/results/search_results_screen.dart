import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultsScreen extends ConsumerWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results for: $query',
          style: const TextStyle(color: Color(0xFF2450A4), fontWeight: FontWeight.w900)
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2450A4)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Color(0xFFD7D7D7)),
            SizedBox(height: 16),
            Text(
              'No results found', 
              style: TextStyle(fontSize: 18, color: Color(0xFF757575), fontWeight: FontWeight.w600)
            ),
          ],
        )
      ),
    );
  }
}
