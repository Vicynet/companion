class BibleQuery {
  final String? book;
  final int? chapter;
  final int? verse;
  final String? translation;
  final String? language;
  final String? conversationalQuery;

  BibleQuery({
    this.book,
    this.chapter,
    this.verse,
    this.translation,
    this.language,
    this.conversationalQuery,
  });
}
