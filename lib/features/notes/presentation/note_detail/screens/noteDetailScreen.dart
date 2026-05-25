import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/note_detail_viewmodel.dart';
import '../../notes_list/viewmodels/note_list_viewmodel.dart';

// ── Colores (misma paleta) ────────────────────────────────────────────────────
const Color kPrimary     = Color(0xFF1A759F);
const Color kPrimaryDark = Color(0xFF184E77);
const Color kAccent      = Color(0xFF52B69A);
const Color kError       = Color(0xFFE63946);

// ── Pantalla de detalle / edición ─────────────────────────────────────────────
class NoteDetailScreen extends StatelessWidget {
  /// `routeNoteId` es opcional. Si es nulo, la pantalla funcionará como creación.
  final String? routeNoteId;

  const NoteDetailScreen({super.key, this.routeNoteId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteDetailViewModel>();

    // Cargar la nota si se proporcionó un id y aún no está cargada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (routeNoteId != null && vm.note == null && !vm.isLoading) {
        vm.loadNote(routeNoteId!);
      }
    });

    // Controladores temporales para los campos (inicializados desde el VM cuando esté disponible)
    final titleController = TextEditingController(text: vm.note?.title ?? '');
    final contentController = TextEditingController(text: vm.note?.content ?? '');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryDark,
        elevation: 0,
        leading: TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: kAccent, size: 20),
          label: const Text(
            'Volver',
            style: TextStyle(color: kAccent, fontSize: 14),
          ),
        ),
        leadingWidth: 120,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: kAccent),
            onPressed: () async {
              // Guardar: crear o actualizar según si routeNoteId existe
              if (routeNoteId == null) {
                await vm.createNote(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                );
              } else {
                await vm.updateNote(
                  id: routeNoteId!,
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                );
              }

              if (vm.isSuccess) {
                // Si se guardó con éxito, refrescar la lista principal
                try {
                  context.read<NoteListViewModel>().loadNotes();
                } catch (_) {}
                Navigator.of(context).pop();
              } else if (vm.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error!)));
              }
            },
            tooltip: 'Guardar',
          ),
        ],
      ),
      body: vm.isLoading && vm.note == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fecha / label
                  Text(vm.note == null ? '' : ''),
                  const SizedBox(height: 10),
                  // Título
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Título',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  // Divider
                  Container(height: 2, width: 100, color: kPrimary),
                  const SizedBox(height: 16),
                  // Contenido
                  Expanded(
                    child: TextField(
                      controller: contentController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: 'Escribe tu nota aquí...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: kError,
            elevation: 0,
            side: BorderSide(color: kError.withAlpha(80)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: routeNoteId == null
              ? null
              : () async {
                  // Eliminar la nota
                  if (routeNoteId != null) {
                    await vm.deleteNote(routeNoteId!);
                    if (vm.isSuccess) {
                      try {
                        context.read<NoteListViewModel>().loadNotes();
                      } catch (_) {}
                      Navigator.of(context).pop();
                    } else if (vm.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error!)));
                    }
                  }
                },
          icon: const Icon(Icons.delete_outline),
          label: const Text('Eliminar nota', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

// ── Cuerpo ────────────────────────────────────────────────────────────────────
class _NoteDetailBody extends StatelessWidget {
  const _NoteDetailBody();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha
          _DateLabel(),
          SizedBox(height: 10),
          // Título
          _TitleField(),
          SizedBox(height: 6),
          // Divisor decorativo
          _Divider(),
          SizedBox(height: 16),
          // Contenido
          Expanded(child: _ContentField()),
        ],
      ),
    );
  }
}

// ── Fecha ─────────────────────────────────────────────────────────────────────
class _DateLabel extends StatelessWidget {
  const _DateLabel();

  @override
  Widget build(BuildContext context) {
    return Text(
      '', // vendrá del ViewModel
      style: TextStyle(
        fontSize: 13,
        color: Colors.grey[600],
      ),
    );
  }
}

// ── Campo de título ───────────────────────────────────────────────────────────
class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    return const TextField(
      readOnly: true, // se volverá editable con el ViewModel
      decoration: InputDecoration(
        hintText: 'Título',
        hintStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFFBBBBBB),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A2A35),
      ),
    );
  }
}

// ── Línea decorativa bajo el título ──────────────────────────────────────────
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: 100,
      color: kPrimary,
    );
  }
}

// ── Campo de contenido ────────────────────────────────────────────────────────
class _ContentField extends StatelessWidget {
  const _ContentField();

  @override
  Widget build(BuildContext context) {
    return const TextField(
      readOnly: true, // se volverá editable con el ViewModel
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        hintText: 'Escribe tu nota aquí...',
        hintStyle: TextStyle(color: Color(0xFFBBBBBB)),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      style: TextStyle(
        fontSize: 15,
        color: Color(0xFF3A4A52),
        height: 1.7,
      ),
    );
  }
}

// ── Barra inferior con botón eliminar ─────────────────────────────────────────
class _DeleteBar extends StatelessWidget {
  const _DeleteBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: kError,
          elevation: 0,
          side: BorderSide(color: kError.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: null, // se conectará al ViewModel
        icon: const Icon(Icons.delete_outline),
        label: const Text(
          'Eliminar nota',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}