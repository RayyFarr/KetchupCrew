class MoveGenerator {

  Board board;
  ArrayList<Move> moves;

  int friendlyKingSquare;
  int opponentKingSquare;
  int friendlyColorIndex;
  int opponentColorIndex;

  int f1 = 61;
  int f8 = 5;
  int d1 = 59;
  int d8 = 3;


  void init() {
    moves = new ArrayList<Move>();

    friendlyColorIndex = int(board.whiteTurn);
    opponentColorIndex = int(!board.whiteTurn);

    friendlyKingSquare = board.kingSquares[friendlyColorIndex];
    opponentKingSquare = board.kingSquares[opponentColorIndex];
  }
  ArrayList<Move> generateMoves(Board _board) {
    board = _board;
    init();

    generateKingMoves();
    generatePawnMoves();
    generateSlidingMoves();
    generateKnightMoves();

    return moves;
  }


  boolean inCheck() {
    ArrayList<Move> moves = generateOpponentLegalMoves(board);
    int kingSquare=board.kingSquares[int(board.whiteTurn)];
    for (Move move : moves) {
      if (move.endSquare==kingSquare)return true;
    }
    return false;
  }
  ArrayList<Move> generateLegalMoves(Board _board) {
    this.board = _board;
    ArrayList<Move> pseudoLegalMoves = generateMoves(this.board);
    ArrayList<Move> legalMoves = new ArrayList<Move>();
    for (Move move : pseudoLegalMoves) {
      this.board.makeMove(move);
      int myKingSquare = board.kingSquares[int(!board.whiteTurn)];
      boolean castle = move.flag == Move.Flag.castling;
      ArrayList<Move> responses = generateMoves(this.board);

      boolean illegal = false;

      for (int i = 0; i<responses.size(); i++) {
        if (responses.get(i).endSquare == myKingSquare
          ||(castle && (responses.get(i).endSquare==move.startSquare+(move.endSquare-move.startSquare )
          || responses.get(i).endSquare==move.startSquare))) {
          illegal = true;
        }
      }

      if (!illegal) {
        legalMoves.add(move);
      }

      this.board.unMakeMove(move);
    }
    moves = legalMoves;
    return legalMoves;
  }
  ArrayList<Move> generateOpponentLegalMoves(Board _board) {
    this.board = _board;
    _board.switchSides();
    ArrayList<Move> legalMoves = generateLegalMoves(board);
    _board.switchSides();
    moves = legalMoves;
    return legalMoves;
  }
  void generateSlidingMoves() {
    PieceList rooks = board.rooks[friendlyColorIndex];
    for (int i = 0; i<rooks.numPieces; i++)
      generateSlidingPieceMoves(rooks.occupiedSquares[i], rook);

    PieceList bishops = board.bishops[friendlyColorIndex];
    for (int i = 0; i<bishops.numPieces; i++)
      generateSlidingPieceMoves(bishops.occupiedSquares[i], bishop);

    PieceList queens = board.queens[friendlyColorIndex];
    for (int i = 0; i<queens.numPieces; i++)
      generateSlidingPieceMoves(queens.occupiedSquares[i], queen);
  }

  void generateSlidingPieceMoves(int startSquare, int piece) {

    int startDirIndex = piece == bishop ? 4 : 0;
    int endDirIndex   = piece == rook ? 4 : 8;


    for (int dirIndex = startDirIndex; dirIndex < endDirIndex; dirIndex++) {
      int dirOffset = directionOffsets[dirIndex];
      for (int n = 0; n<distToEdge[startSquare][dirIndex]; n++) {

        int targetSquare = startSquare + (n+1) * dirOffset;
        if (this.board.squares[targetSquare] != 0) {
          if (isColor(this.board.squares[targetSquare], this.board.whiteTurn))
            break;
          else {
            moves.add(new Move(startSquare, targetSquare, Move.Flag.none));
            break;
          }
        }
        moves.add(new Move(startSquare, targetSquare, Move.Flag.none));
      }
    }
  }

  void generatePawnMoves() {
    PieceList pawns = board.pawns[friendlyColorIndex];
    int col = this.board.colorToMove;
    int turnVal = int(this.board.whiteTurn);
    int forward = 8;
    int enPassantFile = (board.gameState>>9)-1;
    int enPassantSquare = -1;

    if (enPassantFile != -1)
      enPassantSquare = enPassantFile + (col == white?2:5)*8;

    if (col==white) forward *= -1;
    for (int i = 0; i<pawns.numPieces; i++) {
      int startSquare = pawns.occupiedSquares[i];
      boolean isPromotionStep
        = rank(startSquare+forward) == 7 || rank(startSquare+forward) == 0;

      if (this.board.squares[startSquare+forward] == 0) {
        if (!isPromotionStep)moves.add(new Move(startSquare, startSquare+forward, Move.Flag.none));
        else addPromotionMoves(startSquare, startSquare+forward);
        if (pawnTwoJumpSquares.get(turnVal).contains(startSquare) && this.board.squares[startSquare+forward*2] == 0)
          moves.add(new Move(startSquare, startSquare+forward*2, Move.Flag.pawnTwoForward));
      }
      for (int j = 0; j<pawnCaptures[turnVal][startSquare].length; j++) {
        if (this.board.squares[pawnCaptures[turnVal][startSquare][j]] != 0
          && !isColor(this.board.squares[pawnCaptures[turnVal][startSquare][j]], this.board.whiteTurn)) {
          if (!isPromotionStep)
            moves.add(new Move(startSquare, pawnCaptures[turnVal][startSquare][j], Move.Flag.none));
          else
            addPromotionMoves(startSquare, pawnCaptures[turnVal][startSquare][j]);
        } else if (pawnCaptures[turnVal][startSquare][j] == enPassantSquare)
          moves.add(new Move(startSquare, pawnCaptures[turnVal][startSquare][j], Move.Flag.isEnPassant));
      }
    }
  }

  void generateKnightMoves() {
    PieceList knights = board.knights[friendlyColorIndex];
    for (int i = 0; i<knights.numPieces; i++) {
      int startSquare = knights.occupiedSquares[i];
      int[] nMoves = knightMoves[startSquare];
      for (int j = 0; j<nMoves.length; j++) {
        if (!(this.board.squares[nMoves[j]] != empty && isColor(this.board.squares[nMoves[j]], this.board.whiteTurn)))moves.add(new Move(startSquare, nMoves[j], Move.Flag.none));
      }
    }
  }

  void generateKingMoves() {
    for (int i = 0; i<kingMoves[friendlyKingSquare].length; i++) {
      int endSquare = kingMoves[friendlyKingSquare][i];
      //println(manhattanDistance(startSquare,endSquare));
      if (!isColor(this.board.squares[endSquare], this.board.whiteTurn))
        moves.add(new Move(friendlyKingSquare, endSquare, Move.Flag.none));

      if ((endSquare == f1 || endSquare == f8) && hasKingsideCastleRight()) {
        int castledSquare = endSquare+1;
        if (board.squares[endSquare] == empty && board.squares[castledSquare] == empty) {
          moves.add(new Move(friendlyKingSquare, castledSquare, Move.Flag.castling));
        }
      } else if ((endSquare == d1 || endSquare == d8) && hasQueensideCastleRight()) {
        int castledSquare = endSquare-1;
        if (board.squares[endSquare] == empty && board.squares[castledSquare] == empty && board.squares[castledSquare-1] == empty) {
          moves.add(new Move(friendlyKingSquare, castledSquare, Move.Flag.castling));
        }
      }
    }
  }


  boolean hasKingsideCastleRight() {
    int mask = board.whiteTurn ? 0b0001 : 0b0100;
    return (board.gameState & mask) != 0;
  }
  boolean hasQueensideCastleRight() {
    int mask = board.whiteTurn ? 0b0010 : 0b1000;
    return (board.gameState & mask) != 0;
  }

  void addPromotionMoves(int startSquare, int endSquare) {
    moves.add(new Move(startSquare, endSquare, Move.Flag.promoteToQueen));
    moves.add(new Move(startSquare, endSquare, Move.Flag.promoteToKnight));
    moves.add(new Move(startSquare, endSquare, Move.Flag.promoteToRook));
    moves.add(new Move(startSquare, endSquare, Move.Flag.promoteToBishop));
  }
  void showAllMoves() {

    for (int i = 0; i<moves.size(); i++) {
      PVector startPos = indexToCoord(moves.get(i).startSquare);
      PVector endPos = indexToCoord(moves.get(i).endSquare);
      fill(186, 202, 68);
      square(startPos.x*s, startPos.y*s, s);
      fill(0, 100);
      circle(endPos.x*s + s/2, endPos.y*s + s/2, s/2);
    }
  }
  void showPieceMoves(int startSquare) {

    PVector startPos = indexToCoord(startSquare);
    fill(186, 202, 68);
    square(startPos.x*s, startPos.y*s, s);

    for (int i = 0; i<moves.size(); i++) {
      if (moves.get(i).startSquare != startSquare) continue;
      PVector endPos = indexToCoord(moves.get(i).endSquare);
      fill(0, 100);
      square(endPos.x*s, endPos.y*s, s);
    }
  }
}
