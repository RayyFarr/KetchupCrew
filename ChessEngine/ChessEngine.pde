float s;

Board board = new Board();
BoardUI boardUI;

MoveGenerator moveGenerator;

boolean checkmate = false;

int tgtSquare = -1000;
int selectedSquare = -1000;
void setup() {
  size(700, 700);
  s = width/8.0;
  setupImages();
  computeMoveData();

  /*Example Fens:
  ini pos:rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR
   2r1r2k/2nb1ppp/3Ppq2/p1ppnp1p/1pBRPN2/P1P5/1P2QPPP/2B1R1K1
   8/b1n1k3/2rppp1n/8/5PP1/N3P3/6K1/B2N1R2
   */

  board = fenToBoard("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR");

  boardUI = new BoardUI(board, new PVector(0, 0), 800, color(238, 238, 210), color(118, 150, 86));

  moveGenerator = new MoveGenerator();

  ArrayList<Move> newMoves = moveGenerator.generateLegalMoves(board);

}

void draw() {
  background(0);

  boardUI.showSquares();
  //moveGenerator.showAllMoves();
  if (selectedSquare != -1000) moveGenerator.showPieceMoves(selectedSquare);
  boardUI.showPieces();
}

void mousePressed() {
  if(checkmate) return;
  if (mouseButton == LEFT) {
    int xCoord = (int)(mouseX/s);
    int yCoord = (int)(mouseY/s);
    if (board.squares[xCoord + yCoord * 8] != 0 && selectedSquare == -1000) {
      selectedSquare = xCoord + yCoord * 8;
      boardUI.hide(selectedSquare);
      return;
    } else
      tgtSquare = xCoord + yCoord * 8;

    if (selectedSquare != -1000 && tgtSquare !=-1000 && !(selectedSquare == tgtSquare) && selectedIsLegal(selectedSquare, tgtSquare)) {
      board.makeMove(selectedSquare, tgtSquare);
      ArrayList<Move> newMoves = moveGenerator.generateLegalMoves(board);
      if(newMoves.size() == 0) checkmated(board.whiteTurn);
      deSelectPiece();
    } else {
      deSelectPiece();
    }
  } else if (mouseButton ==RIGHT) {
    deSelectPiece();
  }
}
void checkmated(boolean player){
   checkmate = true;
   if(player == true) println("Black is victorious. White is checkmated.");
     if(player == false) println("White is victorious. Black is checkmated.");
     

}
