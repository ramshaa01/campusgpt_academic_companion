import 'package:flutter/material.dart';
import '../theme.dart';

Future<void> showHelpDialog(
  BuildContext context, {
  required String title,
  required String body,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: CampusGptTheme.surfaceContainerHigh,
      title: Row(
        children: [
          const Icon(Icons.help_outline, color: CampusGptTheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: CampusGptTheme.onSurface),
            ),
          ),
        ],
      ),
      content: Text(
        body,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CampusGptTheme.onSurfaceVariant,
            ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it', style: TextStyle(color: CampusGptTheme.primary)),
        ),
      ],
    ),
  );
}
