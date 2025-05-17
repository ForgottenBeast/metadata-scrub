{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  # You also have access to your flake's inputs.

  # The namespace used for your flake, defaulting to "internal" if not set.

  # All other arguments come from NixPkgs. You can use `pkgs` to pull packages or helpers
  # programmatically or you may add the named attributes as arguments here.
  pkgs,
  lib,
  ...
}:

pkgs.resholve.writeScriptBin "metadata-scrub" {
  inputs = with pkgs; [
    exiftool
    toybox
  ];
  execer = [
    "cannot:${pkgs.exiftool}/bin/exiftool"
  ];
  interpreter = "${pkgs.bash}/bin/bash";
} (builtins.readFile (lib.snowfall.fs.get-snowfall-file "/metadata-scrub.sh"))
