import 'dart:math';

class MineSweeperGame {
  static int row = 8;
  static int col = 8;
  static int cells = row * col;
  int numberOfMines = 5;
  int placedFlags = 0;
  int foundBombs = 0;
  bool gameOver = false;
  bool gameWon = false;
  List<Cell> gameMap = [];
  var bombsCoordinates = Map<int, (int, int)>();

  static List<List<dynamic>> map = List.generate(row,
      (x) => List.generate(col, (y) => Cell(x, y, "", false, false, false)));

  void generateMap() {
    placeMines(numberOfMines);
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        gameMap.add(map[i][j]);
      }
    }
  }

  void resetGame() {
    placedFlags = 0;
    foundBombs = 0;
    gameWon = false;
    gameOver = false;
    map = List.generate(row,
        (x) => List.generate(col, (y) => Cell(x, y, "", false, false, false)));
    gameMap.clear();
    generateMap();
  }

  void placeMines(int minesNumber) {
    Random random = Random();
    for (int i = 0; i < minesNumber; i++) {
      int mineRow = random.nextInt(row);
      int mineCol = random.nextInt(col);

      while (map[mineRow][mineCol].content == "X") {
        mineRow = random.nextInt(row);
        mineCol = random.nextInt(col);
      }

      bombsCoordinates[i] = (mineRow, mineCol);
      map[mineRow][mineCol] = Cell(mineRow, mineCol, "X", false, false, true);
    }
  }

  void showMines() {
    /* for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        if (map[i][j].content == "X") {
          map[i][j].reveal = true;
        }
      }
    } */
    bombsCoordinates.forEach(
      (key, value) => map[value.$1][value.$2].reveal = true,
    );
  }

  void getClickedCell(Cell cell) {
    int x = cell.col;
    int y = cell.row;
    //print('(${x},${y})');
    if (!inBoard(x, y) || gameOver || cell.flagged || cell.reveal) return;

    if (cell.content == "X") {
      showMines();
      gameOver = true;
      return;
    }

    int mineCountNum = mineCount(x, y);

    cell.content = mineCountNum;
    cell.reveal = true;

    if (mineCountNum > 0) return;

    if (inBoard(x - 1, y)) getClickedCell(map[y][x - 1]);
    if (inBoard(x + 1, y)) getClickedCell(map[y][x + 1]);
    if (inBoard(x, y - 1)) getClickedCell(map[y - 1][x]);
    if (inBoard(x, y + 1)) getClickedCell(map[y + 1][x]);
    if (inBoard(x - 1, y - 1)) getClickedCell(map[y - 1][x - 1]);
    if (inBoard(x + 1, y + 1)) getClickedCell(map[y + 1][x + 1]);
    if (inBoard(x - 1, y + 1)) getClickedCell(map[y + 1][x - 1]);
    if (inBoard(x + 1, y - 1)) getClickedCell(map[y - 1][x + 1]);
  }

  int mineCount(int x, int y) {
    int count = 0;
    count += bombs(x - 1, y);
    count += bombs(x + 1, y);
    count += bombs(x, y - 1);
    count += bombs(x, y + 1);
    count += bombs(x - 1, y - 1);
    count += bombs(x + 1, y + 1);
    count += bombs(x + 1, y - 1);
    count += bombs(x - 1, y + 1);
    return count;
  }

  int bombs(int x, int y) => inBoard(x, y) && map[y][x].content == "X" ? 1 : 0;
  bool inBoard(int x, int y) => x >= 0 && x < col && y >= 0 && y < row;

  //flag value = \u2691

  void flag(Cell cell) {
    if (gameOver) return;

    if (cell.flagged) {
      cell.flagged = false;
      placedFlags--;
      if (cell.bomb) foundBombs--;
    } else {
      cell.flagged = true;
      placedFlags++;
      if (cell.bomb) foundBombs++;
    }
    checkGameWon();
  }

  void checkGameWon() {
    if (gameOver) return;
    if (placedFlags == numberOfMines) {
      if (foundBombs == numberOfMines) {
        gameWon = true;
      }
      showMines();
      gameOver = true;
    }
  }
}

class Cell {
  int row;
  int col;
  dynamic content;
  bool reveal = false;
  bool flagged = false;
  bool bomb = false;
  Cell(this.row, this.col, this.content, this.reveal, this.flagged, this.bomb);
}
