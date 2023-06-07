import peasy.*;
import java.util.Collections;

boolean PAUSE = false;
int num_frame = 0;

float RAIN_INTENSITY = 0.2;     // mm/h
float DELTA_TIME     = 0.02;    // s
float SIZE_BOX       = 100;     // m

PVector WIND_FORCE = new PVector(-50.,25.,0.);  // m/s
PVector WIND     = WIND_FORCE.copy();           // m/s
PVector GRAVITY  = new PVector(0.,9.81,0.);     // m/s 

int DROP_NB_MAX     = 50000;    // unitless
float DROP_SIZE_MIN = 2.;       // mm
float DROP_SIZE_MAX = 8.;       // mm
PeasyCam camera;

Drops drops;
DropsBox dropsBox = new DropsBox(new PVector(0.,0.,0.), SIZE_BOX*0.5);
ArrayList<Obstacle> obstacles;

void setup(){
  size(1200,800,P3D);
  
  textSize(50.);
  textAlign(CENTER);
  
  camera = new PeasyCam(this,1.5*SIZE_BOX);
  camera.setRotations(0.f,-0.2f,0.f);
  camera.setMinimumDistance(0.001f);
  camera.setMaximumDistance(1000.f);

  drops = new Drops(DROP_NB_MAX,color(0,0,255));

  obstacles = new ArrayList<Obstacle>();
  obstacles.add(new Obstacle(new PVector(0.f,0.f,0.f),color(0,127,127),SIZE_BOX*0.1f  ,"./assets/cube.obj"));
  obstacles.add(new Obstacle(new PVector(0.f,0.f,0.f),color(0,127,127),10.f           ,"./assets/plane.obj"));
}


void draw(){ 
  /*****************************************************************************************
   *****************                        DISPLAY                        *****************
   *****************************************************************************************/
  background(0.);
  //WIND = PVector.mult(WIND_FORCE,3.*abs(cos(frameCount*0.01)));
  lights();
  
  // ------ DISPLAY OBSTACLES ------
  beginShape(TRIANGLES);
  noStroke();
  obstacles.forEach(o -> o.vertices());
  endShape(CLOSE);
  
  // ------ DISPLAY FRUSTRUM ------
  beginShape(QUADS);
  dropsBox.vertices();
  endShape(CLOSE);
  
  // ------ DISPLAY DROPS ------
  drops.vertices();
  
  // ------ DISPLAY HUD ------
  camera.beginHUD();
  fill(255);
  text("Number drops : " + min(DROP_NB_MAX,drops.nbDropsNeeded), width*0.5,height*0.1,0);
  camera.endHUD();
  
  /*****************************************************************************************
   *****************                         UPDATE                        *****************
   *****************************************************************************************/
  if(!PAUSE){
    PVector frustumMovement = new PVector(4.*cos(0.1*num_frame),0.,0.);
    dropsBox.translate(frustumMovement);
    
    drops.computeNbDropNeeded(dropsBox.computeArea());
    drops.update(frustumMovement);
    
    num_frame++;
  }
}

void keyPressed(){
  switch(key){
    case CODED : switch(keyCode){
      case UP : RAIN_INTENSITY += 0.1; break;
      case DOWN : RAIN_INTENSITY -= 0.1; break; 
      case RIGHT : RAIN_INTENSITY += 0.01; break;
      case LEFT : RAIN_INTENSITY -= 0.01; break;
    } break;
    case 'p' : PAUSE = !PAUSE; break;
    case 'i' : 
      println("frameRate: "+frameRate); 
      println("numero frame: "+num_frame);
      println("intensity rain: "+RAIN_INTENSITY); 
  }
}
