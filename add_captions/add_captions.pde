import java.util.Arrays;

String folderName = "shots";
Table descriptions;
String[] filenames;
int currentImage = -1;
PImage img;
String currentDescription;
PFont font;
boolean saveImages = true;

boolean saved = false;

void setup() {
  font = loadFont("Tahoma-48.vlw");
  textFont(font, 32);
  
  java.io.File folder = new java.io.File(dataPath(folderName));
  filenames = folder.list();
  descriptions = loadTable(dataPath("shot_text.csv"), "header");
  nextImage();
  size(img.width, img.height);
}

void draw() {
  image(img, 0, 0);
  textAlign(CENTER);
  
  String formattedText = formatText(currentDescription);
  
  int x = width/2;
  int y = height - 60;

  if(numLines(currentDescription) == 1){
    y += 25;  
  }
  
  
  fill(0);
  text(formattedText, x + 1, y + 1);
  fill(255);
  text(formattedText, x, y);
  if(saveImages && !saved){
    saveImage();
    saved = true;
  }
}

int numLines(String text){
  String[] words = split(text, " ");
  if(words.length > 10){
    return 2;
  } else {
    return 1;
  }
}

String formatText(String text){
  text = text.substring(0, 1).toUpperCase() + text.substring(1) + ".";
  String[] words = split(text, " ");
  
  if(numLines(text) == 1){
    return text;
  } else {
    int mid = words.length/2;
    ArrayList<String> wordList = new ArrayList<String>(Arrays.asList(words));
    wordList.add(mid, "\n");
    String result = "";
    
    for(String word : wordList){
      result = result + word + " ";
    }
    return result;

  }
  
}

void nextImage() {
  currentImage++;
  if (filenames[currentImage].equals(".DS_Store")) {
    currentImage++;
  }
  if (currentImage >= filenames.length) {
    currentImage = 0;
  }

  currentDescription = descriptionForImage(filenames[currentImage]);
  println(currentDescription);
  img = loadImage(dataPath(folderName + "/" + filenames[currentImage]));
  saved = false;
}

String descriptionForImage(String filename){
  String result = "";
  
  for (TableRow row : descriptions.rows()) {
    if(row.getString("filename").equals(filename)){
      result = row.getString("description");
      break;
    }
  }
  
  return result;
}

void saveImage(){
  saveFrame("caption-" + filenames[currentImage]);
}

void mousePressed() {
  nextImage();
}

