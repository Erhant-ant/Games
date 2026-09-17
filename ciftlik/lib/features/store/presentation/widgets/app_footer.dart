import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import 'app_header.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final strings = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildColumn(strings.text('footerCorporate'), [strings.text('footerCorpZahide'), strings.text('footerCorpSocial'), strings.text('footerCorpFaq'), strings.text('footerCorpPrivacy'), strings.text('footerCorpDistance'), strings.text('footerCorpContact')])),
                    Expanded(child: _buildColumn(strings.text('footerCategories'), [strings.text('footerCatOliveOil'), strings.text('footerCatOlives'), strings.text('footerCatSoap'), strings.text('footerCatSpecial'), strings.text('footerCatGifts'), strings.text('footerCatCampaigns')])),
                    Expanded(child: _buildColumn(strings.text('footerAccount'), [strings.text('footerAccMembership'), strings.text('footerAccOrders'), strings.text('footerAccTracking'), strings.text('footerAccFavorites'), strings.text('footerAccGuide'), strings.text('footerAccPassword')])),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.text('footerNewsTitle'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: strings.text('footerNewsPlaceholder'),
                                    filled: true,
                                    fillColor: const Color(0xFFF9F9F9),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE0E0E0))),
                                child: Text(strings.text('footerNewsSubmit'), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(strings.text('footerAddress'), style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.ink)),
                          const SizedBox(height: 16),
                          const Text('T: 0532 123 45 67      info@zahidehanim.com', style: TextStyle(fontSize: 13, color: AppColors.ink)),
                        ],
                      ),
                    ),
                  ],
                ),
              if (!isDesktop)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandMark(),
                    const SizedBox(height: 24),
                    Text(strings.text('footerNewsTitle'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.ink)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: strings.text('footerNewsPlaceholder'),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Text(strings.text('footerNewsSubmit'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_box, size: 18, color: Colors.black87),
                        const SizedBox(width: 8),
                        Expanded(child: Text(strings.isTurkish ? 'Kampanya ve duyurular hakkında e-posta almak istiyorum.' : 'I want to receive emails about campaigns and announcements.', style: const TextStyle(fontSize: 12))),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Divider(color: Color(0xFFE0E0E0), height: 1),
                    _buildMobileAccordion(strings.text('footerCorporate'), [strings.text('footerCorpZahide'), strings.text('footerCorpSocial'), strings.text('footerCorpFaq'), strings.text('footerCorpPrivacy'), strings.text('footerCorpDistance'), strings.text('footerCorpContact')]),
                    const Divider(color: Color(0xFFE0E0E0), height: 1),
                    _buildMobileAccordion(strings.text('footerCategories'), [strings.text('footerCatOliveOil'), strings.text('footerCatOlives'), strings.text('footerCatSoap'), strings.text('footerCatSpecial'), strings.text('footerCatGifts'), strings.text('footerCatCampaigns')]),
                    const Divider(color: Color(0xFFE0E0E0), height: 1),
                    _buildMobileAccordion(strings.text('footerAccount'), [strings.text('footerAccMembership'), strings.text('footerAccOrders'), strings.text('footerAccTracking'), strings.text('footerAccFavorites'), strings.text('footerAccGuide'), strings.text('footerAccPassword')]),
                    const Divider(color: Color(0xFFE0E0E0), height: 1),
                    const SizedBox(height: 32),
                    Text(strings.text('footerAddress'), style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.ink)),
                    const SizedBox(height: 16),
                    const Text('T: 0532 123 45 67\ninfo@zahidehanim.com', style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.ink)),
                    const SizedBox(height: 24),
                  ],
                ),
              if (isDesktop) const SizedBox(height: 48),
              if (isDesktop) const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.facebook, size: 20), const SizedBox(width: 12),
                            const Icon(Icons.camera_alt, size: 20), const SizedBox(width: 12),
                            const Icon(Icons.play_circle_fill, size: 20),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(strings.text('footerCopyrightDetails'), style: const TextStyle(fontSize: 11, color: Colors.black54)),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.credit_card, size: 32, color: Colors.grey),
                      SizedBox(width: 8),
                      Icon(Icons.credit_card_outlined, size: 32, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
        const SizedBox(height: 20),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(item, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            )),
      ],
    );
  }

  Widget _buildMobileAccordion(String title, List<String> items) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.ink)),
        iconColor: AppColors.ink,
        collapsedIconColor: AppColors.ink,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 16),
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(item, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ),
        )).toList(),
      ),
    );
  }
}

