// lib/main.dart

import 'package:flutter/material.dart';
import 'features/keypair/presentation/keypair_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Key Generator Upload',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const KeyPairPage(),
    );
  }
}
