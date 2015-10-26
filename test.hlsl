float4 main(
  float4 world_pos : TEXCOORD6
) : COLOR0 {
  float delta_world = length(fwidth(world_pos));
  return float4(delta_world, delta_world, delta_world, 1);
}
