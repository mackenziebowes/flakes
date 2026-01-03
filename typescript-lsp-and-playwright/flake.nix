{
  description = "A TypeScript + Playwright Dev Environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Standard Intel/AMD Linux
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_20
          typescript
          typescript-language-server
          # This provides the patched browser binaries Playwright needs
          playwright-driver.browsers
        ];

        shellHook = ''
          # 1. Tell Playwright where the Nix-native browsers live
          export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}

          # 2. Prevent Playwright from trying to download browsers on its own
          export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

          # 3. Optional: Skip host requirement validation if you hit library issues
          export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true

          echo "🎮 Playwright 'Gamer Move' Environment Loaded!"
          echo "Browsers are mapped to: $PLAYWRIGHT_BROWSERS_PATH"
        '';
      };
    };
}
