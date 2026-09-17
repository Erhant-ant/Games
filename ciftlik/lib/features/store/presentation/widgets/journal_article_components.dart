import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class JournalArticleComponents {
  static Widget buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.ink,
        ),
      ),
    );
  }

  static Widget buildSubTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.ink,
        ),
      ),
    );
  }

  static Widget buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          height: 1.8,
          color: Colors.black87,
        ),
      ),
    );
  }

  static Widget buildQuote(String text) {
    return Container(
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: AppColors.sand,
        border: Border(left: BorderSide(color: AppColors.terracotta, width: 4)),
        borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: AppColors.ink, height: 1.6),
      ),
    );
  }

  static Widget buildList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 18, height: 1.8, color: AppColors.terracotta, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  static TableRow buildTableRow(String col1, String col2, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? const Color(0xFFF9F7F1) : Colors.transparent,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            col1,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            col2,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
  
  static Widget buildBibliography(List<String> sources, bool isTurkish) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sage.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: AppColors.forest, size: 28),
              const SizedBox(width: 12),
              Text(
                isTurkish ? 'Kaynakça & Bilimsel Kaynaklar' : 'Bibliography & Scientific Sources',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...sources.map((source) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6.0),
                  child: Icon(Icons.circle, size: 8, color: AppColors.terracotta),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    source,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
