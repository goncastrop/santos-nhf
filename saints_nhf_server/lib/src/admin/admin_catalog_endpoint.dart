import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'admin_scope.dart';
import 'csv_catalog.dart';

/// CSV export and import of saints, questions, books and meetings, for
/// maintaining the content in a spreadsheet.
class AdminCatalogEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {AppScope.admin};

  Future<String> exportSaintsCsv(Session session) =>
      CsvCatalog.exportSaints(session);

  Future<String> exportQuestionsCsv(Session session) =>
      CsvCatalog.exportQuestions(session);

  Future<String> exportBooksCsv(Session session) =>
      CsvCatalog.exportBooks(session);

  Future<String> exportMeetingsCsv(Session session) =>
      CsvCatalog.exportMeetings(session);

  /// With [apply] false, only reports what would change.
  Future<ImportReport> importSaintsCsv(
    Session session,
    String csv,
    bool apply,
  ) => CsvCatalog.importSaints(session, csv, apply: apply);

  Future<ImportReport> importQuestionsCsv(
    Session session,
    String csv,
    bool apply,
  ) => CsvCatalog.importQuestions(session, csv, apply: apply);

  Future<ImportReport> importBooksCsv(
    Session session,
    String csv,
    bool apply,
  ) => CsvCatalog.importBooks(session, csv, apply: apply);

  Future<ImportReport> importMeetingsCsv(
    Session session,
    String csv,
    bool apply,
  ) => CsvCatalog.importMeetings(session, csv, apply: apply);
}
