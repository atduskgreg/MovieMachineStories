class FlowPass extends AnalysisPass {
  PVector totalFlow;
  int numFrames = 0;

  FlowPass() {
    reset();
  }
  
  void reset(){
    this.totalFlow = new PVector();
    numFrames = 0;
  }

  void update(Mat m){
    opencv.setGray(m);
    opencv.calculateOpticalFlow();
    totalFlow.add(opencv.getAverageFlow());
    numFrames++;
  }

  void analyze(Mat m) {
  }

  void draw(PGraphics canvas) {
    canvas.stroke(255, 0, 0);
    canvas.noFill();
    canvas.strokeWeight(3);
    
    totalFlow.x = totalFlow.x/numFrames;
    totalFlow.y = totalFlow.y/numFrames;
   
    int flowScale = 50;

    canvas.stroke(255);
    canvas.strokeWeight(2);
    canvas.line(opencv.width/2, opencv.height/2, opencv.width/2 + totalFlow.x*flowScale, opencv.height/2 + totalFlow.y*flowScale);
  }
}

