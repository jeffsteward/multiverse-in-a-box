Universe[] u;
int universeCount = 10;
int currentUniverse = 0;
boolean showHUD = false ;
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

void hud() {
  if (showHUD) {
    text(u[currentUniverse].name(), 40, 40);
    text(u[currentUniverse].info(), 40, 60);
  }
}

// Creates vignette effect
PGraphics createVignette() {
  float hotSpotHeight = height/2.3; 
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  pg.background(255);
  pg.loadPixels();
  for (int i = 0; i < pg.width*pg.height; i++) {
    int x = i%pg.width;
    int y = i/pg.width;

    // if (x < 100 || x > width-100) {
        float d = dist(x, y, pg.width/2, pg.height/2);
      if (d > hotSpotHeight) {
        float multiplier = -1.1*(d-hotSpotHeight); // sorry I'm not so subtle
        // float multiplier = -pow(1.1*(d-hotSpotHeight),1.4);
        pg.pixels[i] = color((pg.pixels[i] >> 16 & 0xFF) + multiplier, (pg.pixels[i] >> 8 & 0xFF) + multiplier, (pg.pixels[i] & 0xFF) + multiplier);
      }
    // }
  }
  pg.updatePixels();
  pg.endDraw();
  return pg;
}