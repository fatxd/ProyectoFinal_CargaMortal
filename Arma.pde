private Player player;
private PImage fondoMenu,boton_1, boton_2, nombre_inicio, nivel_1, nivel_2;
private ZombieJefe zombieJefe;
private ArrayList<ZombieMele> zomiesMele;
private ArrayList<ZombieDistancia> zombiesDistancia;
private boolean w, s, d, a;
private int tiempoInicio;
private int estadoActual = MaquinaEstados.MENU;
private int anteriorTime = 0;
private int contador = 0;
private PFont fuente;

public void setup() {
  size(1024, 682);
  fuente = createFont("Bahnschrift", 32);
  fondoMenu = loadImage("menu_fondo.png");
  boton_1 = loadImage("boton1.png");
  boton_2 = loadImage("boton2.png");
  nombre_inicio = loadImage("nombre_inicio.png");
  nivel_1 = loadImage("piso_nivel1.png");
  nivel_2 = loadImage("piso_nivel2.png");
  cargarSonidos();
  reproducirMenu();
  reproducirMusica();
}

public void draw() {
  image(fondoMenu, 0, 0, width, height);
  int tiempoActual = millis();
  GameTime.update(tiempoActual, tiempoInicio);
  tiempoInicio = tiempoActual;

  switch (estadoActual) {
  case MaquinaEstados.MENU:
    mostrarMenu();
    break;
  case MaquinaEstados.NIVEL_1:
    ejecutarNivel1();
    break;
  case MaquinaEstados.NIVEL_2:
    ejecutarNivel2();
    break;

  case MaquinaEstados.OPCIONES:
    mostrarOpciones();
    break;
  case MaquinaEstados.GAME_OVER:
    mostrarGameOver();
    break;
  }
}
public void mousePressed() {
  if (estadoActual == MaquinaEstados.MENU) {
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
      mouseY > height/2 - 30 && mouseY < height/2 + 30) {
      iniciarJuego();
    }

    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
      mouseY > height/2 + 70 && mouseY < height/2 + 130) {
      estadoActual = MaquinaEstados.OPCIONES;
    }
  }

  if (estadoActual == MaquinaEstados.NIVEL_1 || estadoActual == MaquinaEstados.NIVEL_2) {
    player.recargarBalas();
    player.recargarBalas();
    dispararSonido();
  }
  if (estadoActual == MaquinaEstados.GAME_OVER) {
    reproducirMenu();
    estadoActual = MaquinaEstados.MENU;
  }
}


public void keyPressed() {
  if (key == ESC) {
    if (estadoActual == MaquinaEstados.OPCIONES) {
      estadoActual = MaquinaEstados.MENU;
      key = 0;
    }
  }

  if (estadoActual == MaquinaEstados.NIVEL_1 || estadoActual == MaquinaEstados.NIVEL_2 ) {
    if (key == 's' || key == 'S') s = true;
    if (key == 'w' || key == 'W') w = true;
    if (key == 'a' || key == 'A') a = true;
    if (key == 'd' || key == 'D') d = true;
  }
}

public void keyReleased() {
  if (estadoActual == MaquinaEstados.NIVEL_1 || estadoActual == MaquinaEstados.NIVEL_2) {
    if (key == 's' || key == 'S') s = false;
    if (key == 'w' || key == 'W') w = false;
    if (key == 'a' || key == 'A') a = false;
    if (key == 'd' || key == 'D') d = false;
  }
}

public void mostrarMenu() {
  image(fondoMenu, 0, 0, width, height);
  imageMode(CORNER);
  detenerMusica();
  image(nombre_inicio, 112,112,800,74);
  image(boton_1, 412, 312, 200, 60);
  image(boton_2, 412, 412, 200, 60);
  contador =  0;
}

public void mostrarOpciones() {
  image(fondoMenu, 0, 0, width, height);
  imageMode(CORNER);
  textFont(fuente);
  fill(255);
  textAlign(CENTER, CENTER);
  text("Sonido", width / 2, height / 2);
  textSize(16);
  text("Presiona ESC para volver", width / 2, height - 40);
}

