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

KetchupCrewV1 botV1 = new KetchupCrewV1();
KetchupCrewV2 botV2 = new KetchupCrewV2();


int LARGENUMBER = 100000000;

String gameOverText;
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
  board = fenToBoard("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq");
  boardUI = new BoardUI(board, new PVector(0, 0), 800, color(238, 238, 210), color(118, 150, 86));

  moveGenerator = new MoveGenerator();
  //frameRate(2);
  moveGenerator.generateLegalMoves(board);
}

void draw() {
  //println(moveGenerator.inCheck());

  if (gameOver) {

    boardUI.showSquares();
    moveGenerator.showPieceMoves(selectedSquare);
    boardUI.showPieces();
    boardUI.showGameOverText();
    if (key == 'r' || key == 'R') {
      gameOver = false;
      board = fenToBoard("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq");
      moveGenerator.generateLegalMoves(board);

      deSelectPiece();
    }
    return;
  }


  if (!board.whiteTurn) {
    moveGenerator.generateLegalMoves(board);
    KetchupCrewV1.Result result=botV1.search(4, moveGenerator.moves.get(0));
    board.makeMove(result.move);
    board.printGameState();
    if (!board.draw)moveGenerator.generateLegalMoves(board);
    if (checkGameOver())return;
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
    if (!board.draw && m != null) {
      //println(PAWN_VALUES[0][1][36]);
      board.makeMove(m);
      board.printGameState();
      moveGenerator.generateLegalMoves(board);
      if (checkGameOver())return;

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
  gameOverText = "Checkmate!\n Press R to restart.";
}
void stalemate() {
  gameOver = true;
  println("Game drawed due to stalemate.");
  gameOverText = "Stalemate!\n Press R to restart.";
}
void drawByRule() {
  gameOver=true;
  println("Draw By Repetition or Fifty Move Rule.");
  gameOverText = "Draw!\n Press R to restart.";
}

boolean checkGameOver() {

  if (moveGenerator.moves.size() == 0) {
    if (moveGenerator.inCheck())checkmated(board.whiteTurn);
    else stalemate();

    return true;
  } else if (board.draw) {
    drawByRule();
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
