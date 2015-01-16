import gab.opencv.*;
import org.opencv.core.Mat;

OpenCV opencv;
PImage img;
String folderName = "shots";
int w = 960;
int h = 440;
PGraphics canvas;

void setup(){
  java.io.File folder = new java.io.File(dataPath(folderName));
  String[] filenames = folder.list();
  
  
  opencv = new OpenCV(this, w, h);
  canvas = createGraphics(w,h);
  

  for(int i = 0; i < filenames.length; i++){
    if(filenames[i].equals(".DS_Store")) {
      continue;
    }
    
    canvas.beginDraw();
    canvas.background(0);
        
    opencv.loadImage(dataPath(folderName + "/" + filenames[i]));  
    FaceDetectionPass fd = new FaceDetectionPass();
    fd.analyze(opencv.getGray());
    fd.draw(canvas);
    canvas.endDraw();
    canvas.save("analysis/analysis-"+filenames[i]);
  }  

//  size(img.width, img.height);
}

void draw(){
//  image(img, 0,0);
}
