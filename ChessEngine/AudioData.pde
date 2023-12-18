import processing.sound.*;


public SoundFile  moveSound;
public SoundFile captureSound;
public SoundFile checkSound;
public SoundFile checkMateSound;

void initializeSound(){
  moveSound = new SoundFile(this,"move.mp3");

  checkMateSound = new SoundFile(this,"gameEnd.mp3");
  
}
