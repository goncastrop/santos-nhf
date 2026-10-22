import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../theme.dart';

/// Labels, colors and emblems for the liturgical titles of a saint.
///
/// The feminine form is chosen from how the name starts ("Santa", "Beata"),
/// which is how the catalog always writes them.
extension SaintTitleX on SaintTitle {
  /// Label for a saint whose name is [saintName].
  String labelFor(String saintName) =>
      isFeminineName(saintName) ? _feminine : _masculine;

  String get _masculine => switch (this) {
    SaintTitle.doctor => 'Doctor de la Iglesia',
    SaintTitle.apostol => 'Apóstol',
    SaintTitle.evangelista => 'Evangelista',
    SaintTitle.papa => 'Papa',
    SaintTitle.obispo => 'Obispo',
    SaintTitle.presbitero => 'Presbítero',
    SaintTitle.diacono => 'Diácono',
    SaintTitle.martir => 'Mártir',
    SaintTitle.virgen => 'Virgen',
    SaintTitle.fundador => 'Fundador',
    SaintTitle.religioso => 'Religioso',
    SaintTitle.misionero => 'Misionero',
    SaintTitle.confesor => 'Confesor',
    SaintTitle.laico => 'Laico',
  };

  String get _feminine => switch (this) {
    SaintTitle.doctor => 'Doctora de la Iglesia',
    SaintTitle.apostol => 'Apóstol',
    SaintTitle.evangelista => 'Evangelista',
    SaintTitle.papa => 'Papa',
    SaintTitle.obispo => 'Obispa',
    SaintTitle.presbitero => 'Presbítera',
    SaintTitle.diacono => 'Diaconisa',
    SaintTitle.martir => 'Mártir',
    SaintTitle.virgen => 'Virgen',
    SaintTitle.fundador => 'Fundadora',
    SaintTitle.religioso => 'Religiosa',
    SaintTitle.misionero => 'Misionera',
    SaintTitle.confesor => 'Confesora',
    SaintTitle.laico => 'Laica',
  };

  /// Neutral label for lists and admin screens.
  String get adminLabel => switch (this) {
    SaintTitle.doctor => 'Doctor(a) de la Iglesia',
    SaintTitle.fundador => 'Fundador(a)',
    SaintTitle.religioso => 'Religioso(a)',
    SaintTitle.misionero => 'Misionero(a)',
    SaintTitle.confesor => 'Confesor(a)',
    SaintTitle.laico => 'Laico(a)',
    SaintTitle.obispo => 'Obispo(a)',
    SaintTitle.presbitero => 'Presbítero(a)',
    SaintTitle.diacono => 'Diácono(a)',
    _ => _masculine,
  };

  IconData get icon => switch (this) {
    SaintTitle.doctor => Icons.menu_book_rounded,
    SaintTitle.apostol => Icons.workspace_premium_rounded,
    SaintTitle.evangelista => Icons.auto_stories_rounded,
    SaintTitle.papa => Icons.account_balance_rounded,
    SaintTitle.obispo => Icons.church_rounded,
    SaintTitle.presbitero => Icons.church_outlined,
    SaintTitle.diacono => Icons.volunteer_activism_rounded,
    SaintTitle.martir => Icons.local_fire_department_rounded,
    SaintTitle.virgen => Icons.local_florist_rounded,
    SaintTitle.fundador => Icons.foundation_rounded,
    SaintTitle.religioso => Icons.self_improvement_rounded,
    SaintTitle.misionero => Icons.travel_explore_rounded,
    SaintTitle.confesor => Icons.shield_moon_rounded,
    SaintTitle.laico => Icons.groups_rounded,
  };

  /// Emblem color. Follows the liturgy: red for martyrs, white for virgins,
  /// gold for the rest.
  Color get color => switch (this) {
    SaintTitle.martir => Palette.crimsonLight,
    SaintTitle.virgen => Palette.parchment,
    _ => Palette.goldLight,
  };
}

/// Whether the catalog writes [saintName] as a woman: "Santa" or "Beata".
bool isFeminineName(String saintName) {
  final n = saintName.trim().toLowerCase();
  return n.startsWith('santa ') || n.startsWith('beata ');
}

/// All the titles of a saint as one phrase, e.g. "Virgen y doctora de la
/// Iglesia".
String? titlesPhrase(String saintName, List<SaintTitle>? titles) {
  if (titles == null || titles.isEmpty) return null;
  final sorted = [...titles]..sort((a, b) => a.index.compareTo(b.index));
  final labels = sorted.map((t) => t.labelFor(saintName)).toList();
  final phrase = labels.length == 1
      ? labels.single
      : '${labels.sublist(0, labels.length - 1).join(', ')} y ${labels.last.toLowerCase()}';
  return phrase;
}

/// The saint's titles ordered from the most distinctive down.
List<SaintTitle> sortedTitles(List<SaintTitle>? titles) {
  if (titles == null) return const [];
  return [...titles]..sort((a, b) => a.index.compareTo(b.index));
}
