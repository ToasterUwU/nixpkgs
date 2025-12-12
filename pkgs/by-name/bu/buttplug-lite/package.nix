{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  git,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  dbus,
  udev,
  openssl,
  stdenv,
  libX11,
  libGL,
  libxcb,
  libxkbcommon,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buttplug-lite";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "runtime-shady-backroom";
    repo = "buttplug-lite";
    tag = finalAttrs.version;
    hash = "sha256-Z7xf+507rTWWygPV4p0+Q3e2rFIVgn1Ktu/W1P0FOfw=";
  };

  nativeBuildInputs = [
    pkg-config
    git
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    dbus
    udev
  ];

  cargoHash = "sha256-XGfHJAlv1B+tFKhLqMWiUaVyCUnyuyVZmYz3wvwITQI=";

  desktopItems = [
    (makeDesktopItem {
      name = "buttplug-lite";
      exec = "buttplug-lite";
      desktopName = "Buttplug Lite";
      comment = "Simplified buttplug.io API for when JSON is infeasible";
    })
  ];

  postFixup = ''
    wrapProgram $out/bin/buttplug-lite \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            dbus
            udev
            openssl
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            wayland
          ]
        )
      }
  '';

  meta = {
    description = "Simplified buttplug.io API for when JSON is infeasible";
    homepage = "https://github.com/runtime-shady-backroom/buttplug-lite";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
})
