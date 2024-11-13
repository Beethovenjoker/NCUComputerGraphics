import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

public Vector4 renderer_size;
static public float GH_FOV = 45.0f;
static public float GH_NEAR_MIN = 1e-3f;
static public float GH_NEAR_MAX = 1e-1f;
static public float GH_FAR = 1000.0f;

public boolean debug = true;

public float[] GH_DEPTH;
public PImage renderBuffer;

Engine engine;
Camera main_camera;
Vector3 cam_position;
Vector3 lookat;


void setup(){
   size(1000,600);
   renderer_size = new Vector4(20,50,520,550);
   cam_position = new Vector3(0,-5,-5);
   lookat = new Vector3(0,0,0);
   setDepthBuffer();   
   main_camera = new Camera();
   engine = new Engine(); 
     
}

void setDepthBuffer(){
    renderBuffer = new PImage(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y));
    GH_DEPTH = new float[int(renderer_size.z - renderer_size.x) * int(renderer_size.w - renderer_size.y)];
    for(int i = 0 ; i < GH_DEPTH.length;i++){
        GH_DEPTH[i] = 1.0;
        renderBuffer.pixels[i] = color(1.0*250);
    }
}

void draw(){
    background(255);
    
    engine.run();
    
}

String selectFile(){
    JFileChooser fileChooser = new JFileChooser();      
    fileChooser.setCurrentDirectory(new File("."));
    fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("Obj Files", "obj");
    fileChooser.setFileFilter(filter);

    int result = fileChooser.showOpenDialog(null);
    if (result == JFileChooser.APPROVE_OPTION) {
        String filePath = fileChooser.getSelectedFile().getAbsolutePath();
        return filePath;
    }
    return "";
}


float moveSpeed = 0.1f; // 定義移動速度
// 定義相機移動的邊界
float minX = -10.0f;  // 最小x位置
float maxX = 10.0f;   // 最大x位置
float minY = -10.0f;  // 最小y位置
float maxY = 10.0f;   // 最大y位置
float minZ = -10.0f;  // 最小z位置
float maxZ = 0f;   // 最大z位置
void cameraControl() {
    if (keyPressed) {
        if (key == 'w' || key == 'W') {
            // 向前移動
            if (cam_position.z + moveSpeed <= maxZ) {
                cam_position.z += moveSpeed;
            }
        }
        if (key == 's' || key == 'S') {
            // 向後移動
            if (cam_position.z - moveSpeed >= minZ) {
                cam_position.z -= moveSpeed;
            }
        }
        if (key == 'd' || key == 'D') {
            // 向右移動
            if (cam_position.x - moveSpeed >= minX) {
                cam_position.x -= moveSpeed;
            }
        }
        if (key == 'a' || key == 'A') {
            // 向左移動
            if (cam_position.x + moveSpeed <= maxX) {
                cam_position.x += moveSpeed;
            }
        }
        if (key == 'q' || key == 'Q') {
            // 向上移動
            if (cam_position.y + moveSpeed <= maxY) {
                cam_position.y += moveSpeed;
            }
        }
        if (key == 'e' || key == 'E') {
            // 向下移動
            if (cam_position.y - moveSpeed >= minY) {
                cam_position.y -= moveSpeed;
            }
        }
    }

     // 更新相機位置和朝向
     main_camera.setPositionOrientation(cam_position, lookat);
}   
