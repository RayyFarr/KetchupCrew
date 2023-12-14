
final int PAWNVAL = 100;
final int KNIGHTVAL = 300;
final int BISHOPVAL = 320;
final int ROOKVAL = 500;
final int QUEENVAL = 900;

final int FIANCHETTOBONUS=50;

final int BISHOPPAIRBONUS=50;

final int CASTLEBONUS=100;
final int CASTLERIGHTBONUS=50;



final int DEVELOPMENTBONUS = 50;

PVector center = new PVector(4, 4);

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
        material += PAWNVAL + PAWN_VALUES[int(endGame)][colorIndex][i];
      } else if (pieceType == knight)
        material += KNIGHT_VALUES[int(endGame)][colorIndex][i];
      else if (pieceType == bishop)
        material += BISHOP_VALUES[int(endGame)][colorIndex][i];
      else if (pieceType == rook)
        material += ROOKVAL;
      else if (pieceType == queen)
        material +=  QUEENVAL;
      else if (pieceType == king) {
        material+=getKingValue( endGame, colorToEval);
      }
    }
  }
  return material; 
}


float endGamePower(int materialWithoutPawns) {
  float mult = 1/endGameMaterial;
  return 1 - min(1, materialWithoutPawns*mult);
}



//multiply this with total material.
int getKingValue(boolean endGame, int colorToMove) {
  int value = 0;

  if (!endGame) {


    if (colorToMove == white) {
      if ((board.gameState&0b0011) == 0 && !board.whiteCastled) value -= CASTLERIGHTBONUS;
      else if (board.whiteCastled)value += CASTLEBONUS;
    } else if (colorToMove == black) {
      if ((board.gameState&0b1100) == 0 && !board.whiteCastled)value -= CASTLERIGHTBONUS;
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
