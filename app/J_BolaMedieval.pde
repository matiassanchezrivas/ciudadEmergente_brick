int X_BOLA_MEDIEVAL = 500;
int Y_BOLA_MEDIEVAL = 50;
int TAM_BOLA_MEDIEVAL = 100;

class BolaMedieval {
  PVector location;    // Location of bob
  PVector origin;      // Location of arm origin
  float r;             // Length of arm
  float angle;         // Pendulum arm angle
  float aVelocity;     // Angle velocity
  float aAcceleration; // Angle acceleration
  float damping;       // Arbitrary damping amount
  float amountChange;
  PShape bolaMedievalShape;
  FCircle bolaMedievalFisica;
  boolean suelta = false; 
  float scale; 

  BolaMedieval (PVector origin_, float r_, float amountChange_) {
    origin = origin_.get();
    amountChange=amountChange_;
    location = new PVector();
    r = r_;
    angle = PI/4;
    aVelocity = 0.0;
    aAcceleration = 0.0;
    damping = 1;
    bolaMedievalShape = loadShape("bolaMedieval.svg");
  }

  void reset() {
    suelta=false;
    scale=0;
    angle = PI/4;
    aVelocity = 0.0;
    aAcceleration = 0.0;
    r=50;
  }

  void iniciarFisica() {
    bolaMedievalFisica = new FCircle (TAM_BOLA_MEDIEVAL);
    bolaMedievalFisica.setPosition(location.x, location.y);
    worldBola.add(bolaMedievalFisica);
    bolaMedievalFisica.addForce(angle*999999/2, -1000);
  }

  void draw() {
    if (!suelta) {
      updateWithPendulum();
    } else {

      updateWithFisica();
    }
    display();
    r+=amountChange;
  }


  void soltar() {
    if (!suelta) {
      suelta=true;
      iniciarFisica();
    }
  }

  void updateWithFisica() {
    location.x=bolaMedievalFisica.getX();
    location.y=bolaMedievalFisica.getY();
  };

  void updateWithPendulum() {
    float gravity = 0.4;
    aAcceleration = (-1 * gravity / r) * sin(angle);

    aVelocity += aAcceleration;
    angle += aVelocity;

    aVelocity *= damping;

    location.set(r*sin(angle), r*cos(angle), 0);
    location.add(origin);

    line(width/2, height/2, width/2+aVelocity*width, height/2);
    line(width/2, height/2+100, width/2, height/2+100+aAcceleration*width*5);
    line(width/2, height/2+200, width/2+angle*10, height/2+200);
  }

  void display() {
    scale=1*(1-0.9)+scale*0.9;
    float angle2=atan((location.y-origin.y)/r);


    offscreen.pushStyle();
    offscreen.strokeWeight(3);
    offscreen.stroke(255);
    offscreen.noFill();
    int cantidad =20;

    for (int i=0; i<cantidad; i++) {
      offscreen.pushMatrix();
      offscreen.translate(origin.x-(origin.x-location.x)/cantidad*i, origin.y-(origin.y-location.y)/cantidad*i);
      if (i%2==0) {
        offscreen.rotate(-QUARTER_PI/2+angle2);
      } else {
        offscreen.rotate(QUARTER_PI/2+angle2);
      }
      if (!suelta) {
        offscreen.ellipse(0, 0, 10, 15);
      }
      offscreen.popMatrix();
    }
    //line(origin.x, origin.y, location.x, location.y);
    offscreen.fill(175);
    offscreen.pushMatrix();
    offscreen.translate(location.x, location.y);
    offscreen.scale(scale);
    offscreen.rotate(angle2);
    offscreen.shapeMode(CENTER);
    offscreen.shape(bolaMedievalShape, 0, 0, 100, 100);
    offscreen.popMatrix();
    offscreen.popStyle();
  }
}