import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

/// Labels and icons for the kinds of recommended book.
extension BookKindX on BookKind {
  /// Whether the saint wrote it. The ficha shows these apart from the books
  /// written about them.
  bool get byTheSaint =>
      this == BookKind.obra ||
      this == BookKind.autobiografia ||
      this == BookKind.compilado;

  String get label => switch (this) {
    BookKind.obra => 'Obra suya',
    BookKind.autobiografia => 'Autobiografía',
    BookKind.compilado => 'Compilado de escritos',
    BookKind.biografia => 'Biografía',
    BookKind.estudio => 'Estudio',
    BookKind.novela => 'Novela histórica',
    BookKind.infantil => 'Para chicos',
  };

  IconData get icon => switch (this) {
    BookKind.obra => Icons.edit_note_rounded,
    BookKind.autobiografia => Icons.history_edu_rounded,
    BookKind.compilado => Icons.collections_bookmark_rounded,
    BookKind.biografia => Icons.person_outline_rounded,
    BookKind.estudio => Icons.school_outlined,
    BookKind.novela => Icons.auto_stories_rounded,
    BookKind.infantil => Icons.child_care_rounded,
  };
}

/// The books the saint wrote, in the order the server sent them.
List<SaintBook> writtenBySaint(List<SaintBook> books) =>
    books.where((b) => b.kind.byTheSaint).toList();

/// The books written about the saint.
List<SaintBook> writtenAboutSaint(List<SaintBook> books) =>
    books.where((b) => !b.kind.byTheSaint).toList();

/// Heading of the saint's own writing, e.g. "Escritos de ella".
String writingsHeading(String saintName) =>
    'Escritos ${_isFeminine(saintName) ? 'de ella' : 'de él'}';

/// Heading of the books about the saint, e.g. "Libros sobre ella".
String aboutHeading(String saintName) =>
    'Libros sobre ${_isFeminine(saintName) ? 'ella' : 'él'}';

bool _isFeminine(String saintName) {
  final n = saintName.trim().toLowerCase();
  return n.startsWith('santa ') || n.startsWith('beata ');
}
