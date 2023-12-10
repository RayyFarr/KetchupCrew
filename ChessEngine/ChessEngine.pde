import java.util.*;
import java.util.stream.Collectors;
float s;

Board board = new Board();
BoardUI boardUI;

MoveGenerator moveGenerator;

int moveNumber = 0;
boolean gameOver = false;

int tgtSquare = -1000;
int selectedSquare = -1000;

KetchupCrewLvl1 bot = new KetchupCrewLvl1();


int LARGENUMBER = 100000000;
void setup() {
  size(1000, 1000);
  s = width/8.0;
  setupImages();
  computeMoveData();

  /*Example Fens:
   ini pos:rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq
   2r1r2k/2nb1ppp/3Ppq2/p1ppnp1p/1pBRPN2/P1P5/1P2QPPP/2B1R1K1
   8/b1n1k3/2rppp1n/8/5PP1/N3P3/6K1/B2N1R2
   r3k2r/ppp4P/PPP5/8/8/8/8/5K2
   rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ - 1 8
   //forced draw:7k/6p1/8/4Q3/pppp4/qqqp4/pppp1PPP/6RK w
   */
  board = fenToBoard("7k/6p1/8/4Q3/pppp4/qqqp4/pppp1PPP/6RK w");
  boardUI = new BoardUI(board, new PVector(0, 0), 800, color(238, 238, 210), color(118, 150, 86));

  moveGenerator = new MoveGenerator();
  //frameRate(2);
  //println(bot.search(2,-LARGENUMBER, LARGENUMBER));
  moveGenerator.generateLegalMoves(board);
}

void draw() {
  //println(moveGenerator.inCheck());

  if (gameOver) {

    boardUI.showSquares();
    moveGenerator.showPieceMoves(selectedSquare);
    boardUI.showPieces();
    //board = fenToBoard("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq");
    //gameOver = false;
    return;
  }
  //*random*
  //board.makeMove(moveGenerator.moves.get((int)random(moveGenerator.moves.size())));
  if (true) {
    moveGenerator.generateLegalMoves(board);
    KetchupCrewLvl1.Result result=bot.search(4, null);
    board.makeMove(result.move);
    if (checkGameOver())return;

    board.printGameState();
    moveGenerator.generateLegalMoves(board);
  }
  reRenderBoard();
}

void mousePressed() {
  if (gameOver) return;
  if (mouseButton == LEFT) {
    int xCoord = (int)(mouseX/s);
    int yCoord = (int)(mouseY/s);
    if (board.squares[xCoord + yCoord * 8] != 0 && selectedSquare == -1000) {
      selectedSquare = xCoord + yCoord * 8;
      boardUI.hide(selectedSquare);
      return;
    } else
      tgtSquare = xCoord + yCoord * 8;
    Move m = getMoveWithCoord(selectedSquare, tgtSquare);
    if (!board.drawByRepetition && m != null) {
      //println(PAWN_VALUES[0][1][36]);
      board.makeMove(m);
      if (checkGameOver())return;
      board.printGameState();
      moveGenerator.generateLegalMoves(board);
      reRenderBoard();
      deSelectPiece();
    } else {
      deSelectPiece();
    }
  } else if (mouseButton == RIGHT) {
    deSelectPiece();
  }
}
void checkmated(boolean player) {
  gameOver = true;
  if (player == true) println("Black is victorious. White is checkmated.");
  if (player == false) println("White is victorious. Black is checkmated.");
}
void stalemate() {
  gameOver = true;
  println("Game drawed due to stalemate.");
}
void repetitionDraw() {
  gameOver=true;
  println("Draw By Repetition.");
}

boolean checkGameOver() {

  if (moveGenerator.moves.size() == 0) {
    if (moveGenerator.inCheck())checkmated(board.whiteTurn);
    else stalemate();

    return true;
  } else if (board.drawByRepetition) {
    repetitionDraw();
    return true;
  }
  return false;
}


void reRenderBoard() {
  background(0);
  boardUI.showSquares();
  moveGenerator.showPieceMoves(selectedSquare);
  boardUI.showPieces();
}
