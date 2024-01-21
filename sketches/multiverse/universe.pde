class Universe {
  float horizon = height/2;
  int density = 0;
  PShape ground;
  PShape[] stars;
  PShape[] rings;
  PVector[] starPositions; //track the position of each star
  color[] colors;   //track the color of each star
  
  Universe(int d) {
    density = d;
    
    horizon = height/random(1.2, 2.5);

    stars = new PShape[density];
    rings = new PShape[density];
    starPositions = new PVector[density]; //<>//
    colors = new color[density];
    
    _generateStars();
    _generateGround();
  };
  
  void _generateStars() {
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

  void _generateGround() {
    // lots of magic numbers to cleanup in this function
    ground = createShape(GROUP);

    PShape g = createShape(RECT, 0, horizon, width, height-horizon);
    g.setStroke(false);
    g.setFill(color(10));
    ground.addChild(g);

    // vertical grid
    PShape cl = createShape(LINE, width/2, horizon, width/2, height);
    cl.setStroke(200);
    ground.addChild(cl);

    int spacing = width/20;
    int x = (width/2)+70;
    for (int i=5;i<25; i++) {
      float factor = pow(i/1.2,3.75);

      PShape l = createShape(LINE, x, horizon, x+factor, height);
      l.setStroke(color(10*(factor/1.2)));
      ground.addChild(l);

      x += 70;
    }
    x = (width/2)-70;
    for (int i=5;i<25; i++) {
      float factor = pow(i/1.2,3.75);
      
      PShape l = createShape(LINE, x, horizon, x-factor, height);
      l.setStroke(color(10*(factor/1.2)));
      ground.addChild(l);

      x -= 70;
    }    

    // horizontal grid
    for (int i=0;i<20; i++) {
      float factor = pow(i/1.2,2.5);

      PShape l = createShape(LINE, 0, (horizon)+factor, width, (horizon)+factor);
      l.setStroke(color(10*(factor/1.2)));
      ground.addChild(l);
    }    
}
  
  void update() {};
  
  void display() {
    shape(ground);
    
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
