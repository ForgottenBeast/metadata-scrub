{
  description = "static blog";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      alias = {
        packages.default = "metadata-scrub";
      };
      snowfall = {
        namespace = "metadata-scrub";
        meta = {
          name = "metadata-scrub";
          title = "image metadata scrubbing tool";
        };
      };
    };
}
