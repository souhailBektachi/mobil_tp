import 'package:flutter/material.dart';

class SrsReviewScreen extends StatelessWidget {
  const SrsReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SRS Review'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flash_on, size: 64),  // Changed from flash_card to flash_on
            const SizedBox(height: 16),
            const Text(
              'Spaced Repetition Review',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            const Text(
              'Review vocabulary using spaced repetition',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start Review Session'),
            ),
          ],
        ),
      ),
    );
  }
}
