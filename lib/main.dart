import 'package:flutter/material.dart';
import 'features/keypair/presentation/keypair_page.dart';

void main() async { 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Crypto Key Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const KeyPairPage(),
    );
  }
}
