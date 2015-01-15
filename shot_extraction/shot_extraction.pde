import processing.video.*;
import gab.opencv.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import java.util.Collections;

Movie mov;
EditDetector editDetector;
int w = 960;
int h = 440;
boolean saveFrames = true;
int bufferSize = 3;
int graphScale = 2;
int minFramesBetweenEdits = 10;

ArrayList<PImage> editFrames;


void setup(){
  size(w, h*2);
  
  mov = new Movie(this, "arabia.mov");
  
  editDetector = new EditDetector(this, bufferSize, w, h);
  editFrames = new ArrayList<PImage>();
  
  mov.play();
}


void draw() {
  background(0);
  drawFrames();

  image(mov, 0, 0);

  editDetector.update(mov);

  if(editDetector.editFound()) {
    saveCurrentFrame();
  }

  stroke(255, 0, 0);
  noFill();    

  pushMatrix();
  scale(graphScale);

  
  ArrayList<Integer> diffs = editDetector.getDiffLog();

  if (diffs.size()*graphScale > width/2) {      
    translate(-(diffs.size()*graphScale - (width/2))/graphScale, 0);
  }

  beginShape();
  for (int i = 0; i < diffs.size(); i++) {
    Integer diffSize = diffs.get(i);

    float y = map(diffSize, 0, w*h, 100, 0);    
    vertex(i, y);
  }
  endShape();

  for (Integer i : editDetector.getEditLog()) {
    pushStyle();
    fill(0, 255, 0);
    noStroke();
    float y = map(diffs.get(i), 0, w*h, 100, 0);    
    ellipse(i, y, 5, 5);
    popStyle();
  }
  popMatrix();
}

void drawFrames() {
  int perRow = 5;
  int row = 0;
  int col = 0;

  float frameWidth = (float)w/perRow;
  float frameHeight = (float)h/perRow;

  pushMatrix();

  int numImageRows = 5;

  int currRow = int(editFrames.size()/(float)5);

  if (currRow > (numImageRows-1)) {
    translate(0, int(-(currRow - (numImageRows-1))*frameHeight));
  }

  for (int i = 0; i < editFrames.size(); i++) {    
    image(editFrames.get(i), col*frameWidth, row*frameHeight + h, frameWidth, frameHeight);

    col++;

    if (col >= width/frameWidth) {
      col = 0;
      row++;
    }
  }

  popMatrix();
}

void saveCurrentFrame() {
  PImage editFrame = createImage(w, h, RGB);
  editFrame.copy(mov, 0, 0, w, h, 0, 0, w, h);
  editFrames.add(editFrame);

  if (saveFrames) {
    editFrame.save("shots/"+editDetector.getEditLog().get(editDetector.getEditLog().size() - 1)+"-frame.png");
  }
}
void movieEvent(Movie m) {
  m.read();
}

