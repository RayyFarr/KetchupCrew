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


float whiteTime = 300;
float blackTime = 300;

float whiteTimeLeft = 300;
float blackTimeLeft = 300;


float lastRecordedTime = 0;

int LARGENUMBER = 100000000;

String gameOverText;

float t1 = 0;
float t2 = 0;
void setup() {
  size(900, 1000, P2D);
  smooth(2);
  s = width/8.0;
  setupImages();
  computeMoveData();

  /*Example Fens:
   ini :rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq
   2r1r2k/2nb1ppp/3Ppq2/p1ppnp1p/1pBRPN2/P1P5/1P2QPPP/2B1R1K1
   r3k2r/p1ppqpb1/bn2pn2/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq
   8/b1n1k3/2rppp1n/8/5PP1/N3P3/6K1/B2N1R2
   r3k2r/ppp4P/PPP5/8/8/8/8/5K2
   8/k5q1/8/8/7K/8/4PP2/6r1 w
   rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ
   //forced draw:7k/6p1/8/4Q3/pppp4/qqqp4/pppp1PPP/6RK w
   */
  board = fenToBoard("8/8/3kr3/8/8/8/2K5/8 w ");
  boardUI = new BoardUI(board, width, color(238, 238, 210), color(118, 150, 86));

  moveGenerator = new MoveGenerator();
  //frameRate(2);
  moveGenerator.generateLegalMoves(board);


  initializeSound();

  lastRecordedTime = millis()/1000.0;
}

void draw() {
  //println(moveGenerator.inCheck());

  if (gameOver) {
    boardUI.showSquares();
    boardUI.showPieceMoves(selectedSquare);
    boardUI.showPieces();
    boardUI.showGameOverText();
    if (keyPressed && (key == 'r' || key == 'R')) {
      gameOver = false;
      whiteTimeLeft = whiteTime;
      blackTimeLeft = blackTime;
      board = fenToBoard("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq");
      boardUI.playedMove=null;
      moveGenerator.generateLegalMoves(board);

      deSelectPiece();
    }
    return;
  }
  checkGameOver();
  if (!board.whiteTurn && boardUI.animationDone) {
    int depth = board.getPieceCount() <=4?5:4;
    t1 = millis()/1000.0;

    //KetchupCrewV1.Result result=botV1.search(depth, moveGenerator.moves.get(0));
    KetchupCrewV2.Result result=botV2.search(depth, moveGenerator.moves.get(0), -LARGENUMBER, LARGENUMBER);
    t2 = millis()/1000.0;

    blackTimeLeft-=t2-t1;

    t1 = millis()/1000.0;
    boardUI.playMove(result.move);

    board.makeMove(result.move);
    board.printGameState();
    println(board.colorToMove == white? 1:-1);
    println(evaluate());
    if (!board.draw)moveGenerator.generateLegalMoves(board);
    if (checkGameOver())return;
  }

  reRenderBoard();
}

void mousePressed() {
  if (gameOver) return;
  if (mouseButton == LEFT) {
    int xCoord = (int)(mouseX/boardUI.inc);
    int yCoord = (int)(mouseY/boardUI.inc);
    if ((getColor(board.squares[xCoord + yCoord * 8])==board.colorToMove|| selectedSquare == -1000) && boardUI.animationDone) {
      selectedSquare = xCoord + yCoord * 8;
      return;
    } else
      tgtSquare = xCoord + yCoord * 8;
    Move m = getMoveWithCoord(selectedSquare, tgtSquare);
    if (!board.draw && m != null) {
      //println(PAWN_VALUES[0][1][36]);
      boardUI.playMove(m);
      board.makeMove(m);
      board.printGameState();
      moveGenerator.generateLegalMoves(board);
      t2 = millis()/1000.0;
      whiteTimeLeft-=t2-t1;
      lastRecordedTime=t2;
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
void flag(String playerName, boolean draw) {
  gameOver = true;
  if (!draw)gameOverText = playerName + " won by timeout";
  else gameOverText = "Game drawn due to \n timeout vs insufficient checkmating material";
}

void drawInfo() {
  float y = height-width;

  fill(50);
  rect(0, width, width, y);
  textSize(20);

  fill(255);
  textAlign(LEFT);
  text("White time left : \n" + round(whiteTimeLeft -(board.whiteTurn?millis()/1000.0-lastRecordedTime:0)) + " seconds", 0+10, width+y/2);

  textAlign(RIGHT);
  text("Black time left : \n" + blackTimeLeft + " seconds", width-10, width+y/2);
}

boolean checkGameOver() {

  if (moveGenerator.moves.size() == 0) {
    if (moveGenerator.inCheck())checkmated(board.whiteTurn);
    else stalemate();

    return true;
  } else if (board.draw) {
    drawByRule();
    return true;
  } else if (whiteTimeLeft<=0) {
    flag("Black", false);
    return true;
  } else if (blackTimeLeft<=0) {
    flag("White", false);
    return true;
  }


  return false;
}


void reRenderBoard() {
  background(0);
  boardUI.showSquares();
  boardUI.showPieceMoves(selectedSquare);
  boardUI.showPieces();
  drawInfo();
}
