import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/constants.dart';
import '../../core/theme/design_system.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController controller = Get.find();
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController(text: ApiConstants.loginValue);
    _passwordController = TextEditingController(text: ApiConstants.passwordValue);
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.55,
            child: CustomPaint(
              painter: _WavePainter(),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadii.card),
                          child: Image.asset(
                            'assets/icons/todo_infornet.png',
                            height: 96,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const Text(
                          'To-do Infornet',
                          style: AppTextStyles.loginTitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md + AppSpacing.xs),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _loginController,
                              decoration: const InputDecoration(
                                labelText: 'Usuário',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Obx(() {
                              final isLoading = controller.isLoading.value;
                              final error = controller.errorMessage.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: isLoading
                                        ? null
                                        : () => controller.login(
                                              login: _loginController.text.trim(),
                                              password: _passwordController.text,
                                            ),
                                    icon: isLoading
                                        ? const SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.login),
                                    label: Text(isLoading ? 'Entrando...' : 'Entrar'),
                                  ),
                                  if (error != null) ...[
                                    const SizedBox(height: 12),
                                    Text(
                                      error,
                                      style: AppTextStyles.body.copyWith(color: AppColors.error),
                                    ),
                                  ],
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.05,
        size.width * 0.5,
        size.height * 0.2,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.35,
        size.width,
        size.height * 0.2,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final wavePaint = Paint()
      ..shader = AppGradients.wave.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
