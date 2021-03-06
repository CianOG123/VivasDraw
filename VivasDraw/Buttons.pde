/** 
 *  This file handles all classes of the GUI buttons
 *  By Cian O'Gorman 30-07-2020
 */

/** 
 *  Class to create text buttons
 *  By Cian O'Gorman 30-07-2020
 */
private class Text_Button {

  // Variables
  private int xPosition;
  private int yPosition;
  private String text;
  private int buttonEvent;

  // Booleans
  private boolean cursorChanged = false;

  // Constants
  private final PFont BUTTON_FONT = robotoLight20;
  private final int HOVER_FONT_SIZE = 22;

  Text_Button(int xPosition, int yPosition, String text, int buttonEvent) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.text = text;
    this.buttonEvent = buttonEvent;
  }

  private void draw() {
    changeCursor();
    drawText();
  }

  // Draws the button text to the screen
  private void drawText() {
    textAlign(CENTER, CENTER);
    textFont(BUTTON_FONT);
    fill(TEXT_WHITE);
    if (mouseHover() == true) {
      textSize(HOVER_FONT_SIZE);
    }
    text(text, xPosition, yPosition);
    textAlign(LEFT, BOTTOM);
  }

  // Checks to see if the mouse is hovering over the button
  private boolean mouseHover() {
    if ((mouseX > xPosition - getTextCenter()) && (mouseX < xPosition + getTextCenter())) {
      if ((mouseY > yPosition - textAscent()) && (mouseY < yPosition + textAscent())) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // Returns the width of the text divided by two
  private float getTextCenter() {
    return textWidth(text) / 2;
  }

  // Changes the mouse cursor
  private void changeCursor() {
    if (mouseHover() == true) {
      if (cursorChanged == false) {
        cursorChanged = true;
        cursor(HAND);
      }
    } else if ((cursorChanged == true)) {
      cursorChanged = false;
      cursor(ARROW);
    }
  }

  // Returns the buttons event if the button is pressed
  private int mousePressed() {
    if (mouseHover() == true) {
      return buttonEvent;
    } else {
      return EVENT_NULL;
    }
  }
}

/** 
 *  Class to create Image buttons
 *  By Cian O'Gorman 29-07-2020
 */
private class Image_Button {

  // Objects
  PGraphics graphics;

  // Variables
  private int xPosition;
  private int yPosition;
  private int buttonWidth;
  private int buttonHeight;
  private int textXOffset;
  private int textYOffset;
  private int buttonEvent;
  private String buttonText;

  // Booleans
  private boolean cursorChanged = false;  // Set to true if the cursor has been changed to anything other than ARROW
  private boolean canPress = false;       // Set to true if the user can press the button

  //Constants
  private static final int TEXT_BOUNDARY = 30;  // Separates the text from the image button
  // Fonts
  private final PFont BUTTON_FONT = robotoLight16;
  // Colors
  private static final color BORDER_COLOR = HEADING_DARK_GREY;
  private static final color CENTER_COLOR = 255;

  Image_Button(int xPosition, int yPosition, int buttonWidth, int buttonHeight, PGraphics graphics, int buttonEvent, String buttonText) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.textXOffset = xPosition + (buttonWidth / 2);
    this.textYOffset = buttonHeight + TEXT_BOUNDARY;
    this.graphics = graphics;
    this.buttonEvent = buttonEvent;
    this.buttonText = buttonText;
  }

  private void draw(float scrollOffset, int scrollContextXPosition, int scrollContextYPosition, int scrollContextBoxWidth, int scrollContextBoxHeight) {
    changeCursor(scrollOffset, scrollContextXPosition, scrollContextYPosition, scrollContextBoxWidth, scrollContextBoxHeight);
    if (canPress == true) {
      graphics.stroke(TEXT_WHITE);
    } else {
      graphics.stroke(BORDER_COLOR);
    }
    graphics.fill(CENTER_COLOR);
    graphics.rect(xPosition + scrollOffset, yPosition, buttonWidth, buttonHeight);
    drawText(scrollOffset);
  }

  // Writes the buttons text to the screen
  private void drawText(float scrollOffset) {
    fill(111);
    graphics.textFont(BUTTON_FONT);
    graphics.textAlign(CENTER);
    graphics.text(buttonText, textXOffset + scrollOffset, textYOffset);
    graphics.textAlign(LEFT);
  }

  // Function handles the cursor image
  private void changeCursor(float scrollOffset, int scrollContextXPosition, int scrollContextYPosition, int scrollContextBoxWidth, int scrollContextBoxHeight) {
    // Checking to see if mouse is within the scroll graphic context limits
    if ((mouseX > scrollContextXPosition) && (mouseX < scrollContextXPosition + scrollContextBoxWidth)) {
      if ((mouseY > scrollContextYPosition) && (mouseY < scrollContextYPosition + scrollContextBoxHeight)) {
        // Checking to see if the mouse is within the limits of the button
        if ((mouseX > xPosition + scrollContextXPosition + scrollOffset) && (mouseX < xPosition + buttonWidth + scrollContextXPosition + scrollOffset)) {
          if ((mouseY > yPosition + scrollContextYPosition) && (mouseY < yPosition + buttonHeight + scrollContextYPosition)) {
            if (cursorChanged == false) {
              cursorChanged = true;
              canPress = true;
              cursor(HAND);
            }
            return;
          }
        }
      }
    }
    resetCursor();
  }

  // Resets the cursor to ARROW
  private void resetCursor() {
    if (cursorChanged == true) {
      cursorChanged = false;
      canPress = false;
      cursor(ARROW);
    }
  }

  // Handles what happens if the mouse is pressed
  private void mousePressed() {
    if (canPress == true) {
      if (mouseButton == LEFT) {
        displayedBox = buttonEvent;
      }
    }
  }
}


