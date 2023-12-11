class Board {
  int[] squares = new int[64];

  boolean whiteTurn = true;
  int colorToMove = white;
  //1 is white 0 is black.
  int colorIndex;
  int opponent;
  int[] kingSquares = new int[2];


  color lightColor = color(50, 205, 203);
  color darkColor  = color(205, 50, 52);
  boolean promotedLastMove = false;

  boolean whiteCastled=false;
  boolean blackCastled = false;

  public PieceList[] rooks;
  public PieceList[] bishops;
  public PieceList[] queens;
  public PieceList[] knights;
  public PieceList[] pawns;

  PieceList[] allPieceLists;


  /*bits : 0-3 -> en passant file
   4-8 -> captured Piece
   9-12 -> castling legalities.
   
   */
  Stack<Integer> gameStateHistory = new Stack();
  int gameState = 0b000000001111;


  //fens of previous positions.
  String fenString;
  Stack<String> repetitionHistory = new Stack();
  
  //5.5 means 5 moves and white made a move.increment by 0.5 each move.
  float fiftyMoveCount=0;
  Stack<Float> fiftyMoveHistory = new Stack();

  boolean draw;


  //this works after bitwise shift to as left as possible
  int capPieceMask = 0b11111;
  int epFileMask = 0b1111;
  int castlingMask = 0b1111;

  int plyCount = 1;

  PieceList getPieceList(int pieceType, int c) {
    return allPieceLists[c*8 + pieceType];
  }

  void makeMove(Move move) {
    int startSquare=move.startSquare;
    int targetSquare=move.endSquare;
    int capturedPiece=squares[targetSquare];
    int pieceType = pieceType(squares[startSquare]);
    int capPieceType = pieceType(capturedPiece);

    int newCastleState = gameState & castlingMask;
    boolean isPromotion = move.isPromotion();
    PVector startPosition = indexToCoord(startSquare);
    PVector targetPosition = indexToCoord(targetSquare);

    gameState = 0;
    gameState |= capturedPiece<<4;

    squares[targetSquare] = squares[startSquare];
    
    fiftyMoveCount += 0.5;
    if (pieceType == king) {
      kingSquares[int(whiteTurn)] = targetSquare;
      newCastleState &= (colorToMove == white)? 0b1100:0b0011;
    } else
      getPieceList(pieceType, int(whiteTurn)).move(startSquare, targetSquare);


    if (pieceType==rook)
    {
      if (startPosition.x == 7)
        newCastleState &= colorToMove==white?0b1110:0b1011;
      else if (startPosition.x == 0)
        newCastleState &= colorToMove==white?0b1101:0b0111;
    } else if (pieceType(capturedPiece) == rook) {
      if (targetPosition.x == 7)
        newCastleState &= colorToMove==black?0b1110:0b1011;
      else if (targetPosition.x == 0)
        newCastleState &= colorToMove==black?0b1101:0b0111;
    }
    
    if(pieceType == pawn) fiftyMoveCount = 0;


    if (capturedPiece != empty && !(move.flag == Move.Flag.isEnPassant)) {
      fiftyMoveCount = 0;
      getPieceList(capPieceType, int(!whiteTurn)).removePiece(targetSquare);
    }
    if (isPromotion) {
      int promotionType = move.promotionPiece();

      getPieceList(promotionType, colorIndex).addPiece(targetSquare);
      squares[targetSquare] = colorToMove | promotionType;
      pawns[int(whiteTurn)].removePiece(targetSquare);
    } else {
      int epSquare = targetSquare + ((colorToMove == white) ? 8 : -8);
      switch(move.flag) {
      case Move.Flag.isEnPassant:
        gameState |= squares[epSquare]<<4;
        pawns[int(!whiteTurn)].removePiece(epSquare);
        squares[epSquare] = 0;
        break;
      case Move.Flag.pawnTwoForward:
        gameState |= ((int)targetPosition.x+1)<<9;
        break;
      case Move.Flag.castling:
        boolean kingSide = targetPosition.x==6 ? true:false;
        int rookMoveFrom = kingSide ? targetSquare+1 : targetSquare-2;
        int rookMoveTo = kingSide ? targetSquare-1:targetSquare+1;

        if (colorToMove==white)whiteCastled = true;
        else blackCastled = true;

        squares[rookMoveTo] = squares[rookMoveFrom];
        squares[rookMoveFrom] = empty;

        rooks[colorIndex].move(rookMoveFrom, rookMoveTo);
        newCastleState &= colorToMove==white?0b1100:0b0011;
      }
    }
    gameState |= newCastleState;
    squares[startSquare] = empty;
    gameStateHistory.push(gameState);
    
    fenString = board.toString();
    repetitionHistory.push(fenString);
    fiftyMoveHistory.push(fiftyMoveCount);
    draw = isDraw();
    whiteTurn = !whiteTurn;
    colorIndex = int(whiteTurn);
    if (whiteTurn) {
      colorToMove = white;
      opponent = black;
    } else {
      colorToMove = black;
      opponent = white;
    }
    plyCount++;

    //printGameState();
  }


  void unMakeMove(Move move) {
    int startSquare=move.startSquare;
    int targetSquare=move.endSquare;
    int pieceType = pieceType(squares[targetSquare]);
    int capturedPiece=(gameState>>4)&capPieceMask;
    int capPieceType = pieceType(capturedPiece);

    boolean isPromotion = move.isPromotion();
    PVector targetPosition = indexToCoord(targetSquare);

    whiteTurn = !whiteTurn;
    colorIndex = int(whiteTurn);

    if (whiteTurn) {
      colorToMove = white;
      opponent = black;
    } else {
      colorToMove = black;
      opponent = white;
    }
    plyCount--;

    squares[startSquare] = squares[targetSquare];
    squares[targetSquare] = 0;
    if (capturedPiece != empty && move.flag != Move.Flag.isEnPassant) {
      squares[targetSquare] = capturedPiece;
      getPieceList(capPieceType, int(!whiteTurn)).addPiece(targetSquare);
    }

    if (pieceType == king)
      kingSquares[int(whiteTurn)] = startSquare;
    else if (!isPromotion) {
      getPieceList(pieceType, int(whiteTurn)).move(targetSquare, startSquare);
    }
    if (isPromotion) {
      squares[startSquare] = colorToMove | pawn;
      pawns[colorIndex].addPiece(startSquare);

      int promotionType = move.promotionPiece();

      getPieceList(promotionType, colorIndex).removePiece(targetSquare);
    } else {
      int epSquare = targetSquare + ((colorToMove == black) ? -8 : 8);

      switch(move.flag) {
      case Move.Flag.isEnPassant:
        squares[epSquare] = capturedPiece;
        squares[targetSquare] = empty;
        pawns[int(!whiteTurn)].addPiece(epSquare);

        break;

      case Move.Flag.castling:
        boolean kingSide = targetPosition.x==6 ? true:false;
        int rookMoveFrom = kingSide ? targetSquare+1 : targetSquare-2;
        int rookMoveTo = kingSide ? targetSquare-1:targetSquare+1;
        if (colorToMove==white)whiteCastled = false;
        else blackCastled = false;

        squares[rookMoveFrom] = squares[rookMoveTo];
        squares[rookMoveTo] = 0;
        rooks[colorIndex].move(rookMoveTo, rookMoveFrom);
      }
    }
    gameStateHistory.pop();
    gameState=gameStateHistory.peek();
    repetitionHistory.pop();
    fenString = repetitionHistory.peek();
    fiftyMoveHistory.pop();
    fiftyMoveCount=fiftyMoveHistory.peek();
    draw = isDraw();
  }

  //piece fen notation.
  char[] pieceName
    = new char []{
    '.',
    '.',
    '.',
    '.',
    '.',
    '.',
    '.',
    '.',
    '.',
    'K',
    'P',
    'N',
    '.',
    'B',
    'R',
    'Q',
    '.',
    'k',
    'p',
    'n',
    '.',
    'b',
    'r',
    'q'
  };

  String toString() {
    String fen = "";
    for (int rank = 0; rank<8; rank++) {
      for (int file = 0; file<8; file++) {
        char c = pieceName[squares[file+rank*8]];
        fen+=c;
      }
      fen+="/";
    }

    fen += gameState&castlingMask;
    return fen;
  }
  boolean isDraw() {
    int count = 0;
    for (String fen : repetitionHistory) {
      if (fen.equals(fenString)) {
        count++;
      }
    }

    return (count >= 3) || (fiftyMoveCount >= 50);
  }
  void switchSides() {
    whiteTurn = !whiteTurn;
    colorIndex = int(whiteTurn);
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
    fenString = toString();
    repetitionHistory = new Stack();
    repetitionHistory.push(fenString);
    fiftyMoveCount = 0;
    fiftyMoveHistory = new Stack();
    fiftyMoveHistory.push(fiftyMoveCount);
    whiteTurn = true;
    colorToMove =white;
    opponent = black;
    plyCount = 0;

    knights = new PieceList[]{new PieceList(), new PieceList()};
    bishops = new PieceList[]{new PieceList(), new PieceList()};
    rooks = new PieceList[]{new PieceList(), new PieceList()};
    queens = new PieceList[]{new PieceList(), new PieceList()};
    pawns = new PieceList[]{new PieceList(), new PieceList()};
    PieceList empties = new PieceList();
    allPieceLists = new PieceList[]{
      empties,
      empties,
      pawns[0],
      knights[0],
      empties,
      bishops[0],
      rooks[0],
      queens[0],
      empties,
      empties,
      pawns[1],
      knights[1],
      empties,
      bishops[1],
      rooks[1],
      queens[1],
    };
  }

  int getPieceCount() {
    return knights[0].numPieces+bishops[0].numPieces+rooks[0].numPieces+queens[0].numPieces
      +knights[1].numPieces+bishops[1].numPieces+rooks[1].numPieces+queens[1].numPieces;
  }

  void printGameState() {
    println("Move : " + plyCount/2 + "\n Ply : " + plyCount
      + "\n En Passant File : " + (gameState>>9)
      + "\n En Passant Rank : " + (colorToMove==white?5:1)
      + "\n Captured Piece : " + Integer.toBinaryString((gameState<<4 & capPieceMask))
      + "\n Castle Rights : " + Integer.toBinaryString((gameState & castlingMask))
      + "\n Entire Game State: " + Integer.toBinaryString(gameState)
      + "\n Color To Move : " + (colorToMove == white ? "White" : "Black")
      + "\n White King Square : " + kingSquares[1]
      + "\n Black King Square : " + kingSquares[0]
      + "\n Fifty Move Counter: " + (int)fiftyMoveCount
      + "\n");
  }
}
