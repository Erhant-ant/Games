import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final items = [
      (Icons.spa_outlined, strings.text('benefitNaturalTitle'), strings.text('benefitNaturalBody')),
      (Icons.person_pin_outlined, strings.text('benefitCareTitle'), strings.text('benefitCareBody')),
      (Icons.workspace_premium_outlined, strings.text('benefitTrustTitle'), strings.text('benefitTrustBody')),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 3 : 1,
        crossAxisSpacing: 22,
        mainAxisSpacing: 18,
        childAspectRatio: isDesktop ? 2.5 : 3.4,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE3DAC8)), borderRadius: BorderRadius.circular(15)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.$1, color: AppColors.terracotta, size: 32),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.$2, style: const TextStyle(color: AppColors.forest, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 7),
                    Text(item.$3, style: const TextStyle(color: AppColors.ink, fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