/** 
 *  Class to handle scroll bars
 *  By Cian O'Gorman 28-07-2020
 */
private class Scroll_Bar {

  // Constants
  private static final int SCROLL_BUTTON = LEFT;
  private static final int BAR_X_INSET = 10;
  private static final int BAR_Y_INSET = 2;
  private static final int GRABBER_Y_INSET = 4;
  private static final float CIRCLE_OFFSET = .5;
  private static final int GRABBER_WIDTH = 20;
  private static final int SCROLL_SHADOW_X_INSET = 20;
  private static final int GRABBER_LEFT_LIMIT = 0;

  // Objects
  PGraphics graphics;

  // Variables
  private int xPosition;
  private int yPosition;
  private int scrollWidth;
  private int scrollHeight;
  private int contextXOffset;
  private int contextYOffset;
  private int mouseOffset;

  // Return Variables
  private float scrollOffset = 0;  // The amount of pixels the scroll bar is displaced by

  // Scroll Bar Shadow
  private float barShadowXPosition;
  private float barShadowYPosition;
  private float barShadowCircleYPosition;

  // Grabber
  private int grabberHeight;
  private float circleYPosition;

  // Booleans
  private boolean mouseHeld = false;   // Set to true if the mouse button is being held down
  private boolean cursorChanged = false;  // Set to true if the cursor is anything but the arrow

   Scroll_Bar(int xPosition, int yPosition, int scrollWidth, int scrollHeight, PGraphics graphics, int contextXOffset, int contextYOffset){
    this.graphics = graphics;
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.scrollWidth = scrollWidth;
    this.scrollHeight = scrollHeight;
    this.contextXOffset = contextXOffset;
    this.contextYOffset = contextYOffset;

    // Scroll bar  shadow
    barShadowXPosition = xPosition + BAR_X_INSET;
    barShadowYPosition = yPosition + BAR_Y_INSET;
    barShadowCircleYPosition = yPosition + (scrollHeight / 2);

    // Grabber
    grabberHeight = scrollHeight - GRABBER_Y_INSET;
    circleYPosition = barShadowCircleYPosition + CIRCLE_OFFSET;
  }

  private void draw() {
    clickGrabber();
    moveGrabber();
    drawScrollBarBackground();
    drawGrabber();
  }

