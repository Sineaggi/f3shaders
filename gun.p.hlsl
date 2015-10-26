float4 AmbientColor : register(c1);
float4 EmittanceColor : register(c2);
float4 PSLightColor[10] : register(c3);
float4 PSLightPosition[8] : register(c19);
float4 Toggles : register(c27);

sampler2D BaseMap : register(s0);
sampler2D NormalMap : register(s1);
sampler2D FaceGenMap0 : register(s2);
sampler2D FaceGenMap1 : register(s3);

float4 main(
  float3 tex2 : TEXCOORD2,
  float3 tex3 : TEXCOORD3,
  float3 tex4 : TEXCOORD4,
  float3 tex5 : TEXCOORD5,
  float3 tex6 : TEXCOORD6,
  float3 tex7 : TEXCOORD7,
  float2 tex0 : TEXCOORD0,
  float tex1 : TEXCOORD1,
  float3 color_0 : COLOR0,
  float color_1 : COLOR1
  ) : COLOR0 // correct
{
  float4 output = {0, 0, 0, 0};

  // Texture loading
  float4 basemap = tex2D(BaseMap, tex0);
  float4 normalmap = tex2D(NormalMap, tex0);

  // clip if channel has alpha or something's toggled
  clip(((AmbientColor.w - 1) < 0 ? 1 : 0) * (basemap.w - Toggles.w));


/*
  if (Toggles.x <= 0) {
    // Default
  } else {
    facemaps = noch;
  }
*/

  /*if (Toggles.y <= 0) {
    // Default
    output.xyz = either;
  } else {
    output.xyz = sergey;
  }*/
  return basemap + normalmap;
}
