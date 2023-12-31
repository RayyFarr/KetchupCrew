int[][][] PAWN_VALUES = new int[][][]{
  //Opening material values for pawns based on square
  new int[][]{
    //black.
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,
      100, 100, 100, 100, 100, 100, 100, 100,
      80, 80, 90, 110, 110, 90, 80, 80,
      70, 70, 80, 120, 120, 80, 70, 70,
      60, 60, 70, 120, 120, 70, 60, 60,
      50, 50, 60, 70, 70, 60, 50, 50,
      40, 40, 40, 50, 50, 40, 40, 40,
      0, 0, 0, 0, 0, 0, 0, 0
    },
    //white.
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,
      40, 40, 40, 50, 50, 40, 40, 40,
      50, 50, 60, 70, 70, 60, 50, 50,
      60, 60, 70, 130, 130, 70, 60, 60,
      70, 70, 80, 120, 120, 80, 70, 70,
      80, 80, 90, 110, 110, 90, 80, 80,
      100, 100, 100, 100, 100, 100, 100, 100,
      0, 0, 0, 0, 0, 0, 0, 0
    }
  },
  //Endgame material values of pawns based on squares
  new int[][]{
    //black
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,
      100, 100, 100, 100, 100, 100, 100, 100,
      110, 110, 110, 110, 110, 110, 110, 110,
      120, 120, 120, 120, 120, 120, 120, 120,
      130, 130, 130, 130, 130, 130, 130, 130,
      140, 140, 140, 140, 140, 140, 140, 140,
      150, 150, 150, 150, 150, 150, 150, 150,
      0, 0, 0, 0, 0, 0, 0, 0
    },
    //white
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,
      150, 150, 150, 150, 150, 150, 150, 150,
      140, 140, 140, 140, 140, 140, 140, 140,
      130, 130, 130, 130, 130, 130, 130, 130,
      120, 120, 120, 120, 120, 120, 120, 120,
      110, 110, 110, 110, 110, 110, 110, 110,
      100, 100, 100, 100, 100, 100, 100, 100,
      0, 0, 0, 0, 0, 0, 0, 0
    }
  }
};
int[][][] KNIGHT_VALUES = new int[][][]{
  //Opening material values for knights based on square
  new int[][]{
    //black.
    new int[]{
      300, 290, 300, 300, 300, 300, 290, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      290, 300, 320, 300, 300, 320, 300, 290,
      290, 300, 300, 300, 300, 300, 300, 290,
      290, 300, 300, 300, 300, 300, 300, 290,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
    },
    //white.
    new int[]{
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      290, 300, 300, 300, 300, 300, 300, 290,
      290, 300, 300, 300, 300, 300, 300, 290,
      290, 300, 320, 300, 300, 320, 300, 290,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 290, 300, 300, 300, 300, 290, 300,
    }
  },
  //Endgame material values of knights based on squares
  new int[][]{
    //black
    new int[]{
      250, 270, 270, 270, 270, 270, 270, 250,
      270, 300, 320, 320, 320, 320, 300, 270,
      270, 320, 340, 350, 350, 340, 320, 270,
      270, 320, 350, 360, 360, 350, 320, 270,
      270, 320, 350, 360, 360, 350, 320, 270,
      270, 320, 340, 350, 350, 340, 320, 270,
      270, 300, 320, 320, 320, 320, 300, 270,
      250, 270, 270, 270, 270, 270, 270, 250
    },
    //white
    new int[]{
      250, 270, 270, 270, 270, 270, 270, 250,
      270, 300, 320, 320, 320, 320, 300, 270,
      270, 320, 340, 350, 350, 340, 320, 270,
      270, 320, 350, 360, 360, 350, 320, 270,
      270, 320, 350, 360, 360, 350, 320, 270,
      270, 320, 340, 350, 350, 340, 320, 270,
      270, 300, 320, 320, 320, 320, 300, 270,
      250, 270, 270, 270, 270, 270, 270, 250
    }
  }
};
int[][][] BISHOP_VALUES = new int[][][]{
  //2d array of Opening material values for bishops based on square
  new int[][]{
    //black.
    new int[]{
      300, 300, 290, 300, 300, 290, 300, 300,
      300, 300, 300, 310, 310, 300, 300, 300,
      300, 300, 300, 280, 280, 300, 300, 300,
      300, 300, 320, 300, 300, 320, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
    },
    //white.
    new int[]{
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 300, 300, 300, 300, 300, 300,
      300, 300, 320, 300, 300, 320, 300, 300,
      300, 300, 300, 280, 280, 300, 300, 300,
      300, 300, 300, 310, 310, 300, 300, 300,
      300, 300, 290, 300, 300, 290, 300, 300,
    }
  },
  //2d array of Endgame material values of bishops based on squares
  new int[][]{
    //black
    new int[]{
      350, 370, 370, 370, 370, 370, 370, 350,
      370, 390, 390, 390, 390, 390, 390, 370,
      370, 390, 410, 410, 410, 410, 390, 370,
      370, 390, 410, 430, 430, 410, 390, 370,
      370, 390, 410, 430, 430, 410, 390, 370,
      370, 390, 410, 410, 410, 410, 390, 370,
      370, 390, 390, 390, 390, 390, 390, 370,
      350, 370, 370, 370, 370, 370, 370, 350
    },
    //white
    new int[]{
      350, 370, 370, 370, 370, 370, 370, 350,
      370, 390, 390, 390, 390, 390, 390, 370,
      370, 390, 410, 410, 410, 410, 390, 370,
      370, 390, 410, 430, 430, 410, 390, 370,
      370, 390, 410, 430, 430, 410, 390, 370,
      370, 390, 410, 410, 410, 410, 390, 370,
      370, 390, 390, 390, 390, 390, 390, 370,
      350, 370, 370, 370, 370, 370, 370, 350
    }
  }
};
