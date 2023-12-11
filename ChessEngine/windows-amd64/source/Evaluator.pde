
final int PAWNVAL = 100;
final int KNIGHTVAL = 300;
final int BISHOPVAL = 320;
final int ROOKVAL = 500;
final int QUEENVAL = 900;

final int KNIGHTCENTERVAL=50;
final int FIANBISHOPVAL=50;

final int CASTLEBONUS=50;
final int CASTLERIGHTBONUS=50;

final int KINGFINALRANKBONUS_END=200;
final int KINGDISTBONUS=100;

int endGameMaterial = ROOKVAL * 2 + BISHOPVAL + KNIGHTVAL;
int evaluate() {
  
  boolean endGame = false;

  if (board.getPieceCount() < 4) endGame = true;
  int whiteEval = countMaterial(1, endGame);
  int blackEval = countMaterial(0, endGame);


  float whiteEndgameWeight = endGamePower(whiteEval-board.pawns[1].numPieces*PAWNVAL);
  float blackEndgameWeight =endGamePower(blackEval-board.pawns[0].numPieces*PAWNVAL);
  
  whiteEval+=sweep(1, 0, whiteEval, blackEval, whiteEndgameWeight);
  blackEval+=sweep(0, 1, blackEval, whiteEval, blackEndgameWeight);

  int evaluation = whiteEval-blackEval;


  int perspective = board.colorToMove == white? 1:-1;

  return evaluation*perspective;
}

//Force king to corner.
int sweep(int myIndex, int opponentIndex, int myMat, int opponentMat, float endGameWeight) {
  if (myMat>opponentMat) {
    int friendlyKingSquare = board.kingSquares[myIndex];
    int opponentKingSquare = board.kingSquares[opponentIndex];

    return forceKingToCornerEval(friendlyKingSquare, opponentKingSquare, endGameWeight);
  }
  return 0;
}
int countMaterial(int colorIndex, boolean endGame) {
  int material = 0;
  int colorToEval = colorIndex ==  0 ?black:white;
  for (int i = 0; i<64; i++) {
    if (getColor(board.squares[i]) == colorToEval) {
      int pieceType = pieceType(board.squares[i]);
      if (pieceType == pawn) {
        material += PAWN_VALUES[int(endGame)][colorIndex][i];
      } else if (pieceType == knight)
        material += calculateKnightValue(i);
      else if (pieceType == bishop)
        material += calculateBishopValue(i, colorToEval);
      else if (pieceType == rook)
        material += ROOKVAL;
      else if (pieceType == queen)
        material +=  QUEENVAL;
      else if (pieceType == king) {
        material+=getKingValue(i, endGame, colorToEval);
      }
    }
  }
  return material;
}


float endGamePower(int materialWithoutPawns) {
  float mult = 1/endGameMaterial;
  return 1 - min(1, materialWithoutPawns*mult);
}

//first array is referring to game phase where index 0 is opening
//and index 1 is endgame.
//the second array indecies refer to color.
//the last array refers to material values based on position
int[][][] PAWN_VALUES = new int[][][]{
  //Opening material values for pawns based on square
  new int[][]{
    //black.
    new int[]{

      0, 0, 0, 0, 0, 0, 0, 0,

      100, 100, 90, 80, 80, 100, 100, 100,

      100, 70, 100, 100, 100, 80, 90, 90,

      70, 70, 130, 120, 120, 70, 70, 70,

      60, 60, 110, 130, 130, 70, 60, 60,


      150, 150, 150, 200, 200, 100, 100, 100,

      200, 200, 200, 300, 300, 200, 200, 200,

      0, 0, 0, 0, 0, 0, 0, 0

    },
    //white.
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,

      200, 200, 200, 300, 300, 200, 200, 200,

      150, 150, 150, 200, 200, 150, 150, 150,


      60, 150, 120, 130, 130, 150, 60, 60,

      100, 100, 130, 120, 120, 70, 70, 70,

      100, 70, 90, 100, 100, 80, 90, 90,

      100, 100, 90, 80, 80, 100, 100, 100,

      0, 0, 0, 0, 0, 0, 0, 0

    }

  },
  //endgame material values of pawns based on squares
  new int[][]{

    //white.
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,

      100, 100, 100, 100, 100, 100, 100, 100,

      100, 100, 100, 100, 100, 100, 100, 100,

      200, 200, 200, 200, 200, 200, 200, 200,

      400, 400, 400, 400, 400, 400, 400, 400,


      400, 400, 400, 400, 400, 400, 400, 400,

      500, 500, 500, 500, 500, 500, 500, 500,

      0, 0, 0, 0, 0, 0, 0, 0


    },
    //black.
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,

      500, 500, 500, 500, 500, 500, 500, 500,

      400, 400, 400, 400, 400, 400, 400, 400,


      400, 400, 400, 400, 400, 400, 400, 400,

      200, 200, 200, 200, 200, 200, 200, 200,

      100, 100, 100, 100, 100, 100, 100, 100,

      100, 100, 100, 100, 100, 100, 100, 100,

      0, 0, 0, 0, 0, 0, 0, 0

    }
  }
};


int calculateKnightValue(int square) {

  return KNIGHTVAL +
    (int)map(dist(file(square), rank(square), 4, 4), 0, 4, KNIGHTCENTERVAL, 0);
}
int calculateBishopValue(int square, int colorToMove) {
  int material = BISHOPVAL;
  if (colorToMove == white && (square == 54 || square == 49))
    material+=FIANBISHOPVAL;
  else if (colorToMove == black && (square == 9 || square == 14))
    material+=FIANBISHOPVAL;

  return material;
}
//multiply this with total material.
int getKingValue(int kingSquare, boolean endGame, int colorToMove) {
  int value = 0;

  if (!endGame) {


    if (colorToMove == white) {
      if ((board.gameState&0b0011) == 0) value -= CASTLERIGHTBONUS;
      else if (board.whiteCastled)value += CASTLEBONUS;
    } else if (colorToMove == black) {
      if ((board.gameState&0b1100) == 0)
        value -= CASTLERIGHTBONUS;
      else if (board.blackCastled)value += CASTLEBONUS;
    }
  }
  return value;
}

int forceKingToCornerEval(int myKingSquare, int opponentKingSquare, float endGameWeight) {
  int evaluation = 0;

  int opponentRank = rank(opponentKingSquare);
  int opponentFile = file(opponentKingSquare);

  int opponentKingDistFromCenterFile = max(3-opponentFile, opponentFile-4);
  int opponentKingDistFromCenterRank = max(3-opponentRank, opponentRank-4);
  int opponentKingDistFromCenter = opponentKingDistFromCenterFile+opponentKingDistFromCenterRank;
  evaluation += opponentKingDistFromCenter;

  int myKingRank = rank(myKingSquare);
  int myKingFile = file(myKingSquare);

  int distBetweenKingsFile = abs(myKingFile-opponentFile);
  int distBetweenKingsRank = abs(myKingRank-opponentRank);

  int distBetweenKings = distBetweenKingsFile+distBetweenKingsRank;

  evaluation += 14-distBetweenKings;
  return (int)(evaluation*10 * endGameWeight);
}
