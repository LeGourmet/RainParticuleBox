public class Obstacle {
  private color col;
  
  private ArrayList<PVector> positions;
  private ArrayList<PVector> normales;
  private ArrayList<Triangle> triangles;

  public Obstacle(PVector center, color col, float scale, String path) {
    this.col = col;
 
    this.positions = new ArrayList<>();
    this.triangles = new ArrayList<>();
    this.normales = new ArrayList<>();
    
    String[] lines = loadStrings(path);
    for(String line : lines){
      String datas[] = line.split(" ");
      switch (datas[0]){
        case "v": positions.add(new PVector(Float.parseFloat(datas[1])*scale+center.x,Float.parseFloat(datas[2])*scale+center.y,Float.parseFloat(datas[3])*scale+center.z));break;
        case "vn": normales.add(new PVector(Float.parseFloat(datas[1]),Float.parseFloat(datas[2]),Float.parseFloat(datas[3])));break;
        case "f" : triangles.add(new Triangle(Integer.parseInt(datas[1].split("/")[0])-1,Integer.parseInt(datas[2].split("/")[0])-1,Integer.parseInt(datas[3].split("/")[0])-1,
                                              Integer.parseInt(datas[1].split("/")[2])-1,Integer.parseInt(datas[2].split("/")[2])-1,Integer.parseInt(datas[3].split("/")[2])-1,positions,normales)); break;
        default : break;
      }
    }
  }

  public void vertices() {
    fill(this.col);
    triangles.forEach(t -> t.vertices());
  }
  
  public boolean collide(PVector a, PVector b){
    PVector vec = PVector.sub(b,a);
    float tMax = vec.mag();
    vec.normalize();
    
    for(Triangle t : triangles){
      HitRecord hit = t.intersect(a,vec);
      if(hit.t>0. && hit.t<tMax) return true;
    }
    
    return false;
  }
}
