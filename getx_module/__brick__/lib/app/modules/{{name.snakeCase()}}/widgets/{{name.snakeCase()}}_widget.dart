import 'package:flutter/material.dart';

class {{name.pascalCase()}}Widget extends StatelessWidget {
  const {{name.pascalCase()}}Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text('{{name.pascalCase()}} Widget'),
    );
  }
}