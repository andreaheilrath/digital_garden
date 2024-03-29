
/*
 Processing+LaserCut
*/
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
  size(int(300*mmTOpix), int(300*mmTOpix), PDF, "shepard2.pdf");
}

void setup() {
  // Set up an example font - font size will be 4mm
  textMode(SHAPE);
  PFont myfont;
  myfont = createFont("Caladea", 4, false); 
  textFont(myfont);
  // Change parameter to "true" when design ready for production
  // then re-run the sketch
  production(true);
  // Change background to white when in design mode
  if (!production_flag) {
    background(255,255,255); 
  }
  // Set stroke weight
  // 0.01 mm = thin lines for production
  // 0.1  mm = thicker lines for clear printing in design mode
  strokeWeight((production_flag ? 0.001 : 0.1));

  // No fill on shapes
  noFill();
}

void draw() {
  // Scale all units from mm to points
  // All coordinates (x, y) and widths and heights are henceforth in mm
  translate(width/2, height/2);
  scale(mmTOpix);
  
  /* YOUR DESIGN STARTS HERE */

  // 20mm diameter circle at centre of object
  cut_ellipse(0, 0, 298, 298);
  cut_ellipse(0, 0, 52, 52);
  guide_circle(0,0,71,71);
  cut_regular_holes(4.5 , 30.5*2, 6); //for the screws
 
  float hole_diameter = 5;//in mm
  float circle_diameter_start = 280;//in mm
  float circle_diameter = 0;
  float circle_abstand = 70.0/2.0;
 
  Table table;
  
  table = loadTable("shepard2.csv", "header");
  int no_lines = table.getRowCount();
  println(no_lines + " total rows in table");
  int no_columns = table.getColumnCount();
  println(no_columns + " total columns in table");
  
  int columns_per_set = 4;
  int data_sets = no_columns / columns_per_set;
  
  println(data_sets + " data sets");
  
  for (int data_set = 0; data_set < data_sets; data_set += 1){
    circle_diameter = circle_diameter_start + circle_abstand*data_set - data_sets*circle_abstand;
    guide_circle(0,0,circle_diameter,circle_diameter);
    cut_mode();
    pushMatrix();
  for (TableRow row : table.rows()) {
      int LochNummer1 = row.getInt(0 + data_set*columns_per_set);
      Float AbsLochgroesse1 = row.getFloat(1 + data_set*columns_per_set);
      Float WinkelAbstand1 = row.getFloat(3 + data_set*columns_per_set);
      
        if (Float.isNaN(WinkelAbstand1) == false){
        rotate(2*PI*WinkelAbstand1/100.0);
        ellipse(0, circle_diameter/2.0, AbsLochgroesse1, AbsLochgroesse1);
        popMatrix();
        pushMatrix();
        if (LochNummer1 > 0) {println("Loch Nr " + LochNummer1 + " Winkel Abstand " + WinkelAbstand1 + " Abs Lochgröße " + AbsLochgroesse1);}
      }       
    }
  }
    

  
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

void cut_random_holes(float hole_diameter, float circle_diameter, int no_of_holes, float var){
    guide_circle(0,0,circle_diameter,circle_diameter);
    cut_mode();
    float angle;
    float sum_angle=0;
    float limit = 1.0 - 1.0/no_of_holes;
    pushMatrix();
    while (sum_angle < limit){
      ellipse(0, circle_diameter/2.0, hole_diameter, hole_diameter);
      angle = random(no_of_holes - var, no_of_holes + var);
      rotate(2*PI/angle);
      sum_angle += 1.0/angle;
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

// Set the colour for Ponoko vector engrave mode
void vector_engrave_mode() {
  // red == heavy
  //stroke(255, 0, 0);
  // medium == green
  stroke(0, 255, 0);
  // light = magenta
  //stroke(255, 0, 255);
}

// Draw an hole to suit an M3 screen, centred at (x,y)
void hole_m3(float x, float y)
{
  guide_crosshair(x, y, 2);
  
  ellipseMode(CENTER);
  cut_ellipse(x, y, 3, 3); 
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

// Draw a rectangle to be cut
void cut_rect(float a, float b, float c, float d){
  cut_mode();
  rect(a, b, c, d); 
}

// Draw a rounded rectangle to be cut
void cut_rect(float a, float b, float c, float d, float r){
  cut_mode();
  rect(a, b, c, d, r); }

// Draw an arc to be cut
void cut_arc(float a, float b, float c, float d, float start, float stop){
  cut_mode();
  arc(a, b, c, d, start, stop);  }

// Draw a line to be vector engraved
void engrave_line(float x1, float y1, float x2, float y2){
  vector_engrave_mode();
  line(x1, y1, x2, y2);
}

// Draw a rectangle to be vector engraved
void engrave_rect(float a, float b, float c, float d){
  vector_engrave_mode();
  rect(a, b, c, d); 
}

// Engrave text using heavy raster fill engraving
void engrave_text(String c, float x, float y){
  // Set black fill
  fill(0, 0, 0);
  text(c, x, y);
  noFill();
}

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
