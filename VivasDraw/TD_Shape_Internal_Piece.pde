/**
 *  Shared functions between cross and center classes.
 *  By Cian O'Gorman 05-07-2021.
 */
private class TD_Shape_Internal_Piece extends TD_Shape_Template {

  boolean invertJoints;
  protected ArrayList<Float> jointPoints = new ArrayList<Float>();
  protected ArrayList<Float> jointDips = new ArrayList<Float>();

  // Draws the joints of a center/cross piece
  protected PShape constructCenterJoints(boolean invertJoints) {
    PShape centerJoints = createShape(GROUP);
    PShape joints = createShape();
    joints.beginShape(TRIANGLE_STRIP);
    initialise(joints);
    float startPoint = 0;
    float endPoint = boxHeight;
    if (constructTop == true)
      startPoint += thickness; 
    if (constructBottom == true) {
      endPoint -= thickness;
      if (floorOffsetEnabled == true)
        endPoint -= floorOffset;
    }
    // Variables used to invert the joints 
    float extrudeOffset = 0;
    float intrudeOffset = 0;
    if (invertJoints == true) {
      extrudeOffset = -thickness;
      intrudeOffset = thickness;
    }
    float jointStartYPosition = startPoint;
    boolean jointStartInwards = false;
    float jointEndYPosition = endPoint;
    boolean jointEndInwards = false;
    boolean jointStartFound = false;
    for (int i = 1; i <= (jointAmount - 1); i++) {
      if (i % 2 == 0) {
        // Outwards to inwards
        // Inner edges
        if (jointHeight * (i - 1)  > startPoint && jointHeight * i < endPoint) {
          joints.vertex(extrudeOffset + thickness, jointHeight * (i - 1), 0);
          joints.vertex(extrudeOffset + thickness, jointHeight * (i - 1), thickness);
          joints.vertex(extrudeOffset + thickness, jointHeight * i, 0);
          joints.vertex(extrudeOffset + thickness, jointHeight * i, thickness);
          if (jointStartFound == false) {
            jointStartFound = true;
            jointStartInwards = true;
            jointStartYPosition = (jointHeight * (i - 1));
          }
          jointEndInwards = true;
          jointEndYPosition = (jointHeight * i);
        }
        // Upper edges
        if (jointHeight * i >= startPoint && jointHeight * i <= endPoint) {

          if (invertJoints) {
            joints.vertex(0, jointHeight * i, 0);
            joints.vertex(0, jointHeight * i, thickness);
          } else {
            joints.vertex(thickness, jointHeight * i, 0);
            joints.vertex(thickness, jointHeight * i, thickness);
          }

          if (jointStartFound == false) {
            jointStartFound = true;
            if (invertJoints == true)
              jointStartInwards = false;
            else
              jointStartInwards = true;
            jointStartYPosition = (jointHeight * i);
          }
          if (invertJoints == true)
            jointEndInwards = true;
          else
            jointEndInwards = false;
          jointEndYPosition = (jointHeight * i);
        }
      } else {
        // Inwards to outwards
        if (jointHeight * (i - 1) > startPoint && jointHeight * i < endPoint) {
          // Outer edges
          joints.vertex(intrudeOffset, jointHeight * (i - 1), 0);
          joints.vertex(intrudeOffset, jointHeight * (i - 1), thickness);
          joints.vertex(intrudeOffset, jointHeight * i, 0);
          joints.vertex(intrudeOffset, jointHeight * i, thickness);

          if (jointStartFound == false) {
            jointStartFound = true;
            if (invertJoints == true)
              jointStartInwards = true;
            else
              jointStartInwards = false;
            jointStartYPosition = (jointHeight * (i - 1));
          }
          jointEndInwards = false;
          jointEndYPosition = (jointHeight * i);
        }
        // Bottom edges
        if (jointHeight * i >= startPoint && jointHeight * i <= endPoint) {
          if (invertJoints) {
            joints.vertex(thickness, jointHeight * i, 0);
            joints.vertex(thickness, jointHeight * i, thickness);
          } else {
            joints.vertex(0, jointHeight * i, 0);
            joints.vertex(0, jointHeight * i, thickness);
          }
          if (jointStartFound == false) {
            jointStartFound = true;
            if (invertJoints == true)
              jointStartInwards = true;
            else
              jointStartInwards = false;
            jointStartYPosition = (jointHeight * i);
          }
          if (invertJoints == true)
            jointEndInwards = false;
          else
            jointEndInwards = true;
          jointEndYPosition = (jointHeight * i);
        }
      }
    }
    // Connect startPoint to joints
    if (jointStartInwards == true) {
      PShape jointStart = createShape();
      jointStart.beginShape(TRIANGLE_STRIP);
      initialise(jointStart);
      jointStart.vertex(thickness, startPoint, 0);
      jointStart.vertex(thickness, startPoint, thickness);
      jointStart.vertex(thickness, jointStartYPosition, 0);
      jointStart.vertex(thickness, jointStartYPosition, thickness);
      jointStart.endShape();
      centerJoints.addChild(jointStart);
    } else {
      PShape jointStart = createShape();
      jointStart.beginShape(TRIANGLE_STRIP);
      initialise(jointStart);
      jointStart.vertex(0, jointStartYPosition, 0);
      jointStart.vertex(0, jointStartYPosition, thickness);
      jointStart.vertex(0, startPoint, 0);
      jointStart.vertex(0, startPoint, thickness);

      jointStart.vertex(0, startPoint, 0);
      jointStart.vertex(0, startPoint, thickness);
      jointStart.vertex(thickness, startPoint, 0);
      jointStart.vertex(thickness, startPoint, thickness);
      jointStart.endShape();
      centerJoints.addChild(jointStart);
    }
    if (jointEndInwards == true) {
      if (constructBottom == false)
        endPoint += thickness;  // Add control boolean of some sort if joint is ending short
      joints.vertex(thickness, jointEndYPosition, 0);
      joints.vertex(thickness, jointEndYPosition, thickness);
      joints.vertex(thickness, endPoint, 0);
      joints.vertex(thickness, endPoint, thickness);
    } else {
      joints.vertex(0, jointEndYPosition, 0);
      joints.vertex(0, jointEndYPosition, thickness);
      joints.vertex(0, endPoint, 0);
      joints.vertex(0, endPoint, thickness);

      joints.vertex(0, endPoint, 0);
      joints.vertex(0, endPoint, thickness);
      joints.vertex(thickness, endPoint, 0);
      joints.vertex(thickness, endPoint, thickness);
    }
    joints.endShape();
    centerJoints.addChild(joints);
    return centerJoints;
  }
}
