import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes.dart';
import '../../core/theme/design_system.dart';
import '../controllers/auth_controller.dart';
import '../controllers/todo_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final TodoController controller = Get.find();
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (!authController.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.login);
      });
      return;
    }
    try {
      await controller.fetchTodos();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.todoList);
      });
    } catch (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.login);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppGradients.primary,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  gradient: AppGradients.iconCard,
                  borderRadius: BorderRadius.circular(AppRadii.icon),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Image.asset(
                    'assets/icons/todo_infornet.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Infornet To-Do',
                style: AppTextStyles.splashTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Organize suas tarefas offline e online',
                style: AppTextStyles.splashSubtitle,
              ),
              const SizedBox(height: AppSpacing.xl),
              const SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
