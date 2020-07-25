/**
 *  Interface that all shapes must follow.
 *  Created using examples as a source.
 *  By Cian O'Gorman 16-07-2020.
 */
interface Shape_Interface {

  // Constants
  public static final float STROKE_WEIGHT = 1.2;        // Stroke weight of the shape
  
  // Sets the graphical context for the shape
  void setGraphicContext(PGraphics graphicContext);
  
  // Sets the stroke, stroke weight, and other appearance settings of the shape
  void initialise(PShape shape);

  // Draws the shape to the screen (functions as draw loop)
  void display(boolean updateBoolean, PShape shape);

  // Updates the dimensions of the shape if the update boolean is set to true
  void update(boolean updateBoolean);

  // Plots the vertices of the shape 
  void plotShape(PShape shape);
}


/** 
 *  Super class designed for all static shapes.
 *  This class implements the shape interface.
 *  By Cian O'Gorman 18-07-2020
 */
class Shape_Template_Static implements Shape_Interface {

  // Objects
  protected PGraphics graphicContext;        // The graphic context in which the shape is placed

  void setGraphicContext(PGraphics graphicContext) {
    this.graphicContext = graphicContext;
  }

  void initialise(PShape shape) {
    shape.stroke(GEO_GREEN);
    shape.strokeWeight(STROKE_WEIGHT);
    shape.noFill();
  }

  void display(boolean updateBoolean, PShape shape) {
    update(updateBoolean);
    shape.draw(graphicContext);
  }

  void display(PShape shape) {
    shape.draw(graphicContext);
  }

  //TODO
  void update(boolean updateBoolean) {
    if (updateBoolean == true) {
      updateBoolean = false;
    }
  }

  void plotShape(PShape shape) {
    println("\nShape override failure.");
  }
}