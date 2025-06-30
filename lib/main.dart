import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'features/keypair/presentation/keypair_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures binding before async calls
  await Firebase.initializeApp();              // Initialize Firebase

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
