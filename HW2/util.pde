public void CGLine(float x1,float y1,float x2,float y2){
    //To-Do: Please paste your code from HW1 CGLine.
    
    
}
public boolean outOfBoundary(float x,float y){
    if(x < 0 || x >= width || y < 0 || y >= height) return true;
    return false;
}

public void drawPoint(float x,float y,color c){
    int index = (int)y * width + (int)x;
    if(outOfBoundary(x,y)) return;
    pixels[index] = c;
}

public float distance(Vector3 a,Vector3 b){
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c,c));
}



boolean pnpoly(float x, float y, Vector3[] vertexes) {
  // To-Do : You need to check the coordinate p(x,v) if inside the vertexes. If yes return true.
    boolean c = false;
    int n = vertexes.length;
    int j = n - 1;  // 初始化 j 為最後一個頂點的索引
    for (int i = 0; i < n; i++) {
        if (((vertexes[i].y > y) != (vertexes[j].y > y)) && (x < (vertexes[j].x - vertexes[i].x) * (y - vertexes[i].y) / (vertexes[j].y - vertexes[i].y) + vertexes[i].x)) {
            c = !c;
        }
        j = i;  // 將 j 設為當前頂點的索引，以便下次迭代時使用
    }
    return c;
}

public Vector3[] findBoundBox(Vector3[] v) {
    Vector3 recordminV=new Vector3(1.0/0.0);
    Vector3 recordmaxV=new Vector3(-1.0/0.0);
    // To-Do : You need to find the bounding box of the vertexes v.
    
   //     r1 -------
   //       |   /\  |
   //       |  /  \ |
   //       | /____\|
   //        ------- r2
        // 初始化最小和最大頂點
    // 遍歷所有頂點，更新最小和最大頂點
    for (Vector3 vertex : v) {
        // 更新最小頂點
        recordMinV.x = Math.min(recordMinV.x, vertex.x);
        recordMinV.y = Math.min(recordMinV.y, vertex.y);
        recordMinV.z = Math.min(recordMinV.z, vertex.z);

        // 更新最大頂點
        recordMaxV.x = Math.max(recordMaxV.x, vertex.x);
        recordMaxV.y = Math.max(recordMaxV.y, vertex.y);
        recordMaxV.z = Math.max(recordMaxV.z, vertex.z);
    }

    // 返回box的最小和最大頂點
    Vector3[] result = {recordMinV, recordMaxV};
    return result;
}

public static boolean isInside(Vector3 A, Vector3 B, Vector3 P) {
    // 計算向量 (B - A) 和 (P - A) 的外積
    Vector3 BA = Vector3.sub(B, A);
    Vector3 PA = Vector3.sub(P, A);
    Vector3 crossProduct = Vector3.cross(BA, PA);

    // 如果外積的 Z 分量是非正的，則點 P 在內部
    return crossProduct.z() <= 0;
}

public static Vector3 intersect(Vector3 A, Vector3 B, Vector3 P, Vector3 Q) {
    // 線 AB 表示為 a1x + b1y = c1
    float a1 = B.y() - A.y();
    float b1 = A.x() - B.x();
    float c1 = a1 * A.x() + b1 * A.y();

    // 線 PQ 表示為 a2x + b2y = c2
    float a2 = Q.y() - P.y();
    float b2 = P.x() - Q.x();
    float c2 = a2 * P.x() + b2 * P.y();

    float determinant = a1 * b2 - a2 * b1;

    if (determinant == 0) {
        // 線條平行，無交點
        return null;
    } else {
        float x = (b2 * c1 - b1 * c2) / determinant;
        float y = (a1 * c2 - a2 * c1) / determinant;
        return new Vector3(x, y, 0); 
    }
}

public static Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<>();
    ArrayList<Vector3> output = new ArrayList<>();

    // 將多邊形的點加入 input 
    for (Vector3 point : points) {
        input.add(point);
    }

    // 對每條邊界邊進行迭代
    for (int i = 0; i < boundary.length; i++) {
        int len = input.size();
        if (len == 0) break; // 如果沒有點則中斷

        Vector3 A = boundary[i];
        Vector3 B = boundary[(i + 1) % boundary.length];

        output.clear(); // 清空輸出列表以準備下一次迭代

        // 對多邊形的每個邊進行迭代
        for (int j = 0; j < len; j++) {
            Vector3 P = input.get(j);
            Vector3 Q = input.get((j + 1) % len);

            // 檢查點 Q 是否在邊界內
            if (isInside(A, B, Q)) {
                // 如果 P 在邊界外，則添加 P 和 Q 的交點
                if (!isInside(A, B, P)) {
                    output.add(intersect(A, B, P, Q));
                }
                // 添加點 Q
                output.add(Q);
            } 
            // 如果 P 在邊界內，但 Q 不在，則添加 P 和 Q 的交點
            else if (isInside(A, B, P)) {
                output.add(intersect(A, B, P, Q));
            }
        }

        // 將輸出賦值給 input 以進行下一次裁剪
        input = new ArrayList<>(output);
    }

    // 將輸出列表轉換為陣列
    Vector3[] result = new Vector3[output.size()];
    for (int i = 0; i < result.length; i++) {
        result[i] = output.get(i);
    }

    return result;
}

