import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/register/widgets/register_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgCream,
        body: SafeArea(
          child: Column(
            children: [
              // Compact app ba
              // Form content fills the rest and scrolls only when needed
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: media.viewInsets.bottom + 12,
                      ),
                      child: RegisterFormContent(
                        controller: controller,
                        constraints: constraints,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
