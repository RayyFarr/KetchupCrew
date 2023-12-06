import java.util.*;
import java.util.stream.Collectors;

float s;

Board board = new Board();
BoardUI boardUI;

MoveGenerator moveGenerator;

int moveNumber = 0;
boolean checkmate = false;

int tgtSquare = -1000;
int selectedSquare = -1000;

KetchupCrewLvl1 bot = new KetchupCrewLvl1();
void setup() {
  size(1000, 1000);
  s = width/8.0;
  setupImages();
  computeMoveData();

  /*Example Fens:
   ini pos:rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR
   2r1r2k/2nb1ppp/3Ppq2/p1ppnp1p/1pBRPN2/P1P5/1P2QPPP/2B1R1K1
   8/b1n1k3/2rppp1n/8/5PP1/N3P3/6K1/B2N1R2
   r3k2r/ppp4P/PPP5/8/8/8/8/5K2
   */

  board = fenToBoard("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR");
  board.init();
  boardUI = new BoardUI(board, new PVector(0, 0), 800, color(238, 238, 210), color(118, 150, 86));

  moveGenerator = new MoveGenerator();
  
  //frameRate(2);
  //println(bot.moveGenerationTest(4));
  
    moveGenerator.generateLegalMoves(board);

}

void draw() {
  background(0);
  for (int i = 0; i<1; i++) {
    if (checkmate || board.pieceList.size() == 2) {
      board = fenToBoard("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR");
      checkmate = false;
      return;
    }    
    //bot vs bot//
      //ArrayList<Move> currentMoves = moveGenerator.generateLegalMoves(board);
    
      //board.makeMove(currentMoves.get((int)random(0, currentMoves.size())));
      //moveGenerator.generateLegalMoves(board);
      //if(moveGenerator.moves.size()==0)checkmated(board.whiteTurn);

    //moveGenerator.showAllMoves();
  }

  boardUI.showSquares();
  moveGenerator.showPieceMoves(selectedSquare);
  boardUI.showPieces();
}

void mousePressed() {
  if (checkmate) return;
  if (mouseButton == LEFT) {
    int xCoord = (int)(mouseX/s);
    int yCoord = (int)(mouseY/s);
    if (board.squares[xCoord + yCoord * 8] != 0 && selectedSquare == -1000) {
      selectedSquare = xCoord + yCoord * 8;
      boardUI.hide(selectedSquare);
      return;
    } else
      tgtSquare = xCoord + yCoord * 8;
    Move m = getMoveWithCoord(selectedSquare,tgtSquare);
    if (m != null) {
      board.makeMove(m);
      moveGenerator.generateLegalMoves(board);
      if(moveGenerator.moves.size() == 0)checkmated(board.whiteTurn);
      deSelectPiece();
    } else {
      deSelectPiece();
    }
  } else if (mouseButton ==RIGHT) {
    deSelectPiece();
  }
}
void checkmated(boolean player) {
  checkmate = true;
  if (player == true) println("Black is victorious. White is checkmated.");
  if (player == false) println("White is victorious. Black is checkmated.");
}
