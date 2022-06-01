#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying vec3 vertNormal;
varying vec3 vertLightDir;
uniform vec3 u_light;

void main() {  
  float intensity;
  vec4 color;
  intensity = max(0.0, dot(vertLightDir, vertNormal));
  normalize(u_light);
  color = vec4(u_light.x, u_light.y, u_light.z, 1.0);

  gl_FragColor = color;
}