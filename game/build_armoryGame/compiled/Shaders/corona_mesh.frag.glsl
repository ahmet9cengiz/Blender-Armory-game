#version 450
#include "compiled.inc"
#include "std/gbuffer.glsl"
in vec2 texCoord;
in vec3 wnormal;
out vec4 fragColor[2];
uniform sampler2D ImageTexture_001;
uniform sampler2D ImageTexture_002;
void main() {
vec3 n = normalize(wnormal);
	vec4 ImageTexture_001_texread_store = texture(ImageTexture_001, texCoord.xy);
	ImageTexture_001_texread_store.rgb = pow(ImageTexture_001_texread_store.rgb, vec3(2.2));
	vec4 ImageTexture_002_texread_store = texture(ImageTexture_002, texCoord.xy);
	ImageTexture_002_texread_store.rgb = pow(ImageTexture_002_texread_store.rgb, vec3(2.2));
	vec3 basecol;
	float roughness;
	float metallic;
	float occlusion;
	float specular;
	vec3 ImageTexture_001_Color_res = ImageTexture_001_texread_store.rgb;
	n = ImageTexture_001_Color_res;
	vec3 ImageTexture_002_Color_res = ImageTexture_002_texread_store.rgb;
	basecol = ImageTexture_002_Color_res;
	roughness = 0.4000000059604645;
	metallic = 0.0;
	occlusion = 1.0;
	specular = 0.5;
	n /= (abs(n.x) + abs(n.y) + abs(n.z));
	n.xy = n.z >= 0.0 ? n.xy : octahedronWrap(n.xy);
	const uint matid = 0;
	fragColor[0] = vec4(n.xy, roughness, packFloatInt16(metallic, matid));
	fragColor[1] = vec4(basecol, packFloat2(occlusion, specular));
}
