import 'package:flutter/material.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    required this.child,
    super.key,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: background,
        resizeToAvoidBottomInset: false,
        body: child,
      ),
    );
  }
}
