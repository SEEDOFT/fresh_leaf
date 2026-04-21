import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.scrollable = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.resizeToAvoidBottomInset = true,
    this.onRefresh,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final bool safeAreaTop;
  final bool safeAreaBottom;
  final bool resizeToAvoidBottomInset;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    Widget content = Padding(
      padding: padding,
      child: body,
    );

    if (scrollable) {
      content = SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: content,
      );
    }

    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        top: safeAreaTop,
        bottom: safeAreaBottom,
        child: content,
      ),
    );
  }
}
