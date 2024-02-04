Universe[] u;
int universeCount = 10;
int currentUniverse = 0;
boolean showHUD = false;
PShape hud;
PImage vignette;

void setup() {
  size(800,480);
  // fullScreen();
  noCursor();

  textSize(20);

  u = new Universe[universeCount];
  for (int i=0; i<u.length; i++) {
    u[i] = new Universe(int(random(5,20)));
  }

  hud = createHUD();
  vignette = createVignette();
}

void draw() {
  background(0);
  u[currentUniverse].display();

  blendMode(MULTIPLY);
  image(vignette, 0, 0, width, height);

  blendMode(BLEND);
  hud();
}

void mouseClicked() {
  currentUniverse +=1;
  if (currentUniverse >= universeCount) {
    currentUniverse = 0;
  }
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        u[currentUniverse].panUp();
        break;
      case DOWN:
        u[currentUniverse].panDown();
        break;
      default:
        break;
    }
  } else {
    switch (key) {
      case 'h':
        showHUD = !showHUD;
        break;
      case 'a':
        u[currentUniverse].panLeft();
        break;
      case 'd':
        u[currentUniverse].panRight();
        break;
      case 'w':
        u[currentUniverse].zoomIn();
        break;
      case 's':
        u[currentUniverse].zoomOut();
        break;
      case 'r':
        u[currentUniverse].resetView();
        break;
      default:
        break;	
    }
  }
}

void hud() {
  if (showHUD) {
    stroke(0);
    text(u[currentUniverse].name(), 20, height-20);
    text(u[currentUniverse].info(), 20, height-40);
  
    pushMatrix();
    translate(-width + u[currentUniverse].viewportPosition().x,0);
    shape(hud);
    popMatrix();
  }
}

// Creates vignette effect
PGraphics createVignette() {
  // the hotspot of the vignette is area in focus
  float hotSpotHeight = height/2.7; 
  PGraphics pg = createGraphics(width, height);

  pg.beginDraw();
  pg.background(255);
  pg.loadPixels();
  
  for (int i = 0; i < pg.width*pg.height; i++) {
    int x = i%pg.width;
    int y = i/pg.width;

    float d = dist(x, y, pg.width/2, pg.height/2);
    if (d > hotSpotHeight) {
      float multiplier = -1.1*(d-hotSpotHeight); // sorry I'm not so subtle
      // float multiplier = -pow(1.1*(d-hotSpotHeight),1.4);
      pg.pixels[i] = color((pg.pixels[i] >> 16 & 0xFF) + multiplier, (pg.pixels[i] >> 8 & 0xFF) + multiplier, (pg.pixels[i] & 0xFF) + multiplier);
    }
  }
  
  pg.updatePixels();
  pg.endDraw();
  return pg;
}

PShape createHUD() {
  int d = (width*3)/100;
  int x = d/2;

  PShape _hud = new PShape(GROUP);

  for (int i=0; i<101;i++) {
    PShape tick;

    if (i%6 == 0) {
      tick = createShape(LINE, x, 10, x, 30);
    } else if (i%3 == 0) {
      tick = createShape(LINE, x, 12, x, 27);
    } else {
      tick = createShape(LINE,x, 15, x, 25);
    }
    
    tick.setStroke(color(200, 200, 200));
    tick.setFill(false);
    
    _hud.addChild(tick);
    x += d;
  }
    
  // mark the center of the HUD
  PShape m = createShape(RECT, ((width*3)/2)-1, 6, 3, 28);
  m.setFill(color(200, 200, 200));
  m.setStroke(false);
  _hud.addChild(m);

  return _hud;
}