public class KetchupCrewLvl1{
  
  int pawnValue;
  int knightValue;
  int bishopValue;
  int rookValue;
  int queenValue;
    
  int moveGenerationTest(int depth){
    if(depth == 0){
       return 1;
    }
    
    ArrayList<Move> moves = moveGenerator.generateLegalMoves(board);
    int numPositions = 0;
    
    for(Move move : moves){
      board.makeMove(move);
      numPositions += moveGenerationTest(depth-1);
      board.unMakeMove(move);
      
      
    }
    return numPositions;
  }
  
  
  
}
