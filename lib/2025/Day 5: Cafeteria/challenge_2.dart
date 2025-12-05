/*
The Elves start bringing their spoiled inventory to the trash chute at the back of the kitchen.

So that they can stop bugging you when they get new inventory, the Elves would like to know all of the IDs that the fresh ingredient ID ranges consider to be fresh. An ingredient ID is still considered fresh if it is in any range.

Now, the second section of the database (the available ingredient IDs) is irrelevant. Here are the fresh ingredient ID ranges from the above example:

3-5
10-14
16-20
12-18
The ingredient IDs that these ranges consider to be fresh are 3, 4, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20. So, in this example, the fresh ingredient ID ranges consider a total of 14 ingredient IDs to be fresh.

Process the database file again. How many ingredient IDs are considered to be fresh according to the fresh ingredient ID ranges?
*/

import 'dart:io';

void main() {
  // This time this challenge was resolved with the help of ChatGPT, but I'm not sure if it's the best solution.
  // Unfortunately, I gave up on this challenge after a few times it overflowed the stack.
  // Don't judge me too harshly, thanks 🥲

  var input = File('lib/2025/Day 5: Cafeteria/input.txt').readAsLinesSync();

  // Parse all ranges into (min, max) pairs
  final ranges = <List<int>>[];
  for (var line in input) {
    if (line.isEmpty || !line.contains('-')) continue;

    final parts = line.split('-');
    final min = int.parse(parts[0]);
    final max = int.parse(parts[1]);
    ranges.add([min, max]);
  }

  // Sort ranges by starting position
  ranges.sort((a, b) => a[0].compareTo(b[0]));

  // Merge overlapping ranges
  final merged = <List<int>>[];
  for (var range in ranges) {
    if (merged.isEmpty || merged.last[1] < range[0] - 1) {
      // No overlap: add new range
      merged.add([range[0], range[1]]);
    } else {
      // Overlap: extend the last range
      merged.last[1] = merged.last[1] > range[1] ? merged.last[1] : range[1];
    }
  }

  // Count total unique IDs in merged ranges
  var freshIngredientsRanges = 0;
  for (var range in merged) {
    freshIngredientsRanges += range[1] - range[0] + 1;
  }

  print(freshIngredientsRanges);
}
