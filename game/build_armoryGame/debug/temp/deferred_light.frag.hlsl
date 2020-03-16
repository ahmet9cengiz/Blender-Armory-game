Texture2D<float4> sltcMat;
SamplerState _sltcMat_sampler;
uniform float3 lightArea0;
uniform float3 lightArea1;
uniform float3 lightArea2;
uniform float3 lightArea3;
Texture2D<float4> sltcMag;
SamplerState _sltcMag_sampler;
uniform float4x4 LWVPSpot0;
Texture2D<float4> shadowMapSpot[1];
SamplerComparisonState _shadowMapSpot_sampler[1];
TextureCube<float4> shadowMapPoint[1];
SamplerComparisonState _shadowMapPoint_sampler[1];
uniform float2 lightProj;
uniform float4 shirr[7];
Texture2D<float4> gbuffer0;
SamplerState _gbuffer0_sampler;
Texture2D<float4> gbuffer1;
SamplerState _gbuffer1_sampler;
Texture2D<float4> gbufferD;
SamplerState _gbufferD_sampler;
uniform float3 eye;
uniform float3 eyeLook;
uniform float2 cameraProj;
uniform float3 backgroundCol;
uniform float envmapStrength;
Texture2D<float4> ssaotex;
SamplerState _ssaotex_sampler;
uniform float3 pointPos;
uniform float3 pointCol;
uniform float pointBias;
uniform float4 casData[20];

static float2 texCoord;
static float3 viewRay;
static float4 fragColor;

struct SPIRV_Cross_Input
{
    float2 texCoord : TEXCOORD0;
    float3 viewRay : TEXCOORD1;
};

struct SPIRV_Cross_Output
{
    float4 fragColor : SV_Target0;
};

static float3 L0;
static float3 L1;
static float3 L2;
static float3 L3;
static float3 L4;

float2 octahedronWrap(float2 v)
{
    return (1.0f.xx - abs(v.yx)) * float2((v.x >= 0.0f) ? 1.0f : (-1.0f), (v.y >= 0.0f) ? 1.0f : (-1.0f));
}

void unpackFloatInt16(float val, out float f, inout uint i)
{
    i = uint(int((val / 0.06250095367431640625f) + 1.525902189314365386962890625e-05f));
    f = clamp((((-0.06250095367431640625f) * float(i)) + val) / 0.06248569488525390625f, 0.0f, 1.0f);
}

float2 unpackFloat2(float f)
{
    return float2(floor(f) / 255.0f, frac(f));
}

float3 surfaceAlbedo(float3 baseColor, float metalness)
{
    return lerp(baseColor, 0.0f.xxx, metalness.xxx);
}

float3 surfaceF0(float3 baseColor, float metalness)
{
    return lerp(0.039999999105930328369140625f.xxx, baseColor, metalness.xxx);
}

float3 getPos(float3 eye_1, float3 eyeLook_1, float3 viewRay_1, float depth, float2 cameraProj_1)
{
    float linearDepth = cameraProj_1.y / (((depth * 0.5f) + 0.5f) - cameraProj_1.x);
    float viewZDist = dot(eyeLook_1, viewRay_1);
    float3 wposition = eye_1 + (viewRay_1 * (linearDepth / viewZDist));
    return wposition;
}

float3 shIrradiance(float3 nor)
{
    float3 cl00 = float3(shirr[0].x, shirr[0].y, shirr[0].z);
    float3 cl1m1 = float3(shirr[0].w, shirr[1].x, shirr[1].y);
    float3 cl10 = float3(shirr[1].z, shirr[1].w, shirr[2].x);
    float3 cl11 = float3(shirr[2].y, shirr[2].z, shirr[2].w);
    float3 cl2m2 = float3(shirr[3].x, shirr[3].y, shirr[3].z);
    float3 cl2m1 = float3(shirr[3].w, shirr[4].x, shirr[4].y);
    float3 cl20 = float3(shirr[4].z, shirr[4].w, shirr[5].x);
    float3 cl21 = float3(shirr[5].y, shirr[5].z, shirr[5].w);
    float3 cl22 = float3(shirr[6].x, shirr[6].y, shirr[6].z);
    return ((((((((((cl22 * 0.429042994976043701171875f) * ((nor.y * nor.y) - ((-nor.z) * (-nor.z)))) + (((cl20 * 0.743125021457672119140625f) * nor.x) * nor.x)) + (cl00 * 0.88622701168060302734375f)) - (cl20 * 0.2477079927921295166015625f)) + (((cl2m2 * 0.85808598995208740234375f) * nor.y) * (-nor.z))) + (((cl21 * 0.85808598995208740234375f) * nor.y) * nor.x)) + (((cl2m1 * 0.85808598995208740234375f) * (-nor.z)) * nor.x)) + ((cl11 * 1.02332794666290283203125f) * nor.y)) + ((cl1m1 * 1.02332794666290283203125f) * (-nor.z))) + ((cl10 * 1.02332794666290283203125f) * nor.x);
}

