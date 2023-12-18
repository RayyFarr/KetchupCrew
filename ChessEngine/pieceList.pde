class PieceList {
  int[] occupiedSquares = new int[64];
  int[] indecies = new int[64];
  int numPieces = 0;

  PieceList() {
    occupiedSquares = new int[16];
    indecies = new int[64];
    numPieces = 0;
  }
  void addPiece(int square) {
    occupiedSquares[numPieces] = square;
    indecies[square] = numPieces;

    numPieces++;
  }
  void removePiece(int square) {
    int index = indecies[square];
    occupiedSquares[index] = occupiedSquares[numPieces-1];
    indecies[occupiedSquares[index]] = index;
    numPieces--;
  }
  void move(int startSquare, int targetSquare) {
    int index = indecies[startSquare];
    occupiedSquares[index] = targetSquare;
    indecies[targetSquare] = index;
  }
}
