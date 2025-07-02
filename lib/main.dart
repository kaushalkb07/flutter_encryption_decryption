// lib/main.dart

import 'package:flutter/material.dart';
import 'features/keypair/presentation/keypair_page.dart';
import 'features/chat/presentation/chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Messaging App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MainTabController(),
    );
  }
}

class MainTabController extends StatelessWidget {
  const MainTabController({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Secure Messaging'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Key Exchange'),
              Tab(text: 'Chat'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            KeyPairPage(),
            ChatPage(),
          ],
        ),
      ),
    );
  }
}
