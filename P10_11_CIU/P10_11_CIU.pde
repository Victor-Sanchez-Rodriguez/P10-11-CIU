float[] reference = {100,0,0};
boolean enter_pressed, space_pressed;
float X_coor, Y_coor, Z_coor, angle, cam_rot, movement_activated;
PGraphics wall, floor, ceiling, table;
PImage placeholder;
String url;
int[] magic_emissive = {0,0,0};
int[] magic_specular = {0,0,0};
int magic_shininess;
PShader sh;

void setup(){
  sh = loadShader("fragShader.glsl","vertShader.glsl");
  enter_pressed=false;
  space_pressed=false;
  changeBall();
  size(1980,1020,P3D);
  noStroke();
  drawIntro();
  X_coor=1000;
  Y_coor=height/2;
  Z_coor=-500;
  angle=0;
  cam_rot=0;
  movement_activated=0;
  url="walls.jpg";
  placeholder=loadImage(url);
  wall = createGraphics(placeholder.width,placeholder.height);
  wall.beginDraw();
  wall.image(placeholder,0,0);
  wall.endDraw();  
  url="floor.png";
  placeholder=loadImage(url);
  floor = createGraphics(placeholder.width,placeholder.height);
  floor.beginDraw();
  floor.image(placeholder,0,0);
  floor.endDraw();  
  url="ceiling.jpg";
  placeholder=loadImage(url);
  ceiling = createGraphics(placeholder.width,placeholder.height);
  ceiling.beginDraw();
  ceiling.image(placeholder,0,0);
  ceiling.endDraw();  
  url="table.jpg";
  placeholder=loadImage(url);
  table = createGraphics(placeholder.width,placeholder.height);
  table.beginDraw();
  table.image(placeholder,0,0);
  table.endDraw();
}


void drawIntro() {
  enter_pressed = false;
  background(0);
  textAlign(CENTER);
  text("Bienvenido a la bola mágica",width/2,height/8); 
  text("Controles",width/2,height/3);
  text("Teclas UP/DOWN:     Moverse adelante/atrás",width/2,height/2.4);
  text("Teclas LEFT/RIGHT:     Girar a la izquierda/derecha",width/2,height/2.2);  
  text("Espacio(mantener):     Activar la bola mágica",width/2,height/2);  
  text("R:     Resetear",width/2,height/1.8);  
  text("Pulsa enter para iniciar\n",width/2,height/1.25); 
}


void reset_system(){
  setup();
  enter_pressed=true;
  reference[0]=100;
  reference[1]=0;
  reference[2]=0;
}


void draw(){
  if(enter_pressed){
    pushMatrix();
    ambientLight(20,20,20,1250,400,50);
    pointLight(120,0,0,1000,890,-200);
    pointLight(0,120,0,1500,890,-200);
    pointLight(0,0,120,1000,890,300);
    pointLight(120,0,120,1500,890,300);
    if(space_pressed){
      sh.set("u_light", float(magic_specular[0]), float(magic_specular[1]), float(magic_specular[2]));
      shader(sh);
      if(random(0,100)<10) changeBall();
    } else{
      resetShader();
    }
    drawRoom();
    popMatrix();
    moveCamera();
  }
}


void drawRoom(){
  translate(-20,-180, -1000);
  textureMode(NORMAL);
  textureWrap(REPEAT);
  
  
  // walls
  
  beginShape();
  texture(wall);
  vertex(0,0,0,0,0);
  vertex(2000,0,0,1,0);
  vertex(2000,1200,0,1,1);
  vertex(0,1200,0,0,1);
  endShape();
  beginShape();
  texture(wall);
  vertex(0,0,0,0,0);
  vertex(0,0,2000,1,0);
  vertex(0,1200,2000,1,1);
  vertex(0,1200,0,0,1);
  endShape();
  beginShape();
  texture(wall);
  vertex(2000,0,0,0,0);
  vertex(2000,0,2000,1,0);
  vertex(2000,1200,2000,1,1);
  vertex(2000,1200,0,0,1);
  endShape();
  beginShape();
  texture(wall);
  vertex(0,0,2000,0,0);
  vertex(2000,0,2000,1,0);
  vertex(2000,1200,2000,1,1);
  vertex(0,1200,2000,0,1);
  endShape();
  
  // ceiling
  
  beginShape();
  texture(ceiling);
  vertex(0,0,0,0,0);
  vertex(2000,0,0,1,0);
  vertex(2000,0,2000,1,1);
  vertex(0,0,2000,0,1);
  endShape();
  
  // floor
  
  beginShape();
  texture(floor);
  vertex(0,1200,0,0,0);
  vertex(2000,1200,0,1,0);
  vertex(2000,1200,2000,1,1);
  vertex(0,1200,2000,0,1);
  endShape();
   
    
  // table
  translate(1000, 900, 800);
  
  beginShape();
  texture(table);
  vertex(0,0,0,0,0);
  vertex(500,0,0,1,0);
  vertex(500,50,0,1,1);
  vertex(0,50,0,0,1);
  endShape();
  beginShape();
  texture(table);
  vertex(0,0,0,0,0);
  vertex(0,0,500,1,0);
  vertex(0,50,500,1,1);
  vertex(0,50,0,0,1);
  endShape();
  beginShape();
  texture(table);
  vertex(0,0,500,0,0);
  vertex(500,0,500,1,0);
  vertex(500,50,500,1,1);
  vertex(0,50,500,0,1);
  endShape();
  beginShape();
  texture(table);
  vertex(500,0,0,0,0);
  vertex(500,0,500,1,0);
  vertex(500,50,500,1,1);
  vertex(500,50,0,0,1);
  endShape();
  beginShape();
  texture(table);
  vertex(0,0,0,0,0);
  vertex(500,0,0,1,0);
  vertex(500,0,500,1,1);
  vertex(0,0,500,0,1);
  endShape();  
  
  
  // table legs
  translate(0,50,0);
  drawLeg();
  translate(450,0,0);
  drawLeg();
  translate(0,0,450);
  drawLeg();
  translate(-450,0,0);
  drawLeg();
  
  
  // the magic ball
  translate(250,-150,-200);
  sphereDetail(100);
  shininess(magic_shininess);
  emissive(magic_emissive[0],magic_emissive[1],magic_emissive[2]);
  specular(magic_specular[0],magic_specular[1],magic_specular[2]);
  sphere (100);
}


