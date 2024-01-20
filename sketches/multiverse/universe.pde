class Universe {
  int density = 0;
  PShape[] stars;
  PShape[] rings;
  PVector[] starPositions; //track the position of each star
  color[] colors;   //track the color of each star
  
  Universe(int d) {
    density = d;
    
    stars = new PShape[density];
    rings = new PShape[density];
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
      // calculate the position
      starPositions[i] = new PVector(random(0,width), random(0,height/1.7));
           
      // calculate the size
      int size = 25*(i+1);
           
      // calculate the color
      r = 10+(i*12);
      color argb = a << 24 | r << 16 | g << 8 | b;
      colors[i] = argb;

      // create the shape
      stars[i] = createShape(ELLIPSE, 0, 0, size, size);
      stars[i].setFill(colors[i]);
      stars[i].setStroke(false);
      
      // create the ring
      argb = a << 24 | (10+(i*12)) << 16 | 24 << 8 | 114;
      rings[i] = createShape(ELLIPSE, 0, 0, size+3+sq(i), size+3+sq(i));
      rings[i].setFill(false);
      rings[i].setStroke(color(argb));
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
      float fuzziness = random(0.99,1.01);
      
      pushMatrix();
      translate(starPositions[i].x, starPositions[i].y);
      scale(fuzziness);
      shape(stars[i]);
      shape(rings[i]);
      popMatrix();
    }  
  };
}
