import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/chat/chat_repository.dart';

class WhatsAppCloneApp extends StatelessWidget {
  const WhatsAppCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text('WhatsApp Clone Backend Starter Ready'),
          ),
        ),
      ),
    );
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  throw UnimplementedError(
    'Provide ChatRepository with a concrete BackendService in your app composition root.',
  );
});
