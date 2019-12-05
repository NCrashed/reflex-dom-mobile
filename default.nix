{ minimize ? false }:
let
  reflex-platform = import ./reflex-platform.nix {
    nixpkgsOverlays = [
      (self: super: import ./nixpkgs-overlays/default.nix self super)
    ];
    config.android_sdk.accept_license = true;
  };
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
    runtimeSharedLibs = nixpkgs: [
      "${nixpkgs.secp256k1}/lib/libsecp256k1.so"
    ];
  };

  ios.app-front = {
    executableName = "app-front";
    bundleIdentifier = "org.example.appfront";
    bundleName = "Example iOS App";
  };
})
