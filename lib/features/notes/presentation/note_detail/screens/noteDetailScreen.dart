import 'package:flutter/material.dart';

// ── Colores (misma paleta) ────────────────────────────────────────────────────
const Color kPrimary     = Color(0xFF1A759F);
const Color kPrimaryDark = Color(0xFF184E77);
const Color kAccent      = Color(0xFF52B69A);
const Color kError       = Color(0xFFE63946);

// ── Pantalla de detalle / edición ─────────────────────────────────────────────
class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: null, // se conectará al ViewModel
            tooltip: 'Guardar',
          ),
        ],
      ),
      body: const _NoteDetailBody(),
      bottomNavigationBar: const _DeleteBar(),
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