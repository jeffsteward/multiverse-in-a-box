Universe[] u;
int universeCount = 10;
int currentUniverse = 0;
boolean showHUD = false ;

void setup() {
  // size(800,480);
  fullScreen();
  noCursor();

  textSize(20);

  u = new Universe[universeCount];
  for (int i=0; i<u.length; i++) {
    u[i] = new Universe(int(random(5,20)));
  }
}

void draw() {
  background(0);
  u[currentUniverse].display();
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