public void iniciarJuego() {
  detenerMenu();
  reproducirMusica();
  estadoActual = MaquinaEstados.NIVEL_1;

  player = new Player();
  zombiesDistancia = new ArrayList<ZombieDistancia>();
  zomiesMele = new ArrayList<ZombieMele>();
  tiempoInicio = millis();


}
public void ejecutarNivel1() {
  imageMode(CENTER);
  image(nivel_1, width / 2, height / 2);
   if (contador == 0) {

    zombiesDistancia.add(new ZombieDistancia());
    zomiesMele.add(new ZombieMele());
    contador++;
  }

  if (millis() - anteriorTime >= 2000 && contador < 5) {

    zombiesDistancia.add(new ZombieDistancia());
    zomiesMele.add(new ZombieMele());
    anteriorTime = millis();
    contador++;
  }



  player.display();
  player.usaArma();
  player.mover(w, s, a, d);
  player.recibioDañoDistancia();
  player.colisionarEnemigos(zombiesDistancia, zomiesMele, zombieJefe);

  for (int i = 0; i < zombiesDistancia.size(); i++) {

    zombiesDistancia.get(i).display();
    zombiesDistancia.get(i).mover(player.getPosicionPlayer());
    zombiesDistancia.get(i).disparar();
    player.colisionarJugadorBala(zombiesDistancia.get(i).getBalasVomito());
  }

  for (int i = 0; i < zomiesMele.size(); i++) {

    zomiesMele.get(i).display();
    zomiesMele.get(i).mover(player.getPosicionPlayer());
    player.recibioDañoMele(zomiesMele.get(i));
  }

  if (player.getVidaPlayer() <= 0) {
    estadoActual = MaquinaEstados.GAME_OVER;
  }

  if (zombiesDistancia.size() == 0 && zomiesMele.size() == 0) {
    iniciarNivel2();
  }
}
public void iniciarNivel2() {
  estadoActual = MaquinaEstados.NIVEL_2;

  zombiesDistancia = new ArrayList<ZombieDistancia>();
  zomiesMele = new ArrayList<ZombieMele>();
  zombieJefe = new ZombieJefe();


  for (int i = 0; i < 0; i++) {
    zombiesDistancia.add(new ZombieDistancia());
  }

  for (int i = 0; i < 0; i++) {
    zomiesMele.add(new ZombieMele());
  }

  println("¡Comienza el Nivel 2!");
}
public void ejecutarNivel2() {
  imageMode(CENTER);
  image(nivel_2, width / 2, height / 2);
  imageMode(CORNER);




  player.display();
  player.usaArma();
  player.mover(w, s, a, d);
  player.recibioDañoDistancia();
  player.colisionarEnemigos(zombiesDistancia, zomiesMele, zombieJefe);

  if (zombieJefe.getVida() >=0) {
    zombieJefe.display();
    zombieJefe.mover(player.getPosicionPlayer());
    zombieJefe.disparar();
    player.colisionarJugadorBala(zombieJefe.getBalasVomito());
    player.recibioDañoJefe(zombieJefe);
    player.recibioDañoDistanciaJefe();
  }

  for (int i = 0; i < zombiesDistancia.size(); i++) {

    zombiesDistancia.get(i).display();
    zombiesDistancia.get(i).mover(player.getPosicionPlayer());
    zombiesDistancia.get(i).disparar();
    player.colisionarJugadorBala(zombiesDistancia.get(i).getBalasVomito());
  }

  for (int i = 0; i < zomiesMele.size(); i++) {

    zomiesMele.get(i).display();
    zomiesMele.get(i).mover(player.getPosicionPlayer());
    player.recibioDañoMele(zomiesMele.get(i));
  }


  if (player.getVidaPlayer() <= 0) {
    estadoActual = MaquinaEstados.GAME_OVER;
  }

  if (zombiesDistancia.size() == 0 && zomiesMele.size() == 0 && zombieJefe.getVida() <= 0) {
    println("¡Ganaste el juego!");
    estadoActual = MaquinaEstados.MENU;
  }
}

