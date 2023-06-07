void translate(PVector p){ translate(p.x,p.y,p.z); }
void line(PVector a, PVector b){line(a.x,a.y,a.z,b.x,b.y,b.z);}
void vertex(PVector p){ vertex(p.x,p.y,p.z); }

float sign(float a){
  if(a<0.) return -1.;
  if(a>0.) return 1.;
  return 0.;
}

int clamp(int x, int min, int max){ 
  if(x<min) return min;
  if(x>max) return max;
  return x;
}

PVector PVectorDiv(PVector a, PVector b){ return new PVector(sign(b.x)*a.x/max(abs(b.x),0.001), sign(b.y)*a.y/max(abs(b.y),0.001), sign(b.z)*a.z/max(abs(b.z),0.001)); }
PVector PVectorMin(PVector a, PVector b){ return new PVector(min(a.x,b.x),min(a.y,b.y),min(a.z,b.z)); }
PVector PVectorMax(PVector a, PVector b){ return new PVector(max(a.x,b.x),max(a.y,b.y),max(a.z,b.z)); }

float min(PVector a){ return min(min(a.x,a.y),a.z); }
float max(PVector a){ return max(max(a.x,a.y),a.z); }

public class HitRecord{
  public float t;
  public PVector normal;
  
  public HitRecord(){
    this.t = Float.MAX_VALUE;
  }
}
