int getIndex(int x, int y) {
  return x+y*8;
}

PImage getPieceImage(int i) {
  int offset = 0;
  if (i > 16)offset=6;

  int x = 7 & i;

  if (x == 0) return pieceImages[0];
  if (x == 1) return pieceImages[1+offset];
  if (x == 2) return pieceImages[2+offset];
  if (x == 3) return pieceImages[3+offset];
  if (x == 5) return pieceImages[4+offset];
  if (x == 6) return pieceImages[5+offset];
  if (x == 7) return pieceImages[6+offset];

  return pieceImages[0];
}

void deSelectPiece() {
  selectedSquare = -1000;
  tgtSquare = -1000;
}
PVector indexToCoord(int i) {
  int y = i/8;
  int x = i%8;

  return new PVector(x, y);
}

int rank(int square)
{
  return square/8;
}

int file(int square) {
  return square%8;
}


boolean selectedIsLegal(Move move) {
  for (int i = 0; i<moveGenerator.moves.size(); i++) {
    if (move.startSquare == moveGenerator.moves.get(i).startSquare &&  move.endSquare == moveGenerator.moves.get(i).endSquare)
      return true;
  }
  return false;
}
boolean selectedIsLegal(int startSquare, int endSquare) {
  for (int i = 0; i<moveGenerator.moves.size(); i++) {
    if (startSquare == moveGenerator.moves.get(i).startSquare &&  endSquare == moveGenerator.moves.get(i).endSquare)
      return true;
  }
  return false;
}

Move getMoveWithCoord(int start, int end) {
  try {
    return moveGenerator.moves
      .stream()
      .filter(x -> x.startSquare == start && x.endSquare == end)
      .findFirst()
      .get();
  }
  catch(Exception e) {
    return null;
  }
}

boolean outsideBoard(int square) {
  if (square < 0)return true;
  else if (square > 63)return true;
  else return false;
}

float manhattanDistance(int startSquare, int endSquare) {
  int startFile = file(startSquare);
  int startRank = rank(startSquare);

  int endFile = file(endSquare);
  int endRank = rank(endSquare);


  return abs(startFile-endFile)-abs(startRank-endRank);
}
 float manhattanDistance(int startSquare, PVector center) {
  int startFile = file(startSquare);
  int startRank = rank(startSquare);


  return abs(startFile-center.x)-abs(startRank-center.y);
}
