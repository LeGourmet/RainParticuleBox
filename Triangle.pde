public class Triangle{
  public PVector v0, v1, v2;
  public PVector n0, n1, n2;
  
  public Triangle(int i0, int i1, int i2, int n0, int n1, int n2, ArrayList<PVector> points, ArrayList<PVector> normales){
    this.v0 = points.get(i0);
    this.v1 = points.get(i1);
    this.v2 = points.get(i2);
    
    if(normales != null){
      this.n0 = normales.get(n0);
      this.n1 = normales.get(n1);
      this.n2 = normales.get(n2);
    }
  }
  
  public void vertices(){
     vertex(v0.x,v0.y,v0.z);
     vertex(v1.x,v1.y,v1.z);
     vertex(v2.x,v2.y,v2.z);
  }
  
  public void vertices(float size, PVector position){
     size*=0.5;
     vertex(v0.x*size+position.x,v0.y*size+position.y,v0.z*size+position.z);
     vertex(v1.x*size+position.x,v1.y*size+position.y,v1.z*size+position.z);
     vertex(v2.x*size+position.x,v2.y*size+position.y,v2.z*size+position.z);
  }
  
  public HitRecord intersect( PVector o, PVector dir ){
    PVector x = PVector.sub(v1, v0);
    PVector y =  PVector.sub(v2, v0);
    PVector a = dir.cross(y);
    float det = PVector.dot(x, a); 
  
    HitRecord hit = new HitRecord();
  
    if(det==0.f) return hit;
  
    float invDet = 1./det;
    PVector b = PVector.sub(o,v0);
    float   u = PVector.dot(b,a)*invDet;
    if(u<0.||u>1.) return hit;
  
    PVector c = b.cross(x);
    float   v = PVector.dot(dir,c)*invDet;
    if(v<0.||u+v>1.) return hit;
  
    hit.t = PVector.dot(y,c)*invDet;
    hit.normal = PVector.mult(this.n0, ( 1.f - u - v )).add(PVector.mult(this.n1, u)).add(PVector.mult(this.n2, v)).normalize();
  
    return hit;
  }
  
}
