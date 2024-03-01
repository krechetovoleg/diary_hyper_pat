import 'package:diary_hyper_pat/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru')],
      debugShowCheckedModeBanner: false,
      title: "DHP: Дневник давления и пульса",
      theme: ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 42, 147, 245),
      ),
      home: const Navigation(),
    );
  }
}
