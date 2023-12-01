class Board {
  int[] squares = new int[64];

  boolean whiteTurn = true;

  color lightColor = color(50, 205, 203);
  color darkColor  = color(205, 50, 52);

  int capturedPiece = -1000;

  void makeMove(int startSquare, int targetSquare) {
    if (squares[targetSquare] != empty) capturedPiece = squares[targetSquare];
    else capturedPiece = -1000;
    squares[targetSquare] = squares[startSquare];
    squares[startSquare] = 0;
    whiteTurn=!whiteTurn;
  }
  void makeMove(Move move) {
    if (squares[move.endSquare] != empty) capturedPiece = squares[move.endSquare];
    else capturedPiece = -1000;
    squares[move.endSquare] = squares[move.startSquare];
    squares[move.startSquare] = 0;
    whiteTurn=!whiteTurn;
  }


  void unMakeMove(int startSquare, int endSquare) {
    squares[startSquare] = squares[endSquare];
    if (capturedPiece != -1000) squares[endSquare] = capturedPiece;
    else squares[endSquare] = 0;
    whiteTurn=!whiteTurn;
  }
  void unMakeMove(Move move) {
    squares[move.startSquare] = squares[move.endSquare];
    if (capturedPiece != -1000) squares[move.endSquare] = capturedPiece;
    else squares[move.endSquare] = 0;
    whiteTurn=!whiteTurn;
  }
}
