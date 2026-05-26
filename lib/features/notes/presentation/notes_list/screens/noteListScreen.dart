import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../note_detail/screens/noteDetailScreen.dart';
import '../viewmodels/note_list_viewmodel.dart';

// ── Colores de la paleta ──────────────────────────────────────────────────────
const Color kPrimary     = Color(0xFF1A759F);
const Color kPrimaryDark = Color(0xFF184E77);
const Color kAccent      = Color(0xFF52B69A);
const Color kBackground  = Color(0xFFF0F9F8);
const Color kCardBorder  = Color(0xFFD0DDE3);

// ── Pantalla principal ────────────────────────────────────────────────────────
class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kPrimaryDark,
        elevation: 0,
        title: const Text(
          'Notebook',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const _NoteListBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimary,
        tooltip: 'Add note',
        onPressed: () async {
          // Navegar a la pantalla de detalle para crear una nueva nota
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const NoteDetailScreen(),
          ));
          // Después de volver, recargar la lista
          final vm = context.read<NoteListViewModel>();
          await vm.loadNotes();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ── Cuerpo — lista vacía por ahora ────────────────────────────────────────────
class _NoteListBody extends StatelessWidget {
  const _NoteListBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteListViewModel>();

    // Cargar notas una vez después del primer frame si es necesario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!vm.isLoading && vm.notes.isEmpty && vm.error == null) {
        vm.loadNotes();
      }
    });

    if (vm.isLoading && vm.notes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null && vm.notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Error: ${vm.error}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: vm.loadNotes,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: vm.notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final note = vm.notes[index];
        return NoteCard(
          title: note.title.isNotEmpty ? note.title : '(sin título)',
          preview: note.content.isNotEmpty ? note.content : '(sin contenido)',
          onTap: () async {
            // Navegar a detalle y cargar la nota por id
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => NoteDetailScreen(routeNoteId: note.id),
            ));
            // Al volver, recargar la lista
            await vm.loadNotes();
          },
        );
      },
    );
  }
}

// ── NoteCard — widget reutilizable ────────────────────────────────────────────
class NoteCard extends StatelessWidget {
  final String title;
  final String preview;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.title,
    required this.preview,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);

    return Material(
      color: Colors.white,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.all(color: kCardBorder, width: 0.8),
          ),
          child: Stack(
            children: [
              // Franja de acento interna sin afectar el layout.
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(width: 4, color: kAccent),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2A35),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5A6A72),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}