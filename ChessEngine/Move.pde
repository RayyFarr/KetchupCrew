class Move {

  class Flag {
    public static final int none = 0;
    public static final int isEnPassant = 1;
    public static final int castling = 2;
    public static final int promoteToQueen = 3;
    public static final int promoteToKnight = 4;
    public static final int promoteToRook = 5;
    public static final int promoteToBishop = 6;
    public static final int pawnTwoForward = 7;
  }

  int startSquare;
  int endSquare;
  int flag;

  Move(int startSquare, int endSquare, int flag) {
    this.startSquare = startSquare;
    this.endSquare   = endSquare;
    this.flag        = flag;
  }

  boolean isPromotion() {
    if (flag == Flag.promoteToQueen
      || flag == Flag.promoteToKnight
      || flag == Flag.promoteToRook
      || flag == Flag.promoteToBishop
      )
    {
      return true;
    }

    return false;
  }
  int promotionPiece() {
    switch(flag) {
    case Flag.promoteToQueen:
      return queen;
    case Flag.promoteToKnight:
      return knight;
    case Flag.promoteToRook:
      return rook;
    case Flag.promoteToBishop:
      return bishop;
    default:
      return 0;
    }
  }
}
