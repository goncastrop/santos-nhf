import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../theme.dart';
import '../../utils/books.dart';
import '../../widgets/common.dart';

/// Recommended reading of one saint: what they wrote and what was written
/// about them, in the order the ficha shows them.
class AdminBooksScreen extends StatefulWidget {
  const AdminBooksScreen({super.key, required this.saint});

  final Saint saint;

  @override
  State<AdminBooksScreen> createState() => _AdminBooksScreenState();
}

class _AdminBooksScreenState extends State<AdminBooksScreen> {
  List<SaintBook>? _books;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final books = await client.adminBook.listFor(widget.saint.id!);
      if (mounted) {
        setState(() {
          _books = books;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _edit(SaintBook? book) async {
    final saved = await showDialog<SaintBook>(
      context: context,
      builder: (_) => _BookDialog(saintId: widget.saint.id!, book: book),
    );
    if (saved == null) return;
    try {
      await client.adminBook.save(saved);
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  Future<void> _delete(SaintBook book) async {
    try {
      await client.adminBook.delete(book.id!);
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  /// Reordering only moves a book within its own group, since the ficha shows
  /// the two groups apart anyway.
  Future<void> _move(SaintBook book, int delta) async {
    final books = _books;
    if (books == null) return;
    final own = book.kind.byTheSaint;
    final group = books.where((b) => b.kind.byTheSaint == own).toList();
    final others = books.where((b) => b.kind.byTheSaint != own).toList();
    final from = group.indexWhere((b) => b.id == book.id);
    final to = from + delta;
    if (from < 0 || to < 0 || to >= group.length) return;
    group.insert(to, group.removeAt(from));
    // The saint's own writing always reads first.
    final next = own ? [...group, ...others] : [...others, ...group];
    setState(() => _books = next);
    try {
      final result = await client.adminBook.reorder(widget.saint.id!, [
        for (final b in next) b.id!,
      ]);
      if (mounted) setState(() => _books = result);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final books = _books;
    return Scaffold(
      appBar: AppBar(title: const Text('LIBROS')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Palette.gold,
        foregroundColor: Palette.ink,
        onPressed: () => _edit(null),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo libro'),
      ),
      body: _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : books == null
          ? const LoadingView()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                Text(widget.saint.name, style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  '${books.length} libros. En la ficha se muestran en dos '
                  'grupos: lo que escribió y lo que se escribió sobre '
                  'él o ella.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
                const SizedBox(height: 16),
                for (final group in [true, false])
                  ..._groupSection(
                    context,
                    heading: group
                        ? writingsHeading(widget.saint.name)
                        : aboutHeading(widget.saint.name),
                    books: books
                        .where((b) => b.kind.byTheSaint == group)
                        .toList(),
                  ),
                if (books.isEmpty)
                  Text(
                    'Todavía no hay libros cargados.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Palette.parchmentDim,
                    ),
                  ),
              ],
            ),
    );
  }

  List<Widget> _groupSection(
    BuildContext context, {
    required String heading,
    required List<SaintBook> books,
  }) {
    if (books.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Eyebrow(heading),
      ),
      for (final book in books)
        Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: Icon(book.kind.icon, color: Palette.gold, size: 20),
            title: Text(book.title),
            subtitle: Text(
              [
                book.kind.label,
                if (book.author != null) book.author!,
                if (book.year != null) book.year!.toString(),
              ].join(' · '),
            ),
            onTap: () => _edit(book),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Subir',
                  icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                  onPressed: book.id == books.first.id
                      ? null
                      : () => _move(book, -1),
                ),
                IconButton(
                  tooltip: 'Bajar',
                  icon: const Icon(Icons.arrow_downward_rounded, size: 18),
                  onPressed: book.id == books.last.id
                      ? null
                      : () => _move(book, 1),
                ),
                IconButton(
                  tooltip: 'Borrar',
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Palette.crimsonLight,
                    size: 18,
                  ),
                  onPressed: () => _delete(book),
                ),
              ],
            ),
          ),
        ),
    ];
  }
}

class _BookDialog extends StatefulWidget {
  const _BookDialog({required this.saintId, this.book});

  final int saintId;
  final SaintBook? book;

  @override
  State<_BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<_BookDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.book?.title ?? '');
  late final _author = TextEditingController(text: widget.book?.author ?? '');
  late final _year = TextEditingController(
    text: widget.book?.year?.toString() ?? '',
  );
  late final _publisher = TextEditingController(
    text: widget.book?.publisher ?? '',
  );
  late final _url = TextEditingController(text: widget.book?.url ?? '');
  late final _note = TextEditingController(text: widget.book?.note ?? '');
  late BookKind _kind = widget.book?.kind ?? BookKind.biografia;

  @override
  void dispose() {
    for (final c in [_title, _author, _year, _publisher, _url, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _blank(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Palette.inkRaised,
      title: Text(widget.book == null ? 'Nuevo libro' : 'Editar libro'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (v) =>
                      (v ?? '').trim().isEmpty ? 'Falta el título' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<BookKind>(
                  initialValue: _kind,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  dropdownColor: Palette.inkRaised,
                  items: [
                    for (final kind in BookKind.values)
                      DropdownMenuItem(value: kind, child: Text(kind.label)),
                  ],
                  onChanged: (v) => setState(() => _kind = v ?? _kind),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _author,
                  decoration: const InputDecoration(
                    labelText: 'Autor',
                    helperText: 'Vacío si lo escribió el santo',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _year,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                        ),
                        decoration: const InputDecoration(labelText: 'Año'),
                        validator: (v) {
                          final text = (v ?? '').trim();
                          if (text.isEmpty) return null;
                          final year = int.tryParse(text);
                          if (year == null || year < -1000 || year > 2400) {
                            return '-1000 a 2400';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _publisher,
                        decoration: const InputDecoration(
                          labelText: 'Editorial',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _url,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Link para leerlo o conseguirlo',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _note,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Por qué leerlo',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              (widget.book ??
                      SaintBook(
                        saintId: widget.saintId,
                        title: '',
                        kind: _kind,
                      ))
                  .copyWith(
                    title: _title.text.trim(),
                    kind: _kind,
                    author: _blank(_author),
                    year: int.tryParse(_year.text.trim()),
                    publisher: _blank(_publisher),
                    url: _blank(_url),
                    note: _blank(_note),
                  ),
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
