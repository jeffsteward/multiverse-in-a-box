class Universe {
  int density = 0;
  PVector[] starPositions; //track the position of each star
  color[] colors;   //track the color of each star
  
  Universe(int d) {
    density = d;
    
    starPositions = new PVector[density]; //<>//
    colors = new color[density];
    
    _generate();
  };
  
  void _generate() {
    int a = 255;
    int r = 0;
    int g = 100 + int(random(-5, 5));
    int b = 114 + int(random(-5, 5));
    
    for (int i=0;i<density;i++) {
      starPositions[i] = new PVector(random(0,width), random(0,height/1.7));
     
      r = 10+(i*12);
      color argb = a << 24 | r << 16 | g << 8 | b;
      colors[i] = argb;
    }
  }

  void _drawGround() {
    noStroke();
    fill(0);
    rect(0,height/1.75, width, height/1.75);
    
    noFill();
    for (int i=1;i<20; i++) {
      float factor = pow(i/1.2,2.5);
      stroke(10*(factor/1.2));
      line(0, (height/1.75)+factor, width, (height/1.75)+factor);
    }
    
}
  
  void update() {};
  
  void display() {
    _drawGround();
    noStroke();
    
    for (int i=0; i<density; i++) {
      fill(colors[i]);
      int fuzziness = int(random(-5,5));
      circle(starPositions[i].x, starPositions[i].y, 25*(i+1)+fuzziness);
      
      noFill();
      stroke(10+(i*12), 24, 114);
      circle(starPositions[i].x, starPositions[i].y, 25*(i+1)+fuzziness+3+sq(i));
    }  
  };
}