public void mostrarGameOver() {
  background(0);
  fill(255, 0, 0);
  textFont(fuente);
  textAlign(CENTER);
  text("GAME OVER", width/2, height/2-100);
  text("PERDISTE CRACK", width/2, height/2-40);
  fill(255);
  textSize(20);
  text("Haz click para volver al menu", width/2, height/2+220);
  detenerMusica();
}
class Arma {
  private ArrayList<Proyectil> balasJugador;
  private PVector posicion;
  public Arma(PVector posicion) {
    this.posicion = posicion;
    this.balasJugador = new ArrayList<Proyectil>();
  }
  public void disparar() {

    for (int i = balasJugador.size() - 1; i >= 0; i--) { //visualiza las balas
      Proyectil bala = balasJugador.get(i);
      bala.mover();
      bala.display();
      if (bala.posicion.x < 0 || bala.posicion.x > width //elimna las balas
        || bala.posicion.y < 0 || bala.posicion.y > height) {
        balasJugador.remove(i);
      }
    }
  }
  public void generarBalas() { //genenra BalasJugador
    balasJugador.add(new BalaJugador(this.posicion.copy(), new PVector(mouseX, mouseY))); //agrega las balas
  }
}
class BalaJugador extends Proyectil {
  private PImage bala;
  private PVector objetivo;
  private int xFrame, yFrame, anchoFrame, altoFrame;
  private float xFrameFloat, nextxFrameFloat, velocidadFrame;

  public BalaJugador(PVector player, PVector objetivo) {
    this.posicion = player;
    this.objetivo = objetivo;
    this.direccion = Utilidad.trayectoria(this.posicion, this.objetivo);
    this.bala = loadImage("shoot.png");
    this.xFrame = 0;
    this.yFrame = 0;
    this.anchoFrame = 27;
    this.altoFrame = 35;
    this.xFrameFloat = 0;
    this.velocidadFrame = 180;
  }

  public void display() {
    imageMode(CENTER);
    image(this.bala.get(this.xFrame, this.yFrame, this.anchoFrame, this.altoFrame), this.posicion.x, this.posicion.y);
    xFrameFloat +=velocidadFrame*GameTime.deltaTime; //se ogliba el tiempo entre Frame
    if (this.xFrameFloat >= this.nextxFrameFloat) {
      this.xFrame += this.anchoFrame;
      this.xFrameFloat = 0;
    }
    if (this.xFrame >= 4*anchoFrame) {
      this.xFrame = 0;
      this.nextxFrameFloat= this.anchoFrame;
    }
  }

  public void mover() {
    this.posicion.x += this.direccion.x*this.velocidad*GameTime.deltaTime;
    this.posicion.y += this.direccion.y*this.velocidad*GameTime.deltaTime;
  }
}
class BalaVomito extends Proyectil {
  private float diametro = 10;
  private int colliderVomito;
  public BalaVomito(PVector objetivo, PVector posicion) {
    this.posicion = posicion;
    this.direccion = Utilidad.trayectoria(this.posicion, objetivo);
    this.colliderVomito = 5;
  }
  public void mover() {
    this.posicion.x += this.direccion.x*this.velocidad*GameTime.deltaTime;
    this.posicion.y += this.direccion.y*this.velocidad*GameTime.deltaTime;
  }
  public void display() {
    fill(0, 255, 0);
    noStroke();
    ellipse(this.posicion.x, this.posicion.y, diametro, diametro);
  }
}
abstract class Enemigo extends GameObject {
  PVector direccion;
  Enemigo() {
  }
  public void mover() {
  }
  public void display() {
  }
}
abstract class GameObject {
  protected PVector posicion;
  protected float velocidad;
  public GameObject() {
  }

  abstract public void display();
  public void mover() {
  }
}
static class GameTime {
  static float deltaTime = 0;

  static void update(int tiempoActual, int tiempoAnterior) {
    deltaTime = (tiempoActual - tiempoAnterior) / 1000.0;
  }
}
static class MaquinaEstados{
  public static final int MENU = 0;
  public static final int NIVEL_1 = 2;
  public static final int NIVEL_2 = 3;
  public static final int OPCIONES = 4;
  public static final int GAME_OVER = 5;
  


}
class Player extends GameObject {
  private char estado; //se usa para cambiar la visualizacion del sprite dependiendo como se mueve
  private Sprite sprite;
  private int radioCollider;
  private Arma arma;
  private float vidaJugador;
  private boolean dañoAJugador;