void drawLeg(){
  beginShape();
  texture(table);
  vertex(0,0,0,0,0);
  vertex(0,250,0,1,0);
  vertex(50,250,0,1,1);
  vertex(50,0,0,0,1);
  endShape();
  beginShape();
  texture(table);
  vertex(0,0,50,0,0);
  vertex(0,250,50,1,0);
  vertex(50,250,50,1,1);
  vertex(50,0,50,0,1);
  endShape();
  beginShape();
  texture(table);
  vertex(50,0,0,0,0);
  vertex(50,250,0,1,0);
  vertex(50,250,50,1,1);
  vertex(50,0,50,0,1);
  endShape();
  beginShape();
  texture(table);
  vertex(0,0,0,0,0);
  vertex(0,250,0,1,0);
  vertex(0,250,50,1,1);
  vertex(0,0,50,0,1);
  endShape();
}


void moveCamera(){
  if(cam_rot!=0) changeReference();
  
  X_coor += movement_activated*(reference[0])/10;
  Z_coor += movement_activated*(reference[2])/10;
  if(X_coor>1950) X_coor = 1950;
  if(X_coor<50) X_coor = 50;
  if(Z_coor>950) Z_coor = 950;
  if(Z_coor<-950) Z_coor = -950;
  
  camera(X_coor, Y_coor, Z_coor, X_coor+reference[0], Y_coor+reference[1], Z_coor+reference[2], 0, 1, 0);
}


void changeReference(){
  angle = cam_rot%360;
  if(angle<0) angle+=360;
  float[] X_rotation_vector = {cos(radians(angle)),0,sin(radians(angle))};
  float[] Z_rotation_vector = {-sin(radians(angle)),0,cos(radians(angle))};
  float[] temp_reference = {reference[0],reference[1],reference[2]};
  reference[0] = temp_reference[0]*X_rotation_vector[0] + temp_reference[2]*Z_rotation_vector[0]+0;
  reference[1] = temp_reference[0]*X_rotation_vector[1] + temp_reference[2]*Z_rotation_vector[1]+0;
  reference[2] = temp_reference[0]*X_rotation_vector[2] + temp_reference[2]*Z_rotation_vector[2]+0;
}


void changeBall(){
  magic_shininess=(int)random(1,100);
  magic_emissive[0]=(int)random(1,100);
  magic_emissive[1]=(int)random(1,100);
  magic_emissive[2]=(int)random(1,100);
  magic_specular[0]=(int)random(1,100);
  magic_specular[1]=(int)random(1,100);
  magic_specular[2]=(int)random(1,100);
}


void keyPressed() {
  if (keyCode == UP) movement_activated = 1f;
  if (keyCode == DOWN) movement_activated = -1f;
  if (keyCode == LEFT) cam_rot = -2f;
  if (keyCode == RIGHT) cam_rot = 2f;
  if (keyCode == ENTER) enter_pressed=true;
  if (key == 'r' || key == 'R') reset_system();
  if (key == ' ') space_pressed=true;
}

void keyReleased(){
  if (keyCode == LEFT || keyCode == RIGHT) cam_rot = 0;
  if (keyCode == UP || keyCode == DOWN) movement_activated = 0;
  if (key == ' ') space_pressed=false;
}
