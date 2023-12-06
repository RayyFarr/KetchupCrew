class MoveGenerator {

  Board board;
  ArrayList<Move> moves;

  int kingSquare;
  ArrayList<Move> generateMoves(Board _board) {
    moves = new ArrayList<Move>();
    this.board = _board;
    for (int file = 0; file<8; file++) {
      for (int rank = 0; rank<8; rank++) {

        int piece = board.squares[file + rank*8];

        if (!isColor(piece, this.board.whiteTurn)) continue;
        if (isSliding(piece))generateSlidingMoves(file + rank*8, pieceType(piece));
        else if (pieceType(piece) == pawn) generatePawnMoves(file + rank * 8, piece);
        else if (pieceType(piece) == knight) generateKnightMoves(file + rank * 8);
        else if (pieceType(piece) == king) {
          generateKingMoves(file+rank*8);
        }
      }
    }

    return moves;
  }
  int getKingSquare(boolean whiteToMove) {
    for (int i = 0; i<64; i++) {
      if (pieceType(this.board.squares[i]) == king && isColor(this.board.squares[i], whiteToMove)) {
        kingSquare = i;
        return i;
      }
    }
    kingSquare = -1000;
    return -1000;
  }
  ArrayList<Move> generateLegalMoves(Board _board) {
    this.board = _board;
    ArrayList<Move> pseudoLegalMoves = generateMoves(this.board);
    ArrayList<Move> legalMoves = new ArrayList<Move>();
    for (Move move : pseudoLegalMoves) {
      this.board.makeMove(move);
      int myKingSquare = getKingSquare(!this.board.whiteTurn);
      ArrayList<Move> responses = generateMoves(this.board);

      boolean illegal = false;
      for (int i = 0; i<responses.size(); i++) {
        if (responses.get(i).endSquare == myKingSquare) {
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

  void generateSlidingMoves(int startSquare, int piece) {

    int startDirIndex = (pieceType(piece) == bishop) ? 4 : 0;
    int endDirIndex   = (pieceType(piece) == rook) ? 4 : 8;



    for (int dirIndex = startDirIndex; dirIndex < endDirIndex; dirIndex++) {
      int dirOffset = directionOffsets[dirIndex];
      for (int n = 0; n<distToEdge[startSquare][dirIndex]; n++) {
       
        int targetSquare = startSquare + (n+1) * dirOffset;
        if (this.board.squares[targetSquare] != 0) {
          if (isColor(this.board.squares[targetSquare], this.board.whiteTurn))
            break;
          else {
            moves.add(new Move(startSquare, targetSquare,Move.Flag.none));
            break;
          }
        }
        moves.add(new Move(startSquare, targetSquare,Move.Flag.none));
      }
    }
  }

  void generatePawnMoves(int startSquare, int piece) {
    int c = int(this.board.whiteTurn);
    int forward = 8;
    if (c==1) forward *= -1;
    if (this.board.squares[startSquare+forward] == 0) {
      moves.add(new Move(startSquare, startSquare+forward,Move.Flag.pawnTwoForward));
      if (pawnTwoJumpSquares.get(c).contains(startSquare) && this.board.squares[startSquare+forward*2] == 0)
        moves.add(new Move(startSquare, startSquare+forward*2,Move.Flag.pawnTwoForward));
    }
    
    for (int i = 0; i<pawnCaptures[c][startSquare].length; i++){
      if (this.board.squares[pawnCaptures[c][startSquare][i]] != 0 
        && !isColor(this.board.squares[pawnCaptures[c][startSquare][i]], this.board.whiteTurn))
        moves.add(new Move(startSquare, pawnCaptures[c][startSquare][i],Move.Flag.none));
    }
  }

  void generateKnightMoves(int startSquare) {
    int[] nMoves = knightMoves[startSquare];
    for (int i = 0; i<nMoves.length; i++) {
      if (!(this.board.squares[nMoves[i]] != empty && isColor(this.board.squares[nMoves[i]], this.board.whiteTurn)))moves.add(new Move(startSquare, nMoves[i],Move.Flag.none));
    }
  }

  void generateKingMoves(int startSquare) {
    //println(kingMoves[startSquare].length);
    for (int i = 0; i<kingMoves[startSquare].length; i++) {
      int endSquare = kingMoves[startSquare][i];
      //println(manhattanDistance(startSquare,endSquare));
      if (!isColor(this.board.squares[endSquare], this.board.whiteTurn))
        moves.add(new Move(startSquare, endSquare,Move.Flag.none));
    }
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
