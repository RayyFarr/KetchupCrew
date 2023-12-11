//Index offsets for all 8 directions.
int[] directionOffsets = {8, -8, 1, -1, 7, -7, 9, -9};


//index offsets for knights.
int[] knightMoveOffsets = { 15, 17, -17, -15, 10, -6, 6, -10};


//Cartesian offsets for knights.
int[] knightMoveXOffsets = {-1, 1, -1, 1, 2, 2, -2, -2};
int[] knightMoveYOffsets = {2, 2, -2, -2, 1, -1, 1, -1};

//[][] => squares/moves.
int[][] knightMoves = new int[64][];

// [][][] => color/squares/moves.
int[][][] pawnCaptures = new int[2][64][];


//set of each squares where pawns can jump two times. first set is for black and second is for white.

ArrayList<Set<Integer>> pawnTwoJumpSquares = new ArrayList<Set<Integer>>();


int[][] kingMoves = new int[64][];

int[][] distToEdge = new int[64][];

void computeMoveData() {

  IntList whiteJumps = new IntList();
  IntList blackJumps = new IntList();

  for (int file = 0; file < 8; file++) {

    for (int rank = 0; rank < 8; rank++) {

      int squareIndex = file + rank * 8;
      PVector position = indexToCoord(squareIndex);

      distToEdge[squareIndex] = new int[8];

      int top = 7 - rank;
      int bottom = rank;

      int right = 7 - file;
      int left = file;

      distToEdge[squareIndex][0] = top;
      distToEdge[squareIndex][1] = bottom;
      distToEdge[squareIndex][2] = right;
      distToEdge[squareIndex][3] = left;
      distToEdge[squareIndex][4] = min(left, top);
      distToEdge[squareIndex][5] = min(right, bottom);
      distToEdge[squareIndex][6] = min( right, top);
      distToEdge[squareIndex][7] = min(left, bottom);



      IntList knightSquares = new IntList();
      for (int i = 0; i<knightMoveOffsets.length; i++) {
        PVector coord = PVector.add(indexToCoord(squareIndex), new PVector(knightMoveXOffsets[i], knightMoveYOffsets[i]));
        if (coord.x >= 0 && coord.x < 8 && coord.y >= 0 && coord.y < 8) knightSquares.append(squareIndex + knightMoveOffsets[i]);
      }
      knightMoves[squareIndex] = knightSquares.toArray();


      IntList sqWhitePawnCaptures = new IntList();

      if (file != 7)sqWhitePawnCaptures.append(squareIndex - 7);
      if (file != 0)sqWhitePawnCaptures.append(squareIndex - 9);

      pawnCaptures[1][squareIndex] = sqWhitePawnCaptures.toArray();

      IntList sqBlackPawnCaptures = new IntList();
      position = indexToCoord(squareIndex);
      if (file != 0)sqBlackPawnCaptures.append(squareIndex + 7);
      if (file != 7)sqBlackPawnCaptures.append(squareIndex + 9);

      pawnCaptures[0][squareIndex] = sqBlackPawnCaptures.toArray();

      if (rank == 1)
        blackJumps.append(squareIndex);
      else if (rank == 6)
        whiteJumps.append(squareIndex);

      IntList sqKingMoves = new IntList();

      for (int i = 0; i<directionOffsets.length; i++) {
        if (!outsideBoard(squareIndex + directionOffsets[i]) && manhattanDistance(squareIndex, indexToCoord(squareIndex + directionOffsets[i])) <= 2)
          sqKingMoves.append(squareIndex + directionOffsets[i]);
      }
      kingMoves[squareIndex] = sqKingMoves.toArray();
    }
  }
  HashSet blackSet = new HashSet<>(Arrays.stream(blackJumps.toArray()).boxed().collect(Collectors.toSet()));
  HashSet whiteSet = new HashSet<>(Arrays.stream(whiteJumps.toArray()).boxed().collect(Collectors.toSet()));
  pawnTwoJumpSquares.add(blackSet);
  pawnTwoJumpSquares.add(whiteSet);
}
