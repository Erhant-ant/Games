import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 800;
    final strings = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 70),
      color: AppColors.forest,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1500),
        child: SizedBox(
          height: isDesktop ? 440 : null,
          child: Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            children: [
              Expanded(
                child: Image.network(
                  'https://images.unsplash.com/photo-1595841696677-6489ff3f8cd1?auto=format&fit=crop&w=1200&q=85',
                  fit: BoxFit.cover,
                  height: isDesktop ? double.infinity : 300,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.olive),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(strings.text('storyEyebrow'), style: const TextStyle(color: Color(0xFFF5DC9C), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      const SizedBox(height: 14),
                      Text(strings.text('storyTitle'), style: const TextStyle(color: Colors.white, fontSize: 33, fontWeight: FontWeight.bold, height: 1.15)),
                      const SizedBox(height: 18),
                      Text(strings.text('storyBody'), style: const TextStyle(color: Color(0xFFEBF0DF), fontSize: 16, height: 1.55)),
                      const SizedBox(height: 25),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Color(0xFFF5DC9C))),
                        child: Text(strings.text('readStory')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
