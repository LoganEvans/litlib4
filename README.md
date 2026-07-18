<!-- FILENAME: README.md -->

# Litlib: A Lean4 Library of Scientific Literature

[![DOI](https://zenodo.org/badge/1206534238.svg)](https://doi.org/10.5281/zenodo.21432195)

**Litlib** is a strict, Lean4-based metadata and transcription framework for bridging the impossible formalization gap in modern mathematical physics.

In an ideal world, every new theoretical physics paper would be formalized from first principles. In reality, modern papers rely on decades of complex, unformalized literature. The standard workaround of scattering opaque `axiom` keywords throughout a codebase leads to logical explosions and untrackable assumptions.

Litlib addresses this by treating peer-reviewed papers as compartmentalized, auditable boundary classes. We transcribe published theorems into strict Lean4 typeclasses, allowing downstream researchers to assume them as axiomatic bedrock in a highly controlled, trackable manner.

## The Core Philosophy: Compartmentalized Axiomatics

Instead of asserting an axiom globally, Litlib encodes a paper's claim as a parameterized `class` (a signature). To use a theorem from the literature, your downstream code must explicitly request that class as a parameter.

```lean
@[litlib_track "Topological TMD Geometric Ratio Witness"]
theorem kinematicTmdRatio (pu : CGD.Axioms.PhysicalUniverse) :
  ∀ (matrixExp : Matrix (Fin 2) (Fin 2) ℂ → Matrix (Fin 2) (Fin 2) ℂ)
    [Litlib.Y2000.hall2000elementary.DerivativeExponential (Fin 2) matrixExp]
    (alpha L : ℝ),
    ...
```

By doing this:
1. The formalization break is highly visible.
2. The assumption is strictly scoped to the theorems that actually need it.
3. The `litlib_report` engine can automatically trace dependencies and generate formal verification appendices for your papers.

## The AI Elephant in the Room

We aggressively utilize AI to help transcribe physical literature into Lean4 signatures. However, physics literature is difficult to transcribe due to unstated boundary conditions. AI agents frequently fall into "Bullshit Exploits" (e.g., collapsing spacetime dimensions into trivial vector spaces, substituting complex tensor contractions with opaque dummy functions, or failing to enforce non-degeneracy).

**Expect transcriptions to contain flaws.**
Our methodology embraces this: as human reviewers (and better models) uncover these loopholes, we will patch the Litlib signatures to be more restrictive.

**This will break your downstream proofs.**
When a Litlib signature is patched to prevent a trivial mathematical exploit, your downstream derivation *should* break, forcing you to prove that your specific physical scenario satisfies the true, rigorous boundary conditions of the cited paper. It is the necessary price of doing business at the edge of theoretical physics.

## Getting Started

### 1. Installation
Litlib uses [Nix](https://nixos.org/download) to ensure a perfectly reproducible environment, avoiding Lean/Lake version mismatch hell.

```bash
# Enter the reproducible shell (downloads Lean4 and dependencies automatically)
nix develop

# Build the project
lake build
```

### 2. The Litlib Report Engine
Litlib comes with a powerful CLI tool that scans your codebase for `@[litlib_track]` and `Litlib.equation` macros.

```bash
# See all available filters and options
.lake/build/bin/litlib_report --help

# View a hierarchical dashboard of all tracked literature, theorems, and dependencies
.lake/build/bin/litlib_report --dashboard

# View a comprehensive signature dump of all theorems tagged with `@[litlib_track]`
.lake/build/bin/litlib_report --code-summary=litlib_track

# Generate a complete LaTeX integration package (code summary, .sty, and BibTeX)
.lake/build/bin/litlib_report --latex=path/to/latex/files/
```

## Local Usage

You do not need to upstream your transcriptions to a central master repository.

You can add `litlib4` as a dependency in your own Lake project, create a local `Litlib/` directory, and transcribe the specific papers you need for your current research. The `litlib_report` CLI will natively scan your local project and generate the BibTeX and LaTeX appendices specifically for your work.

## Conventions & Contributing

If you are writing or reviewing transcriptions, please review:
* `docs/conventions.md`: File structures, Lean4 Mathlib style rules, and PR guidelines.
* `docs/ai_transcription_prompt.md`: The system prompt detailing the "Sloppiness Exploits" you must actively defend against when formalizing physics.