  // Draws the background to the scroll bar and all parts that do not move
  private void drawScrollBarBackground() {
    graphics.noStroke();
    graphics.fill(STANDARD_GREY);
    graphics.rect(xPosition, yPosition, scrollWidth, scrollHeight);
    graphics.fill(LIGHT_GREY);
    graphics.rect(barShadowXPosition, barShadowYPosition, scrollWidth - SCROLL_SHADOW_X_INSET, grabberHeight);
    graphics.circle(barShadowXPosition - CIRCLE_OFFSET, barShadowCircleYPosition + CIRCLE_OFFSET, grabberHeight);
    graphics.circle(barShadowXPosition + scrollWidth - (BAR_X_INSET * 2), barShadowCircleYPosition + CIRCLE_OFFSET, grabberHeight);
  }

  // Draws the grabber to the screen
  private void drawGrabber() {
    graphics.fill(HEADING_LIGHT_GREY);
    graphics.rect(barShadowXPosition + scrollOffset, barShadowYPosition, GRABBER_WIDTH, grabberHeight);
    graphics.circle(barShadowXPosition - CIRCLE_OFFSET + scrollOffset, circleYPosition, grabberHeight);
    graphics.circle(barShadowXPosition + GRABBER_WIDTH + scrollOffset, circleYPosition, grabberHeight);
  }

  // Moves the grabber if its being pressed
  private void moveGrabber() {
    if (mouseHeld == true) {
      scrollOffset = mouseX - (contextXOffset + mouseOffset);
      if (scrollOffset <= GRABBER_LEFT_LIMIT) {
        scrollOffset = GRABBER_LEFT_LIMIT;
      } else if (scrollOffset >= scrollWidth - (SCROLL_SHADOW_X_INSET + GRABBER_WIDTH)) {
        scrollOffset =  scrollWidth - (SCROLL_SHADOW_X_INSET + (int) GRABBER_WIDTH);
      }
      if (mousePressed == false) {
        mouseHeld = false;
      }
    }
  }

  // Gets whether the grabber is being pressed
  private void clickGrabber() {
    if (mouseHeld == false) {
      if ((mouseX > barShadowXPosition + contextXOffset + scrollOffset) && (mouseX < barShadowXPosition + GRABBER_WIDTH + contextXOffset + scrollOffset)) {
        if ((mouseY > yPosition + contextYOffset) && (mouseY < yPosition + scrollHeight + contextYOffset)) {
          if ((mousePressed == true) && (mouseButton == SCROLL_BUTTON)) {
            cursor(MOVE);
            mouseHeld = true;
            cursorChanged = true;
            mouseOffset = mouseX - (contextXOffset + (int) scrollOffset);
          } else {
            cursorChanged = true;
            cursor(HAND);
          }
        } else {
          changeCursorToArrow();
        }
      } else {
        changeCursorToArrow();
      }
    }
  }

  // Changes the cursor to an arrow
  private void changeCursorToArrow() {
    if (cursorChanged == true) {
      cursor(ARROW);
      cursorChanged = false;
    }
  }

  // Returns the scroll offset of the grabber
  private float getScrollOffset() {
    return scrollOffset;
  }
}

/**
 *  Check box button class
 *  By Cian O'Gorman 28-07-2020
 */
private class Check_Box {
  // Variables
  private int xPosition, yPosition;
  private int checkBoxWidth, checkBoxHeight;
  private String label;
  private boolean buttonSelected = false;
  private int xOffset;  
  private PGraphics graphics;

  // Constants
  private static final int BOUNDARY = 10;
  private static final color LABEL_COLOR = TEXT_WHITE;
  private static final color BUTTON_COLOR = TEXT_WHITE;
  private final PFont BUTTON_FONT = robotoLight15;

