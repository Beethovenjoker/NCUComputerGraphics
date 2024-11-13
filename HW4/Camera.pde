public class Camera extends GameObject{
    Matrix4 projection=new Matrix4();
    Matrix4 worldView=new Matrix4();
    int wid;
    int hei;
    float near;
    float far;
    
    Camera() {
        wid=256;
        hei=256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform.position = new Vector3(0,15,-50);
        name = "Camera";
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }


    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        // To - Do (HW3)
        // This function takes four parameters, which are the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.
        float e = 1.0f / tan(GH_FOV * 2*PI / 360.0f);
        float a = float(h) / float(w);
        float d = near - far;

        // Creating the projection matrix for a perspective projection
        projection.makeZero(); // Resetting the projection matrix to zero
        projection.m[0] = 1;
        projection.m[5] = a;
        projection.m[10] = far / -d * (1/e);
        projection.m[11] = (near * far) / d * (1/e);
        projection.m[14] = 1/e;
        projection = Matrix4.Identity();

    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {
        worldView = Matrix4.RotX(rotX).mult(  Matrix4.RotY(rotY)).mult( Matrix4.Trans(pos.mult(-1)));
    }
    
    void setPositionOrientation() {
        worldView = Matrix4.RotX(transform.rotation.x).mult(  Matrix4.RotY(transform.rotation.y)).mult( Matrix4.Trans(transform.position.mult(-1)));
    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // To - Do (HW3)
        // This function takes two parameters, which are the position of the camera and the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.
        // T
        Matrix4 T = Matrix4.Trans(pos.mult(-1));

        // Calculate the forward vector (lookat - position)
        Vector3 forward = Vector3.sub(lookat, pos).unit_vector();

        // Define the up vector (world's up forward)
        Vector3 up = new Vector3(0, 1, 0);

        // Calculate the right vector (cross product of up and forward)
        Vector3 right = Vector3.cross(forward, up).unit_vector();

        // Calculate the real up vector (cross product of forward and right)
        up = Vector3.cross(right, forward).unit_vector();

        // GRM
        Matrix4 GRM = Matrix4.Identity();
        GRM.m[0] = right.x;   GRM.m[1] = right.y;   GRM.m[2] = right.z;
        GRM.m[4] = up.x;      GRM.m[5] = up.y;      GRM.m[6] = up.z;
        GRM.m[8] = forward.x; GRM.m[9] = forward.y; GRM.m[10] = forward.z;

        worldView = GRM.mult(T);
    }
}
