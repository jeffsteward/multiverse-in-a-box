Universe[] u;
int universeCount = 10;
int currentUniverse = 0;

void setup() {
  //size(400,400);
  fullScreen();
  noCursor();

  u = new Universe[universeCount];
  for (int i=0; i<u.length; i++) {
    u[i] = new Universe(int(random(5,20)));
  }
}

void draw() {
  background(0);
  u[currentUniverse].display();
}

void mouseClicked() {
  currentUniverse +=1;
  if (currentUniverse >= universeCount) {
    currentUniverse = 0;
  }
}
