{
  description = "Flake for search.secshell.de";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    secshell.url = "github:secshellnet/nixos";
    search = {
      url = "github:NuschtOS/search";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs-unstable,
      secshell,
      search,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = (import nixpkgs-unstable) {
            inherit system;
          };
        in
        {
          packages = {
            default = search.packages.${system}.mkSearch {
              specialArgs.modulesPath = nixpkgs-unstable + "/nixos/modules";
              modules = [
                secshell.nixosModules.default
                {
                  _module.args = { inherit pkgs; };
                }
              ];
              title = "NixOS Modules Search";
              urlPrefix = "https://github.com/secshellnet/nixos/blob/main/";
            };
          };
        });
}
