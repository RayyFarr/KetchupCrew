static final int white = 8;
static final int black = 16;

static final int empty = 0;
static final int king = 1;
static final int pawn = 2;
static final int knight = 3;
static final int bishop = 5;
static final int rook = 6;
static final int queen = 7;

static final int whiteKing = king | white;
static final int whitePawn = pawn | white;
static final int whiteKnight = knight | white;
static final int whiteBishop = bishop | white;
static final int whiteRook = rook | white;
static final int whiteQueen = queen | white;

static final int blackKing = king | black;
static final int blackPawn = pawn | black;
static final int blackKnight = knight | black;
static final int blackBishop = bishop | black;
static final int blackRook = rook | black;
static final int blackQueen = queen | black;

static PImage[] pieceImages = new PImage[13];


final int typeMask = 0b00111;
final int blackMask = 0b10000;
final int whiteMask = 0b01000;
final int colourMask = whiteMask | blackMask;

void setupImages() {
  pieceImages[0] = createImage(0, 0, RGB);
  pieceImages[1] = loadImage("whiteKing.png");
  pieceImages[2] = loadImage("whitePawn.png");
  pieceImages[3] = loadImage("whiteKnight.png");
  pieceImages[4] = loadImage("whiteBishop.png");
  pieceImages[5] = loadImage("whiteRook.png");
  pieceImages[6] = loadImage("whiteQueen.png");
  pieceImages[7] = loadImage("blackKing.png");
  pieceImages[8] = loadImage("blackPawn.png");
  pieceImages[9] = loadImage("blackKnight.png");
  pieceImages[10] = loadImage("blackBishop.png");
  pieceImages[11] = loadImage("blackRook.png");
  pieceImages[12] = loadImage("blackQueen.png");
}

boolean isColor(int piece, boolean whiteTurn) {
  if(getColor(piece) == white && whiteTurn) return true;
  else if(getColor(piece) == black && !whiteTurn) return true;
  return false;
}

int getColor(int piece){ return piece & colourMask;}


int pieceType(int piece){ return piece & typeMask;}

boolean isSliding(int piece){return (piece & 0b100) != 0;}

boolean isRookOrQueen(int piece){return (piece & 0b110) == 0b110;}
boolean isBishopOrQueen(int piece){return (piece & 0b101) == 0b101;}
