import 'package:flutter/cupertino.dart';

extension RemoveNull<K, V> on Map<K, V?> {
  Map<K, V> removeNulls() {
    return Map.fromEntries(entries.where((e) => e.value != null)).cast();
  }
}

extension Op on Color {
  Color op(double v) {
    return withValues(colorSpace: colorSpace, alpha: v);
  }
}
