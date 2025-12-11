{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle,
  jdk21,
  # wrapGAppsHook4,
  copyDesktopItems,
  makeDesktopItem,
  writeScript,
}:
let
  version = "2025.11.17.beta-0115";
  pname = "eliteintel";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-${version}";

  src = fetchFromGitHub {
    owner = "stone-alex";
    repo = "EliteIntel";
    tag = "v${version}";
    hash = "sha256-PHqNpcBclIZrLRIp3IU/YjQDezI/Ah9TmepHg64ylwE=";
  };

  nativeBuildInputs = [
    gradle
    # wrapGAppsHook4
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  # gradleFlags = [
  #   "-Dorg.gradle.java.home=${jdk21}"
  #   "--stacktrace"
  # ];

  # gradleBuildTask = "application:jpackage";

  installPhase = ''
    runHook preInstall

    ls . > $out/jpackage-files.txt
    mkdir -p $out/{share/eliteintel,bin}
    # cp -r application/build/jpackage/Elite\ Dangerous\ Odyssey\ Materials\ Helper/* $out/share/eliteintel

    mkdir -p $out/share/icons/hicolor/512x512/apps/
    # ln -s $out/share/eliteintel/lib/Elite\ Dangerous\ Odyssey\ Materials\ Helper.png $out/share/icons/hicolor/512x512/apps/eliteintel.png

    runHook postInstall
  '';

  # dontWrapGApps = true;

  desktopItems = [
    (makeDesktopItem {
      name = "eliteintel";
      type = "Application";
      desktopName = "EliteIntel";
      comment = "Helper for managing materials in Elite Dangerous Odyssey";
      icon = "ed-odyssey-materials-helper";
      exec = "ed-odyssey-materials-helper %u";
      categories = [ "Game" ];
      mimeTypes = [ "x-scheme-handler/edomh" ];
    })
  ];

  passthru.updateScript = writeScript "update-eliteintel" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p nix-update

    nix-update eliteintel --version=unstable # update version and hash
    `nix-build --no-out-link -A eliteintel.mitmCache.updateScript` # update deps.json
  '';

  meta = {
    description = "TOS compliant AI co-pilot and data analyst for Elite Dangerous ";
    homepage = "https://github.com/stone-alex/EliteIntel";
    downloadPage = "https://github.com/stone-alex/EliteIntel/releases/tag/v${version}";
    changelog = "https://github.com/stone-alex/EliteIntel/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    maintainers = with lib.maintainers; [
      toasteruwu
    ];
    mainProgram = "eliteintel";
    platforms = lib.platforms.linux;
  };
}
