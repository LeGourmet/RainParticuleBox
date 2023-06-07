public class DropsBox{
  private PVector _positionOld;
  private PVector _position;
  private float   _size;
  
  private PVector[] vertex = new PVector[8];
  private PVector[] normales = new PVector[6];
  private int[] faces = new int[24];
  
  public DropsBox(PVector p_center, float p_size){
    this._positionOld = new PVector(0.f,0.f,0.f);
    this._position = p_center;
    this._size = p_size;
    
    vertex[0] = new PVector( p_size, p_size, p_size);
    vertex[1] = new PVector(-p_size, p_size, p_size);
    vertex[2] = new PVector( p_size,-p_size, p_size);
    vertex[3] = new PVector(-p_size,-p_size, p_size);
    vertex[4] = new PVector( p_size, p_size,-p_size);
    vertex[5] = new PVector(-p_size, p_size,-p_size);
    vertex[6] = new PVector( p_size,-p_size,-p_size);
    vertex[7] = new PVector(-p_size,-p_size,-p_size);
    
    normales[0] = new PVector( 1., 0., 0.);
    normales[1] = new PVector(-1., 0., 0.);
    normales[2] = new PVector( 0., 1., 0.);
    normales[3] = new PVector( 0.,-1., 0.);
    normales[4] = new PVector( 0., 0., 1.);
    normales[5] = new PVector( 0., 0.,-1.);
    
    faces[ 0] = 1; faces[ 1] = 3; faces[ 2] = 7; faces[ 3] = 5;
    faces[ 4] = 0; faces[ 5] = 2; faces[ 6] = 6; faces[ 7] = 4;
    faces[ 8] = 2; faces[ 9] = 6; faces[10] = 7; faces[11] = 3;
    faces[12] = 1; faces[13] = 0; faces[14] = 4; faces[15] = 5;
    faces[16] = 5; faces[17] = 4; faces[18] = 6; faces[19] = 7;
    faces[20] = 1; faces[21] = 0; faces[22] = 2; faces[23] = 3;
  
    this._updateVertex();
  }
  
  public PVector getMovement(){
    return PVector.sub(_position,_positionOld);
  }
  
  public float getArea(){
    return _size*_size*_size;
  }
  
  public void update(){
    _positionOld.set(_position);
    _position.set(100.f*cos(0.1*frameCount),0.f,0.f);
    _updateVertex();
  }
  
  public void vertices(){
    noFill();
    stroke(255);
    
    for(int i=0; i<24 ;i++)
        vertex(vertex[faces[i]]);
  }
  
  public boolean isOutside(PVector p){
    for(int i=0; i<6 ;i++){
      PVector mid = new PVector(0.,0.,0.);
      mid.add(vertex[faces[4*i  ]]);
      mid.add(vertex[faces[4*i+1]]);
      mid.add(vertex[faces[4*i+2]]); 
      mid.add(vertex[faces[4*i+3]]);
      mid.mult(0.25);
      
      if(PVector.dot(PVector.sub(mid,p),normales[i])>0.) return true;
    }
    return false;
  }
  
  public PVector sampleSurface(PVector vec){
    int i;
    
    PVector dir = vec.copy().normalize();
    
    float r = random(0,1);
    float u = random(0,1);
    float v = random(0,1);
    
    float[] prob = new float[] {max(0.,PVector.dot(dir,normales[0])),0.,0.,0.,0.,0.};
    for(i=1; i<6 ;i++)
      prob[i] = max(0.,PVector.dot(dir,normales[i])) + prob[i-1];
    
    for(i=0; i<6 ;i++)
      if(prob[i]>=r*prob[5])
        break;
    
    PVector point = new PVector(0.,0.,0.);
    point.add(PVector.mult(vertex[faces[4*i  ]], (1.-u)*(1.-v)));
    point.add(PVector.mult(vertex[faces[4*i+1]],      u*(1.-v)));
    point.add(PVector.mult(vertex[faces[4*i+2]],      u*    v )); 
    point.add(PVector.mult(vertex[faces[4*i+3]], (1.-u)*v     ));
    point.add(PVector.mult(normales[i],random(0.01,PVector.dot(vec,normales[i]))));
    
    return point;
  }
  
  private void _updateVertex(){
    for(PVector vec : vertex) {
      vec.sub(_positionOld);
      vec.add(_position);
    }
  }
}
