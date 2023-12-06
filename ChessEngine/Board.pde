class Board {
  int[] squares = new int[64];

  boolean whiteTurn = true;
  int colorToMove;
  int opponent;

  color lightColor = color(50, 205, 203);
  color darkColor  = color(205, 50, 52);
  boolean promotedLastMove = false;

  IntList pieceList = new IntList();


  /*bits : 0-3 -> en passant file
   4-8 -> captured Piece
   9-12 -> castling legalities.
   
   */
  Stack<Integer> gameStateHistory = new Stack();
  int gameState = 0b000000001111;


  int capPieceMask = 0b0000111110000;
  int epFileMask = 0b1111000000000;
  int castlingMask = 0b0000000001111;


  void makeMove(Move move) {
    gameState = 0;

    int startSquare=move.startSquare;
    int targetSquare=move.endSquare;
    int capturedPiece=squares[targetSquare];
    boolean isPromotion = move.isPromotion();
    PVector targetPosition = indexToCoord(targetSquare);

    gameState |= capturedPiece<<4;

    squares[targetSquare] = squares[startSquare];

    if (isPromotion) {
      int promotionPiece = move.promotionPiece();
      squares[targetSquare] = promotionPiece;
    } else {
      int epSquare = targetSquare + ((colorToMove == white) ? -8 : 8);

      switch(move.flag) {
      case Move.Flag.isEnPassant:
        gameState |= squares[epSquare];
        squares[epSquare] = 0;
        break;
      case Move.Flag.pawnTwoForward:
        gameState |= (int)(targetPosition.x+1) << 8;
        break;
      case Move.Flag.castling:
        boolean kingSide = targetPosition.x==6 ? true:false;
        int rookMoveFrom = kingSide ? targetSquare+1 : targetSquare-2;
        int rookMoveTo = kingSide ? targetSquare-1:targetSquare+1;

        squares[rookMoveTo] = squares[rookMoveFrom];
        squares[rookMoveFrom] = empty;

        gameState &= 0b111111111 | (kingSide ? 1100:0011);
      }
    }
    squares[startSquare] = capturedPiece;

    gameStateHistory.push(gameState);
    whiteTurn = !whiteTurn;
    if (whiteTurn) {
      colorToMove = white;
      opponent = black;
    } else {
      colorToMove = black;
      opponent = white;
    }
  }


  void unMakeMove(Move move) {
    int startSquare=move.startSquare;
    int targetSquare=move.endSquare;
    int capturedPiece=gameState;
    boolean isPromotion = move.isPromotion();
    PVector targetPosition = indexToCoord(targetSquare);

    squares[startSquare] = squares[targetSquare];

    if (isPromotion)
      squares[startSquare] = colorToMove | pawn;
    else {
      int epSquare = targetSquare + ((colorToMove == white) ? -8 : 8);

      switch(move.flag) {
      case Move.Flag.isEnPassant:
        squares[epSquare] = opponent | pawn;
        break;
      case Move.Flag.pawnTwoForward:
        gameState |= (int)(targetPosition.x+1) << 8;
        break;
      case Move.Flag.castling:
        boolean kingSide = targetPosition.x==6 ? true:false;
        int rookMoveFrom = kingSide ? targetSquare+1 : targetSquare-2;
        int rookMoveTo = kingSide ? targetSquare-1:targetSquare+1;

        squares[rookMoveFrom] = squares[rookMoveTo];
        squares[rookMoveFrom] = empty;
      }
    }
    squares[startSquare] = capturedPiece;

    gameStateHistory.pop();
    gameState=gameStateHistory.lastElement();
    whiteTurn = !whiteTurn;
    if (whiteTurn) {
      colorToMove = white;
      opponent = black;
    } else {
      colorToMove = black;
      opponent = white;
    }
  }

  void init() {
    gameState = 0b000000001111;
    gameStateHistory = new Stack();
    gameStateHistory.push(gameState);
  }
}
