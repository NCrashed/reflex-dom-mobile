{ minimize ? false }:
let
  reflex-platform = import ./reflex-platform.nix {};
in reflex-platform.project ({ pkgs, ... }: {
  packages = {
    app-front = ./app-front;
    app-shared = ./app-shared;
    app-back = ./app-back;
  };
  shells = {
    ghcjs = ["app-front" "app-shared"];
    ghc = ["app-back" "app-front" "app-shared"]; # We can build front by GHC to enable use of IDE tools for it
  };
  overrides = import ./overrides.nix { inherit reflex-platform minimize; };

  android.app-front = {
    executableName = "app-front";
    applicationId = "org.example.appfront";
    displayName = "Example Android App";
  };

  ios.app-front = {
    executableName = "app-front";
    bundleIdentifier = "org.example.appfront";
    bundleName = "Example iOS App";
  };
})
