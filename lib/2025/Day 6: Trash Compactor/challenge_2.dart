/*
The big cephalopods come back to check on how things are going. When they see that your grand total doesn't match the one expected by the worksheet, they realize they forgot to explain how to read cephalopod math.

Cephalopod math is written right-to-left in columns. Each number is given in its own column, with the most significant digit at the top and the least significant digit at the bottom. (Problems are still separated with a column consisting only of spaces, and the symbol at the bottom of the problem is still the operator to use.)

Here's the example worksheet again:

123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
Reading the problems right-to-left one column at a time, the problems are now quite different:

The rightmost problem is 4 + 431 + 623 = 1058
The second problem from the right is 175 * 581 * 32 = 3253600
The third problem from the right is 8 + 248 + 369 = 625
Finally, the leftmost problem is 356 * 24 * 1 = 8544
Now, the grand total is 1058 + 3253600 + 625 + 8544 = 3263827.

Solve the problems on the math worksheet again. What is the grand total found by adding together all of the answers to the individual problems?
*/
import 'dart:io';

void main() {
  var input = File(
    'lib/2025/Day 6: Trash Compactor/input.txt',
  ).readAsLinesSync();

  int maxLength = input
      .map((line) => line.length)
      .reduce((a, b) => a > b ? a : b);

  List<String> rows = [];
  for (var i = 0; i < input.length - 1; i++) {
    rows.add(input[i].padRight(maxLength));
  }
  String operatorRow = input[input.length - 1].padRight(maxLength);

  int grandTotal = 0;

  int col = maxLength - 1;
  while (col >= 0) {
    bool isEmptyColumn = true;
    for (var row in rows) {
      if (col < row.length && row[col] != ' ') {
        isEmptyColumn = false;
        break;
      }
    }
    if (col < operatorRow.length && operatorRow[col] != ' ') {
      isEmptyColumn = false;
    }

    if (isEmptyColumn) {
      col--;
      continue;
    }

    int problemEnd = col;
    int problemStart = col;

    while (problemStart > 0) {
      bool foundSpace = true;
      for (var row in rows) {
        if (problemStart - 1 < row.length && row[problemStart - 1] != ' ') {
          foundSpace = false;
          break;
        }
      }
      if (problemStart - 1 < operatorRow.length &&
          operatorRow[problemStart - 1] != ' ') {
        foundSpace = false;
      }

      if (foundSpace) {
        break;
      }
      problemStart--;
    }

    List<int> numbers = [];
    for (int c = problemEnd; c >= problemStart; c--) {
      String numStr = '';
      for (var row in rows) {
        if (c < row.length && row[c] != ' ') {
          numStr += row[c];
        }
      }
      if (numStr.isNotEmpty) {
        numbers.add(int.parse(numStr));
      }
    }

    String operator = '';
    for (int c = problemStart; c <= problemEnd; c++) {
      if (c < operatorRow.length && operatorRow[c] != ' ') {
        operator = operatorRow[c];
        break;
      }
    }

    int result = numbers[0];
    if (operator == '*') {
      for (int i = 1; i < numbers.length; i++) {
        result *= numbers[i];
      }
    } else {
      for (int i = 1; i < numbers.length; i++) {
        result += numbers[i];
      }
    }

    grandTotal += result;

    col = problemStart - 1;
  }

  print(grandTotal);
}
