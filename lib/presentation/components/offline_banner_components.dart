import 'package:flutter/material.dart';

import '../../core/theme/design_system.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warning.withOpacity(0.15),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: const Text(
        'Modo offline: exibindo dados salvos.',
        textAlign: TextAlign.center,
        style: AppTextStyles.banner,
      ),
    );
  }
}