int clipQuadToHorizon()
{
    int n = 0;
    int config = 0;
    if (L0.z > 0.0f)
    {
        config++;
    }
    if (L1.z > 0.0f)
    {
        config += 2;
    }
    if (L2.z > 0.0f)
    {
        config += 4;
    }
    if (L3.z > 0.0f)
    {
        config += 8;
    }
    if (config == 0)
    {
    }
    else
    {
        if (config == 1)
        {
            n = 3;
            L1 = (L0 * (-L1.z)) + (L1 * L0.z);
            L2 = (L0 * (-L3.z)) + (L3 * L0.z);
        }
        else
        {
            if (config == 2)
            {
                n = 3;
                L0 = (L1 * (-L0.z)) + (L0 * L1.z);
                L2 = (L1 * (-L2.z)) + (L2 * L1.z);
            }
            else
            {
                if (config == 3)
                {
                    n = 4;
                    L2 = (L1 * (-L2.z)) + (L2 * L1.z);
                    L3 = (L0 * (-L3.z)) + (L3 * L0.z);
                }
                else
                {
                    if (config == 4)
                    {
                        n = 3;
                        L0 = (L2 * (-L3.z)) + (L3 * L2.z);
                        L1 = (L2 * (-L1.z)) + (L1 * L2.z);
                    }
                    else
                    {
                        if (config == 5)
                        {
                            n = 0;
                        }
                        else
                        {
                            if (config == 6)
                            {
                                n = 4;
                                L0 = (L1 * (-L0.z)) + (L0 * L1.z);
                                L3 = (L2 * (-L3.z)) + (L3 * L2.z);
                            }
                            else
                            {
                                if (config == 7)
                                {
                                    n = 5;
                                    L4 = (L0 * (-L3.z)) + (L3 * L0.z);
                                    L3 = (L2 * (-L3.z)) + (L3 * L2.z);
                                }
                                else
                                {
                                    if (config == 8)
                                    {
                                        n = 3;
                                        L0 = (L3 * (-L0.z)) + (L0 * L3.z);
                                        L1 = (L3 * (-L2.z)) + (L2 * L3.z);
                                        L2 = L3;
                                    }
                                    else
                                    {
                                        if (config == 9)
                                        {
                                            n = 4;
                                            L1 = (L0 * (-L1.z)) + (L1 * L0.z);
                                            L2 = (L3 * (-L2.z)) + (L2 * L3.z);
                                        }
                                        else
                                        {
                                            if (config == 10)
                                            {
                                                n = 0;
                                            }
                                            else
                                            {
                                                if (config == 11)
                                                {
                                                    n = 5;
                                                    L4 = L3;
                                                    L3 = (L3 * (-L2.z)) + (L2 * L3.z);
                                                    L2 = (L1 * (-L2.z)) + (L2 * L1.z);
                                                }
                                                else
                                                {
                                                    if (config == 12)
                                                    {
                                                        n = 4;
                                                        L1 = (L2 * (-L1.z)) + (L1 * L2.z);
                                                        L0 = (L3 * (-L0.z)) + (L0 * L3.z);
                                                    }
                                                    else
                                                    {
                                                        if (config == 13)
                                                        {
                                                            n = 5;
                                                            L4 = L3;
                                                            L3 = L2;
                                                            L2 = (L2 * (-L1.z)) + (L1 * L2.z);
                                                            L1 = (L0 * (-L1.z)) + (L1 * L0.z);
                                                        }
                                                        else
                                                        {
                                                            if (config == 14)
                                                            {
                                                                n = 5;
                                                                L4 = (L3 * (-L0.z)) + (L0 * L3.z);
                                                                L0 = (L1 * (-L0.z)) + (L0 * L1.z);
                                                            }
                                                            else
                                                            {
                                                                if (config == 15)
                                                                {
                                                                    n = 4;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (n == 3)
    {
        L3 = L0;
    }
    if (n == 4)
    {
        L4 = L0;
    }
    return n;
}

float integrateEdge(float3 v1, float3 v2)
{
    float cosTheta = dot(v1, v2);
    float theta = acos(cosTheta);
    float3 _496 = v1;
    float3 _497 = v2;
    float _502;
    if (theta > 0.001000000047497451305389404296875f)
    {
        _502 = theta / sin(theta);
    }
    else
    {
        _502 = 1.0f;
    }
    float res = cross(_496, _497).z * _502;
    return res;
}

float ltcEvaluate(float3 N, float3 V, float dotNV, float3 P, inout float3x3 Minv, float3 points0, float3 points1, float3 points2, float3 points3)
{
    float3 T1 = normalize(V - (N * dotNV));
    float3 T2 = cross(N, T1);
    Minv = mul(transpose(float3x3(float3(T1), float3(T2), float3(N))), Minv);
    L0 = mul(points0 - P, Minv);
    L1 = mul(points1 - P, Minv);
    L2 = mul(points2 - P, Minv);
    L3 = mul(points3 - P, Minv);
    L4 = 0.0f.xxx;
    int _955 = clipQuadToHorizon();
    int n = _955;
    if (n == 0)
    {
        return 0.0f;
    }
    L0 = normalize(L0);
    L1 = normalize(L1);
    L2 = normalize(L2);
    L3 = normalize(L3);
    L4 = normalize(L4);
    float sum = 0.0f;
    float3 param = L0;
    float3 param_1 = L1;
    sum += integrateEdge(param, param_1);
    float3 param_2 = L1;
    float3 param_3 = L2;
    sum += integrateEdge(param_2, param_3);
    float3 param_4 = L2;
    float3 param_5 = L3;
    sum += integrateEdge(param_4, param_5);
    if (n >= 4)
    {
        float3 param_6 = L3;
        float3 param_7 = L4;
        sum += integrateEdge(param_6, param_7);
    }
    if (n == 5)
    {
        float3 param_8 = L4;
        float3 param_9 = L0;
        sum += integrateEdge(param_8, param_9);
    }
    return max(0.0f, -sum);
}

float attenuate(float dist)
{
    return 1.0f / (dist * dist);
}

float PCF(Texture2D<float4> shadowMap, SamplerComparisonState _shadowMap_sampler, float2 uv, float compare, float2 smSize)
{
    float3 _206 = float3(uv + ((-1.0f).xx / smSize), compare);
    float result = shadowMap.SampleCmp(_shadowMap_sampler, _206.xy, _206.z);
    float3 _215 = float3(uv + (float2(-1.0f, 0.0f) / smSize), compare);
    result += shadowMap.SampleCmp(_shadowMap_sampler, _215.xy, _215.z);
    float3 _226 = float3(uv + (float2(-1.0f, 1.0f) / smSize), compare);
    result += shadowMap.SampleCmp(_shadowMap_sampler, _226.xy, _226.z);
    float3 _237 = float3(uv + (float2(0.0f, -1.0f) / smSize), compare);
    result += shadowMap.SampleCmp(_shadowMap_sampler, _237.xy, _237.z);
    float3 _245 = float3(uv, compare);
    result += shadowMap.SampleCmp(_shadowMap_sampler, _245.xy, _245.z);
    float3 _256 = float3(uv + (float2(0.0f, 1.0f) / smSize), compare);
    result += shadowMap.SampleCmp(_shadowMap_sampler, _256.xy, _256.z);
    float3 _267 = float3(uv + (float2(1.0f, -1.0f) / smSize), compare);
    result += shadowMap.SampleCmp(_shadowMap_sampler, _267.xy, _267.z);
    float3 _278 = float3(uv + (float2(1.0f, 0.0f) / smSize), compare);
    result += shadowMap.SampleCmp(_shadowMap_sampler, _278.xy, _278.z);
    float3 _289 = float3(uv + (1.0f.xx / smSize), compare);
    result += shadowMap.SampleCmp(_shadowMap_sampler, _289.xy, _289.z);
    return result / 9.0f;
}

float shadowTest(Texture2D<float4> shadowMap, SamplerComparisonState _shadowMap_sampler, float3 lPos, float shadowsBias)
{
    bool _458 = lPos.x < 0.0f;
    bool _464;
    if (!_458)
    {
        _464 = lPos.y < 0.0f;
    }
    else
    {
        _464 = _458;
    }
    bool _470;
    if (!_464)
    {
        _470 = lPos.x > 1.0f;
    }
    else
    {
        _470 = _464;
    }
    bool _476;
    if (!_470)
    {
        _476 = lPos.y > 1.0f;
    }
    else
    {
        _476 = _470;
    }
    if (_476)
    {
        return 1.0f;
    }
    return PCF(shadowMap, _shadowMap_sampler, lPos.xy, lPos.z - shadowsBias, 1024.0f.xx);
}

float3 sampleLight(float3 p, float3 n, float3 v, float dotNV, float3 lp, float3 lightCol, float3 albedo, float rough, float spec, float3 f0, int index, float bias)
{
    float3 ld = lp - p;
    float3 l = normalize(ld);
    float3 h = normalize(v + l);
    float dotNH = dot(n, h);
    float dotVH = dot(v, h);
    float dotNL = dot(n, l);
    float theta = acos(dotNV);
    float2 tuv = float2(rough, theta / 1.57079637050628662109375f);
    tuv = (tuv * 0.984375f) + 0.0078125f.xx;
    float4 t = sltcMat.SampleLevel(_sltcMat_sampler, tuv, 0.0f);
    float3x3 invM = float3x3(float3(float3(1.0f, 0.0f, t.y)), float3(float3(0.0f, t.z, 0.0f)), float3(float3(t.w, 0.0f, t.x)));
    float3 param = n;
    float3 param_1 = v;
    float param_2 = dotNV;
    float3 param_3 = p;
    float3x3 param_4 = invM;
    float3 param_5 = lightArea0;
    float3 param_6 = lightArea1;
    float3 param_7 = lightArea2;
    float3 param_8 = lightArea3;
    float _1107 = ltcEvaluate(param, param_1, param_2, param_3, param_4, param_5, param_6, param_7, param_8);
    float ltcspec = _1107;
    ltcspec *= sltcMag.SampleLevel(_sltcMag_sampler, tuv, 0.0f).w;
    float3 param_9 = n;
    float3 param_10 = v;
    float param_11 = dotNV;
    float3 param_12 = p;
    float3x3 param_13 = float3x3(float3(1.0f, 0.0f, 0.0f), float3(0.0f, 1.0f, 0.0f), float3(0.0f, 0.0f, 1.0f));
    float3 param_14 = lightArea0;
    float3 param_15 = lightArea1;
    float3 param_16 = lightArea2;
    float3 param_17 = lightArea3;
    float _1133 = ltcEvaluate(param_9, param_10, param_11, param_12, param_13, param_14, param_15, param_16, param_17);
    float ltcdiff = _1133;
    float3 direct = (albedo * ltcdiff) + ((ltcspec * spec) * 0.0500000007450580596923828125f).xxx;
    direct *= attenuate(distance(p, lp));
    direct *= lightCol;
    float4 lPos = mul(float4(p + ((n * bias) * 10.0f), 1.0f), LWVPSpot0);
    direct *= shadowTest(shadowMapSpot[0], _shadowMapSpot_sampler[0], lPos.xyz / lPos.w.xxx, bias);
    return direct;
}

void frag_main()
{
    float4 g0 = gbuffer0.SampleLevel(_gbuffer0_sampler, texCoord, 0.0f);
    float3 n;
    n.z = (1.0f - abs(g0.x)) - abs(g0.y);
    float2 _1367;
    if (n.z >= 0.0f)
    {
        _1367 = g0.xy;
    }
    else
    {
        _1367 = octahedronWrap(g0.xy);
    }
    n = float3(_1367.x, _1367.y, n.z);
    n = normalize(n);
    float roughness = g0.z;
    float param;
    uint param_1;
    unpackFloatInt16(g0.w, param, param_1);
    float metallic = param;
    uint matid = param_1;
    float4 g1 = gbuffer1.SampleLevel(_gbuffer1_sampler, texCoord, 0.0f);
    float2 occspec = unpackFloat2(g1.w);
    float3 albedo = surfaceAlbedo(g1.xyz, metallic);
    float3 f0 = surfaceF0(g1.xyz, metallic);
    float depth = (gbufferD.SampleLevel(_gbufferD_sampler, texCoord, 0.0f).x * 2.0f) - 1.0f;
    float3 p = getPos(eye, eyeLook, normalize(viewRay), depth, cameraProj);
    float3 v = normalize(eye - p);
    float dotNV = max(dot(n, v), 0.0f);
    float3 envl = shIrradiance(n);
    envl *= albedo;
    envl += (backgroundCol * surfaceF0(g1.xyz, metallic));
    envl *= (envmapStrength * occspec.x);
    fragColor = float4(envl.x, envl.y, envl.z, fragColor.w);
    float3 _1478 = fragColor.xyz * ssaotex.SampleLevel(_ssaotex_sampler, texCoord, 0.0f).x;
    fragColor = float4(_1478.x, _1478.y, _1478.z, fragColor.w);
    int param_2 = 0;
    float param_3 = pointBias;
    float3 _1498 = sampleLight(p, n, v, dotNV, pointPos, pointCol, albedo, roughness, occspec.y, f0, param_2, param_3);
    float3 _1501 = fragColor.xyz + _1498;
    fragColor = float4(_1501.x, _1501.y, _1501.z, fragColor.w);
    fragColor.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    texCoord = stage_input.texCoord;
    viewRay = stage_input.viewRay;
    frag_main();
    SPIRV_Cross_Output stage_output;
    stage_output.fragColor = fragColor;
    return stage_output;
}
