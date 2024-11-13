public void CGLine(float x1,float y1,float x2,float y2){
    //To-Do: You need to implement the "line algorithm" in this section. 
    //You can use the function line(x1, y1, x2, y2); to verify the correct answer. 
    //However, remember to comment out the function before you submit your homework. 
    //Otherwise, you will receive a score of 0 for this part.
       
    //Utilize the function drawPoint(x, y, color) to apply color to the pixel at coordinates (x, y).
    //For instance: drawPoint(0, 0, color(255, 0, 0)); signifies drawing a red point at (0, 0).   
       
    /*
    stroke(0);
    noFill();
    line(x1,y1,x2,y2);
    */

    float dx = abs(x2 - x1);
    float dy = abs(y2 - y1);
    float x = x1;
    float y = y1;
    int xIncrement = (x1 < x2) ? 1 : -1;
    int yIncrement = (y1 < y2) ? 1 : -1;
    float decision;

    if (dx >= dy) {
        decision = (2 * dy) - dx;
        while (x != x2) {
            drawPoint(x, y, color(0, 0, 0));
            if (decision > 0) {
                y += yIncrement;
                decision -= 2 * dx;
            }
            decision += 2 * dy;
            x += xIncrement;
        }
    } 
    else {
        decision = (2 * dx) - dy;
        while (y != y2) {
            drawPoint(x, y, color(0, 0, 0));
            if (decision > 0) {
                x += xIncrement;
                decision -= 2 * dy;
            }
            decision += 2 * dx;
            y += yIncrement;
        }
    }
    drawPoint(x, y, color(0, 0, 0));
}


public void CGCircle(float x,float y,float r){
    //To-Do: You need to implement the "circle algorithm" in this section. 
    //You can use the function circle(x, y, r); to verify the correct answer. 
    //However, remember to comment out the function before you submit your homework. 
    //Otherwise, you will receive a score of 0 for this part.
       
    //Utilize the function drawPoint(x, y, color) to apply color to the pixel at coordinates (x, y).
    //For instance: drawPoint(0, 0, color(255, 0, 0)); signifies drawing a red point at (0, 0).         
    
    /*
    stroke(0);
    noFill();
    circle(x,y,r*2);
    */  

    float dx = 0;
    float dy = r;
    float radiusError = 1 - r;

    while (dx <= dy) {
        drawPoint(x + dx, y + dy, color(0, 0, 0));
        drawPoint(x - dx, y + dy, color(0, 0, 0));
        drawPoint(x + dx, y - dy, color(0, 0, 0));
        drawPoint(x - dx, y - dy, color(0, 0, 0));
        drawPoint(x + dy, y + dx, color(0, 0, 0));
        drawPoint(x - dy, y + dx, color(0, 0, 0));
        drawPoint(x + dy, y - dx, color(0, 0, 0));
        drawPoint(x - dy, y - dx, color(0, 0, 0));
        dx++;

        if (radiusError < 0) {
          radiusError += 2 * dx + 1;
        } 
        else 
        {
          dy--;
          radiusError += 2 * (dx - dy + 1);
        }
    }
}

