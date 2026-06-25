import 'package:flutter/material.dart';
import '../theme.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.radius = 20,
  });

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radius,
      backgroundColor: CampusGptTheme.primaryContainer.withOpacity(0.3),
      child: Text(
        initial,
        style: TextStyle(
          color: CampusGptTheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.9,
        ),
      ),
    );
  }
}
