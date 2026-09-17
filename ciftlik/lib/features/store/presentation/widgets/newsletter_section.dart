import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class NewsletterSection extends StatelessWidget {
  const NewsletterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 76),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 58),
      color: AppColors.sage,
      child: Column(
        children: [
          Text(strings.text('newsletterEyebrow'), style: const TextStyle(color: AppColors.terracotta, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 2)),
          const SizedBox(height: 10),
          Text(strings.text('newsletterTitle'), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.forest, fontSize: 29, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          Text(strings.text('newsletterBody'), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ink)),
          const SizedBox(height: 23),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: strings.text('email'),
                      filled: true,
                      fillColor: Colors.white,
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(backgroundColor: AppColors.forest, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
                  child: Text(strings.text('subscribe')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
