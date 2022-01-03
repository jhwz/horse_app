import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horse_app/utils/height_unit.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final Provider<SharedPreferences> preferences =
    Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class PreferencesNotifier<T> extends StateNotifier<T> {
  final String key;
  final StateNotifierProviderRef ref;
  final Function(SharedPreferences prefs, String key, T val) write;
  final T Function(SharedPreferences prefs, String key) read;

  PreferencesNotifier(this.key, this.ref, this.read, this.write, T defaultVal)
      : super(defaultVal) {
    super.state = read(ref.read(preferences), key);
  }

  @override
  T get state => super.state;

  @override
  set state(T val) {
    super.state = val;
    write(ref.read(preferences), key, val);
  }
}
