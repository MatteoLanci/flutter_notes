import 'package:flutter/material.dart';
import 'package:flutter_notes/home_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('it_IT', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
