/*
The Elves were right; they definitely don't have enough extension cables. You'll need to keep connecting junction boxes together until they're all in one large circuit.

Continuing the above example, the first connection which causes all of the junction boxes to form a single circuit is between the junction boxes at 216,146,977 and 117,168,530. The Elves need to know how far those junction boxes are from the wall so they can pick the right extension cable; multiplying the X coordinates of those two junction boxes (216 and 117) produces 25272.

Continue connecting the closest unconnected pairs of junction boxes together until they're all in the same circuit. What do you get if you multiply together the X coordinates of the last two junction boxes you need to connect?
*/

import 'dart:io';

void main() {
  final points = File(
    'lib/2025/Day 8: Playground/input.txt',
  ).readAsLinesSync().map((l) => l.split(',').map(int.parse).toList()).toList();

  final n = points.length;
  final parent = List.generate(n, (i) => i);
  final size = List.filled(n, 1);
  var components = n;

  int find(int x) => parent[x] == x ? x : parent[x] = find(parent[x]);
  bool unite(int a, int b) {
    a = find(a);
    b = find(b);
    if (a == b) return false;
    if (size[a] < size[b]) {
      final t = a;
      a = b;
      b = t;
    }
    parent[b] = a;
    size[a] += size[b];
    components--;
    return true;
  }

  final pairs = <(int, int, int)>[];
  for (var i = 0; i < n; i++) {
    for (var j = i + 1; j < n; j++) {
      final p = points[i], q = points[j];
      final dx = p[0] - q[0], dy = p[1] - q[1], dz = p[2] - q[2];
      pairs.add((dx * dx + dy * dy + dz * dz, i, j));
    }
  }

  pairs.sort((a, b) => a.$1.compareTo(b.$1));
  var result = 0;
  for (final pair in pairs) {
    if (unite(pair.$2, pair.$3) && components == 1) {
      result = points[pair.$2][0] * points[pair.$3][0];
      break;
    }
  }

  print(result);
}