  public Player() {
    this.posicion = new PVector(width/2, height/2);
    this.velocidad = 100;
    this.sprite = new Sprite();
    this.estado = 'q';
    this.arma = new Arma(this.posicion);
    this.radioCollider = 12;
    this.vidaJugador = 100;
    this.dañoAJugador = false;
  }
  public PVector getPosicionPlayer() {
    return this.posicion;
  }
  public float getVidaPlayer() {
    return vidaJugador;
  }

  public void recargarBalas() {
    this.arma.generarBalas();
  }
  public void display() {
    this.sprite.displayJugador(estado, this.posicion);
  }
  public void usaArma() {
    this.arma.disparar();
  }

  public void mover(boolean arriba, boolean abajo, boolean izquierda, boolean derecha) {
    if (arriba) {
      this.posicion.y -= velocidad*GameTime.deltaTime;
      this.estado = 'w';
    }
    if (abajo) {
      this.posicion.y += velocidad*GameTime.deltaTime;
      this.estado = 's';
    }
    if (izquierda) {
      this.posicion.x -= velocidad*GameTime.deltaTime;
      this.estado = 'a';
    }
    if (derecha) {
      this.posicion.x += velocidad*GameTime.deltaTime;
      this.estado = 'd';
    }
    if (!arriba && !abajo && !izquierda && !derecha) {
      this.estado = 'q';
    }
  }

  public void colisionarJugadorBala(ArrayList<Proyectil> balasVomito) {
    for (int i = balasVomito.size() - 1; i >= 0; i--) {
      Proyectil bala = balasVomito.get(i);
      float d = bala.posicion.dist(this.posicion);

      if (d < (this.radioCollider + ((BalaVomito) bala).colliderVomito)) {

        dañoAJugador = true;

        balasVomito.remove(i);
      }
    }
  }
  public void colisionarEnemigos(ArrayList<ZombieDistancia> zombiesDistancia, ArrayList<ZombieMele> zombiesMele, ZombieJefe zombieJefe) {
    for (int i = this.arma.balasJugador.size() - 1; i >= 0; i--) {
      boolean colisiono = false;
      for (int j =0; j < zombiesDistancia.size(); j++) {
        if (arma.balasJugador.get(i).posicion.dist(zombiesDistancia.get(j).getPosicion()) < 10 + zombiesDistancia.get(j).getRadioColision()) {
          this.arma.balasJugador.remove(i);
          if (zombiesDistancia.get(j).recibeDaño()) zombiesDistancia.remove(j);
          colisiono = true;
          break;
        }
      }
      if (colisiono) continue;
      for (int j =0; j < zombiesMele.size(); j++) {
        if (arma.balasJugador.get(i).posicion.dist(zombiesMele.get(j).getPosicion()) < 10 + zombiesMele.get(j).getRadioColision()) {
          this.arma.balasJugador.remove(i);
          if (zombiesMele.get(j).recibeDaño()) zombiesMele.remove(j);
          //zombiesMele.get(j).empujar();
          colisiono = true;
          break;
        }
      }
      if (colisiono) continue;
      if (zombieJefe != null &&
        arma.balasJugador.get(i).posicion.dist(zombieJefe.getPosicion()) < 10 + zombieJefe.getRadioColision()) {

        this.arma.balasJugador.remove(i);
        if (zombieJefe.recibeDaño()) zombieJefe = null;
        break;
      }
    }
  }

