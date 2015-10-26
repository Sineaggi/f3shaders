float4 AmbientColor : register(c1);
float4 PSLightColor[10] : register(c3);
float4 Toggles : register(c27);

sampler2D BaseMap : register(s0);
sampler2D NormalMap : register(s1);

#define	expand(v)		(((v) - 0.5) / 0.5)
#define	compress(v)		(((v) * 0.5) + 0.5)
#define	uvtile(w)		(((w) * 0.04) - 0.02)
#define	shade(n, l)		max(dot(n, l), 0)
#define	shades(n, l)		saturate(dot(n, l))

#define PI 3.14159265;

float4 main (
  float2 uvs : TEXCOORD0,
  float3 vertex_color : COLOR0,
  float4 fog_color : COLOR1,
  float4 tex1 : TEXCOORD1_centroid, // light dir
  float3 tex3 : TEXCOORD3_centroid // eye light
) : COLOR0 {
  float4 basemap = tex2D(BaseMap, uvs);
  float4 normalmap = tex2D(NormalMap, uvs);

  if ((AmbientColor.w - 1) < 0)
    clip(basemap.w - Toggles.w);

  float3 basecolor = basemap.rgb;

  if (Toggles.x > 0) {
    basecolor = basecolor * vertex_color;
  }

  float alpha = basemap.w * AmbientColor.w;

  float3 ntex3 = normalize(tex3);

  float3 nnormal = normalize((normalmap.xyz - 0.5) * 2);

  float heh = shades(nnormal, ntex3);

  float hah = dot(nnormal, tex1.xyz); // I don't even know

  float powah = pow(heh, Toggles.z);

  float total_spec = powah * normalmap.w;

  float nope = saturate(hah + 0.5);

  float crep = nope * total_spec;

  float rep = 0.200000003 - hah;

  hah = saturate(hah);

  float3 mox = PSLightColor[0].xyz * hah + AmbientColor.xyz;

  float3 nech = max(mox, 0);

  if (rep >= 0) {
    total_spec = total_spec;
  } else {
    total_spec = crep;
  }

  float3 yech = total_spec * PSLightColor[0].xyz;

  yech = saturate(yech * tex1.w);

  float3 r0xyz = nech * basecolor + yech;

  float3 watlerp = lerp(r0xyz, fog_color.xyz, fog_color.w);

  float3 finalcolor;

  if (-Toggles.y >= 0) {
    finalcolor = r0xyz;
  } else {
    finalcolor = watlerp;
  }

  return float4(finalcolor, alpha);
}

float oren_nayer (
  float3 lightDirection,
  float3 viewDirection,
  float3 surfaceNormal,
  float roughness,
  float albedo
) {
  float LdotV = dot(lightDirection, viewDirection);
  float NdotL = dot(lightDirection, surfaceNormal);
  float NdotV = dot(surfaceNormal, viewDirection);

  float s = LdotV - NdotL * NdotV;
  float t = lerp(1.0, max(NdotL, NdotV), step(0.0, s));

  float sigma2 = roughness * roughness;
  float A = 1.0 + sigma2 * (albedo / (sigma2 + 0.13) + 0.5 / (sigma2 + 0.33));
  float B = 0.45 * sigma2 / (sigma2 + 0.09);

  return albedo * max(0.0, NdotL) * (A + B * s / t) / PI;
}
