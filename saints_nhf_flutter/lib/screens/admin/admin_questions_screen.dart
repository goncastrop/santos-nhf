import 'package:flutter/material.dart';
import 'package:saints_nhf_client/saints_nhf_client.dart';

import '../../client.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

/// Question bank of one saint.
class AdminQuestionsScreen extends StatefulWidget {
  const AdminQuestionsScreen({super.key, required this.saint});

  final Saint saint;

  @override
  State<AdminQuestionsScreen> createState() => _AdminQuestionsScreenState();
}

class _AdminQuestionsScreenState extends State<AdminQuestionsScreen> {
  List<Question>? _questions;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final q = await client.adminQuestion.listFor(widget.saint.id!);
      if (mounted) {
        setState(() {
          _questions = q;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _edit(Question? question) async {
    final saved = await showDialog<Question>(
      context: context,
      builder: (_) => _QuestionDialog(
        saintId: widget.saint.id!,
        question: question,
      ),
    );
    if (saved == null) return;
    try {
      await client.adminQuestion.save(saved);
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  Future<void> _delete(Question q) async {
    try {
      await client.adminQuestion.delete(q.id!);
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('PREGUNTAS')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Palette.gold,
        foregroundColor: Palette.ink,
        onPressed: () => _edit(null),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva pregunta'),
      ),
      body: _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : _questions == null
          ? const LoadingView()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                Text(widget.saint.name, style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  '${_questions!.length} preguntas. Se recomiendan entre 5 y 10 '
                  'por santo para que el duelo no se repita.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Palette.parchmentDim,
                  ),
                ),
                const SizedBox(height: 16),
                for (final q in _questions!)
                  Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.prompt, style: textTheme.titleMedium),
                          const SizedBox(height: 8),
                          for (var i = 0; i < q.options.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Icon(
                                    i == q.correctIndex
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    size: 14,
                                    color: i == q.correctIndex
                                        ? Palette.gold
                                        : Palette.inkLine,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      q.options[i],
                                      style: textTheme.bodySmall?.copyWith(
                                        color: i == q.correctIndex
                                            ? Palette.parchment
                                            : Palette.parchmentDim,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _edit(q),
                                child: const Text('Editar'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Palette.crimsonLight,
                                ),
                                onPressed: () => _delete(q),
                                child: const Text('Borrar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _QuestionDialog extends StatefulWidget {
  const _QuestionDialog({required this.saintId, this.question});

  final int saintId;
  final Question? question;

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  late final _prompt = TextEditingController(
    text: widget.question?.prompt ?? '',
  );
  late final _options = List.generate(
    4,
    (i) => TextEditingController(
      text: (widget.question?.options.length ?? 0) > i
          ? widget.question!.options[i]
          : '',
    ),
  );
  late int _correct = widget.question?.correctIndex ?? 0;

  @override
  void dispose() {
    _prompt.dispose();
    for (final c in _options) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text(
        widget.question == null ? 'Nueva pregunta' : 'Editar pregunta',
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _prompt,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Pregunta'),
              ),
              const SizedBox(height: 12),
              Text(
                'Marcá la opción correcta',
                style: textTheme.labelSmall,
              ),
              const SizedBox(height: 4),
              for (var i = 0; i < 4; i++)
                Row(
                  children: [
                    Radio<int>(
                      value: i,
                      // ignore: deprecated_member_use
                      groupValue: _correct,
                      // ignore: deprecated_member_use
                      onChanged: (v) => setState(() => _correct = v ?? 0),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _options[i],
                        decoration: InputDecoration(
                          labelText: 'Opción ${String.fromCharCode(65 + i)}',
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            Question(
              id: widget.question?.id,
              saintId: widget.saintId,
              prompt: _prompt.text,
              options: _options.map((c) => c.text).toList(),
              correctIndex: _correct,
            ),
          ),
          child: const Text('GUARDAR'),
        ),
      ],
    );
  }
}
