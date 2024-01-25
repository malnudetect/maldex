import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProvider {
  // FirebaseAuth auth;
}

final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(0);
  int updateCounter() => state++;
}

class Klopp extends ConsumerWidget {
  const Klopp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var count = ref.watch(counterProvider);
    return Scaffold(
      body: Center(
        child: Text("$count"),
      ),
    );
  }
}
