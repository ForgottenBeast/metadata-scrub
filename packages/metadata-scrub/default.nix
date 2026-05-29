{ pkgs, lib, ... }:

pkgs.resholve.writeScriptBin "metadata-scrub" {
  inputs = with pkgs; [
    exiftool
    toybox
    file
    binutils
  ];
  execer = [
    "cannot:${pkgs.exiftool}/bin/exiftool"
    "cannot:${pkgs.file}/bin/file"
  ];
  interpreter = "${pkgs.bash}/bin/bash";
} (builtins.readFile (lib.snowfall.fs.get-snowfall-file "/metadata-scrub.sh"))
