import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../state/app_state.dart';
import '../../theme.dart';
import '../../utils/feast.dart';
import '../../utils/scores.dart';
import '../../utils/titles.dart';
import '../../widgets/common.dart';
import '../../widgets/saint_card.dart';
import '../../widgets/saint_illustration.dart';
import 'admin_books_screen.dart';
import 'admin_meetings_screen.dart';
import 'admin_questions_screen.dart';
import 'admin_revisions_screen.dart';

/// Create or edit a saint: texts, feast, scores, status and illustration.
///
/// Existing saints are always fetched fresh from the server before editing,
/// so a stale list can never lead to overwriting someone else's changes.
class AdminSaintEditScreen extends StatelessWidget {
  const AdminSaintEditScreen({super.key, this.saintId});

  /// Null to create a new saint.
  final int? saintId;

  @override
  Widget build(BuildContext context) {
    if (saintId == null) return const _SaintForm(saint: null);
    return _FreshSaint(
      saintId: saintId!,
      builder: (saint) => _SaintForm(saint: saint),
    );
  }
}

/// Loads a saint by id and hands it to [builder].
class _FreshSaint extends StatefulWidget {
  const _FreshSaint({required this.saintId, required this.builder});

  final int saintId;
  final Widget Function(Saint saint) builder;

  @override
  State<_FreshSaint> createState() => _FreshSaintState();
}

class _FreshSaintState extends State<_FreshSaint> {
  late Future<Saint> _future = client.adminSaint.get(widget.saintId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Saint>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('EDITAR')),
            body: ErrorView(
              error: snapshot.error!,
              onRetry: () => setState(() {
                _future = client.adminSaint.get(widget.saintId);
              }),
            ),
          );
        }
        final saint = snapshot.data;
        if (saint == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('EDITAR')),
            body: const LoadingView(),
          );
        }
        return widget.builder(saint);
      },
    );
  }
}

class _SaintForm extends StatefulWidget {
  const _SaintForm({required this.saint});

  final Saint? saint;

  @override
  State<_SaintForm> createState() => _SaintFormState();
}

class _SaintFormState extends State<_SaintForm> {
  /// Keep in sync with `AdminSaintEndpoint.maxIllustrationBytes`. The bytes
  /// are base64 encoded in the request, so this stays well below the server's
  /// `maxRequestSize` of 10 MB.
  static const _maxIllustrationBytes = 6 * 1024 * 1024;

  final _formKey = GlobalKey<FormState>();
  late Saint _saint = widget.saint ?? Saint(name: '', slug: '');
  String? _illustrationUrl;
  bool _saving = false;
  bool _uploading = false;
  bool _slugEdited = false;

  late final _name = TextEditingController(text: _saint.name);
  late final _slug = TextEditingController(text: _saint.slug);
  late final _title = TextEditingController(text: _saint.title ?? '');
  late final _day = TextEditingController(
    text: _saint.feastDay?.toString() ?? '',
  );
  late final _birthYear = TextEditingController(
    text: _saint.birthYear?.toString() ?? '',
  );
  late final _deathYear = TextEditingController(
    text: _saint.deathYear?.toString() ?? '',
  );
  late final _season = TextEditingController(
    text: _saint.season?.toString() ?? '',
  );
  late final _episode = TextEditingController(
    text: _saint.episode?.toString() ?? '',
  );
  late final _youtube = TextEditingController(text: _saint.youtubeUrl ?? '');
  late final _bio = TextEditingController(text: _saint.bio);
  late final _prayer = TextEditingController(text: _saint.prayer ?? '');
  int? _month;
  late bool _birthApprox = _saint.birthApprox;
  late bool _deathApprox = _saint.deathApprox;

  bool get isNew => widget.saint == null;

