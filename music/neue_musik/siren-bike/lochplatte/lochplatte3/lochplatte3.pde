import processing.pdf.*;

// Global that determines if guidelines and annotations are shown (ie. design mode)
// or hidden (ie. production mode)
boolean production_flag = false;
float mmTOpix = 72/25.4;
float pixTOmm  = 25.4/75;

public void settings() {
  //In PDF documents, everything is measured using “Point”. 
  //In the PDF world, 1 point = 1/72 inch, it means that a page width of 595 points is actually 595 / 72 = 8.27 inches, 
  //which is the standard width for DIN A4 page size.
  size(int(600*mmTOpix), int(600*mmTOpix), PDF, "output.pdf");
}

void setup() {
  production(false);
  // Change background to white when in design mode
  if (!production_flag) {
    background(255,255,255); 
  }
  // Set stroke weight
  // 0.01 mm = thin lines for production
  // 0.1  mm = thicker lines for clear printing in design mode
  strokeWeight((production_flag ? 0.01 : 0.1));

  // No fill on shapes
  noFill();
}

void draw() {
  // Scale all units from mm to points
  // All coordinates (x, y) and widths and heights are henceforth in mm
  translate(width/2, height/2);
  scale(mmTOpix);
  
  /* YOUR DESIGN STARTS HERE */

  // Center Part: Holes for mount and screws
  cut_ellipse(0, 0, 596, 596);
  cut_ellipse(0, 0, 52, 52);
  guide_circle(0,0,71,71);

  guide_crosshair(0, 0, 15);
  cut_regular_holes(4.5 , 30.5*2, 6);
 
  float hole_diameter = 5;//in mm
  float outer_cicle_diameter = 600;//in mm
  
  int[] oberton_faktoren = {11,9,7,6,5,4,3};
  int basis_anzahl = 12;
  
  //cut_sheppard(hole_diameter, outer_cicle_diameter, 4);


  cut_regular_holes(hole_diameter, outer_cicle_diameter-1*66-33 ,basis_anzahl*6);
  cut_regular_holes(hole_diameter, outer_cicle_diameter-1*66-33 ,basis_anzahl*5);
  cut_regular_holes(hole_diameter, outer_cicle_diameter-1*66-33 ,basis_anzahl*4);

  cut_regular_holes(hole_diameter, outer_cicle_diameter-2*66-33 ,basis_anzahl*5); 
  cut_regular_holes(hole_diameter, outer_cicle_diameter-2*66-33 ,basis_anzahl*4);  
  cut_regular_holes(hole_diameter, outer_cicle_diameter-2*66-33 ,basis_anzahl*3);  
   
   
  cut_regular_holes(hole_diameter, outer_cicle_diameter-3*66-33 , basis_anzahl*7); 
  cut_regular_holes(hole_diameter, outer_cicle_diameter-3*66-33 , basis_anzahl*5);
  
  cut_regular_holes(hole_diameter, outer_cicle_diameter-4*66-33 ,basis_anzahl*5);
  cut_regular_holes(hole_diameter, outer_cicle_diameter-4*66-33 ,basis_anzahl*4);

  cut_random_holes(hole_diameter, outer_cicle_diameter-5*66-33);
  cut_random_holes(hole_diameter, outer_cicle_diameter-6*66-33);
  
  /* YOUR DESIGN ENDS HERE */
  
  // Exit the program 
  println("Finished.");
  exit();
}


// "LIBRARY" FUNCTIONS
// Not a complete set of functions, just enough stuff to get 
// what I needed to accomplish done

void cut_regular_holes(float hole_diameter, float circle_diameter, int no_of_holes){
    guide_circle(0,0,circle_diameter,circle_diameter);
    cut_mode();
    pushMatrix();
    for(int i = 0; i<no_of_holes; i++){
      ellipse(0, circle_diameter/2.0, hole_diameter, hole_diameter);
      rotate(2*PI/float(no_of_holes));
    }
    popMatrix();
}

void cut_sheppard(float hole_diameter, float circle_diameter, int rows){
    guide_circle(0,0,circle_diameter,circle_diameter);
    cut_mode();
    float delta_0 = TWO_PI/200.0;
    float delta_phi;
    float phi =0;
    pushMatrix();
    for(int row = 1; row< rows+1; row++){
      println(row);
      while(floor((phi/TWO_PI) / row) < 1){
      ellipse(0, circle_diameter/2.0 -(44.0*row), hole_diameter, hole_diameter);
      delta_phi = delta_0*exp(phi*0.0748);
      print(delta_phi);
      print(" ");
      rotate(delta_phi);
      phi += delta_phi;
      print(phi);
      }
    }
    popMatrix();
}

void cut_random_holes(float hole_diameter, float circle_diameter){
    guide_circle(0,0,circle_diameter,circle_diameter);
    cut_mode();
    float dphi_min, dphi_max;
    dphi_min = TWO_PI / circle_diameter * PI;
    dphi_max = 2*dphi_min;
    float phi, dphi;
    phi = 0;
    pushMatrix();
    while (phi < TWO_PI){
      ellipse(0, circle_diameter/2.0, hole_diameter, hole_diameter);
      dphi = random(dphi_min, dphi_max);
      rotate(dphi);
      phi += dphi;
    }
    popMatrix();
}

// Use this method to set the global production flag
void production(boolean v){
 production_flag = v;
 }

// Set the Ponoko cut colour, blue 
void cut_mode(){
  // blue for laser cut
  stroke(0,0,255);
}

// Set the colour of the guide lines to orange
void guide_mode() {
  stroke(0xff,0x66,0);
}


// Draw a line to be cut
void cut_line(float x1, float y1, float x2, float y2)
{
  cut_mode();
  line(x1, y1, x2, y2);
}

// Draw an ellipse to be cut
void cut_ellipse(float a, float b, float c, float d) {
  cut_mode();
  ellipse(a, b, c, d);
}


// Draw an arc to be cut
void cut_arc(float a, float b, float c, float d, float start, float stop){
  cut_mode();
  arc(a, b, c, d, start, stop);  }


// Draw a guideline
// It will be hidden in production mode
void guide_line(float x1, float y1, float x2, float y2){
  if (production_flag) return;
  guide_mode();
  line(x1, y1, x2, y2);
}

// Draw a guide rectangle
// It will be hidden in production mode
void guide_rect(float a, float b, float c, float d){
  if (production_flag) return;
  guide_mode();
  rect(a, b, c, d); 
}

// Draw a guide circle
// It will be hidden in production mode
void guide_circle(float a, float b, float c, float d){
  if (production_flag) return;
  guide_mode();
  ellipse(a, b, c, d); 
}


// Draw a guide cross hair centred at (x,y) and with a radius of rad
// It will be hidden in produciton mode
void guide_crosshair(float x, float y, float rad){
    guide_line(x, y - rad, x, y + rad);
    guide_line(x - rad, y, x + rad, y); 
}

// Print an annotation in string c at (x,y)
// It will be hidden in produciton mode
void note(String c, float x, float y){
  if (production_flag) return;
  fill(0xff,0x66,0);
  text(c, x, y);
  noFill();
}
