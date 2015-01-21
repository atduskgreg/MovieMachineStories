import java.awt.Rectangle;

class ColorPalettePass extends AnalysisPass {
  PaletteDetector palette;
  int numColors = 10;
  
  ColorPalettePass(PApplet applet) {
    super(applet);
  }

  void setNumColors(int n ) {
    this.numColors =  n;
  }

  void analyze(PImage src) {
    palette = new PaletteDetector(applet, applet.width, applet.height, numColors);
    palette.loadImage(src);
    palette.calculatePalette(); 
  }

  void draw(PGraphics canvas) {
    canvas.pushStyle();
    canvas.noStroke();
    
    int totalSize = 0;
    
    println(palette.totalSize());
    
    int x = 0;
    for (int i = 0; i < palette.numColors(); i++) {
      println("["+i+"] "+ (float)palette.getSizes()[i] +" "  + ((float)palette.getSizes()[i]/ palette.totalSize()));
      float scalingFactor = (float)palette.getSizes()[i] / palette.totalSize();
      float sectionWidth = scalingFactor * canvas.width/2;
      
      canvas.fill(palette.getColors()[i]);
      canvas.rect(x, 0, sectionWidth, canvas.height);
      x += sectionWidth;
    }
    
    println("x: " + x + "canvas width: " + canvas.width/2);
    
    canvas.popStyle();

    //    canvas.stroke(0, 255, 0);
    //    canvas.noFill();
    //    canvas.strokeWeight(3);
    //    for (int i = 0; i < faces.length; i++) {
    //      canvas.rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    //    }
  }
}

