public abstract class Material{
    Vector3 albedo = new Vector3(0.9,0.9,0.9);
    Shader shader;
    Material(){
        // In the Material, pass the relevant attribute variables and uniform variables you need. 
        // In the attribute variables, include relevant variables about vertices, 
        // and in the uniform, pass other necessary variables. 
        // Please note that a Material will be bound to the corresponding Shader.
    }    
    abstract Vector4[][] vertexShader(Triangle triangle,Matrix4 M);       
    abstract Vector4 fragmentShader(Vector3 position,Vector4[] varing);    
    void attachShader(Shader s){
        shader = s;
    }
}

public class DepthMaterial extends Material{
    DepthMaterial(){
        shader =  new Shader(new DepthVertexShader(), new DepthFragmentShader());
    }
    Vector4[][] vertexShader(Triangle triangle,Matrix4 M){
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector4[][] r = shader.vertex.main(new Object[]{position},new Object[]{MVP});
        return r;
    }
    
    Vector4 fragmentShader(Vector3 position,Vector4[] varing){
        return shader.fragment.main(new Object[]{position});
    }
}

public class PhongMaterial extends Material{
    Vector3 Ka = new Vector3(0.3,0.3,0.3);
    float Kd = 0.5;
    float Ks = 0.5;
    float m = 20;
    PhongMaterial(){
        shader = new Shader(new PhongVertexShader(),new PhongFragmentShader());
    }
    
    Vector4[][] vertexShader(Triangle triangle,Matrix4 M){
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector3[] normal = triangle.normal;
        Vector4[][] r = shader.vertex.main(new Object[]{position,normal},new Object[]{MVP,M});
        return r;
    }
    
    Vector4 fragmentShader(Vector3 position,Vector4[] varing){
        
        return shader.fragment.main(new Object[]{position,varing[0].xyz(),varing[1].xyz(),albedo,new Vector3(Kd,Ks,m)});
    }

}


public class FlatMaterial extends Material {
    Vector3 Ka = new Vector3(0.3,0.3,0.3);
    float Kd = 0.5;
    float Ks = 0.5;
    float m = 20;
    FlatMaterial(){
        shader = new Shader(new FlatVertexShader(),new FlatFragmentShader());
    }
    
    Vector4[][] vertexShader(Triangle triangle,Matrix4 M){
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector3[] normal = triangle.normal;
        Vector4[][] r = shader.vertex.main(new Object[]{position,normal},new Object[]{MVP,M});
        return r;
    }
    
    Vector4 fragmentShader(Vector3 position,Vector4[] varing){
        
        return shader.fragment.main(new Object[]{position,varing[0].xyz(),varing[1].xyz(),albedo,new Vector3(Kd,Ks,m)});
    }
}


public class FlatFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        // 世界位置的幾何中心
        Vector3 w_centroid = ((Vector3)varying[1]);
        // 面法線
        Vector3 faceNormal = ((Vector3)varying[2]);
        // 反照率
        Vector3 albedo = (Vector3) varying[3]; // 物體的反照率（Albedo）
        Vector3 kdksm = (Vector3) varying[4]; // 漫反射係數（Kd）、鏡面反射係數（Ks）、高光指數（m）
        Light light = basic_light; // 基本光源
        Camera cam = main_camera; // 主攝影機

        // 計算環境光
        Vector3 ambient = light.light_color.product(AMBIENT_LIGHT).product(albedo);

        // 計算漫反射光
        Vector3 lightDir = Vector3.sub(light.transform.position, w_centroid).unit_vector();
        float diff = Math.max(Vector3.dot(faceNormal, lightDir), 0.0f);
        Vector3 diffuse = light.light_color.mult(diff).product(albedo);

        // 合成最終顏色
        Vector3 finalColor = ambient.add(diffuse);

        return new Vector4(finalColor.x(), finalColor.y(), finalColor.z(), 1.0f);
    }
}

public enum MaterialEnum{
    DM,FM,GM,PM;
}
