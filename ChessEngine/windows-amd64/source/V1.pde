public class KetchupCrewV1 {



  int moveGenerationTest(int depth) {
    if (depth == 0) {
      return 1;
    }

    ArrayList<Move> moves = moveGenerator.generateLegalMoves(board);
    int numPositions = 0;
    for (Move move : moves) {
      board.makeMove(move);
      numPositions += moveGenerationTest(depth-1);
      board.unMakeMove(move);
    }
    return numPositions;
  }
  class Result {
    int score;
    Move move;

    Result(int score, Move move) {
      this.score = score;
      this.move = move;
    }
  }
  Result search(int depth, Move bestMove) {
    if (depth == 0) {
      return new Result(evaluate(), bestMove);
    }

    ArrayList<Move> moves = moveGenerator.generateLegalMoves(board);

    if (moves.size() == 0) {
      if (moveGenerator.inCheck())
        return new Result(-LARGENUMBER, bestMove);
      else return new Result(0, bestMove);
    } else if (board.draw) {
      return new Result(0, bestMove);
    }

    int bestScore = -LARGENUMBER;

    for (Move move : moves) {
      board.makeMove(move);
      int eval = -search(depth - 1, move).score;
      board.unMakeMove(move);

      if (eval >= bestScore) {
        bestScore = eval;
        bestMove = move;
      }
    }

    return new Result(bestScore, bestMove);
  }
}
