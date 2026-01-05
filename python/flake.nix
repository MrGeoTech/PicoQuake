{
  description = "PicoQuake USB vibration sensor library development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          # Build dependencies
          hatchling
          pip
          
          # Core dependencies
          pyserial
          protobuf
          cobs
          tomli
          
          # Optional dependencies (plot/test)
          numpy
          scipy
          matplotlib
          pytest
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
          ];

          shellHook = ''
            echo "PicoQuake development environment activated"
            echo "Python: $(python --version)"
            
            # Set up a local virtual environment for editable installs
            if [ ! -d .venv ]; then
              python -m venv .venv
            fi
            source .venv/bin/activate
            
            # Install the package in editable mode
            pip install -e . > /dev/null 2>&1 || true
          '';
        };
      }
    );
}
