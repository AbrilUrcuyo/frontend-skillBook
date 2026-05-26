import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/notes/presentation/notes_list/screens/noteListScreen.dart';
import 'core/di/injection.dart';
import 'features/notes/presentation/notes_list/viewmodels/note_list_viewmodel.dart';
import 'features/notes/presentation/note_detail/viewmodels/note_detail_viewmodel.dart';

void main() {
  // Configura la inyección de dependencias (ajusta la URL base a tu backend)
  setupInjection(apiBaseUrl: 'http://10.0.2.2:8080/v1');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NoteListViewModel>(
          create: (_) => getIt<NoteListViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<NoteDetailViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const NoteListScreen(),
      ),
    );
  }
}