  Check_Box(int xPosition, int yPosition, int checkBoxWidth, int checkBoxHeight, String label, int xOffset, PGraphics pg) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    this.checkBoxWidth = checkBoxWidth;
    this.checkBoxHeight = checkBoxHeight;
    this.label = label;
    this.xOffset = xOffset;
    graphics = pg;
  }

  private void draw(PGraphics graphicContext) {
    if ((isMouseHovering()) || (buttonAutoRotate == true)) {
      graphics.stroke(BUTTON_COLOR);
    } else {
      graphics.stroke(HEADING_DARK_GREY);
    }
    if (buttonSelected) {
      graphicContext.fill(BUTTON_COLOR);
    } else {
      graphicContext.fill(LABEL_COLOR);
    }
    graphicContext.rect(xPosition, yPosition, checkBoxWidth, checkBoxHeight);
    graphicContext.fill(LABEL_COLOR);
    graphicContext.textFont(BUTTON_FONT);
    graphicContext.text(label, (xPosition + checkBoxWidth + BOUNDARY), yPosition  + 13);
  }

  private void isCheckBoxPressed() {
    if (isMouseHovering()) {
      buttonAutoRotate = !buttonAutoRotate;
    }
  }

  private void mousePressed() {
    isCheckBoxPressed();
  }

  private boolean isMouseHovering() {
    boolean enableHover = false;
    if ((mouseX > xPosition + xOffset) && (mouseX < (xPosition + checkBoxWidth + xOffset))) {
      if ((mouseY > yPosition) && (mouseY < (yPosition + checkBoxHeight))) {
        enableHover = true;
      }
    }
    return enableHover;
  }
}




/** 
 *  Class to handle text input boxes
 *  Cursor errors will occur if placed directly beside 3D Container
 *  By Cian O'Gorman 20-07-2020
 */
private class Text_Input {

  // Constants
  protected static final int INPUT_TIME_LIMIT = 15;            // The amount of frames that will elapse between considered user inputs

  // Variables
  protected int xPosition, yPosition, buttonHeight, buttonWidth;  // Positioning and size of the button on screen
  protected String valueTitle;
  protected float value;
  protected String inputBuffer;
  protected int charPressedBuffer = 0;                            // Stops the user from erasing all letters when pressing backspace, or double typing a letter
  protected int mousePressedBuffer = 0;
  protected int measureType = 0;                                  // The type of measurements the button corresponds to (used for updating the public variables)
  protected String measurementString = "";

  // Booleans
  protected boolean cursorChanged = false;                        // Used to change the cursor image
  protected boolean inputMode = false;                            // Set to true when user is inputting values

  // Arrays
  protected char[] validChars = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'};   // The characters that are accepted as input from the user


  Text_Input(int xPosition, int yPosition, String valueTitle, float value, int measureType) {
    this.xPosition = xPosition;
    this.yPosition = yPosition;
    textFont(robotoLight25);    // Used to get height of text
    this.buttonHeight = int (textAscent() + textDescent());
    this.valueTitle = valueTitle;
    this.value = value;
    this.inputBuffer = Float.toString(value);
    this.measureType = measureType;
    setMeasurementString();
  }

  protected void draw() {
    changeCursor();
    getTextWidth();
    userInput();
    enableInputMode();
    displayButton();
  }

  // Displays the button on the screen
  protected void displayButton() {
    textFont(robotoLight25);
    fill(TEXT_WHITE);
    if (inputMode == false) {
      text(valueTitle + value + measurementString, xPosition, yPosition + textAscent() + textDescent());
    } else {
      text(valueTitle + inputBuffer + measurementString, xPosition, yPosition + textAscent() + textDescent());
    }
  }

  // Returns the width of the text
  protected void getTextWidth() {
    buttonWidth = (int) textWidth(valueTitle + value + measurementString);
  }

  // Changes the cursor icon to indicate the user can change the value of the text
  protected void changeCursor() {
    if ((mouseX > xPosition) && (mouseX < xPosition + buttonWidth) && (mouseY >= yPosition) && (mouseY <= yPosition + buttonHeight)) {
      if (cursorChanged == false) {
        cursorChanged = true;
        cursor(TEXT);
      }
    } else if (cursorChanged == true) {
      cursor(ARROW);
      cursorChanged = false;
    }
  }

  // Handles user input
  protected void userInput() {
    if ((inputMode == true) && (keyPressed) && (charPressedBuffer == 0)) {
      charPressedBuffer = 1;
      switch(key) {
      case BACKSPACE:
        if (inputBuffer.length() != 1) {
          inputBuffer = inputBuffer.substring(0, inputBuffer.length() - 2);
          inputBuffer += '_';
        }
        break;
      case ENTER:
        saveToValue();
        inputMode = false;
        inputEnabledElseWhere = false;
        break;
      default:
        for (int i = 0; i < validChars.length; i++) {
          if (key == validChars[i]) {
            String character = Character.toString(key);
            inputBuffer = inputBuffer.substring(0, inputBuffer.length() - 1);
            inputBuffer += character;
            inputBuffer += '_';
            i = validChars.length;
          }
        }
        break;
      }
    } else if (charPressedBuffer != 0) {
      charPressedBuffer++;
      if ((charPressedBuffer >= INPUT_TIME_LIMIT) || (keyPressed == false)) {
        charPressedBuffer = 0;
      }
    }
  }

