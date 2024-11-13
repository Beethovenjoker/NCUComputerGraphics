public class PhongVertexShader extends VertexShader{
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];
        
        for(int i=0;i<gl_Position.length;i++){
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }
        
        Vector4[][] result = {gl_Position,w_position,w_normal};
        
        return result;
    }
}

public class PhongFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector3 position = (Vector3)varying[0];
        Vector3 w_position = (Vector3)varying[1];
        Vector3 w_normal = (Vector3)varying[2];
        Vector3 albedo = (Vector3) varying[3];
        Vector3 kdksm = (Vector3) varying[4];
        Light light = basic_light;
        Camera cam = main_camera;
        
        
        // To - Do (HW4)
        // In this section, we have passed in all the variables you need. 
        // Please use these variables to calculate the result of Phong shading 
        // for that point and return it to GameObject for rendering
        // 環境光計算
        Vector3 ambient = light.light_color.product(AMBIENT_LIGHT).product(albedo);

        // 漫反射光計算
        Vector3 lightDir = Vector3.sub(light.transform.position, w_position).unit_vector();
        float dotNL = Math.max(Vector3.dot(w_normal, lightDir), 0.0f);
        Vector3 diffuse = light.light_color.mult(kdksm.x()).mult(dotNL);

        // 表面顏色處理：反照率乘以環境光和漫反射光的結果
        Vector3 laId = albedo.product(ambient.add(diffuse));

        // 鏡面反射光計算
        Vector3 viewDir = Vector3.sub(cam.transform.position, w_position).unit_vector();
        Vector3 h = light.transform.position.add(cam.transform.position).unit_vector();
        float dotHN = (float)Math.pow(Math.max(Vector3.dot(h, w_normal.unit_vector()), 0.0), kdksm.z());
        Vector3 specular = light.light_color.mult(kdksm.y()).mult(dotHN);

        // 光照結果合成
        Vector3 illuminate = laId.add(specular);

        // 創建最終顏色向量
        Vector4 result = new Vector4(illuminate.x(), illuminate.y(), illuminate.z(), 1.0);

        // 返回包含最終顏色和 Alpha 值的 Vector4
        return result;
    }
}



public class FlatVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[])attribute[0]; // 取得頂點位置
        Matrix4 MVP = (Matrix4)uniform[0]; // 取得模型視圖投影矩陣
        Matrix4 M = (Matrix4)uniform[1];
        // 計算三角形的幾何中心
        Vector3 centroid = Vector3.add(aVertexPosition[0], aVertexPosition[1]).add(aVertexPosition[2]).dive(3.0f);
        // 轉換幾何中心到世界空間
        Vector3 w_centroid = M.mult(centroid.getVector4(1.0f)).xyz();
        // 計算三角形的面法線
        Vector3 v0 = Vector3.sub(aVertexPosition[1], aVertexPosition[0]);
        Vector3 v1 = Vector3.sub(aVertexPosition[2], aVertexPosition[0]);
        Vector3 faceNormal = Vector3.cross(v0, v1).unit_vector();
        // 將面法線轉換到世界空間
        Vector3 w_normal = M.mult(faceNormal.getVector4(0.0f)).xyz().unit_vector();

        // 轉換每個頂點位置到裁剪空間
        Vector4[] gl_Position = new Vector4[aVertexPosition.length];
        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0f));
        }

        // 將幾何中心和面法線傳遞給片段著色器
        Vector4[] centroids = new Vector4[]{w_centroid.getVector4(1.0f), w_centroid.getVector4(1.0f), w_centroid.getVector4(1.0f)};
        Vector4[] normals = new Vector4[]{w_normal.getVector4(0.0f), w_normal.getVector4(0.0f), w_normal.getVector4(0.0f)};

        Vector4[][] result = {gl_Position, centroids, normals};
        return result;
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



public class GroundVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[])attribute[0]; // 頂點位置
        Vector3[] aVertexNormal = (Vector3[])attribute[1]; // 頂點法線
        Matrix4 MVP = (Matrix4)uniform[0]; 
        Matrix4 M = (Matrix4)uniform[1]; 
        Vector3 Ka = (Vector3)uniform[2]; // 環境光系数
        float Kd = (Float)uniform[3]; // 漫反射系数
        Vector3 albedo = (Vector3)uniform[4]; // 反照率
        Light light = basic_light; // 基本光源

        Vector4[] gl_Position = new Vector4[aVertexPosition.length];
        Vector4[] colors = new Vector4[aVertexPosition.length];

        for (int i = 0; i < aVertexPosition.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            Vector3 worldPos = M.mult(aVertexPosition[i].getVector4(1.0)).xyz();
            Vector3 worldNormal = M.mult(aVertexNormal[i].getVector4(0.0)).xyz().unit_vector();

            // 光照計算
            Vector3 ambient = Ka.product(albedo);
            Vector3 lightDir = Vector3.sub(light.transform.position, worldPos).unit_vector();
            float diff = Math.max(Vector3.dot(worldNormal, lightDir), 0.0f);
            Vector3 diffuse = albedo.product(light.light_color).mult(diff * Kd);

            // 將環境光和漫反射光结合
            Vector3 totalLight = ambient.add(diffuse);
            colors[i] = totalLight.getVector4(1.0);
        }

        return new Vector4[][]{gl_Position, colors};
    }
}

public class GroundFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        // 直接使用頂點著色器計算後的光照颜色
        Vector4 interpolatedColor = (Vector4)varying[0];

        // 返回插值后的颜色
        return interpolatedColor;
    }
}
