int[] directionOffsets = {8,-8,1,-1,7,-7,9,-9};
int[][] pawnAttackDir = { new int[] {-7,-9},new int[] {7,9}};

int[] knightMoveOffsets = { 15, 17, -17, -15, 10, -6, 6, -10};

int[] knightMoveXOffsets = {-1,1,-1,1,2,2,-2,-2};
int[] knightMoveYOffsets = {2,2,-2,-2,1,-1,1,-1};

int[][] knightMoves = new int[64][];

int[][] distToEdge = new int[64][];

void computeMoveData(){
  
  
  for(int file = 0;file < 8;file++){
    
    for(int rank = 0;rank < 8;rank++){
      
      int squareIndex = file + rank * 8;
      
      distToEdge[squareIndex] = new int[8];
      
      int top = 7 - rank;
      int bottom = rank;
      
      int right = 7 - file;
      int left = file;
      
      distToEdge[squareIndex][0] = top;
      distToEdge[squareIndex][1] = bottom;
      distToEdge[squareIndex][2] = right;
      distToEdge[squareIndex][3] = left;
      distToEdge[squareIndex][4] = min(left,top);
      distToEdge[squareIndex][5] = min(right,bottom);
      distToEdge[squareIndex][6] = min( right,top);
      distToEdge[squareIndex][7] = min(left,bottom);
      
      
      
      IntList knightSquares = new IntList();
      for(int i = 0;i<knightMoveOffsets.length;i++){
        PVector coord = PVector.add(indexToCoord(squareIndex),new PVector(knightMoveXOffsets[i],knightMoveYOffsets[i]));
        if(coord.x >= 0 && coord.x < 8 && coord.y >= 0 && coord.y < 8) knightSquares.append(squareIndex + knightMoveOffsets[i]); 
      }
      knightMoves[squareIndex] = knightSquares.toArray();
    }
  }
  
  
}