  // Checks to see if the box has been clicked and enables input mode if it has
  protected void enableInputMode() {
    if (mousePressed == true && mouseButton == LEFT) {
      if ((mouseX > xPosition) && (mouseX < xPosition + buttonWidth) && (mouseY >= yPosition) && (mouseY <= yPosition + buttonHeight)) {
        if (mousePressedBuffer == 0) {
          mousePressedBuffer = 1;
          if ((inputMode == false) && (inputEnabledElseWhere == false)) {
            inputMode = true;
            inputEnabledElseWhere = true;
            inputBuffer = String.valueOf(value);
            inputBuffer += '_';
          } else if (inputEnabledElseWhere == false) {
            saveToValue();
            inputMode = false;
            inputEnabledElseWhere = false;
          }
        } else {
          mousePressedBuffer++;
          if (mousePressedBuffer >= INPUT_TIME_LIMIT) {
            mousePressedBuffer = 0;
          }
        }
      }
    }
  }

  // Saves the inputBuffer to value
  protected void saveToValue() {
    inputBuffer = inputBuffer.substring(0, inputBuffer.length() - 1);
    if (inputBuffer != "") {
      try {
        float newValue = Float.parseFloat(inputBuffer);
        if (newValue != value) {
          value = newValue;
          updateMeasurement();              // Position means, shapes are only updated if new measurement is valid
          println("\nMeasurement update");
        }
      } 
      catch(Exception NumberFormatException) {
      }
    }
  }

  // Updates the public variables for length, width, height, etc
  protected void updateMeasurement() {
    refreshBox = true;
    switch (measureType) {
    case LENGTH:
      boxLength = value;
      break;
    case WIDTH:
      boxWidth = value;
      break;
    case HEIGHT:
      boxHeight = value;
      break;
    case THICKNESS:
      thickness = value;
      break;
    case FLOOR_OFFSET:
      floorOffset = value;
      break;
    case JOINT_AMOUNT:
      jointAmount = (int) value;
      break;
    }
  }

  // Sets the measurement string base on the button type
  protected void setMeasurementString() {
    if (measureType == JOINT_AMOUNT) {
      measurementString = "";
    } else {
      measurementString = "mm";
    }
  }
}




/** 
 *  Modified subclass for dealing with joint amount input
 *  By Cian O'Gorman 27-07-2020
 */
private class Joint_Input extends Text_Input {

  Joint_Input(int xPosition, int yPosition, String valueTitle, int value, int measureType) {
    super(xPosition, yPosition, valueTitle, value, measureType);
  }

  // Displays the button on the screen
  @Override
    protected void displayButton() {
    textFont(robotoLight25);
    fill(TEXT_WHITE);
    if (inputMode == false) {
      text(valueTitle + (int) value + measurementString, xPosition, yPosition + textAscent() + textDescent());
    } else {
      text(valueTitle + inputBuffer + measurementString, xPosition, yPosition + textAscent() + textDescent());
    }
  }

  // Saves the inputBuffer to value
  @Override
    protected void saveToValue() {
    inputBuffer = inputBuffer.substring(0, inputBuffer.length() - 1);
    if (inputBuffer != "") {
      try {
        float newValue = Float.parseFloat(inputBuffer);
        if (newValue != value) {
          value = newValue;
          if (value % 1 != 0) {
            value = (int) value;
          }
          if (value < 3) {
            value = 3;
          }
          if (value % 2 == 0) {
            value++;
          }
          updateMeasurement();              // Position means, shapes are only updated if new measurement is valid
          println("\nMeasurement update");
        }
      } 
      catch(Exception NumberFormatException) {
      }
    }
  }
}
