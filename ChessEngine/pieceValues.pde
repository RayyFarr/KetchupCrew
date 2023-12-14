int[][][] PAWN_VALUES = new int[][][]{
  //Opening material values for pawns based on square
  new int[][]{
    //black.
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,
      50, 50, 50, 50, 50, 50, 50, 50,
      10, 10, 20, 30, 30, 20, 10, 10,
      5, 5, 10, 25, 25, 10, 5, 5,
      0, 0, 0, 20, 20, 0, 0, 0,
      5, -5, -10, 0, 0, -10, -5, 5,
      5, 10, 10, -20, -20, 10, 10, 5,
      0, 0, 0, 0, 0, 0, 0, 0
    },
    //white.
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,
      5, 10, 10, -20, -20, 10, 10, 5,
      5, -5, -10, 0, 0, -10, -5, 5,
      0, 0, 0, 20, 20, 0, 0, 0,
      5, 5, 10, 25, 25, 10, 5, 5,
      10, 10, 20, 30, 30, 20, 10, 10,
      50, 50, 50, 50, 50, 50, 50, 50,
      0, 0, 0, 0, 0, 0, 0, 0
    }
  },
  //Endgame material values of pawns based on squares
  new int[][]{
    //black
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,
      60, 60, 60, 60, 60, 60, 60, 60,
      30, 30, 40, 50, 50, 40, 30, 30,
      20, 20, 30, 40, 40, 30, 20, 20,
      10, 10, 20, 30, 30, 20, 10, 10,
      0, 0, 10, 20, 20, 10, 0, 0,
      10, 20, 20, -40, -40, 20, 20, 10,
      0, 0, 0, 0, 0, 0, 0, 0
    },
    //white
    new int[]{
      0, 0, 0, 0, 0, 0, 0, 0,
      10, 20, 20, -40, -40, 20, 20, 10,
      0, 0, 10, 20, 20, 10, 0, 0,
      10, 10, 20, 30, 30, 20, 10, 10,
      20, 20, 30, 40, 40, 30, 20, 20,
      30, 30, 40, 50, 50, 40, 30, 30,
      60, 60, 60, 60, 60, 60, 60, 60,
      0, 0, 0, 0, 0, 0, 0, 0
    }
  }
};
int[][][] KNIGHT_VALUES = new int[][][]{
  //Opening material values for knights based on square
  new int[][]{
    //black.
    new int[]{
      280, 320, 320, 320, 320, 320, 320, 280,
      320, 360, 380, 380, 380, 380, 360, 320,
      320, 380, 400, 420, 420, 400, 380, 320,
      320, 380, 420, 440, 440, 420, 380, 320,
      320, 380, 420, 440, 440, 420, 380, 320,
      320, 380, 400, 420, 420, 400, 380, 320,
      320, 360, 380, 380, 380, 380, 360, 320,
      280, 320, 320, 320, 320, 320, 320, 280
    },
    //white.
    new int[]{
      280, 320, 320, 320, 320, 320, 320, 280,
      320, 360, 380, 380, 380, 380, 360, 320,
      320, 380, 400, 420, 420, 400, 380, 320,
      320, 380, 420, 440, 440, 420, 380, 320,
      320, 380, 420, 440, 440, 420, 380, 320,
      320, 380, 400, 420, 420, 400, 380, 320,
      320, 360, 380, 380, 380, 380, 360, 320,
      280, 320, 320, 320, 320, 320, 320, 280
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
  //Opening material values for bishops based on square
  new int[][]{
    //black.
    new int[]{
      300, 320, 320, 320, 320, 320, 320, 300,
      320, 380, 340, 340, 340, 340, 380, 320,
      320, 340, 360, 360, 360, 360, 340, 320,
      320, 340, 360, 380, 380, 360, 340, 320,
      320, 340, 360, 380, 380, 360, 340, 320,
      320, 340, 360, 360, 360, 360, 340, 320,
      320, 340, 340, 340, 340, 340, 340, 320,
      300, 320, 320, 320, 320, 320, 320, 300
    },
    //white.
    new int[]{
      300, 320, 320, 320, 320, 320, 320, 300,
      320, 340, 340, 340, 340, 340, 340, 320,
      320, 340, 360, 360, 360, 360, 340, 320,
      320, 340, 360, 380, 380, 360, 340, 320,
      320, 340, 360, 380, 380, 360, 340, 320,
      320, 340, 360, 360, 360, 360, 340, 320,
      320, 380, 340, 340, 340, 340, 380, 320,
      300, 320, 320, 320, 320, 320, 320, 300
    }
  },
  //Endgame material values of bishops based on squares
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