  public void recibioDañoDistancia() {
    if (dañoAJugador) {

      this.vidaJugador -= Utilidad.DAÑO_VOMITO;
      this.dañoAJugador = false;
      if (vidaJugador == 0);
      dañoSonido();
    }
    gameOverSonido();
  }
  public void recibioDañoMele(ZombieMele zombieMele) {
    int ahora = millis();
    int ultimo = zombieMele.getTiempoUltimoDañoMele();

    if (Utilidad.colisionRectangulos(
      this.posicion,
      sprite.getAnchoFrameJugador(),
      sprite.getAltoFrameJugador(),
      zombieMele.getPosicion(),
      sprite.getAnchoFrameEnemigo(),
      sprite.getAltoFrameEnemigo()
      ) && ahora - ultimo > zombieMele.getCooldownDañoMele()) {
      this.vidaJugador -= Utilidad.DAÑO_MELE;
      zombieMele.setTiempoUltimoDañoMele(ahora);
      dañoSonido();
    }
  }
  public void recibioDañoJefe(ZombieJefe zombieJefe) {
    int ahora = millis();
    int ultimo = zombieJefe.getTiempoUltimoDañoJefe();

    if (Utilidad.colisionRectangulos(
      this.posicion,
      sprite.getAnchoFrameJugador(),
      sprite.getAltoFrameJugador(),
      zombieJefe.getPosicion(),
      sprite.getAnchoFrameEnemigo(),
      sprite.getAltoFrameEnemigo()
      ) && ahora - ultimo > zombieJefe.getCooldownDañoJefe()) {
      this.vidaJugador -= Utilidad.DAÑO_JEFE;
      zombieJefe.setTiempoUltimoDañoJefe(ahora);
    }
  }
  public void recibioDañoDistanciaJefe() {
    if (dañoAJugador) {
      this.vidaJugador -= Utilidad.DAÑO_JEFE;
      this.dañoAJugador = false;
      if (vidaJugador == 0);
      dañoSonido();
    }
  }
}
abstract class Proyectil extends GameObject {
  protected PVector direccion;
  public Proyectil() {
    this.velocidad = 300;
  }
  abstract  public void display();
  abstract public void mover();
}
import ddf.minim.*;
Minim minim;
AudioPlayer musicaFondo;
AudioPlayer sonidoDisparo;
AudioPlayer sonidoDaño;
AudioPlayer sonidoGameOver;
AudioPlayer sonidoMenu;

public void cargarSonidos() {
  minim = new Minim(this);
  musicaFondo = minim.loadFile("musica.mp3");
  sonidoDisparo = minim.loadFile("disparo.mp3");
  sonidoDaño = minim.loadFile("daño.mp3");
  sonidoGameOver = minim.loadFile("gameover.mp3");
  sonidoMenu = minim.loadFile("menu.mp3");
}

void reproducirMenu() {
  if (!sonidoMenu.isPlaying()) {
    sonidoMenu.loop();
  }
}

void detenerMenu() {
  if (sonidoMenu.isPlaying()) {
    sonidoMenu.pause();
    sonidoMenu.rewind();
  }
}
public void reproducirMusica() {
  if (!musicaFondo.isPlaying()) {
    musicaFondo.loop();
  }
}

public void detenerMusica() {
  if (musicaFondo.isPlaying()) {
    musicaFondo.pause();
    musicaFondo.rewind();
  }
}

public void dispararSonido() {
  sonidoDisparo.rewind();
  sonidoDisparo.setGain(-22);
  sonidoDisparo.play();
}

public void dañoSonido() {
  sonidoDaño.rewind();
  sonidoDaño.play();
}

public void gameOverSonido() {
  sonidoGameOver.rewind();
  sonidoGameOver.play();
}
class Sprite {
  private PImage enemigo, enemigoAtaca, jugador, jugadorIzq, jugadorAtras, jugadorAbajo;
  private int xFrame = 0, yFrame, xFrameJugador, yFrameJugador, anchoFrameEnemigo, altoFrameEnemigo, anchoFrameJugador, altoFrameJugador;
  private float xFrameFloat, nextxFrameFloat, velocidadFrame;
  public Sprite() {
    imageMode(CENTER);
    this.enemigo = loadImage("slime.png");
    this.jugador = loadImage("sprite.png");
    this.jugadorIzq = loadImage("izquierda.png");
    this.jugadorAtras = loadImage("arriba.png");
    this.jugadorAbajo = loadImage("abajo.png");
    this.enemigoAtaca = loadImage("enemigoAtaca.png");
    this.xFrame = 0;
    this.yFrame = 0;
    this.xFrameJugador = 0;
    this.yFrameJugador = 0;
    this.anchoFrameEnemigo = 32;
    this.altoFrameEnemigo = 25;
    this.anchoFrameJugador = 32;
    this.altoFrameJugador = 32;
    this.xFrameFloat = 0;
    this.nextxFrameFloat = anchoFrameEnemigo;
    this.velocidadFrame = 200;
  }
  
