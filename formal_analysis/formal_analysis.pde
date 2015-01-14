import processing.video.*;

Movie mov;


void setup(){
  size(960, 440);
  
  mov = new Movie(this, "arabia.mov");
  mov.play();
}

void draw(){
  image(mov, 0, 0, width, height);
}

void movieEvent(Movie m) {
  m.read();
}

