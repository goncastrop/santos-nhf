import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

/// Export and import the catalog as CSV files.
class AdminCatalogScreen extends StatefulWidget {
  const AdminCatalogScreen({super.key});

  @override
  State<AdminCatalogScreen> createState() => _AdminCatalogScreenState();
}

/// The four files the content is maintained in.
enum _Sheet {
  saints('Santos', 'santos'),
  questions('Preguntas', 'preguntas'),
  books('Libros', 'libros'),
  meetings('Encuentros', 'encuentros');

  const _Sheet(this.title, this.fileName);

  final String title;
  final String fileName;

  Future<String> export() => switch (this) {
    _Sheet.saints => client.adminCatalog.exportSaintsCsv(),
    _Sheet.questions => client.adminCatalog.exportQuestionsCsv(),
    _Sheet.books => client.adminCatalog.exportBooksCsv(),
    _Sheet.meetings => client.adminCatalog.exportMeetingsCsv(),
  };

  Future<ImportReport> import(String csv, {required bool apply}) =>
      switch (this) {
        _Sheet.saints => client.adminCatalog.importSaintsCsv(csv, apply),
        _Sheet.questions => client.adminCatalog.importQuestionsCsv(csv, apply),
        _Sheet.books => client.adminCatalog.importBooksCsv(csv, apply),
        _Sheet.meetings => client.adminCatalog.importMeetingsCsv(csv, apply),
      };
}

class _AdminCatalogScreenState extends State<AdminCatalogScreen> {
  bool _busy = false;
  String? _pendingCsv;
  _Sheet _pendingSheet = _Sheet.saints;
  String? _pendingFileName;
  ImportReport? _preview;