  public void displayEnemigo(char estadoEnemigo, PVector posicion) {
    switch(estadoEnemigo) {

    case 'q':
      {
        image(this.enemigo.get(this.xFrame, this.yFrame, this.anchoFrameEnemigo, this.altoFrameEnemigo), posicion.x, posicion.y);
        xFrameFloat +=velocidadFrame*GameTime.deltaTime;
        if (this.xFrameFloat >= this.nextxFrameFloat) {
          this.xFrame += this.anchoFrameEnemigo;
          this.xFrameFloat = 0;
        }
        if (this.xFrame >= 4*anchoFrameEnemigo) {
          this.xFrame = 0;
          this.nextxFrameFloat= this.anchoFrameEnemigo;
        }
        break;
      }
    case 'a':
      {
        image(this.enemigoAtaca.get(this.xFrame, this.yFrame, this.anchoFrameEnemigo, this.altoFrameEnemigo), posicion.x, posicion.y);
        xFrameFloat +=velocidadFrame*GameTime.deltaTime;
        if (this.xFrameFloat >= this.nextxFrameFloat) {
          this.xFrame += this.anchoFrameEnemigo;
          this.xFrameFloat = 0;
        }
        if (this.xFrame >= 3*anchoFrameEnemigo) {
          this.xFrame = 0;
          this.nextxFrameFloat= this.anchoFrameEnemigo;
        }
        break;
      }
    }
  }

  public void displayJugador(char estado, PVector posicion) {
    switch(estado) {
    case 'q':
      {
        this.xFrameJugador = 384;
        image(this.jugador.get(this.xFrameJugador, this.yFrameJugador, this.anchoFrameJugador, this.altoFrameJugador), posicion.x, posicion.y);
        break;
      }
    case 'a':
      {
        image(this.jugadorIzq.get(this.xFrameJugador-1, this.yFrameJugador, this.anchoFrameJugador, this.altoFrameJugador), posicion.x, posicion.y);
        xFrameFloat +=velocidadFrame*GameTime.deltaTime;
        if (this.xFrameFloat >= this.nextxFrameFloat) {
          this.xFrameJugador += this.anchoFrameJugador;
          this.xFrameFloat = 0;
        }
        if (this.xFrameJugador >= 4*anchoFrameEnemigo) {
          this.nextxFrameFloat= this.anchoFrameJugador;
          this.xFrameJugador = 0;
        }
        break;
      }
    case 'd':
      {
        image(this.jugador.get(this.xFrameJugador, this.yFrameJugador, this.anchoFrameJugador, this.altoFrameJugador), posicion.x, posicion.y);
        xFrameFloat +=velocidadFrame*GameTime.deltaTime;
        if (this.xFrameFloat >= this.nextxFrameFloat) {
          this.xFrameJugador += this.anchoFrameEnemigo;
          this.xFrameFloat = 0;
        }
        if (this.xFrameJugador >= 4*anchoFrameEnemigo) {
          this.xFrameJugador = 0;
          this.nextxFrameFloat= this.anchoFrameJugador;
        }

        break;
      }
    case 'w':
      {
        image(this.jugadorAtras.get(this.xFrameJugador, this.yFrameJugador, this.anchoFrameJugador, this.altoFrameJugador), posicion.x, posicion.y);
        xFrameFloat +=velocidadFrame*GameTime.deltaTime;
        if (this.xFrameFloat >= this.nextxFrameFloat) {
          this.xFrameJugador += this.anchoFrameJugador;
          this.xFrameFloat = 0;
        }
        if (this.xFrameJugador >= 5*anchoFrameEnemigo) {
          this.nextxFrameFloat= this.anchoFrameJugador;
          this.xFrameJugador = 0;
        }
        break;
      }
    case 's':
      {
        image(this.jugadorAbajo.get(this.xFrameJugador, this.yFrameJugador, this.anchoFrameJugador, this.altoFrameJugador), posicion.x, posicion.y);
        xFrameFloat +=velocidadFrame*GameTime.deltaTime;
        if (this.xFrameFloat >= this.nextxFrameFloat) {
          this.xFrameJugador += this.anchoFrameJugador;
          this.xFrameFloat = 0;
        }
        if (this.xFrameJugador >= 3*anchoFrameEnemigo) {
          this.nextxFrameFloat = this.anchoFrameJugador;
          this.xFrameJugador = 0;
        }
        break;
      }
    }
  }
  public int getAltoFrameEnemigo() {
    return altoFrameEnemigo;
  }
  public int getAnchoFrameEnemigo() {
    return anchoFrameEnemigo;
  }
  public int getAltoFrameJugador() {
    return altoFrameJugador;
  }
  public int getAnchoFrameJugador() {
    return anchoFrameJugador;
  }
}
static class Utilidad {
  public static final float DAÑO_VOMITO = 10;
  public static final float DAÑO_MELE = 15;
  public static final float DAÑO_JEFE = 25;
  Utilidad() {
  }

