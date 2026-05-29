import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresh_leaf/app/modules/login/controllers/login_controller.dart';
import 'package:fresh_leaf/app/modules/login/widgets/login_widget.dart';
import 'package:fresh_leaf/shared/widgets/exit_confirmation_sheet.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showExitConfirmationSheet(context);
        if (shouldExit && context.mounted) {
          await SystemNavigator.pop();
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: LoginFormContent(
                        controller: controller,
                        constraints: constraints,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
