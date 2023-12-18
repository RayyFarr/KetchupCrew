class BoardUI
{
  float dim;
  float inc;


  color lightColor = color(#34CBAE);
  color darkColor = color(#CB3451);

  Board displayBoard;
  Move playedMove;




  int animationProgress = 100;
  boolean animationDone = true;
  float animationEasing = 0.25;

  BoardUI(Board b, float dimensions, color lc, color dc) {
    displayBoard = b;
    dim = dimensions;
    inc = dimensions/8.0;
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
    for (int file = 0; file<8; file++) {
      for (int rank = 0; rank<8; rank++) {
        if ((file+rank)%2 == 0) fill(lightColor);
        else fill(darkColor);

        square(file*inc, rank*inc, inc);

        //text(file+rank*8, file*s + 5, rank*s+s-5);
      }
    }
    if (playedMove!=null) {
      fill(#0FF080);
      square(file(playedMove.startSquare)*inc, rank(playedMove.startSquare)*inc, inc);
      fill(#28D75D);
      square(file(playedMove.endSquare)*inc, rank(playedMove.endSquare)*inc, inc);
    }
  }
  void showPieces() {
    noStroke();
    boolean isAnimationPiece = false;
    for (int file = 0; file<8; file++) {
      for (int rank = 0; rank<8; rank++) {
        isAnimationPiece = playedMove != null && file+rank*8==playedMove.endSquare && !animationDone;
        if (!isAnimationPiece && board.squares[file+rank*8] != empty) {

          int piece = board.squares[getIndex(file, rank)];
          image(getPieceImage(piece), file*inc, rank*inc, inc, inc);
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
      image(getPieceImage(piece), movedX*inc, movedY*inc, inc,inc);
    }
  }
  void showGameOverText() {
    fill(0, 150);
    rect(0, 0, width, height);
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(80);
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

  void showPieceMoves(int startSquare) {

    PVector start = indexToCoord(startSquare);
    fill(186, 202, 68);
    square(start.x*inc, start.y*inc, inc);

    for (int i = 0; i<moveGenerator.moves.size(); i++) {
      if (moveGenerator.moves.get(i).startSquare != startSquare) continue;
      int endSquare = moveGenerator.moves.get(i).endSquare;
      PVector end = indexToCoord(moveGenerator.moves.get(i).endSquare);
      fill(0, 70);
      if(board.squares[endSquare] == empty)circle(end.x*inc+inc/2, end.y*inc+inc/2, inc/2);
      else{
        rectMode(CENTER);
        square(end.x*inc+inc/2, end.y*inc+inc/2, inc-inc/10);
        rectMode(CORNER);
      }
    }
  }
}
