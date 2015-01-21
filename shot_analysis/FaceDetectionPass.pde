import java.awt.Rectangle;

class FaceDetectionPass extends AnalysisPass {
  Rectangle[] faces;
  
  FaceDetectionPass(PApplet applet){
    super(applet);
  }

  void analyze(Mat m) {
    opencv.setGray(m);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    faces = opencv.detect();
  }

  void draw(PGraphics canvas) {
    canvas.pushStyle();
    canvas.stroke(0, 255, 0);
    canvas.noFill();
    canvas.strokeWeight(3);
    for (int i = 0; i < faces.length; i++) {
      canvas.rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
    canvas.popStyle();

  }
}