  Future<void> _export(_Sheet sheet) async {
    setState(() => _busy = true);
    try {
      final csv = await sheet.export();
      final stamp = DateTime.now().toIso8601String().substring(0, 10);
      final name = '${sheet.fileName}-$stamp';
      // A BOM makes Excel open UTF-8 accents correctly.
      final bytes = utf8.encode('﻿$csv');
      await FileSaver.instance.saveFile(
        name: name,
        bytes: bytes,
        fileExtension: 'csv',
        mimeType: MimeType.csv,
      );
      if (mounted) showMessage(context, 'Archivo $name.csv generado.');
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pick(_Sheet sheet) async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'CSV', extensions: ['csv'], mimeTypes: ['text/csv']),
      ],
    );
    if (file == null) return;
    final csv = await file.readAsString();
    setState(() {
      _pendingCsv = csv;
      _pendingSheet = sheet;
      _pendingFileName = file.name;
      _preview = null;
      _busy = true;
    });
    try {
      final report = await sheet.import(csv, apply: false);
      if (mounted) setState(() => _preview = report);
    } catch (e) {
      if (mounted) {
        showMessage(context, friendlyError(e), error: true);
        setState(() => _pendingCsv = null);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _apply() async {
    final csv = _pendingCsv;
    if (csv == null) return;
    setState(() => _busy = true);
    try {
      final report = await _pendingSheet.import(csv, apply: true);
      if (!mounted) return;
      final state = AppState.of(context);
      await Future.wait([state.refreshCatalog(), state.refreshCollection()]);
      if (!mounted) return;
      setState(() {
        _preview = report;
        _pendingCsv = null;
      });
      showMessage(
        context,
        'Importado: ${report.created} nuevos, ${report.updated} actualizados.',
      );
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final preview = _preview;
    return Scaffold(
      appBar: AppBar(title: const Text('IMPORTAR · EXPORTAR')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Text(
            'Mantené el contenido en una planilla. Exportá el CSV, editalo en '
            'Google Sheets o Excel y volvé a importarlo. Los santos se '
            'identifican por su slug, las preguntas y los libros por su id, '
            'y los encuentros por el par de slugs; las filas nuevas se crean '
            'y las existentes se actualizan. '
            'Nada se borra desde acá.',
            style: textTheme.bodyMedium?.copyWith(color: Palette.parchmentDim),
          ),
          const SizedBox(height: 20),
          _Section(
            title: _Sheet.saints.title,
            hint:
                'Columnas: slug, nombre, titulo, titulos_liturgicos, '
                'fiesta_mes, fiesta_dia, nacimiento, nacimiento_aprox, '
                'muerte, muerte_aprox, temporada, capitulo, youtube_url, '
                'estado, los seis puntajes, biografia y oracion_texto. La '
                'ilustración se sube desde la app.',
            onExport: _busy ? null : () => _export(_Sheet.saints),
            onImport: _busy ? null : () => _pick(_Sheet.saints),
          ),
          const SizedBox(height: 14),
          _Section(
            title: _Sheet.questions.title,
            hint:
                'Columnas: id (vacío para crear), santo_slug, pregunta, '
                'opcion_a a opcion_d y correcta (A, B, C o D).',
            onExport: _busy ? null : () => _export(_Sheet.questions),
            onImport: _busy ? null : () => _pick(_Sheet.questions),
          ),
          const SizedBox(height: 14),
          _Section(
            title: _Sheet.books.title,
            hint:
                'Columnas: id (vacío para crear), santo_slug, titulo, autor, '
                'tipo (obra, autobiografia, compilado, biografia, estudio, '
                'novela, infantil), anio, editorial, link y nota.',
            onExport: _busy ? null : () => _export(_Sheet.books),
            onImport: _busy ? null : () => _pick(_Sheet.books),
          ),
          const SizedBox(height: 14),
          _Section(
            title: _Sheet.meetings.title,
            hint:
                'Columnas: santo_slug y otro_santo_slug, una fila por cada '
                'par de santos que se conocieron en vida, en cualquier orden. '
                'Se agregan los pares nuevos; para quitar uno, editá el santo '
                'y usá el botón "Con quién se conoció".',
            onExport: _busy ? null : () => _export(_Sheet.meetings),
            onImport: _busy ? null : () => _pick(_Sheet.meetings),
          ),
          if (_busy) ...[const SizedBox(height: 24), const LoadingView()],
          if (preview != null) ...[
            const SizedBox(height: 24),
            Eyebrow(
              preview.applied
                  ? 'Importación aplicada'
                  : 'Vista previa · ${_pendingFileName ?? ''}',
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${preview.created} nuevos · ${preview.updated} '
                      'actualizados · ${preview.unchanged} sin cambios'
                      '${preview.errors.isEmpty ? '' : ' · ${preview.errors.length} errores'}',
                      style: textTheme.titleMedium,
                    ),
                    if (preview.errors.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      for (final e in preview.errors)
                        Text(
                          e,
                          style: textTheme.bodySmall?.copyWith(
                            color: Palette.crimsonLight,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        'Corregí los errores en la planilla y volvé a elegir '
                        'el archivo. No se importa nada mientras haya errores.',
                        style: textTheme.bodySmall?.copyWith(
                          color: Palette.parchmentDim,
                        ),
                      ),
                    ],
                    if (preview.changes.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      for (final c in preview.changes.take(60))
                        Text('• $c', style: textTheme.bodySmall),
                      if (preview.changes.length > 60)
                        Text(
                          '… y ${preview.changes.length - 60} más',
                          style: textTheme.bodySmall,
                        ),
                    ],
                    if (!preview.applied &&
                        preview.errors.isEmpty &&
                        _pendingCsv != null) ...[
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _busy ? null : _apply,
                        icon: const Icon(Icons.check_rounded),
                        label: Text(
                          'APLICAR ${preview.created + preview.updated} CAMBIOS',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.hint,
    required this.onExport,
    required this.onImport,
  });

  final String title;
  final String hint;
  final VoidCallback? onExport;
  final VoidCallback? onImport;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              hint,
              style: textTheme.bodySmall?.copyWith(color: Palette.parchmentDim),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: onExport,
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('EXPORTAR CSV'),
                ),
                FilledButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.upload_file_rounded, size: 18),
                  label: const Text('IMPORTAR CSV'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
