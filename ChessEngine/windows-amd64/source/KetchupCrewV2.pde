class KetchupCrewV2 {

  class Result {
    int score;
    Move move;

    Result(int score, Move move) {
      this.score = score;
      this.move = move;
    }
  }
  Result search(int depth, Move bestMove, int alpha, int beta) {
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
      int eval = -search(depth - 1, move, -beta, -alpha).score;
      board.unMakeMove(move);

      if (eval >= bestScore) {
        bestScore = eval;
        bestMove = move;
      }

      alpha = Math.max(alpha, eval);
      if (alpha >= beta) break;  // beta cut-off
    }

    return new Result(bestScore, bestMove);
  }
}
