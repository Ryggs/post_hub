import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    required this.onRetry,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 60,
              ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of (context).textTheme.titleMedium,
              textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }




}