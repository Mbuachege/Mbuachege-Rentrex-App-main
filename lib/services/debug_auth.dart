// lib/auth/debug_auth.dart
import 'dart:developer';
import 'secure_store.dart';

Future<void> debugAuthState() async {
  final t = await SecureStore.getToken();
  final exp = await SecureStore.getTokenExpiration();
  String mask(String? v) => (v == null || v.isEmpty)
      ? '(none)'
      : '${v.substring(0, 6)}…${v.substring(v.length - 6)}';
  log('[AUTH] token: ${mask(t)}  exp: ${exp ?? '(none)'}');
}
