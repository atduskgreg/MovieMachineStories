class EditDetector {
  int bufferSize;
  Integer[] buffer;
  ArrayList<Integer> diffLog;
  ArrayList<Integer> editLog;
  int minFramesBetweenEdits;
  OpenCV opencv;

  // TODO: pass mat dimensions in in constructor? update with mat? option to manually set threshold?

  // Initialize with the size of buffer you want.
  // Smaller buffer means faster response, more danger of 
  // false positives, larger the reverse.
  EditDetector(PApplet parent, int bufferSize, int w, int h) {
    initBuffer(bufferSize);
    diffLog = new ArrayList<Integer>();
    editLog = new ArrayList<Integer>();
    minFramesBetweenEdits = 10;

    opencv = new OpenCV(parent, w, h);
    opencv.startBackgroundSubtraction(5, 3, 0.3);
  }

  void setMinFramesBetweenEdits(int minFramesBetweenEdits) {
    this.minFramesBetweenEdits = minFramesBetweenEdits;
  }

  ArrayList<Integer> getEditLog() {
    return editLog;
  }
  
  ArrayList<Integer> getDiffLog(){
    return diffLog;
  }

  void update(PImage p) {
    opencv.loadImage(p);
    updateMat(opencv.getGray());
  }

  // Update with Mat directly could be especially useful
  // if you're looking for edits in multiple submats from a single source image
  void updateMat(Mat m) {
    opencv.setGray(m);
    opencv.updateBackground();

    int diffPix = Core.countNonZero(opencv.getGray());
    updateBuffer(diffPix);
    diffLog.add((int)getMean(buffer));

    if (editLog.size() < 1) {
      editLog.add(frameCount-1);
    }

    if (diffLog.size() > 1) {
      int currentFrame = diffLog.size() - 1;

      int current = diffLog.get(currentFrame);
      int prev = diffLog.get(currentFrame - 1);

      int delta = current - prev;
      int lastEditAt = 0;

      if (editLog.size() > 0) {
        lastEditAt = editLog.get(editLog.size()-1);
      }

      if (delta > 10000 && ((currentFrame - lastEditAt) > minFramesBetweenEdits) ) {
        editLog.add(currentFrame);
      }
    }
  }


  void initBuffer(int bufferSize) {
    this.bufferSize = bufferSize;
    buffer = new Integer[bufferSize];
    for (int i = 0; i < bufferSize; i++) {
      buffer[i] = 0;
    }
  }

  void updateBuffer(Integer newValue) {
    Integer[] updatedBuffer = new Integer[buffer.length];

    for (int i = 0; i < buffer.length-1; i++) {
      updatedBuffer[i+1] = buffer[i];
    }

    updatedBuffer[0] = newValue;

    buffer = updatedBuffer;
  }

  int lastEditFrame() {
    return editLog.get(editLog.size() - 1);
  }

  boolean editFound() {    
    return ((frameCount-1) == lastEditFrame());
  }


  // Metric of amount of change within the buffer.
  // TODO: scale the buffer mean by the size of the input.
  float getScore() {
    float mean = getMean(buffer);

    return mean;
  }

  float getMean(Integer[] b) {
    double total = 0;
    for (int i = 0; i < b.length; i++) {
      total += b[i];
    }

    return (float)total/b.length;
  }
}