  public static void movimientoEnemigo(PVector posInicial, PVector posFinal, float velocidad, float distanciaMinima) {
    float distanciaX = posFinal.x - posInicial.x;
    float distanciaY = posFinal.y - posInicial.y;
    float distancia = sqrt(distanciaX * distanciaX + distanciaY * distanciaY);

    if (distancia > distanciaMinima) {
      float movX = distanciaX  / distancia * velocidad * GameTime.deltaTime;
      float movY = distanciaY / distancia * velocidad * GameTime.deltaTime;
      posInicial.x += movX;
      posInicial.y += movY;
    }
  }

  private static boolean colisionRectangulos(PVector posA, float anchoA, float alturaA, PVector posB, float anchoB, float alturaB) {

    float distanciaX = posA.x - posB.x;
    float distanciaY = posA.y - posB.y;


    if (distanciaX < 0) distanciaX = -distanciaX;
    if (distanciaY < 0) distanciaY = -distanciaY;


    return distanciaX < (anchoA / 2 + anchoB / 2) &&
      distanciaY < (alturaA / 2 + alturaB / 2);
  }

  public static PVector trayectoria(PVector posInicial, PVector posFinal) {
    PVector distancia = new PVector(posFinal.x - posInicial.x, posFinal.y - posInicial.y);
    float hipotenusa = sqrt(distancia.x * distancia.x + distancia.y * distancia.y);
    PVector movimiento = new PVector(distancia.x/hipotenusa, distancia.y/hipotenusa);
    return  movimiento;
  }
}
class ZombieDistancia extends Enemigo {

  private int colliderZombie, tiempoEntreBala, vida;
  private Sprite sprite;
  private ArrayList<Proyectil> balasVomito;
  private char estadoEnemigo;
  public ZombieDistancia() {
    this.posicion = new PVector(random(width), random(height));
    this.velocidad = 100;
    this.colliderZombie = 10;
    this.estadoEnemigo = 'q';
    this.sprite = new Sprite();
    this.balasVomito =new ArrayList<Proyectil>();
    this.vida = 10;
    this.tiempoEntreBala = 0;
  }

  public void mover(PVector posJugador) {
    Utilidad.movimientoEnemigo(this.posicion, posJugador, this.velocidad, 400);
  }

  public void display() {
    sprite.displayEnemigo(this.estadoEnemigo, this.posicion);
  }
  public boolean recibeDaño() {
    boolean murio=false;
    this.vida-= 2;
    if (vida <=0) murio = true ;
    return murio;
  }
  public void disparar() {
    tiempoEntreBala++; // un cronometro para la balaVotime
    if (tiempoEntreBala >= 120) {
      this.estadoEnemigo = 'a';
      balasVomito.add(new BalaVomito(player.getPosicionPlayer(), this.posicion.copy())); //agrega BalasMoco
      tiempoEntreBala = 0;  //reinicia el cronometro
    } else if (tiempoEntreBala>= 20) this.estadoEnemigo = 'q';
    for (int i = this.balasVomito.size() - 1; i >= 0; i--) {  //visualiza balaVomito
      Proyectil bala = this.balasVomito.get(i);
      bala.mover();
      bala.display();

      if (bala.posicion.x < 0 || bala.posicion.x > width //elimina bala
        || bala.posicion.y < 0 || bala.posicion.y > height) {
        balasVomito.remove(i);
      }
    }
  }

