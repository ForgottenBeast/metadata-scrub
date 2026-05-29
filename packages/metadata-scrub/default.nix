{ pkgs, lib, ... }:

pkgs.resholve.writeScriptBin "metadata-scrub" {
  inputs = with pkgs; [
    exiftool
    toybox
    binutils
  ];
  execer = [
    "cannot:${pkgs.exiftool}/bin/exiftool"
    "cannot:${pkgs.binutils}/bin/strip"
  ];
  interpreter = "${pkgs.bash}/bin/bash";
} (builtins.readFile (lib.snowfall.fs.get-snowfall-file "/metadata-scrub.sh"))
