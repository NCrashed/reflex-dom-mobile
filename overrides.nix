# Here you can put overrides of dependencies
{ reflex-platform ? (import ./reflex-platform.nix {}), minimize ? false, ... }:
let
  pkgs = reflex-platform.nixpkgs;
  overrideCabal = pkgs.haskell.lib.overrideCabal;
  optimizeGhcjs = drv: overrideCabal drv (drv: { buildFlags = (drv.buildFlags or []) ++ ["--ghcjs-option=-O2 " "--ghcjs-option=-dedupe"]; });
  statics = ./app-front/statics;
  runClosureCompiler = drv: pkgs.haskell.lib.overrideCabal drv (drv: {
    postFixup = ''
      cd $out/bin/app-front.jsexe
      ${pkgs.closurecompiler}/bin/closure-compiler all.js --compilation_level=ADVANCED_OPTIMIZATIONS \
        --externs=all.js.externs \
        --externs=${statics}/js/runmain.js \
        --jscomp_off=duplicate \
        --jscomp_off=undefinedVars \
        --jscomp_off=externsValidation \
        > all.min.js
        ${pkgs.zopfli}/bin/zopfli -i1000 all.min.js
        '';
  });
in (self: super: let
  prodOverride = drv: if minimize then runClosureCompiler (optimizeGhcjs drv) else drv;
  isAndroid = self.ghc.stdenv.targetPlatform.libc == "bionic";
  androidOverride = drv: if isAndroid then overrideCabal drv (drv: {
    configureFlags = (drv.configureFlags or []) ++ ["-fandroid"];
  }) else drv;
  in {
    app-front = prodOverride (androidOverride super.app-front);
  }
)
