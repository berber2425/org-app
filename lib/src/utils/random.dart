/*
export function randomColor() {
  const colors: number[] = [];

  for (let i = 0; i < 3; i += 1) {
    if (i === 0) {
      colors.push(Math.floor(Math.random() * 360));
    } else {
      colors.push((colors[i - 1] + 80 + Math.floor(Math.random() * 100)) % 360);
    }
  }

  return colors.join(",");
}

*/

import 'dart:math';

String randomColor() {
  final List<int> colors = [];
  for (var i = 0; i < 3; i++) {
    if (i == 0) {
      colors.add((Random().nextDouble() * 360).floor());
    } else {
      colors.add(
          (colors[i - 1] + 80 + (Random().nextDouble() * 100).floor()) % 360);
    }
  }
  return colors.join(',');
}