public void CGEllipse(float x,float y,float r1,float r2){
    //To-Do: You need to implement the "ellipse algorithm" in this section. 
    //You can use the function ellipse(x, y, r1,r2); to verify the correct answer. 
    //However, remember to comment out the function before you submit your homework. 
    //Otherwise, you will receive a score of 0 for this part.
       
    //Utilize the function drawPoint(x, y, color) to apply color to the pixel at coordinates (x, y).
    //For instance: drawPoint(0, 0, color(255, 0, 0)); signifies drawing a red point at (0, 0).         
      
    /*  
    stroke(0);
    noFill();
    ellipse(x,y,r1*2,r2*2);
    */

    float x = 0;
    float y = r2;
    
    // Initial decision parameter of region 1
    float d1 = r2 * r2 - r1 * r1 * r2 + r1 * r1 / 4;
    float dx = 2 * r2 * r2 * x;
    float dy = 2 * r1 * r1 * y;
    
    // For region 1
    while (dx < dy ) {
        drawPoint(x + x_center, y + y_center, color(0, 0, 0));
        drawPoint(-x + x_center, y + y_center, color(0, 0, 0));
        drawPoint(x + x_center, -y + y_center, color(0, 0, 0));
        drawPoint(-x + x_center, -y + y_center, color(0, 0, 0));

        // Checking and updating value of
        // decision parameter based on algorithm
        if (d1 < 0) {
            x++;
            dx += 2 * r2 * r2;
            d1 += dx + r2 * r2;
        } else {
            x++;
            y--;
            dx += 2 * r2 * r2;
            dy -= 2 * r1 * r1;
            d1 += dx - dy + (r2 * r2);
        }
    }
    // Decision parameter of region 2
    float d2 = r2 * r2 * (x + 0.5) * (x + 0.5) + r1 * r1 * (y - 1) * (y - 1) - r1 * r1 * r2 * r2;

    while (y >= 0) {
        drawPoint(x + x_center, y + y_center, color(0, 0, 0));
        drawPoint(-x + x_center, y + y_center, color(0, 0, 0));
        drawPoint(x + x_center, -y + y_center, color(0, 0, 0));
        drawPoint(-x + x_center, -y + y_center, color(0, 0, 0));

        if (d2 > 0) {
            y--;
            dy -= 2 * r1 * r1;
            d2 += r1 * r1 - dy;
        } else {
            y--;
            x++;
            dx +=  2 * r2 * r2;
            dy -=  2 * r1 * r1;
            d2 += dx - dy + (r1 * r1);
        }
    }
      
}

public void CGCurve(Vector3 p1,Vector3 p2,Vector3 p3,Vector3 p4){
    //To-Do: You need to implement the "bezier curve algorithm" in this section. 
    //You can use the function bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y); to verify the correct answer. 
    //However, remember to comment out the function before you submit your homework. 
    //Otherwise, you will receive a score of 0 for this part.
       
    //Utilize the function drawPoint(x, y, color) to apply color to the pixel at coordinates (x, y).
    //For instance: drawPoint(0, 0, color(255, 0, 0)); signifies drawing a red point at (0, 0). 
    
    /*
    stroke(0);
    noFill();
    bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    */

    // Number of segments to approximate the curve
    int numSegments = 1000;
    
    for (int i = 0; i <= numSegments; i++) {
        float t = i / (float)numSegments;
        float oneMinusT = 1.0 - t;
        
        // Calculate the coordinates of a point on the Bezier curve
        float x = oneMinusT * oneMinusT * oneMinusT * p1.x +
                  3 * oneMinusT * oneMinusT * t * p2.x +
                  3 * oneMinusT * t * t * p3.x +
                  t * t * t * p4.x;
        float y = oneMinusT * oneMinusT * oneMinusT * p1.y +
                  3 * oneMinusT * oneMinusT * t * p2.y +
                  3 * oneMinusT * t * t * p3.y +
                  t * t * t * p4.y;
        
        // Draw a point at the calculated coordinates with the desired color
        drawPoint((int)x, (int)y, color(0, 0, 0)); 
    }
}

public void CGEraser(Vector3 p1,Vector3 p2){
    //To-Do: You need to erase the scene in the area defined by points p1 and p2 in this section.. 
    //   p1  ------
    //      |      |
    //      |      |
    //       ------ p2
    // The background color is color(250);
    // You can use the mouse wheel to change the eraser range.
    
    
    //Utilize the function drawPoint(x, y, color) to apply color to the pixel at coordinates (x, y).
    //For instance: drawPoint(0, 0, color(255, 0, 0)); signifies drawing a red point at (0, 0). 
    //drawPoint(0,0,color(250));
    
    // calculate the boundary of the eraser
    float minX = min(p1.x, p2.x);
    float maxX = max(p1.x, p2.x);
    float minY = min(p1.y, p2.y);
    float maxY = max(p1.y, p2.y);

    // set up backgrond color
    int bgColor = color(250);

    // for all pixels in the eraser
    for (float x = minX; x <= maxX; x++) {
        for (float y = minY; y <= maxY; y++) {
            // draw the background color to the pixels
            drawPoint(x, y, bgColor);
        }
    }

    
 
}

public void drawPoint(float x,float y,color c){
    stroke(c);
    point(x,y);
}

public float distance(Vector3 a,Vector3 b){
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c,c));
}
