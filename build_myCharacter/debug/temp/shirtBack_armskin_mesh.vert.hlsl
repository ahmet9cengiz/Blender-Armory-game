uniform float4 skinBones[38];
uniform float texUnpack;
uniform float posUnpack;
uniform float3x3 N;
uniform float4x4 WVP;

static float4 gl_Position;
static float4 pos;
static float2 texCoord;
static float2 tex;
static float4 bone;
static float4 weight;
static float3 wnormal;
static float2 nor;

struct SPIRV_Cross_Input
{
    float4 bone : TEXCOORD0;
    float2 nor : TEXCOORD1;
    float4 pos : TEXCOORD2;
    float2 tex : TEXCOORD3;
    float4 weight : TEXCOORD4;
};

struct SPIRV_Cross_Output
{
    float2 texCoord : TEXCOORD0;
    float3 wnormal : TEXCOORD1;
    float4 gl_Position : SV_Position;
};

void getSkinningDualQuat(int4 bone_1, inout float4 weight_1, inout float4 A, inout float4 B)
{
    int4 bonei = bone_1 * int4(2, 2, 2, 2);
    float4x4 matA = float4x4(float4(skinBones[bonei.x]), float4(skinBones[bonei.y]), float4(skinBones[bonei.z]), float4(skinBones[bonei.w]));
    float4x4 matB = float4x4(float4(skinBones[bonei.x + 1]), float4(skinBones[bonei.y + 1]), float4(skinBones[bonei.z + 1]), float4(skinBones[bonei.w + 1]));
    float3 _129 = weight_1.xyz * sign(mul(matA, matA[3])).xyz;
    weight_1 = float4(_129.x, _129.y, _129.z, weight_1.w);
    A = mul(weight_1, matA);
    B = mul(weight_1, matB);
    float invNormA = 1.0f / length(A);
    A *= invNormA;
    B *= invNormA;
}

void vert_main()
{
    float4 spos = float4(pos.xyz, 1.0f);
    texCoord = tex * texUnpack;
    float4 param = weight;
    float4 skinB;
    float4 param_2 = skinB;
    float4 param_1;
    getSkinningDualQuat(int4(bone * 32767.0f), param, param_1, param_2);
    float4 skinA = param_1;
    skinB = param_2;
    float3 _188 = spos.xyz * posUnpack;
    spos = float4(_188.x, _188.y, _188.z, spos.w);
    float3 _209 = spos.xyz + (cross(skinA.xyz, cross(skinA.xyz, spos.xyz) + (spos.xyz * skinA.w)) * 2.0f);
    spos = float4(_209.x, _209.y, _209.z, spos.w);
    float3 _232 = spos.xyz + ((((skinB.xyz * skinA.w) - (skinA.xyz * skinB.w)) + cross(skinA.xyz, skinB.xyz)) * 2.0f);
    spos = float4(_232.x, _232.y, _232.z, spos.w);
    float3 _239 = spos.xyz / posUnpack.xxx;
    spos = float4(_239.x, _239.y, _239.z, spos.w);
    wnormal = normalize(mul(float3(nor, pos.w) + (cross(skinA.xyz, cross(skinA.xyz, float3(nor, pos.w)) + (float3(nor, pos.w) * skinA.w)) * 2.0f), N));
    gl_Position = mul(spos, WVP);
    gl_Position.z = (gl_Position.z + gl_Position.w) * 0.5;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    pos = stage_input.pos;
    tex = stage_input.tex;
    bone = stage_input.bone;
    weight = stage_input.weight;
    nor = stage_input.nor;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.texCoord = texCoord;
    stage_output.wnormal = wnormal;
    return stage_output;
}
