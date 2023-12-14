class BoardUI
{

  PVector pos;
  float dim;

  color lightColor = color(#34CBAE);
  color darkColor = color(#CB3451);

  Board displayBoard;
  Move playedMove;




  int animationProgress = 100;
  boolean animationDone = true;
  float animationEasing = 0.25;

  BoardUI(Board b, PVector position, float dimensions, color lc, color dc) {
    displayBoard = b;
    pos = position;
    dim = dimensions;
    lightColor = lc;
    darkColor = dc;
  }

  //MUST BE CALLED BEFORE MAKING THE MOVE ON BOARD !!!!!
  void playMove(Move move) {
    playedMove = move;
    playSounds(move);
    animationDone = false;
    animationProgress = 0;
  }
  void showSquares() {
    noStroke();
    fill(255);
    for (int file = 0; file<8; file++) {
      for (int rank = 0; rank<8; rank++) {
        if ((file+rank)%2 == 0) fill(lightColor);
        else fill(darkColor);

        square(file*s, rank*s, s);

        fill(0);
        //text(file+rank*8, file*s + 5, rank*s+s-5);
      }
    }
    if (playedMove!=null) {
      fill(#0FF080);
      square(file(playedMove.startSquare)*s, rank(playedMove.startSquare)*s, s);
      fill(#28D75D);
      square(file(playedMove.endSquare)*s, rank(playedMove.endSquare)*s, s);
    }
    fill(255);
  }
  void showPieces() {
    noStroke();
    boolean isAnimationPiece = false;
    for (int file = 0; file<8; file++) {
      for (int rank = 0; rank<8; rank++) {
        isAnimationPiece = playedMove != null && file+rank*8==playedMove.endSquare && !animationDone;
        if (!isAnimationPiece) {

          int piece = board.squares[getIndex(file, rank)];
          image(getPieceImage(piece), file*s, rank*s, s, s);
        }
      }
    }
    if (!animationDone) {

      animationProgress += (110-animationProgress)*animationEasing;
      animationProgress = min(100, animationProgress);
      animationDone = animationProgress>=100;

      float movedX = map(animationProgress, 0, 100, file(playedMove.startSquare), file(playedMove.endSquare));
      float movedY = map(animationProgress, 0, 100, rank(playedMove.startSquare), rank(playedMove.endSquare));
      int piece = board.squares[playedMove.endSquare];
      image(getPieceImage(piece), movedX*s, movedY*s, s, s);
    }
  }
  void showGameOverText() {
    fill(0, 150);
    rect(0, 0, width, height);
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(100);
    text(gameOverText, width/2, height/2);
  }
  void playSounds(Move move) {

    board.makeMove(move);
    moveGenerator.generateLegalMoves(board);
    if (checkGameOver()) {
      checkMateSound.play();
      board.unMakeMove(move);
      return;
    }
    board.unMakeMove(move);

    moveSound.play();
  }

  void animate() {
  }
}
