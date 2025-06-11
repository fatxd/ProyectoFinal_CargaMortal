class BalaPlayer extends Proyectil{
 private float radio = 50;
 private PImage bala;
 
  public BalaPlayer(PVector Player, PVector objetivo){
     super(Player);
     this.direccion = PVector.sub(objetivo, Player);
     this.direccion.normalize();
     this.direccion.mult(super.velocidad.x);
     this.bala = loadImage("bala2.jpeg");
  }
  
  public void display(){
    fill(0,255,0);
     noStroke();
     ellipse(this.posicion.x,this.posicion.y,radio,radio);
  }
  public void mover(){
    this.posicion.add(direccion);
  }
}
