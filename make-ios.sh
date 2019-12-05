nix-build -o ios-result -A ios.app-front --arg config '{system="x86_64-darwin";}'
