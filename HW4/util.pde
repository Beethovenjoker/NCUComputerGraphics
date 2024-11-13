public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
}
public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int)y * width + (int)x;
    if (outOfBoundary(x, y)) return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}



boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // HW2
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
    // HW2
    // To-Do : You need to find the bounding box of the vertexes v.

    //     r1 -------
    //       |   /\  |
    //       |  /  \ |
    //       | /____\|
    //        ------- r2
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

public float getDepth(float x, float y, Vector3[] vertex ) {
    // To - Do (HW3)
    // You need to calculate the depth (z) in the triangle (vertex) based on the positions x and y. and return the z value;
    Vector3 A = vertex[0];
    Vector3 B = vertex[1];
    Vector3 C = vertex[2];

    // Compute vectors from point to vertices
    Vector3 ab = B.sub(A);
    Vector3 ac = C.sub(A);
    Vector3 n = Vector3.cross(ab, ac);

    // ax + by + cz + d = 0, n = (a, b, c)
    float d = -1 * Vector3.dot(n, A);

    float z = -(n.x * x + n.y * y + d) / n.z;    
    return z;
    return 0.0;
}

float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A=verts[0].homogenized();
    Vector3 B=verts[1].homogenized();
    Vector3 C=verts[2].homogenized();

    Vector4 AW = verts[0];
    Vector4 BW = verts[1];
    Vector4 CW = verts[2];

   
    // To - Do (HW4)
    // Calculate the barycentric coordinates of point P in the triangle verts using the barycentric coordinate system.
    // Please notice that you should use Perspective-Correct Interpolation otherwise you will get wrong answer.
    Vector3 v0 = Vector3.sub(B, A);
    Vector3 v1 = Vector3.sub(C, A);
    Vector3 v2 = Vector3.sub(P, A);

    float d00 = Vector3.dot(v0, v0);
    float d01 = Vector3.dot(v0, v1);
    float d11 = Vector3.dot(v1, v1);
    float d20 = Vector3.dot(v2, v0);
    float d21 = Vector3.dot(v2, v1);
    float denom = d00 * d11 - d01 * d01;

    // 透視正確插值
    float v = (d11 * d20 - d01 * d21) / denom;
    float w = (d00 * d21 - d01 * d20) / denom;
    float u = 1.0f - v - w;

    // 調整重心坐標以考慮頂點的w坐標
    u *= AW.w;
    v *= BW.w;
    w *= CW.w;
    float sum = u + v + w;
    u /= sum;
    v /= sum;
    w /= sum;

    float[] result = {u, v, w};
    return result;
    float[] result={0.0, 0.0, 0.0};

    return result;
}


Vector3 interpolation(float[] abg, Vector3[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

Vector4 interpolation(float[] abg, Vector4[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

float interpolation(float[] abg, float[] v) {
    return v[0]*abg[0] + v[1]*abg[1] + v[2]*abg[2];
}
