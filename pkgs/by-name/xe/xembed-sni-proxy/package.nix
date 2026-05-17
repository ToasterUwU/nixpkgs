{
  rustPlatform,
  fetchFromGitea,
  libx11,
  libxcb,
  lib,
}:
rustPlatform.buildRustPackage (final: {
  pname = "xembed-sni-proxy";
  version = "0-unstable-2026-03-05";
  src = fetchFromGitea {
    domain = "somegit.dev";
    owner = "vikingowl";
    repo = "xembed-sni-proxy";
    rev = "4738e91179961d66b15b62dd387bd1b8cd130058";
    hash = "sha256-IYXH9pcAwQafSG/xuV79ZP9i4WMur8fMdIekARs+5o0=";
  };

  cargoHash = "sha256-YJdSMjyBa7BQI2CV0FjtZg6BOljgcKc6HctDBO1CgJM=";

  buildInputs = [
    libx11
    libxcb
  ];

  meta = {
    description = "A lightweight proxy that bridges legacy XEmbed system tray icons to the StatusNotifierItem (SNI) D-Bus protocol";
    homepage = "https://somegit.dev/vikingowl/xembed-sni-proxy";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ toasteruwu ];
    platforms = lib.platforms.linux;
    mainProgram = "xembed-sni-proxy";
  };
})
