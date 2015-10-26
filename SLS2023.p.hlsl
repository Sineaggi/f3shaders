float4 AmbientColor : register(c1);
float4 PSLightColor[10] : register(c3);
float4 Toggles : register(c27);

sampler2D BaseMap : register(s0);
sampler2D NormalMap : register(s1);

float4 main (
  float2 uv : TEXCOORD0,
  float3 color0 : COLOR0,
  float color1 : COLOR1,
  float tex1 : TEXCOORD1_centroid,
  float3 tex3 : TEXCOORD3_centroid
) : COLOR0 {
  int4 c0 = {0, 1, 0, 0};
  float4 c2 = {-0.5, 0.200000003, 0.5, -1};

  float4 basemap = tex2D(BaseMap, uv);
  float4 normalmap = tex2D(NormalMap, uv);

  float alpha = basemap.w * AmbientColor.w;

  if ((AmbientColor.w - 1) < 0)
    clip(basemap.w - Toggles.w);

  float3 basecolor = basemap;

  if (-Toggles.x >= 0) {
    // do nothing
  } else {
    basecolor = basecolor * color0; // fog?
  }

  return float4(fog, alpha);
}
