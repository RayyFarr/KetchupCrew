class BoardUI
{

  PVector pos;
  float dim;

  color lightColor = color(#34CBAE);
  color darkColor = color(#CB3451);

  Board displayBoard;

  int hiddenSquare;
  boolean hidePiece = false;

  void hide(int square) {
    hiddenSquare = square;
    hidePiece = true;
  }
  void unhide(){
    hidePiece = false; 
  }

  BoardUI(Board b, PVector position, float dimensions, color lc, color dc) {
    displayBoard = b;
    pos = position;
    dim = dimensions;
    lightColor = lc;
    darkColor = dc;
  }

  void showSquares() {
    noStroke();

    for (int file = 0; file<8; file++) {
      for (int rank = 0; rank<8; rank++) {
        if ((file+rank)%2 == 0) fill(lightColor);
        else fill(darkColor);

        square(file*s, rank*s, s);
      }
    }
  }
  void showPieces() {
    noStroke();

    for (int file = 0; file<8; file++) {
      for (int rank = 0; rank<8; rank++) {
        if (!(file+rank*8 == hiddenSquare && hidePiece)) {
          int piece = board.squares[getIndex(file, rank)];
          image(getPieceImage(piece), file*s, rank*s, s, s);
        }
      }
    }
    if (selectedSquare != -1000)image(getPieceImage(board.squares[selectedSquare]), mouseX - s/2, mouseY - s/2, s, s);
  }
}
