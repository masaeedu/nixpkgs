{ lib, mkDerivation, fetchFromGitHub
, kcoreaddons, kwindowsystem, plasma-framework, systemsettings }:

mkDerivation rec {
  pname = "krohnkite";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "esjeon";
    repo = "krohnkite";
    rev = "v${version}";
    sha256 = "0gib39vvnpdynyfqfrkzri67dhr4lf3zpk3njw4zzkz97c8k6psq";
  };

  buildInputs = [
    kcoreaddons kwindowsystem plasma-framework systemsettings
  ];

  dontBuild = true;

  # 1. --global still installs to $HOME/.local/share so we use --packageroot
  # 2. plasmapkg2 doesn't copy metadata.desktop into place, so we do that manually
  installPhase = ''
    runHook preInstall

    plasmapkg2 --type kwinscript --install ${src}/res/ --packageroot $out/share/kwin/scripts
    install -Dm644 ${src}/res/metadata.desktop $out/share/kservices5/krohnkite.desktop

    runHook postInstalll
  '';

  meta = with lib; {
    description = "A dynamic tiling extension for KWin";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
    inherit (src.meta) homepage;
    inherit (kwindowsystem.meta) platforms;
  };
}
