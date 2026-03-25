import 'package:flutter/material.dart';

class {{pascalCase name}}Widget extends StatelessWidget {
  final String title;

  const {{pascalCase name}}Widget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(title),
    );
  }
}