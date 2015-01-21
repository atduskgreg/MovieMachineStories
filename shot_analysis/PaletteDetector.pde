class PaletteDetector {
  color[] palette;
  int[] sizes;
  int numColors;
  OpenCV opencv;
  boolean paletteStale;

  PaletteDetector(PApplet parent, int w, int h, int numColors) {
    this.numColors = numColors;
    palette = new color[numColors];
    this.opencv = new OpenCV(parent, w, h);
    this.opencv.useColor(HSB);
    
//    sizes = new int[numColors];

    paletteStale = true;
  }

  void loadImage(PImage img) {
    this.opencv.loadImage(img);
    paletteStale = true;
  }

  // returns them in RGB color space
  color[] getColors() {
    if (paletteStale) {
      calculatePalette();
    }

    return palette;
  }

  int[] getSizes(){
    return sizes;
  }
  
  int totalSize(){
    int result = 0;
    for(int i = 0; i < sizes.length; i++){
      result += sizes[i];
    }
    return result;
  }

  int numColors() {
    return numColors;
  }

  void calculatePalette() {
    pushStyle();
    colorMode(HSB);
    Mat h = this.opencv.getH().reshape(1, opencv.width*opencv.height);  
    Core.multiply(h, new Scalar(255.0/180.0), h);
    Mat s = this.opencv.getS().reshape(1, opencv.width*opencv.height);  
    Mat v = this.opencv.getV().reshape(1, opencv.width*opencv.height);

    ArrayList<Mat> cols = new ArrayList<Mat>();
    cols.add(h);
    cols.add(s);
    cols.add(v);

    Mat c = new Mat(opencv.height, opencv.width, CvType.CV_32F );
    Core.hconcat(cols, c);

    c.convertTo(c, CvType.CV_32F);

    Mat labels = new Mat();
    TermCriteria criteria = new TermCriteria(TermCriteria.EPS, 1000, 0);
    Mat centers = new Mat();

    Core.kmeans(c, numColors, labels, criteria, 10, Core.KMEANS_RANDOM_CENTERS, centers);

    //== Begin horrible process of sorting colors based on size of cluster

    HashMap<Integer, Integer> labelScores = new HashMap<Integer, Integer>();
    this.sizes = new int[numColors];

    println("SCORES==========");
    for (int i = 0; i < numColors; i++) {
      Mat thisLabel = new Mat();
      Core.inRange(labels, new Scalar(i), new Scalar(i), thisLabel);
      int score = Core.countNonZero(thisLabel);
      labelScores.put(score, i);
      println(i + ": " + score);
      this.sizes[i] = score;
    }

    Arrays.sort(sizes);

    color[] unorderedClusters = new color[numColors];

    for (int i  = 0; i < centers.height(); i++) {
      unorderedClusters[i] = color((float)centers.get(i, 0)[0], (float)centers.get(i, 1)[0], (float)centers.get(i, 2)[0]);
    }

    int[] sortedIndices = new int[numColors];
    int j = 0;
    for (int i = numColors-1; i >= 0; i--) {
      sortedIndices[j] = labelScores.get(this.sizes[i]);
      j++;
    }

    palette = new color[numColors];
    for (int i = 0; i < sortedIndices.length; i++) {
      palette[i] = unorderedClusters[sortedIndices[i]];
    }
    popStyle();
    
    for(int i = 0; i < palette.length; i++){
      palette[i] = color(red(palette[i]), green(palette[i]), blue(palette[i]));
    }


    paletteStale = false;
  }
}