  public PVector getPosicion() {
    return posicion;
  }


  public int getRadioColision() {
    return this.colliderZombie;
  }


  public ArrayList<Proyectil> getBalasVomito() {
    return this.balasVomito;
  }
}
class ZombieMele extends Enemigo {
  private int colliderZombie, cooldownDañoMele, tiempoUltimoDañoMele, vida;
  private Sprite sprite;

  public ZombieMele() {
    this.posicion = new PVector( random(width), random(height));
    this.velocidad = 100;
    this.vida = 10;
    this.colliderZombie = 10;
    this.sprite = new Sprite();
    this.cooldownDañoMele = 2000;
    this.tiempoUltimoDañoMele = 0;
  }

  public void mover(PVector posJugador) {
    Utilidad.movimientoEnemigo(this.posicion, posJugador, this.velocidad, 25);
  }

  public void display() {
    sprite.displayEnemigo('q', this.posicion);
  }


  public PVector getPosicion() {
    return posicion;
  }
 

  public int getRadioColision() {
    return this.colliderZombie;
  }
  public int getCooldownDañoMele() {
    return this.cooldownDañoMele;
  }
  public int getTiempoUltimoDañoMele() {
    return this.tiempoUltimoDañoMele;
  }
  public void setTiempoUltimoDañoMele(int tiempo) {
    this.tiempoUltimoDañoMele = tiempo;
  }
  public boolean recibeDaño() {
    boolean murio=false;
    this.vida-= 2;
    if (vida <=0) murio = true ;

    return murio;
  }
}
class ZombieJefe extends Enemigo {
  private int colliderZombie, tiempoEntreBala, cooldownDañoJefe, tiempoUltimoDañoJefe, vida;
  private ArrayList<Proyectil> balasVomito;
  private Sprite sprite;
  private char estadoEnemigo;

  public ZombieJefe() {
    this.posicion = new PVector(random(width), random(height));
    this.velocidad = 50;
    this.colliderZombie = 10;
    this.estadoEnemigo = 'q';
    this.sprite = new Sprite();
    this.balasVomito = new ArrayList<Proyectil>();
    this.vida = 2;
    this.tiempoEntreBala = 0;
    this.cooldownDañoJefe = 2000;
    this.tiempoUltimoDañoJefe = 0;
    this.sprite = new Sprite();
  }

  public void mover(PVector posJugador) {
    Utilidad.movimientoEnemigo(this.posicion, posJugador, this.velocidad, 0);
  }

  public void display() {
    sprite.displayEnemigo(this.estadoEnemigo, this.posicion);
  }
  public void disparar() {
    tiempoEntreBala++; // un cronometro para la balaVotime
    if (tiempoEntreBala >= 50) {
      this.estadoEnemigo = 'a';
      balasVomito.add(new BalaVomito(player.getPosicionPlayer(), this.posicion.copy())); //agrega BalasMoco
      tiempoEntreBala = 0;  //reinicia el cronometro
    } else if (tiempoEntreBala>= 20) this.estadoEnemigo = 'q';
    for (int i = this.balasVomito.size() - 1; i >= 0; i--) {  //visualiza balaVomito
      Proyectil bala = this.balasVomito.get(i);
      bala.mover();
      bala.display();

      if (bala.posicion.x < 0 || bala.posicion.x > width //elimina bala
        || bala.posicion.y < 0 || bala.posicion.y > height) {
        balasVomito.remove(i);
      }
    }
  }
  public boolean recibeDaño() {
    boolean murio=false;
    this.vida-= 2;
    if (vida <=0) murio = true ;

    return murio;
  }
  public PVector getPosicion() {
    return posicion;
  }
  public int getRadioColision() {
    return this.colliderZombie;
  }
  public int getVida() {
    return vida;
  }
  public int getCooldownDañoJefe() {
    return this.cooldownDañoJefe;
  }
  public int getTiempoUltimoDañoJefe() {
    return this.tiempoUltimoDañoJefe;
  }
  public void setTiempoUltimoDañoJefe(int tiempo) {
    this.tiempoUltimoDañoJefe = tiempo;
  }
  public ArrayList<Proyectil> getBalasVomito() {
    return this.balasVomito;
  }
}
