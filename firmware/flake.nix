{
  description = "PicoQuake USB Vibration Sensor Build Environment with PlatformIO";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { 
          inherit system;
          config.allowUnfree = true;  # PlatformIO has some unfree components
        };
        
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            platformio
            
            python3
            python3Packages.pip
            python3Packages.virtualenv
            
            usbutils
          ];
        };
      }
    );
}
