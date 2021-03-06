float hsize = 10; //<>// //<>//
float cstart = 700;
float hstart = 6;
float zstart = 5;
int hwincount = 0;
int zwincount = 0;

Common c;
Hero h;
Zombie z;

ArrayList<Common> commons;
ArrayList<Hero> heroes;
ArrayList<Zombie> zombies;

void setup() {
  size(1200, 800, P2D);

  commons = new ArrayList<Common>();
  heroes = new ArrayList<Hero>();
  zombies = new ArrayList<Zombie>();
  // testing


  for (int i = 0; i < cstart; i++) {
    c = new Common();
    commons.add(c);
  }

  for (int i = 0; i < hstart; i++) {
    h = new Hero();
    heroes.add(h);
  }
  for (int i = 0; i < zstart; i++) {
    z = new Zombie(random(0.1*width, 0.9*width), random(0.1*height, 0.9*height));
    zombies.add(z);
  }
}


void draw() {
  background(51);
  fill(255);
  text("Zombies " + str(zwincount) + "-" + str(hwincount) + " Humans", 10, 24);
  text("Commons: " + str(commons.size()), 10, height - 39);
  text("Heroes: " + str(heroes.size()), 10, height - 26);
  text("Zombies: " + str(zombies.size()), 10, height - 13);
  
  display();

  animate();
  stacking();

  bitten();


  if (heroes.size() == 0) {
    zwincount++;
    setup();
  }
  if (zombies.size() == 0) {
    hwincount++;
    setup();
  }
}






void display() {
  for (Common c : commons) {
    c.show();
  }
  for (Hero h : heroes) {
    h.show();
  }
  for (Zombie z : zombies) {
    z.show();
  }
}
void animate() {
  for (Common c : commons) {
    c.move();
  }
  for (Zombie z : zombies) {
    z.move();
  }
  for (Hero h : heroes) {
    h.move();
    h.shoot();
  }
}


void bitten() {
  for (int i = commons.size() - 1; i >= 0; i--) {
    for (int j = zombies.size() - 1; j >= 0; j--) {
      float d = dist(commons.get(i).pos.x, commons.get(i).pos.y, zombies.get(j).pos.x, zombies.get(j).pos.y);
      if (d < hsize) {
        z = new Zombie(commons.get(i).pos.x, commons.get(i).pos.y);
        zombies.add(z);


        commons.get(i).visible = false;
        commons.remove(i);
        break;
      }
    }
  }

  for (int i = heroes.size() - 1; i >= 0; i--) {
    for (int j = zombies.size() - 1; j >= 0; j--) {
      float d = dist(heroes.get(i).pos.x, heroes.get(i).pos.y, zombies.get(j).pos.x, zombies.get(j).pos.y);
      if (d < hsize) {
        z = new Zombie(heroes.get(i).pos.x, heroes.get(i).pos.y);
        zombies.add(z);


        heroes.get(i).visible = false;
        heroes.remove(i);
        break;
      }
    }
  }
}


void trajectory(float x1, float y1, float x2, float y2) {
  stroke(167, 240, 44);
  strokeWeight(4);
  line(x1, y1, x2, y2);
}

void stacking() {
  for (int i = 0; i < zombies.size() - 1; i++) {
    for (int j = i + 1; j < zombies.size(); j++) {
      float d = dist(zombies.get(i).pos.x, zombies.get(i).pos.y, zombies.get(j).pos.x, zombies.get(j).pos.y);
      if (d < 0.5*hsize) {
        
        zombies.get(i).direction.rotate(random(PI*3/4, PI*5/4));
        zombies.get(i).pos.add(zombies.get(i).direction);
      }
    }
  }
}


boolean edges(float x, float y) {
  return (x + hsize > width || x - hsize < 0 || y + hsize > height || y - hsize < 0);
}