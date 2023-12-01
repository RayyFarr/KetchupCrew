Board fenToBoard(String fenString) {
  Board board = new Board();
  char[] chars = fenString.toCharArray();

  int file = 0;
  int rank = 0;

  for (int i = 0; i<chars.length; i++) {
    char c = chars[i];
    if (Character.isDigit(c)) {
      file += Character.getNumericValue(c);
    } else if (c == '/') {
      rank++;
      file=0;
    } else {

      char lc = Character.toLowerCase(c);

      int sq = board.squares[file + rank*8];

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

      if (Character.isUpperCase(c)) sq |= white;
      else sq |= black;
       board.squares[file + rank*8] = sq;
      file += 1;
      
    }
  }

  return board;
}
