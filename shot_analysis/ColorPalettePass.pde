import java.awt.Rectangle;

class ColorPalettePass extends AnalysisPass {
  PaletteDetector palette;
  int numColors = 5;


  ColorPalettePass(PApplet applet) {
    super(applet);
  }

  void setNumColors(int n ) {
    this.numColors =  n;
  }

  void analyze(PImage src) {
    palette = new PaletteDetector(applet, applet.width, applet.height, numColors);
    palette.loadImage(src);
  }

  void draw(PGraphics canvas) {
    canvas.pushStyle();
    for (int i = 0; i < palette.numColors (); i++) {
      canvas.fill(palette.getColors()[i]);
      int t = (canvas.height-20)/ palette.numColors();
      canvas.rect(0, t*i, width+1, t);
    }
    
    canvas.popStyle();

    //    canvas.stroke(0, 255, 0);
    //    canvas.noFill();
    //    canvas.strokeWeight(3);
    //    for (int i = 0; i < faces.length; i++) {
    //      canvas.rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    //    }
  }
}

