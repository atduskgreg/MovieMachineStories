import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.core.Core;
import org.opencv.core.TermCriteria;
import org.opencv.core.CvType;
import org.opencv.core.Scalar;
import org.opencv.imgproc.Imgproc;
import java.util.Arrays;

OpenCV opencv;
String folderName = "shots";
int w = 960;
int h = 440;
PGraphics canvas;
PImage img;

void setup(){
  java.io.File folder = new java.io.File(dataPath(folderName));
  String[] filenames = folder.list();
  
  
  opencv = new OpenCV(this, w, h);
  canvas = createGraphics(w*2,h);
  

  for(int i = 0; i < filenames.length; i++){
    if(filenames[i].equals(".DS_Store")) {
      continue;
    }
    
    canvas.beginDraw();
    canvas.background(0);
        
    img  = loadImage(dataPath(folderName + "/" + filenames[i]));
    opencv.loadImage(img); 
    
    ColorPalettePass cpp = new ColorPalettePass(this);
    cpp.analyze(img);
    cpp.draw(canvas);
    
    FaceDetectionPass fd = new FaceDetectionPass(this);
    fd.analyze(opencv.getGray());
    fd.draw(canvas);
    
    canvas.image(img, w, 0);
    
    canvas.endDraw();
    canvas.save("analysis/analysis-"+filenames[i]);
  }  

//  size(img.width, img.height);
}

void draw(){
//  image(img, 0,0);
}
