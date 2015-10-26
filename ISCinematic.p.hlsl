float4 Cinematic : register(c0);
float4 Tint : register(c1);
float4 Fade : register(c2);

sampler2D Src0 : register(s0);

float4 main2(float2 tc : TEXCOORD0) : COLOR0 {
  float3 c3 = float3(0.298999995, 0.587000012, 0.114); // def c3, 0.298999995, 0.587000012, 0.114, 0

  float4 Render = tex2D(Src0, tc);


  float val = dot(Render.xyz, c3); // dp3 r1.w, r0, c3
  float4 lep = lerp(val, Render, Cinematic.x); // lrp r2, c0.x, r0, r1.w
  // Add tint
  float4 lep2 = val * Tint - lep;
  float4 lep3 = Tint.w * lep2 + lep;
  // wat
  float4 lep4 = lerp(lep3, Fade, Tint.w);
  float4 lep5 = Cinematic.w * lep4 - Cinematic.y;
  float4 lep6 = Cinematic.z * lep5 + Cinematic.y;
  return lep6;
}

float4 main(float2 tc : TEXCOORD0) : COLOR0 {
  float3 c3 = float3(0.298999995, 0.587000012, 0.114); // def c3, 0.298999995, 0.587000012, 0.114, 0

  float4 Render = tex2D(Src0, tc);

  float val = Render.x * 0.298999995 + Render.y * 0.587000012 + Render.z * 0.114; //    dot(Render.xyz, c3); // dp3 r1.w, r0, c3
  float4 lep = lerp(val, Render, Cinematic.x); // lrp r2, c0.x, r0, r1.w
  // Add tint
  float4 lep2 = val * Tint - lep;
  float4 lep3 = Tint.w * lep2 + lep;
  // wat
  float4 lep4 = lerp(lep3, Fade, Tint.w);
  float4 lep5 = Cinematic.w * lep4 - Cinematic.y;
  float4 lep6 = Cinematic.z * lep5 + Cinematic.y;
  return lep6;
}
