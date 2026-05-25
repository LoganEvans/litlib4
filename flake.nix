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
            pkgs.elan # Replaces pkgs.lean4
            pkgs.zstd # Required for Mathlib cache decompression
          ];

          shellHook = ''
            # Force Elan to install toolchains locally in the repository
            export ELAN_HOME="$PWD/.elan"

            if [ ! -d ".lake/packages/mathlib" ]; then
              echo "======================================================="
              echo "🚀 Initializing litlib4 Lean environment..."
              echo "-> Running 'lake update' to fetch mathlib4..."
              lake update || true
              
              echo "-> Fetching Mathlib cache..."
              lake exe cache get || echo "⚠️ Cache fetch failed or incomplete."
              
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

          buildInputs = [ pkgs.git ];

          buildPhase = ''
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
