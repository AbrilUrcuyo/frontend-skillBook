import 'package:flutter/material.dart';

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
        onPressed: null,
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
    // Por ahora lista vacía; aquí irán los items reales
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: 0,             // <- se llenará desde el ViewModel
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => const SizedBox.shrink(),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: kAccent, width: 4),
            top: BorderSide(color: kCardBorder, width: 0.8),
            right: BorderSide(color: kCardBorder, width: 0.8),
            bottom: BorderSide(color: kCardBorder, width: 0.8),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
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
            // Preview del contenido
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
    );
  }
}