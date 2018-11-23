# Development build of GHCJS version of frontend
cabal new-build exe:app-front
cp dist-newstyle/build/x86_64-linux/ghcjs-8.4.0.1/app-front-1.0.0.0/x/app-front/build/app-front/app-front.jsexe/all.js ./statics/js/all.js
