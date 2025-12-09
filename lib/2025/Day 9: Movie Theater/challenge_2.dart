/*
The Elves just remembered: they can only switch out tiles that are red or green. So, your rectangle can only include red or green tiles.

In your list, every red tile is connected to the red tile before and after it by a straight line of green tiles. The list wraps, so the first red tile is also connected to the last red tile. Tiles that are adjacent in your list will always be on either the same row or the same column.

Using the same example as before, the tiles marked X would be green:

..............
.......#XXX#..
.......X...X..
..#XXXX#...X..
..X........X..
..#XXXXXX#.X..
.........X.X..
.........#X#..
..............
In addition, all of the tiles inside this loop of red and green tiles are also green. So, in this example, these are the green tiles:

..............
.......#XXX#..
.......XXXXX..
..#XXXX#XXXX..
..XXXXXXXXXX..
..#XXXXXX#XX..
.........XXX..
.........#X#..
..............
The remaining tiles are never red nor green.

The rectangle you choose still must have red tiles in opposite corners, but any other tiles it includes must now be red or green. This significantly limits your options.

For example, you could make a rectangle out of red and green tiles with an area of 15 between 7,3 and 11,1:

..............
.......OOOOO..
.......OOOOO..
..#XXXXOOOOO..
..XXXXXXXXXX..
..#XXXXXX#XX..
.........XXX..
.........#X#..
..............
Or, you could make a thin rectangle with an area of 3 between 9,7 and 9,5:

..............
.......#XXX#..
.......XXXXX..
..#XXXX#XXXX..
..XXXXXXXXXX..
..#XXXXXXOXX..
.........OXX..
.........OX#..
..............
The largest rectangle you can make in this example using only red and green tiles has area 24. One way to do this is between 9,5 and 2,3:

..............
.......#XXX#..
.......XXXXX..
..OOOOOOOOXX..
..OOOOOOOOXX..
..OOOOOOOOXX..
.........XXX..
.........#X#..
..............
Using two red tiles as opposite corners, what is the largest area of any rectangle you can make using only red and green tiles?
*/
import 'dart:io';
import 'dart:math';

void main() {
  final r = File(
    'lib/2025/Day 9: Movie Theater/input.txt',
  ).readAsLinesSync().map((l) => l.split(',').map(int.parse).toList()).toList();
  // Coordinate compression
  final xs = (r.map((p) => p[0]).toSet().toList()..sort());
  final ys = (r.map((p) => p[1]).toSet().toList()..sort());
  final xIdx = {for (var i = 0; i < xs.length; i++) xs[i]: i};
  final yIdx = {for (var i = 0; i < ys.length; i++) ys[i]: i};
  final w = xs.length, h = ys.length;
  // Precompute edges
  final vEdges = [
    for (var i = 0; i < r.length; i++)
      if (r[i][0] == r[(i + 1) % r.length][0])
        [
          r[i][0],
          min(r[i][1], r[(i + 1) % r.length][1]),
          max(r[i][1], r[(i + 1) % r.length][1]),
        ],
  ];
  final hEdges = [
    for (var i = 0; i < r.length; i++)
      if (r[i][1] == r[(i + 1) % r.length][1])
        [
          r[i][1],
          min(r[i][0], r[(i + 1) % r.length][0]),
          max(r[i][0], r[(i + 1) % r.length][0]),
        ],
  ];

  bool inside(int px, int py) {
    for (final e in hEdges) {
      if (py == e[0] && px >= e[1] && px <= e[2]) return true;
    }
    for (final e in vEdges) {
      if (px == e[0] && py >= e[1] && py <= e[2]) return true;
    }
    var c = 0;
    for (final e in vEdges) {
      if (e[0] > px && py >= e[1] && py < e[2]) c++;
    }
    return c % 2 == 1;
  }

  final g = [
    for (var yi = 0; yi < h; yi++)
      [for (var xi = 0; xi < w; xi++) inside(xs[xi], ys[yi]) ? 1 : 0],
  ];
  final p = List.generate(h + 1, (_) => List.filled(w + 1, 0));
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      p[y + 1][x + 1] = g[y][x] + p[y][x + 1] + p[y + 1][x] - p[y][x];
    }
  }
  int cnt(int x1, int y1, int x2, int y2) =>
      p[y2 + 1][x2 + 1] - p[y1][x2 + 1] - p[y2 + 1][x1] + p[y1][x1];
  var best = 0;
  for (var i = 0; i < r.length; i++) {
    for (var j = i + 1; j < r.length; j++) {
      final xLo = min(xIdx[r[i][0]]!, xIdx[r[j][0]]!),
          xHi = max(xIdx[r[i][0]]!, xIdx[r[j][0]]!);
      final yLo = min(yIdx[r[i][1]]!, yIdx[r[j][1]]!),
          yHi = max(yIdx[r[i][1]]!, yIdx[r[j][1]]!);
      if (cnt(xLo, yLo, xHi, yHi) == (xHi - xLo + 1) * (yHi - yLo + 1)) {
        best = max(best, (xs[xHi] - xs[xLo] + 1) * (ys[yHi] - ys[yLo] + 1));
      }
    }
  }
  print(best);
}
