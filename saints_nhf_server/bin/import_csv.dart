// Development tool: imports the content CSVs straight into the database,
// without going through the admin screen and its file picker.
//
//   dart run bin/import_csv.dart santos.csv preguntas.csv libros.csv
//   dart run bin/import_csv.dart --apply santos.csv encuentros.csv
//
// Without --apply it only reports what would change, the same preview the
// admin panel shows. The kind of each file is taken from its name.
import 'dart:io';

import 'package:saints_nhf_server/src/admin/csv_catalog.dart';
import 'package:saints_nhf_server/src/generated/protocol.dart';
import 'package:saints_nhf_server/src/generated/serverpod.dart';

/// The kinds in the order they are applied: saints first, because the other
/// three hang off them.
const _kinds = ['santos', 'preguntas', 'libros', 'encuentros'];

Future<void> main(List<String> args) async {
  final apply = args.contains('--apply');
  final paths = args.where((a) => !a.startsWith('--')).toList();
  if (paths.isEmpty) {
    stderr.writeln(
      'Usage: dart run bin/import_csv.dart [--apply] <archivo.csv>...\n'
      'El nombre del archivo define qué es: santos, preguntas, libros o '
      'encuentros.',
    );
    exit(64);
  }

  final pod = Serverpod(['--mode', 'development', '--role', 'maintenance']);
  await pod.start();
  final session = await pod.createSession();
  var failed = false;
  try {
    paths.sort((a, b) => _kind(a).compareTo(_kind(b)));
    for (final path in paths) {
      final file = File(path);
      if (!file.existsSync()) {
        stderr.writeln('No existe $path');
        failed = true;
        continue;
      }
      final kind = _kinds[_kind(path)];
      final csv = file.readAsStringSync();
      final report = switch (kind) {
        'santos' => await CsvCatalog.importSaints(session, csv, apply: apply),
        'preguntas' => await CsvCatalog.importQuestions(
          session,
          csv,
          apply: apply,
        ),
        'libros' => await CsvCatalog.importBooks(session, csv, apply: apply),
        _ => await CsvCatalog.importMeetings(session, csv, apply: apply),
      };
      stdout.writeln(
        '\n${kind.toUpperCase()}  ${file.uri.pathSegments.last}\n'
        '  nuevos ${report.created} · actualizados ${report.updated} · '
        'sin cambios ${report.unchanged} · '
        '${report.applied ? 'APLICADO' : 'vista previa'}',
      );
      for (final error in report.errors) {
        stderr.writeln('  ERROR $error');
      }
      if (report.errors.isNotEmpty) failed = true;
      for (final change in report.changes.take(8)) {
        stdout.writeln('  · $change');
      }
      if (report.changes.length > 8) {
        stdout.writeln('  · … y ${report.changes.length - 8} más');
      }
    }
    if (apply && !failed) {
      final saints = await Saint.db.count(session);
      final questions = await Question.db.count(session);
      final books = await SaintBook.db.count(session);
      final meetings = await SaintMeeting.db.count(session);
      stdout.writeln(
        '\nEl catálogo queda con $saints santos, $questions preguntas, '
        '$books libros y $meetings encuentros.',
      );
    }
  } finally {
    await session.close();
  }
  await pod.shutdown(exitProcess: false);
  exit(failed ? 1 : 0);
}

/// Index in [_kinds], by the name of the file. "encuentros" is looked for
/// first, because "encuentros-santos.csv" also says "santo".
int _kind(String path) {
  final name = path.toLowerCase();
  if (name.contains('encuentro')) return 3;
  if (name.contains('santo')) return 0;
  if (name.contains('pregunta')) return 1;
  if (name.contains('libro')) return 2;
  throw ArgumentError(
    'No puedo deducir qué es "$path": el nombre tiene que decir '
    'santos, preguntas, libros o encuentros.',
  );
}
