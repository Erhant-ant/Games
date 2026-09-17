import 'package:flutter/material.dart';

class JournalArticle {
  final String id;
  final String titleTr;
  final String titleEn;
  final String summaryTr;
  final String summaryEn;
  final String coverImageUrl;
  final List<String> tagsTr;
  final List<String> tagsEn;
  final String date;
  final String author;
  final String authorAvatarUrl;
  final Widget Function(BuildContext, bool isTurkish) contentBuilder;

  const JournalArticle({
    required this.id,
    required this.titleTr,
    required this.titleEn,
    required this.summaryTr,
    required this.summaryEn,
    required this.coverImageUrl,
    required this.tagsTr,
    required this.tagsEn,
    required this.date,
    required this.author,
    required this.authorAvatarUrl,
    required this.contentBuilder,
  });
}
