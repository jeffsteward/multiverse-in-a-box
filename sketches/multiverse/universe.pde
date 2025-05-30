class Universe {
  PVector _viewportPosition;
  int _width = width*3;
  int _height = height*3;
  float horizon = height/2;
  
  int density = 0;
  int starFieldSize = int(random(100, 200));
  
  PShape ground;
  PShape mountains;
  
  PVector[] starField;
  
  PShape[] stars;
  PShape[] rings;
  PVector[] starPositions; //track the position of each star
  float[] starWeights;
  color[] colors;   //track the color of each star
  
  String name;
  
  Universe(int d) {
    density = d;
    
    horizon = height/random(1.2, 2.5);

    stars = new PShape[density];
    rings = new PShape[density];
    starPositions = new PVector[density]; 
    starWeights = new float[density];
    colors = new color[density];
    
    _generateStarField();
    _generateStars();
    _generateGrid();
    _generateMountains();
    _initialViewport();

    name = "U-" + density + "-" + starFieldSize + "-" + random(0,100);
  };
  
  String name() {
    return name;
  }

  String info() {
    return "X: " + _viewportPosition.x + ", Y: " + _viewportPosition.y + ", Z: " + _viewportPosition.z;
  }

  PVector viewportPosition() {
    return _viewportPosition;
  }

  void _initialViewport() {
    _viewportPosition = new PVector(0, 0, 0);
  }

  void _generateStarField() {
    starField = new PVector[starFieldSize];
    for (int i=0; i<starFieldSize; i++) {
      starField[i] = new PVector(random(0,_width), random(0,_height));
    }
  }

  void _generateStars() {
    int a = 255;
    int r = 0;
    int g = 100 + int(random(-5, 5));
    int b = 114 + int(random(-5, 5));
    
    int scaleFactor = int(height*0.015);

    for (int i=0;i<density;i++) {
      // calculate the position
      starPositions[i] = new PVector(random(-width,width*2), random(0,height/1.7), i);
      starWeights[i] = starPositions[i].z/2;

      // calculate the size
      // int size = scaleFactor*(i+1);
      int size = int(scaleFactor*(starPositions[i].z+1));
           
      // calculate the color
      // r = 10+(i*12);
      r = 10 + int(starPositions[i].z * 12);
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

  void _generateMountains() {
    int peakCount = int(random(2, 10));
    float colorStep = 200/peakCount;
    
    float peakXPadding = width*0.05; //padding is 5% of the screen width
    float peakYPadding = height*0.05; // peak can rise 5% above the horizon

    mountains = createShape(GROUP);

    for (int i=0; i<=peakCount; i++) {
      PShape m = createShape();
      m.setStroke(false);
      m.setFill(color(i*colorStep));
      // m.setFill(color(150, i*colorStep, 150));

      //vertex order: left side base->mountain peak->right side base
      m.beginShape();
      m.vertex(random(-1000,-100), height);
      m.vertex(random(peakXPadding, width-peakXPadding), random(horizon-peakYPadding, horizon+(horizon/2)));
      m.vertex(width+random(100, 1000), height);
      m.endShape(CLOSE);

      mountains.addChild(m);
    }
  }

  void _generateGrid() {
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

    int spacing = int(width*0.01); 
    int centerOffset = int(width*0.02); 
    int x = (width/2)+centerOffset;
    for (int i=5;i<25; i++) {
      float factor = pow(i/1.2,3.75);

      PShape l = createShape(LINE, x, horizon, x+factor, height);
      l.setStroke(color(10*(factor/1.2)));
      ground.addChild(l);

      x += centerOffset;
    }
    x = (width/2)-centerOffset;
    for (int i=5;i<25; i++) {
      float factor = pow(i/1.2,3.75);
      
      PShape l = createShape(LINE, x, horizon, x-factor, height);
      l.setStroke(color(10*(factor/1.2)));
      ground.addChild(l);

      x -= centerOffset;
    }    

    // horizontal grid
    for (int i=0;i<20; i++) {
      float factor = pow(i/1.2,2.5);

      PShape l = createShape(LINE, 0, (horizon)+factor, width, (horizon)+factor);
      l.setStroke(color(10*(factor/1.2)));
      ground.addChild(l);
    }    
}
  
  void zoomIn() {
    _viewportPosition.z +=0.02;
  }

  void zoomOut() {
    if (_viewportPosition.z > -0.8) {
      _viewportPosition.z -=0.02;
    }
  }

  void panLeft() {
    _viewportPosition.x +=1.0;
  }

  void panRight() {
    _viewportPosition.x -=1.0;
  }

  void panUp() {
    _viewportPosition.y +=1.0;
  }

  void panDown() {
    _viewportPosition.y -=1.0;
  }

  void resetView() {
    _initialViewport();
  }

  void update() {};
  
  void display() {
    for (int i=0; i<starField.length; i++) {
      stroke(255);
      point(starField[i].x + _viewportPosition.x/20, starField[i].y + + _viewportPosition.y/20);
    }

    for (int i=0; i<density; i++) {
      float fuzziness = random(0.99,1.01);
      
      pushMatrix();
      translate(starPositions[i].x + (_viewportPosition.x * starWeights[i]), 
                starPositions[i].y + (_viewportPosition.y * starWeights[i]));
      scale(_viewportPosition.z + fuzziness);
      shape(stars[i]);
      shape(rings[i]);
      popMatrix();
    }  

    shape(mountains);
    // shape(ground);
  };
}
