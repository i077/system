self: super:

{
  vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
}
