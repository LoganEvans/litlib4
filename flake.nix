{
  description = "litlib4: The standard library of scientific literature and physics axioms";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

        # ----------------------------------------------------------------------
        # DEV SHELL (For developing litlib4 itself)
        # ----------------------------------------------------------------------
        litlib-shell = pkgs.mkShell {
          buildInputs = [
            pkgs.git
            pkgs.lean4
          ];

          shellHook = ''
            export LAKE_NO_ELAN=1

            if [ ! -d ".lake/packages/mathlib" ]; then
              echo "======================================================="
              echo "🚀 Initializing litlib4 Nix Lean environment..."
              echo "-> Running 'lake update' to fetch mathlib4..."
              lake update || true
              echo "✅ Dependencies fetched! Run 'lake build'."
              echo "======================================================="
            fi
          '';
        };

        # ----------------------------------------------------------------------
        # NIX DERIVATION (For downstream projects to consume via /nix/store/)
        # ----------------------------------------------------------------------
        # This allows a downstream flake to depend on `inputs.litlib4.packages.${system}.default`
        # and add it to LEAN_PATH so Lean can see it without Lake fetching it.
        litlib-build = pkgs.stdenv.mkDerivation {
          pname = "litlib4";
          version = "0.1.0";
          src = ./.;

          buildInputs = [ pkgs.lean4 pkgs.git ];

          buildPhase = ''
            export LAKE_NO_ELAN=1
            # In a pure Nix build, we bypass Lake fetching and rely on LEAN_PATH
            # For now, this is a placeholder that exposes the source tree to the Nix store.
            # Downstream Lakefiles can reference this exact path via `require litlib4 from "path"`
          '';

          installPhase = ''
            mkdir -p $out
            cp -r * $out/
          '';
        };

      in
      {
        pkgs = pkgs;
        packages = {
          default = litlib-build;
        };
        devShells.default = litlib-shell;
        formatter = (pkgs: treefmtEval.config.build.wrapper) { };
      }
    );
}