  @override
  void initState() {
    super.initState();
    _month = _saint.feastMonth;
    _slugEdited = !isNew;
    if (_saint.id != null && _saint.illustrationPath != null) {
      client.adminSaint.illustrationUrl(_saint.id!).then((url) {
        if (mounted) setState(() => _illustrationUrl = url);
      });
    }
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _slug,
      _title,
      _day,
      _birthYear,
      _deathYear,
      _season,
      _episode,
      _youtube,
      _bio,
      _prayer,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  static String slugify(String input) {
    const from = 'áàäâãéèëêíìïîóòöôõúùüûñç';
    const to = 'aaaaaeeeeiiiiooooouuuunc';
    var s = input.toLowerCase();
    for (var i = 0; i < from.length; i++) {
      s = s.replaceAll(from[i], to[i]);
    }
    s = s.replaceAll(RegExp('[^a-z0-9]+'), '-');
    return s.replaceAll(RegExp('^-+|-+\$'), '');
  }

  Saint _collect() {
    int? parse(TextEditingController c) => int.tryParse(c.text.trim());
    String? blankToNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    return _saint.copyWith(
      name: _name.text.trim(),
      slug: _slug.text.trim(),
      title: blankToNull(_title),
      feastMonth: _month,
      feastDay: _month == null ? null : parse(_day),
      birthYear: parse(_birthYear),
      birthApprox: _birthApprox,
      deathYear: parse(_deathYear),
      deathApprox: _deathApprox,
      season: parse(_season),
      episode: parse(_episode),
      youtubeUrl: blankToNull(_youtube),
      bio: _bio.text.trim(),
      prayer: blankToNull(_prayer),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final saint = _collect();
    String? note;
    if (!isNew) {
      note = await showDialog<String>(
        context: context,
        builder: (_) => const _NoteDialog(),
      );
      if (note == null) return; // Cancelled.
    }
    setState(() => _saving = true);
    try {
      final saved = await client.adminSaint.save(saint, note);
      if (!mounted) return;
      final state = AppState.of(context);
      await Future.wait([state.refreshCatalog(), state.refreshCollection()]);
      if (!mounted) return;
      if (isNew) {
        // Stay on the page so the illustration can be uploaded right away.
        setState(() => _saint = saved);
        showMessage(context, 'Santo creado. Ahora podés subir la ilustración.');
      } else {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar santo'),
        content: Text(
          'Se borra ${_saint.name}, su historial y las cartas que los '
          'usuarios ya tengan de él. Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Palette.crimson),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await client.adminSaint.delete(_saint.id!);
      if (!mounted) return;
      final state = AppState.of(context);
      await Future.wait([state.refreshCatalog(), state.refreshCollection()]);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  Future<void> _pickIllustration() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    final ext = _extensionOf(picked);
    if (!mounted) return;
    if (bytes.length > _maxIllustrationBytes) {
      final mb = (bytes.length / (1024 * 1024)).toStringAsFixed(1);
      showMessage(
        context,
        'La imagen pesa $mb MB y el máximo es '
        '${_maxIllustrationBytes ~/ (1024 * 1024)} MB. '
        'Reducila antes de subirla.',
        error: true,
      );
      return;
    }
    final state = AppState.of(context);
    setState(() => _uploading = true);
    try {
      final id = _saint.id!;
      // The bytes go to our own server, which stores them. Uploading straight
      // to the storage bucket is blocked by its cross-origin rules on the web.
      final saved = await client.adminSaint.uploadIllustration(
        id,
        ext,
        ByteData.sublistView(bytes),
      );
      final url = await client.adminSaint.illustrationUrl(id);
      if (!mounted) return;
      setState(() {
        _saint = saved;
        _illustrationUrl = url;
      });
      await Future.wait([state.refreshCatalog(), state.refreshCollection()]);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  String _extensionOf(XFile file) {
    final mime = file.mimeType ?? '';
    if (mime.contains('png')) return 'png';
    if (mime.contains('webp')) return 'webp';
    if (mime.contains('jpeg') || mime.contains('jpg')) return 'jpg';
    final name = file.name.toLowerCase();
    final dot = name.lastIndexOf('.');
    return dot == -1 ? 'png' : name.substring(dot + 1);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final preview = _collect();
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'NUEVO SANTO' : 'EDITAR'),
        actions: [
          if (!isNew)
            IconButton(
              tooltip: 'Preguntas',
              icon: const Icon(Icons.quiz_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdminQuestionsScreen(saint: _saint),
                ),
              ),
            ),
          if (!isNew)
            IconButton(
              tooltip: 'Libros recomendados',
              icon: const Icon(Icons.menu_book_outlined),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdminBooksScreen(saint: _saint),
                ),
              ),
            ),
          if (!isNew)
            IconButton(
              tooltip: 'Con quién se conoció',
              icon: const Icon(Icons.people_outline_rounded),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdminMeetingsScreen(saint: _saint),
                ),
              ),
            ),
          if (!isNew)
            IconButton(
              tooltip: 'Historial de cambios',
              icon: const Icon(Icons.history_rounded),
              onPressed: () async {
                final restored = await Navigator.of(context).push<Saint>(
                  MaterialPageRoute(
                    builder: (_) => AdminRevisionsScreen(saintId: _saint.id!),
                  ),
                );
                if (restored != null && context.mounted) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            Center(
              child: SaintCard(
                saint: infoOfSaint(preview, illustrationUrl: _illustrationUrl),
                scores: scoresOfSaint(preview),
                width: 200,
              ),
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Ilustración',
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 84,
                    child: ClipPath(
                      clipper: const ArchClipper(),
                      child: SaintIllustration(
                        url: _illustrationUrl,
                        name: preview.name.isEmpty ? 'S' : preview.name,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _saint.id == null
                              ? 'Guardá el santo primero para poder subir la '
                                    'ilustración.'
                              : 'PNG, JPG o WEBP. Se guarda separada de la '
                                    'tarjeta; la app dibuja el marco y los '
                                    'puntajes.',
                          style: textTheme.bodySmall?.copyWith(
                            color: Palette.parchmentDim,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _saint.id == null || _uploading
                              ? null
                              : _pickIllustration,
                          icon: _uploading
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.upload_rounded, size: 18),
                          label: Text(
                            _illustrationUrl == null ? 'SUBIR' : 'REEMPLAZAR',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Identidad',
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v ?? '').trim().isEmpty
                        ? 'El nombre es obligatorio'
                        : null,
                    onChanged: (v) {
                      if (!_slugEdited) _slug.text = slugify(v);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _slug,
                    decoration: const InputDecoration(
                      labelText: 'Slug (identificador en URLs)',
                    ),
                    onChanged: (_) => _slugEdited = true,
                    validator: (v) =>
                        RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$').hasMatch(v ?? '')
                        ? null
                        : 'Solo minúsculas, números y guiones',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _title,
                    decoration: const InputDecoration(
                      labelText: 'Título corto',
                      hintText: 'Ej.: Doctora de la Iglesia',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Títulos litúrgicos',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Como los presenta la liturgia. Cada uno es una medalla '
                    'en la tarjeta, en el orden de esta lista.',
                    style: textTheme.bodySmall?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in SaintTitle.values)
                        FilterChip(
                          avatar: Icon(t.icon, size: 14, color: t.color),
                          label: Text(t.adminLabel),
                          selected: (_saint.titles ?? const []).contains(t),
                          selectedColor: Palette.goldDark,
                          onSelected: (on) => setState(() {
                            final next = [...?_saint.titles];
                            if (on) {
                              next.add(t);
                            } else {
                              next.remove(t);
                            }
                            next.sort((a, b) => a.index.compareTo(b.index));
                            _saint = _saint.copyWith(titles: next);
                          }),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Fiesta y programa',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<int?>(
                          initialValue: _month,
                          decoration: const InputDecoration(labelText: 'Mes'),
                          dropdownColor: Palette.inkRaised,
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Sin fecha'),
                            ),
                            for (var i = 0; i < 12; i++)
                              DropdownMenuItem(
                                value: i + 1,
                                child: Text(monthNames[i]),
                              ),
                          ],
                          onChanged: (v) => setState(() => _month = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _day,
                          enabled: _month != null,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Día'),
                          validator: (v) {
                            if (_month == null) return null;
                            final d = int.tryParse((v ?? '').trim());
                            if (d == null || d < 1 || d > 31) return '1 a 31';
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _YearField(
                          controller: _birthYear,
                          label: 'Nació en',
                          approx: _birthApprox,
                          onApprox: (v) => setState(() => _birthApprox = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _YearField(
                          controller: _deathYear,
                          label: 'Murió en',
                          approx: _deathApprox,
                          onApprox: (v) => setState(() => _deathApprox = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Años para la línea de tiempo. Negativo para antes de '
                    'Cristo. Marcá "c." cuando la fecha es aproximada.',
                    style: textTheme.bodySmall?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _season,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Temporada',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _episode,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Capítulo',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _youtube,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'Link al fragmento en YouTube',
                      hintText: 'https://www.youtube.com/live/...?t=3065',
                    ),
                    validator: (v) {
                      final t = (v ?? '').trim();
                      if (t.isEmpty) return null;
                      final uri = Uri.tryParse(t);
                      return uri != null && uri.hasScheme && uri.host.isNotEmpty
                          ? null
                          : 'Pegá un link completo';
                    },
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Textos',
              child: Column(
                children: [
                  TextFormField(
                    controller: _bio,
                    minLines: 6,
                    maxLines: 20,
                    decoration: const InputDecoration(labelText: 'Biografía'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _prayer,
                    minLines: 4,
                    maxLines: 12,
                    decoration: const InputDecoration(labelText: 'Oración'),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Puntajes',
              child: Column(
                children: [
                  for (final c in ScoreCategory.values)
                    _ScoreSlider(
                      category: c,
                      value: c.of(scoresOfSaint(_saint)),
                      onChanged: (v) => setState(() {
                        _saint = switch (c) {
                          ScoreCategory.catequesis => _saint.copyWith(
                            catequesis: v,
                          ),
                          ScoreCategory.escritos => _saint.copyWith(
                            escritos: v,
                          ),
                          ScoreCategory.oracion => _saint.copyWith(oracion: v),
                          ScoreCategory.patronazgos => _saint.copyWith(
                            patronazgos: v,
                          ),
                          ScoreCategory.evangelizacion => _saint.copyWith(
                            evangelizacion: v,
                          ),
                          ScoreCategory.viajes => _saint.copyWith(viajes: v),
                        };
                      }),
                    ),
                ],
              ),
            ),
            _Section(
              title: 'Publicación',
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _saint.status == SaintStatus.published
                      ? 'Publicado'
                      : 'Borrador',
                ),
                subtitle: Text(
                  _saint.status == SaintStatus.published
                      ? 'Visible en el catálogo y puede salir como carta.'
                      : 'Solo lo ven los administradores.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
                value: _saint.status == SaintStatus.published,
                onChanged: (v) => setState(() {
                  _saint = _saint.copyWith(
                    status: v ? SaintStatus.published : SaintStatus.draft,
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(isNew ? 'CREAR SANTO' : 'GUARDAR CAMBIOS'),
            ),
            if (!isNew) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Palette.crimsonLight,
                ),
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Eliminar santo'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(title),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ScoreSlider extends StatelessWidget {
  const _ScoreSlider({
    required this.category,
    required this.value,
    required this.onChanged,
  });

  final ScoreCategory category;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        SizedBox(
          width: 118,
          child: Text(category.label, style: textTheme.bodyMedium),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 99,
            divisions: 99,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            value.toString(),
            textAlign: TextAlign.end,
            style: textTheme.titleMedium?.copyWith(color: Palette.goldLight),
          ),
        ),
      ],
    );
  }
}

class _NoteDialog extends StatefulWidget {
  const _NoteDialog();

  @override
  State<_NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Qué cambiaste?'),
      content: TextField(
        controller: _note,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Ej.: Ajuste de balance en viajes',
        ),
        onSubmitted: (v) => Navigator.pop(context, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _note.text.trim()),
          child: const Text('GUARDAR'),
        ),
      ],
    );
  }
}

/// A year plus the "c." switch that marks it as approximate.
class _YearField extends StatelessWidget {
  const _YearField({
    required this.controller,
    required this.label,
    required this.approx,
    required this.onApprox,
  });

  final TextEditingController controller;
  final String label;
  final bool approx;
  final ValueChanged<bool> onApprox;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(signed: true),
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Tooltip(
          message: approx ? 'Año aproximado' : 'Año exacto',
          child: TextButton(
            onPressed: () => onApprox(!approx),
            child: Text(
              'c.',
              style: TextStyle(
                color: approx ? Palette.gold : Palette.parchmentDim,
                decoration: approx ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        ),
      ),
      validator: (v) {
        final text = (v ?? '').trim();
        if (text.isEmpty) return null;
        final year = int.tryParse(text);
        if (year == null || year < -1000 || year > 2400) return '-1000 a 2400';
        return null;
      },
      onChanged: (_) {},
    );
  }
}
