import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod Providers
class AuthProvider {
  static final emailProvider = StateProvider<String>((ref) => '');
  static final passwordProvider = StateProvider<String>((ref) => '');
}
