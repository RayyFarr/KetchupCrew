Board fenToBoard(String fenString) {
  Board board = new Board();
  board.init();

  char[] chars = fenString.toCharArray();

  int file = 0;
  int rank = 0;
  boolean detectCastling = false;
  boolean whiteTurn = true;
  int colorToMove = white;
  int opponent = black;

  int gameState = 0;
  for (int i = 0; i<chars.length; i++) {
    char c = chars[i];

    if (c == ' ')
      detectCastling = true;
    if (!detectCastling) {
      if (Character.isDigit(c)) {
        file += Character.getNumericValue(c);
      } else if (c == '/') {
        rank++;
        file=0;
      } else {

        char lc = Character.toLowerCase(c);

        int sq = board.squares[file + rank*8];
        boolean whitePiece = Character.isUpperCase(c);
        if (lc == 'k')
          sq = king;
        else if (lc == 'p')
          sq = pawn;
        else if (lc == 'n')
          sq = knight;
        else if (lc == 'b')
          sq = bishop;
        else if (lc == 'r')
          sq = rook;
        else if (lc == 'q')
          sq = queen;
        board.getPieceList(sq, int(whitePiece)).addPiece(file+rank*8);

        if (whitePiece) {
          if (lc == 'k')board.kingSquares[1] = file+rank*8;
          sq |= white;
        } else
        {
          if (lc == 'k')board.kingSquares[0] = file+rank*8;
          sq |= black;
        }
        board.squares[file + rank*8] = sq;
        file += 1;
      }
    } else {
      if (c=='w') {
        whiteTurn = true;
        colorToMove = white;
        opponent = black;
      } else if (c=='b') {
        whiteTurn = false;
        colorToMove = black;
        opponent = white;
      } else if (c == 'K')gameState |= 0b0001;
      else if (c=='Q')gameState |= 0b0010;
      else if (c=='k')gameState |= 0b0100;
      else if (c=='q')gameState |= 0b1000;
    }
  }
  board.gameState = gameState;
  board.whiteTurn = whiteTurn;
  board.colorToMove = colorToMove;
  board.opponent = opponent;
  return board;
}
