{
  description = "UDPP25-Integrations Development Environment";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?rev=ab7b6889ae9d484eed2876868209e33eb262511d";
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
      dotnetPkg = (with pkgs.dotnetCorePackages; combinePackages [
        sdk_8_0_3xx
        sdk_9_0
      ]);
      deps = [
        # pkgs.nodejs_20
        # pkgs.jq
        pkgs.curl

        pkgs.azure-cli
        pkgs.bicep
          pkgs.zlib # required by bicep
          pkgs.icu # required by bicep
          pkgs.openssl # required by bicep

        dotnetPkg
        (pkgs.vscode-with-extensions.override
          {
            vscodeExtensions = with pkgs.vscode-extensions; [
              jnoortheen.nix-ide
              streetsidesoftware.code-spell-checker

              # ms-dotnettools.vscode-dotnet-runtime
              ms-dotnettools.csharp
              ms-dotnettools.csdevkit

              github.copilot
              github.copilot-chat
            ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              # https://ms-vscode.gallery.vsassets.io/_apis/public/gallery/publisher/{publisher}/extension/{name}/{version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage
              # {
              #   name = "powerplatform-vscode";
              #   publisher = "microsoft-IsvExpTools";
              #   version = "2.0.76";
              #   sha256 = "18b0mcgrb665w6jqzwj5mqifix0sdz4xxl1ld3c38g30b64nbcwf";
              # }
              {
                name = "vscode-dotnet-runtime";
                publisher = "ms-dotnettools";
                version = "2.2.5";
                sha256 = "0c8hx1584ykc3r38d8a0vhnknkirf1wg7bfrjzj62714nc35qr5g";
              }
              {
                name = "vscode-bicep";
                publisher = "ms-azuretools";
                version = "0.33.93";
                sha256 = "05bfxqiqzv6zy6y84k5rja41xxbghywa7xp8m2wj1faf12syi7gy";
              }
            ];
          })
      ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "udpp25-integrations-development-environment";

        # requires nix-ld to be enabled
        # nix-ld allows unpatched dynamic binaries to run on NixOS
        NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath ([
          pkgs.stdenv.cc.cc
        ] ++ deps);
        NIX_LD = "${pkgs.stdenv.cc.libc_bin}/bin/ld.so";
        nativeBuildInputs = [
        ] ++ deps;

        shellHook = ''
          # set environment variables
          export DOTNET_ROOT="${dotnetPkg}/share/dotnet";

          # launch vscode
          code .
        '';
      };
    };
}
