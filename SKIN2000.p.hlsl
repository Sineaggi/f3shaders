float4 AmbientColor : register(c1);
float4 PSLightColor[10] : register(c3);
float4 Toggles : register(c27);

sampler2D BaseMap : register(s0);
sampler2D NormalMap : register(s1);
sampler2D FaceGenMap0 : register(s2);
sampler2D FaceGenMap1 : register(s3);

sampler2D whatthefuk : register(s4);

// something v0

#define expand(v) (((v) - 0.5) / 0.5)
#define	sqr(v) ((v) * (v))
#define	shades(n, l) saturate(dot(n, l))

float4 main(
  float2 tex0 : TEXCOORD0, // Texture coordinates
  float3 tex6 : TEXCOORD6_centroid, // View direction?
  float3 base : COLOR0, // Base color
  float4 fog : COLOR1, // Fog color
  float3 tex1 : TEXCOORD1_centroid // Light direction?
  ) : COLOR0
{
  // Texture loading
  float4 basemap = tex2D(whatthefuk, tex0);
  float4 normalmap = tex2D(NormalMap, tex0);
  float4 facemap0 = tex2D(FaceGenMap0, tex0);
  float4 facemap1 = tex2D(FaceGenMap1, tex0);

  // Clip if channel has alpha
  if ((AmbientColor.w - 1) < 0)
    clip(basemap.w - Toggles.w);

  float3 basecolor = ((facemap1 + facemap1) * expand(facemap0) + basemap) * 2;

  if (Toggles.x > 0)
    // Not default
    basecolor = basecolor * base;

    float3 enormalmap = normalize((normalmap - 0.5f) * 2.0f);
    float abe = shades(enormalmap, tex6);
    float3 fplight = (shades(tex6, -tex1) * sqr(1 - abe) * PSLightColor[0]) / 2.0f;
    float3 ps_light = (PSLightColor[0] * shades(enormalmap, tex1)) + fplight;
    float3 light = max(ps_light + AmbientColor.xyz, 0);

  float3 finalcolor = light * basecolor;

  if (Toggles.y > 0)
    // Not default
    finalcolor = (fog.a * (fog.rgb - finalcolor)) + finalcolor;

  return float4(finalcolor, basemap.w * AmbientColor.w);
}
