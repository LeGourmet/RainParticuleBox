public class Drops{
  private int nbDropsMax;
  public  int nbDropsNeeded;
  
  private PVector[] dropsPos;    //= new PVector[DROP_NB_MAX];
  private PVector[] dropsPosOld; //= new PVector[DROP_NB_MAX];
  private float[]   dropsSize;   //= new float[DROP_NB_MAX];
  private boolean[] dropsAlive;  //= new boolean[DROP_NB_MAX];
  
  private color col;
  
  // todo init avec info intensité
  public Drops(int nbDropsMax, color col){
    this.nbDropsMax = nbDropsMax;
    nbDropsNeeded = 0;
    
    dropsPos = new PVector[nbDropsMax];
    dropsPosOld = new PVector[nbDropsMax];
    dropsSize = new float[nbDropsMax];
    dropsAlive = new boolean[nbDropsMax];
    
    for(int i=0; i<nbDropsMax ;i++) dropsAlive[i] = false;
    
    this.col = col;
  }
  
  public void vertices(){
    stroke(col);
    for(int i=0; i<nbDropsMax ;i++){
      if(!dropsAlive[i]) continue;
      strokeWeight(dropsSize[i]*0.5);
      line(dropsPos[i],dropsPosOld[i]);
    }
  }
  
  private float getLambda(){
    return 4.1f*pow(RAIN_INTENSITY, -0.21f);
  }
  
  public void computeNbDropNeeded(float area){
    float lambda = getLambda();
    nbDropsNeeded = (RAIN_INTENSITY < 0.01f) ? 0 : floor(area * 8000.f/lambda * exp(-lambda*DROP_SIZE_MIN));
  }
  
  private boolean collide(PVector a, PVector b){
    for(Obstacle o : obstacles){
        if(o.collide(a,b)) return true;
    }
    return false;
  }
  
  public void update(PVector frustumMovement){    
    float cx = 0.47;
    
    for(int i=0; i<nbDropsMax ;i++){
      if(!dropsAlive[i]){
        if(i<nbDropsNeeded){
          dropsSize[i] = DROP_SIZE_MIN - max(-4.,log(random(0,1))/getLambda());
          
          PVector V0_sq = PVector.add(PVector.mult(GRAVITY,(dropsSize[i])/(0.9195*cx)),PVector.mult(WIND,WIND.mag()));
          PVector V0 = PVector.div(V0_sq,sqrt(V0_sq.mag()));
          PVector V0_cam_sq = 
            PVector.add(V0_sq,PVector.mult(frustumMovement,-1100.f));
            //V0_sq;
          PVector V0_cam = PVector.div(V0_cam_sq,sqrt(V0_cam_sq.mag()));
          
          dropsPos[i] = dropsBox.generateDrop(V0_cam);
          dropsPosOld[i] = PVector.sub(dropsPos[i],PVector.mult(V0,DELTA_TIME));
          
          // inside dropsBox and inside rain shadow map
          dropsAlive[i] = !(dropsBox.outside(dropsPos[i]) || collide(PVector.sub(dropsPos[i],PVector.mult(V0,10000.f)),dropsPos[i]));
        }
        continue;
      }
      
      PVector velOld = PVector.div(PVector.sub(dropsPos[i],dropsPosOld[i]),DELTA_TIME);
      
      PVector wind_local = 
        //PVector.mult(dropsPos[i],90.*cos(sqrt(dropsPos[i].mag()))/dropsPos[i].mag());
        new PVector(0.,0.,0.);
      
      PVector wind = PVector.add(PVector.mult(WIND,WIND.mag()),PVector.mult(wind_local,wind_local.mag()));
      
      PVector a = PVector.add(GRAVITY,PVector.mult(PVector.sub(wind,PVector.mult(velOld,velOld.mag())),0.9195*cx/dropsSize[i]));
      PVector vel = PVector.add(velOld,PVector.mult(a,DELTA_TIME));
      PVector posNext = PVector.add(dropsPos[i],PVector.mult(vel,DELTA_TIME)); 
      
      dropsPosOld[i] = dropsPos[i];
      dropsPos[i] = posNext;
      
      // check collistion with scene 
      if(collide(dropsPosOld[i],dropsPos[i])){
        dropsAlive[i] = false; 
        continue;
      }
      
      // check collision with dropsBox
      if(dropsBox.outside(dropsPos[i]))
        dropsAlive[i] = false;
    }
  }
  
}
