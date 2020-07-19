/** 
 *  Draws the grid to the screen
 *  By Cian O'Gorman 18-07-2020
 */
class Grid_Static extends Shape_Template_Static {

  // Constants
  private static final int GRID_ORIGIN_CENTRE = 250;                 // The centre of the square grid on pixels (used for centering the grid on the screen)
  private final float GRID_LENGTH = 500;                        // The size of the entire grid
  private final float GRID_SQUARE_LENGTH = GRID_LENGTH / 5;     // The size of a grid square

  // Object initialisation
  private PShape gridStatic;

  Grid_Static(PGraphics graphicContext) {
    setGraphicContext(graphicContext);
    gridStatic = createShape();
    gridStatic.beginShape(LINES);      // Draws the vertices as lines between every other pair of vertices
    initialise(gridStatic);
    plotShape(gridStatic);
    gridStatic.endShape();
  }


  @Override
    void initialise(PShape gridStatic) {
    gridStatic.stroke(255);
    gridStatic.strokeWeight(STROKE_WEIGHT);
    gridStatic.noFill();
  }

  void draw() {
    pushMatrix();

    // Centres the origin of the grid on the screen (Top left corner)
    translate((width / 2), (height / 2), GRAPHIC_CONTEXT_VERTICLE_POSITION);

    // Rotates graphic context so we look down on the grid
    rotateX(GLOBAL_X_ROTATE);

    // Auto rotates the grid
    globalYRotate -= Y_ROTATE_SPEED;
    rotateY(globalYRotate);

    // Centres the grid on screen
    translate(-GRID_ORIGIN_CENTRE, 0, -GRID_ORIGIN_CENTRE);

    display(gridStatic);
    popMatrix();
  }

  @Override
    void plotShape(PShape shape) {
    gridStatic.vertex(0, 0, GRID_SQUARE_LENGTH);
    gridStatic.vertex(GRID_LENGTH, 0, GRID_SQUARE_LENGTH);
    gridStatic.vertex(0, 0, (GRID_SQUARE_LENGTH * 2));
    gridStatic.vertex(GRID_LENGTH, 0, (GRID_SQUARE_LENGTH * 2));
    gridStatic.vertex(0, 0, (GRID_SQUARE_LENGTH * 3));
    gridStatic.vertex(GRID_LENGTH, 0, (GRID_SQUARE_LENGTH * 3));
    gridStatic.vertex(0, 0, (GRID_SQUARE_LENGTH * 4));
    gridStatic.vertex(GRID_LENGTH, 0, (GRID_SQUARE_LENGTH * 4));

    gridStatic.vertex(GRID_SQUARE_LENGTH, 0, 0);
    gridStatic.vertex(GRID_SQUARE_LENGTH, 0, GRID_LENGTH);
    gridStatic.vertex((GRID_SQUARE_LENGTH * 2), 0, 0);
    gridStatic.vertex((GRID_SQUARE_LENGTH * 2), 0, GRID_LENGTH);
    gridStatic.vertex((GRID_SQUARE_LENGTH * 3), 0, 0);
    gridStatic.vertex((GRID_SQUARE_LENGTH * 3), 0, GRID_LENGTH);
    gridStatic.vertex((GRID_SQUARE_LENGTH * 4), 0, 0);
    gridStatic.vertex((GRID_SQUARE_LENGTH * 4), 0, GRID_LENGTH);
  }
}
