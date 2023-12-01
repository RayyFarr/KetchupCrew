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
        else if (pieceType(piece) == king){         
          generateKingMoves(file+rank*8);
        }
      }
    }

    return moves;
  }
  int getKingSquare(boolean whiteToMove){
    for(int i = 0;i<64;i++){
      if(pieceType(this.board.squares[i]) == king && isColor(this.board.squares[i],whiteToMove)){
        kingSquare = i;
        return i;  
      }
    }
    kingSquare = -1000;
    return -1000;
  }
  ArrayList<Move> generateLegalMoves(Board _board){
    this.board = _board;
    ArrayList<Move> pseudoLegalMoves = generateMoves(this.board);  
    ArrayList<Move> legalMoves = new ArrayList<Move>();

    for(Move move : pseudoLegalMoves){
      this.board.makeMove(move);
      int myKingSquare = getKingSquare(!this.board.whiteTurn);
      ArrayList<Move> responses = generateMoves(this.board);  
      
      boolean illegal = false;
      for(int i = 0;i<responses.size();i++){
        println(responses.get(i).endSquare,myKingSquare);
        if(responses.get(i).endSquare == myKingSquare) {
          
          println("truth hurts");
          illegal = true;
        }
      }
              
      if(!illegal){
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
            moves.add(new Move(startSquare, targetSquare));
            break;
          }
        }
        moves.add(new Move(startSquare, targetSquare));
      }
    }
  }

  void generatePawnMoves(int startSquare, int piece) {
    int forward = 8;
    if (getColor(piece) == white) forward *= -1;


    if (this.board.squares[startSquare+forward] == 0)
      moves.add(new Move(startSquare, startSquare+forward));
    if (this.board.squares[startSquare+forward] == 0 && (startSquare - 2 * forward  < 0 || startSquare - 2 * forward > 63) && this.board.squares[startSquare + 2*forward] == 0)
      moves.add(new Move(startSquare, startSquare + 2*forward));

    int isBlack = getColor(piece) == black ? 1 : 0;
    for (int i = 0; i < 2; i++) {
      int captSquare = startSquare + pawnAttackDir[isBlack][i];
      if (this.board.squares[captSquare] != 0
        && !isColor(this.board.squares[captSquare], this.board.whiteTurn)
        && abs(indexToCoord(captSquare).y - indexToCoord(startSquare).y) < 2)
        moves.add(new Move(startSquare, captSquare));
    }
  }

  void generateKnightMoves(int startSquare) {
    int[] nMoves = knightMoves[startSquare];
    for (int i = 0; i<nMoves.length; i++) {
      if (!(this.board.squares[nMoves[i]] != empty && isColor(this.board.squares[nMoves[i]], this.board.whiteTurn)))moves.add(new Move(startSquare, nMoves[i]));
    }
  }

  void generateKingMoves(int startSquare) {
    for (int n = 0; n<directionOffsets.length; n++) {
      int sq = startSquare + directionOffsets[n];
      if (sq > 0 && sq < 64 && !isColor(this.board.squares[sq], this.board.whiteTurn))
      {

        moves.add(new Move(startSquare, sq));
      }
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
