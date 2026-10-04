-- FILENAME: Litlib/Y2011/krasnov2011plebanski/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

namespace Litlib.Y2011.krasnov2011plebanski

Litlib.paper "krasnov2011plebanski"
  type "article"
  title "Plebański formulation of general relativity: a practical introduction"
  authors ["Krasnov, Kirill"]
  journal "General Relativity and Gravitation"
  volume "43"
  issue "1"
  pages "1--15"
  year "2011"
  publisher "Springer"
  doi "10.1007/s10714-010-1061-x"

Litlib.equation "krasnov2011plebanski"
  eq "1"
  page "3"
  kind "definition"
/--
Physical Interpretation: Defines the Hodge dual operator acting on bivectors (antisymmetric
rank-two tensors) in a 4-dimensional semi-Riemannian manifold.
Mathematical Boundaries: Enforces 4D spacetime indices (`Fin 4`), contraction over the upper
indices of the Levi-Civita volume tensor density, and a factor of `1/2` preventing
double-counting of antisymmetrized pairs.
-/
class Eq1
    (epsilonUpDown : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (hodgeDual : (Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ)) : Prop where
  hodgeDualDef : ∀ (A : Fin 4 → Fin 4 → ℝ) (mu nu : Fin 4),
    hodgeDual A mu nu =
      (1 / 2 : ℝ) * ∑ rho : Fin 4, ∑ sigma : Fin 4,
        epsilonUpDown mu nu rho sigma * A rho sigma

Litlib.equation "krasnov2011plebanski"
  eq "2"
  page "3"
  kind "definition"
/--
Physical Interpretation: Defines the left and right Hodge duals of the Riemann curvature tensor.
The left dual acts on the first pair of bivector indices, while the right dual acts on the
second pair of bivector indices.
Mathematical Boundaries: Explicitly indexes 4D spacetime tensors, contracting with the
Levi-Civita volume tensor density with proper normalization.
-/
class Eq2
    (epsilonUpDown : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (leftHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (rightHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)) : Prop where
  leftHodgeDef : ∀ R mu nu rho sigma,
    leftHodge R mu nu rho sigma =
      (1 / 2 : ℝ) * ∑ alpha : Fin 4, ∑ beta : Fin 4,
        epsilonUpDown mu nu alpha beta * R alpha beta rho sigma
  rightHodgeDef : ∀ R mu nu rho sigma,
    rightHodge R mu nu rho sigma =
      (1 / 2 : ℝ) * ∑ alpha : Fin 4, ∑ beta : Fin 4,
        R mu nu alpha beta * epsilonUpDown rho sigma alpha beta

Litlib.equation "krasnov2011plebanski"
  eq "3"
  page "3"
  kind "theorem"
/--
Physical Interpretation: Reformulates the Einstein vacuum field equations using the Hodge
duality operator on the Riemann curvature tensor. A metric is an Einstein metric (its Ricci tensor
is proportional to the metric) if and only if the left and right Hodge duals of the Riemann
tensor coincide.
Mathematical Boundaries: Metric invertibility (`gInv`) prevents topological collapse and rules out
degenerate metrics. The curvature tensor `R` must be antisymmetric in its index pairs and satisfy
the first algebraic Bianchi identity.
-/
class Eq3
    (g : Fin 4 → Fin 4 → ℝ)
    (gInv : Fin 4 → Fin 4 → ℝ)
    (gIsInv : ∀ mu nu, (∑ alpha : Fin 4, g mu alpha * gInv alpha nu) = if mu = nu then 1 else 0)
    (leftHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (rightHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (ricciTensor : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ)) : Prop where
  ricciTensorDef : ∀ R mu nu,
    ricciTensor R mu nu = ∑ rho : Fin 4, ∑ sigma : Fin 4, gInv rho sigma * R rho mu sigma nu
  einsteinConditionIff : ∀ (R : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ),
    (∀ mu nu rho sigma, R mu nu rho sigma + R mu rho sigma nu + R mu sigma nu rho = 0) →
    (∀ mu nu rho sigma, R mu nu rho sigma = - R nu mu rho sigma) →
    (∀ mu nu rho sigma, R mu nu rho sigma = - R mu nu sigma rho) →
    ((∃ (c : ℝ), ∀ mu nu, ricciTensor R mu nu = c * g mu nu) ↔
     (∀ mu nu rho sigma, leftHodge R mu nu rho sigma = rightHodge R mu nu rho sigma))

Litlib.equation "krasnov2011plebanski"
  eq "4"
  page "4"
  kind "definition"
/--
Physical Interpretation: Defines self-dual and anti-self-dual bivectors as the eigenspaces of the
Hodge star operator with eigenvalues `i` and `-i` respectively.
Mathematical Boundaries: Applies to complex-valued 2-forms over the 4-dimensional spacetime.
The imaginary eigenvalues reflect the Lorentzian metric signature condition `*² = -1` on 2-forms.
-/
class Eq4
    (hodgeStar : (Fin 4 → Fin 4 → ℂ) → (Fin 4 → Fin 4 → ℂ))
    (isSelfDual : (Fin 4 → Fin 4 → ℂ) → Prop)
    (isAntiSelfDual : (Fin 4 → Fin 4 → ℂ) → Prop) : Prop where
  selfDualIff : ∀ (A : Fin 4 → Fin 4 → ℂ),
    isSelfDual A ↔ (∀ mu nu, hodgeStar A mu nu = Complex.I * A mu nu)
  antiSelfDualIff : ∀ (A : Fin 4 → Fin 4 → ℂ),
    isAntiSelfDual A ↔ (∀ mu nu, hodgeStar A mu nu = -(Complex.I * A mu nu))

Litlib.equation "krasnov2011plebanski"
  eq "6"
  page "4"
  kind "definition"
/--
Physical Interpretation: The identity operator in the linear space of bivectors, defined as
the antisymmetrized product of Kronecker delta tensors.
Mathematical Boundaries: Explicitly operates on rank-2 antisymmetric tensors in 4 dimensions.
-/
class Eq6
    (delta : Fin 4 → Fin 4 → ℝ)
    (identityBivector : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) : Prop where
  identityDef : ∀ mu nu rho sigma,
    identityBivector mu nu rho sigma =
      (1 / 2 : ℝ) * (delta mu rho * delta nu sigma - delta mu sigma * delta nu rho)

Litlib.equation "krasnov2011plebanski"
  eq "5"
  page "4"
  kind "definition"
/--
Physical Interpretation: The Atiyah-Hitchin-Singer projectors `P±` onto the spaces of self-dual
and anti-self-dual bivectors.
Mathematical Boundaries: Explicitly constructs the chiral projection operators from the bivector
identity operator and the Levi-Civita volume tensor.
-/
class Eq5
    (identityBivector : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (epsilonUpDown : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (pPlus : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (pMinus : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) : Prop where
  pPlusDef : ∀ mu nu rho sigma,
    pPlus mu nu rho sigma =
      (1 / 2 : ℂ) * ((identityBivector mu nu rho sigma : ℂ) +
        (1 / (2 * Complex.I)) * (epsilonUpDown mu nu rho sigma : ℂ))
  pMinusDef : ∀ mu nu rho sigma,
    pMinus mu nu rho sigma =
      (1 / 2 : ℂ) * ((identityBivector mu nu rho sigma : ℂ) -
        (1 / (2 * Complex.I)) * (epsilonUpDown mu nu rho sigma : ℂ))

Litlib.equation "krasnov2011plebanski"
  eq "7"
  page "4"
  kind "theorem"
/--
Physical Interpretation: The Atiyah-Hitchin-Singer theorem applied to General Relativity.
Vacuum Einstein conditions are mathematically identical to the vanishing of the mixed
anti-self-dual / self-dual projection of the Riemann curvature tensor: `P⁻ R P⁺ = 0`.
Mathematical Boundaries: Fully contracts over all four 4-dimensional internal indices.
-/
class Eq7
    (g : Fin 4 → Fin 4 → ℝ)
    (ricci : Fin 4 → Fin 4 → ℝ)
    (rCurv : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (pPlus pMinus : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ) : Prop where
  einsteinConditionIff :
    (∃ (c : ℝ), ∀ mu nu, ricci mu nu = c * g mu nu) ↔
    (∀ mu nu rho sigma,
      ∑ alpha : Fin 4, ∑ beta : Fin 4, ∑ gamma : Fin 4, ∑ delta_ : Fin 4,
        pMinus mu nu alpha beta * rCurv alpha beta gamma delta_ * pPlus gamma delta_ rho sigma = 0)

Litlib.equation "krasnov2011plebanski"
  eq "8_11"
  page "5"
  kind "definition"
/--
Physical Interpretation: Constructs the self-dual (`sigma`) and anti-self-dual (`sigmaBar`)
2-form bases from the spacetime tetrad 1-forms `theta0` and `thetaSpat`.
Mathematical Boundaries: Expands the exterior wedge product of tetrad 1-forms into explicit
spacetime components, preventing the Opaque Function Exploit.
-/
class Eq8_11
    (theta0 : Fin 4 → ℝ)
    (thetaSpat : Fin 3 → Fin 4 → ℝ)
    (epsilonIjk : Fin 3 → Fin 3 → Fin 3 → ℝ)
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaBar : Fin 3 → Fin 4 → Fin 4 → ℂ) : Prop where
  sigmaDef : ∀ (i : Fin 3) (mu nu : Fin 4),
    sigma i mu nu =
      Complex.I * (theta0 mu * thetaSpat i nu - theta0 nu * thetaSpat i mu) -
      (1 / 2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
        (thetaSpat j mu * thetaSpat k nu - thetaSpat j nu * thetaSpat k mu)
  sigmaBarDef : ∀ (i : Fin 3) (mu nu : Fin 4),
    sigmaBar i mu nu =
      Complex.I * (theta0 mu * thetaSpat i nu - theta0 nu * thetaSpat i mu) +
      (1 / 2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
        (thetaSpat j mu * thetaSpat k nu - thetaSpat j nu * thetaSpat k mu)

Litlib.equation "krasnov2011plebanski"
  eq "9_10"
  page "5"
  kind "theorem"
/--
Physical Interpretation: Reality and orthogonality relations for the constructed 2-forms:
`(i/2) Σⁱ ∧ Σʲ = δⁱʲ √-g d⁴x` and `Σⁱ ∧ Σ̄ʲ = 0`.
Mathematical Boundaries: Evaluated via contraction with the Levi-Civita volume tensor.
Locks down the non-degeneracy of the basis and prevents the Trivial Type Exploit.
-/
class Eq9_10
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaBar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (gDetSqrt : ℝ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) : Prop where
  realityCond1 : ∀ (i j : Fin 3),
    (Complex.I / 8) * ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ rho : Fin 4, ∑ s : Fin 4,
      (epsilon4 mu nu rho s : ℂ) * sigma i mu nu * sigma j rho s =
    if i = j then (gDetSqrt : ℂ) else 0
  realityCond2 : ∀ (i j : Fin 3),
    ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ rho : Fin 4, ∑ s : Fin 4,
      (epsilon4 mu nu rho s : ℂ) * sigma i mu nu * sigmaBar j rho s = 0

Litlib.equation "krasnov2011plebanski"
  eq "12"
  page "5"
  kind "definition"
/--
Physical Interpretation: Defines the connection `A` compatible with the self-dual 2-forms `sigma`:
`dΣⁱ + εⁱʲᵏ Aʲ ∧ Σᵏ = 0`. This is the Plebański analogue of the vanishing torsion condition.
Mathematical Boundaries: Enforces functional dependence for derivatives (`deriv`), eliminating
the Decoupled Derivative Exploit. Evaluated in full component expansion.
-/
class Eq12
    (sigma : (Fin 4 → ℝ) → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (aConn : (Fin 4 → ℝ) → Fin 3 → Fin 4 → ℂ)
    (epsilonIjk : Fin 3 → Fin 3 → Fin 3 → ℝ)
    (deriv : ((Fin 4 → ℝ) → ℂ) → (Fin 4 → ℝ) → Fin 4 → ℂ) : Prop where
  compatibility : ∀ (x : Fin 4 → ℝ) (i : Fin 3) (mu nu rho : Fin 4),
    (deriv (fun y ↦ sigma y i nu rho) x mu +
     deriv (fun y ↦ sigma y i rho mu) x nu +
     deriv (fun y ↦ sigma y i mu nu) x rho) +
    ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
      (aConn x j mu * sigma x k nu rho +
       aConn x j nu * sigma x k rho mu +
       aConn x j rho * sigma x k mu nu) = 0

Litlib.equation "krasnov2011plebanski"
  eq "13"
  page "5"
  kind "definition"
/--
Physical Interpretation: The curvature 2-form `F` of the compatible connection `A`:
`Fⁱ = dAⁱ + (1/2) εⁱʲᵏ Aʲ ∧ Aᵏ`.
Mathematical Boundaries: Explicitly computes the exterior derivative and non-abelian Lie algebra
bracket in spacetime components.
-/
class Eq13
    (aConn : (Fin 4 → ℝ) → Fin 3 → Fin 4 → ℂ)
    (fCurv : (Fin 4 → ℝ) → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (epsilonIjk : Fin 3 → Fin 3 → Fin 3 → ℝ)
    (deriv : ((Fin 4 → ℝ) → ℂ) → (Fin 4 → ℝ) → Fin 4 → ℂ) : Prop where
  curvatureDef : ∀ (x : Fin 4 → ℝ) (i : Fin 3) (mu nu : Fin 4),
    fCurv x i mu nu =
      (deriv (fun y ↦ aConn y i nu) x mu - deriv (fun y ↦ aConn y i mu) x nu) +
      (1 / 2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
        (aConn x j mu * aConn x k nu - aConn x j nu * aConn x k mu)

Litlib.equation "krasnov2011plebanski"
  eq "14"
  page "5"
  kind "theorem"
/--
Physical Interpretation: Decomposes the curvature of the self-dual connection into self-dual
(`Fⁱʲ`) and anti-self-dual (`F̄ⁱʲ`) components: `Fⁱ(A_Σ) = Fⁱʲ Σʲ + F̄ⁱʲ Σ̄ʲ`.
Mathematical Boundaries: Requires that the background self-dual and anti-self-dual 2-forms span
the space of antisymmetric 2-forms (`formsBasis`).
-/
class Eq14
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaBar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (formsBasis : ∀ (f : Fin 4 → Fin 4 → ℂ),
      (∀ mu nu, f mu nu = - f nu mu) →
      ∃ (c cBar : Fin 3 → ℂ), ∀ mu nu,
        f mu nu = (∑ j : Fin 3, c j * sigma j mu nu) + (∑ j : Fin 3, cBar j * sigmaBar j mu nu)) : Prop where
  curvatureDecomposition : ∀ (fI : Fin 3 → Fin 4 → Fin 4 → ℂ),
    (∀ i mu nu, fI i mu nu = - fI i nu mu) →
    ∃ (fIj fBarIj : Fin 3 → Fin 3 → ℂ),
      ∀ i mu nu, fI i mu nu =
        (∑ j : Fin 3, fIj i j * sigma j mu nu) +
        (∑ j : Fin 3, fBarIj i j * sigmaBar j mu nu)

Litlib.equation "krasnov2011plebanski"
  eq "15"
  page "6"
  kind "definition"
/--
Physical Interpretation: Formulates the vacuum Einstein equations in the Plebański formalism:
`Tr(F) = -Λ` and `F̄ⁱʲ = 0`.
Mathematical Boundaries: Enforces the 10 independent vacuum Einstein conditions via 1 trace
condition and 9 vanishing anti-self-dual curvature conditions.
-/
class Eq15
    (plebanskiVacuum : ℂ → (Fin 3 → Fin 3 → ℂ) → (Fin 3 → Fin 3 → ℂ) → Prop) : Prop where
  plebanskiVacuumIff : ∀ (lambda : ℂ) (fIj fBarIj : Fin 3 → Fin 3 → ℂ),
    plebanskiVacuum lambda fIj fBarIj ↔
    ((∑ i : Fin 3, fIj i i) = -lambda ∧ (∀ i j, fBarIj i j = 0))

Litlib.equation "krasnov2011plebanski"
  eq "15_weyl"
  page "6"
  kind "definition"
/--
Physical Interpretation: The self-dual Weyl curvature tensor components are given by the
trace-free part of the self-dual curvature matrix `Fⁱʲ`: `Ψⁱʲ = (Fⁱʲ)_tf`.
Mathematical Boundaries: Explicitly removes the scalar trace to isolate the conformally
invariant Weyl curvature.
-/
class Eq15_Weyl
    (fIj : Fin 3 → Fin 3 → ℂ)
    (psiIj : Fin 3 → Fin 3 → ℂ) : Prop where
  weylCurvatureDef : ∀ i j,
    psiIj i j = fIj i j - (1 / 3 : ℂ) * (∑ k : Fin 3, fIj k k) * (if i = j then 1 else 0)

Litlib.equation "krasnov2011plebanski"
  eq "16"
  page "6"
  kind "definition"
/--
Physical Interpretation: Defines the projection of the trace-free stress-energy tensor
`T̃_μν = T_μν - (1/4) g_μν T` onto the mixed self-dual/anti-self-dual 2-form basis:
`Tⁱʲ = T̃^ρ_μ Σⁱ_νρ Σ̄^j μν`.
Mathematical Boundaries: The construction explicitly raises indices with the inverse metric `gInv`.
-/
class Eq16
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaBar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (gInv : Fin 4 → Fin 4 → ℂ)
    (tTilde : Fin 4 → Fin 4 → ℂ)
    (tIj : Fin 3 → Fin 3 → ℂ) : Prop where
  tIjDef : ∀ (i j : Fin 3),
    tIj i j =
      ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ rho : Fin 4, ∑ alpha : Fin 4, ∑ beta : Fin 4,
        tTilde rho mu *
        sigma i nu rho *
        gInv mu alpha *
        gInv nu beta *
        sigmaBar j alpha beta

Litlib.equation "krasnov2011plebanski"
  eq "17"
  page "6"
  kind "definition"
/--
Physical Interpretation: Non-vacuum Einstein equations coupled to matter in the Plebański
formulation: `Tr(F) = -Λ - 2πGT` and `F̄ⁱʲ = -2πGTⁱʲ`.
Mathematical Boundaries: Explicitly couples the curvature trace and anti-self-dual parts to the
matter stress-energy trace and projection matrix `Tⁱʲ`.
-/
class Eq17
    (lambda : ℂ)
    (gNewton : ℂ)
    (fIj : Fin 3 → Fin 3 → ℂ)
    (fBarIj : Fin 3 → Fin 3 → ℂ)
    (tTrace : ℂ)
    (tIj : Fin 3 → Fin 3 → ℂ)
    (plebanskiMatterEqs : Prop) : Prop where
  einsteinEqsIff : plebanskiMatterEqs ↔
    ((∑ i : Fin 3, fIj i i) = -lambda - 2 * (Real.pi : ℂ) * gNewton * tTrace ∧
     (∀ i j, fBarIj i j = -2 * (Real.pi : ℂ) * gNewton * tIj i j))

Litlib.equation "krasnov2011plebanski"
  eq "bridge_theorem_vacuum"
  page "6"
  kind "theorem"
/--
Physical Interpretation: Establishes the equivalence between the Plebański vacuum equations
and the standard metric Einstein vacuum equations with cosmological constant:
`Tr(F) = -Λ ∧ F̄ⁱʲ = 0 ↔ R_μν = Λ g_μν`.
Mathematical Boundaries: Metric invertibility (`gInv`) prevents topological collapse. The
predicate `isPlebanskiCurvature` binds `(fIj, fBarIj)` directly to `g`, preventing the
decoupling exploit where arbitrary curvature matrices could falsify the equivalence.
-/
class PlebanskiToEinsteinEquivalence
    (g : Fin 4 → Fin 4 → ℝ)
    (gInv : Fin 4 → Fin 4 → ℝ)
    (ricci : Fin 4 → Fin 4 → ℝ)
    (lambda : ℝ)
    (fIj fBarIj : Fin 3 → Fin 3 → ℂ)
    (isPlebanskiCurvature : (Fin 4 → Fin 4 → ℝ) → (Fin 3 → Fin 3 → ℂ) → (Fin 3 → Fin 3 → ℂ) → Prop)
    (plebanskiVacuum : ℂ → (Fin 3 → Fin 3 → ℂ) → (Fin 3 → Fin 3 → ℂ) → Prop)
    (isLeviCivitaRicci : (Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ) → Prop) : Prop where
  equivalenceIff :
    (∀ mu nu, (∑ alpha : Fin 4, g mu alpha * gInv alpha nu) = if mu = nu then 1 else 0) →
    isLeviCivitaRicci g ricci →
    isPlebanskiCurvature g fIj fBarIj →
    (plebanskiVacuum (lambda : ℂ) fIj fBarIj ↔ (∀ a b, ricci a b = lambda * g a b))

Litlib.equation "krasnov2011plebanski"
  eq "bridge_theorem_matter"
  page "6"
  kind "theorem"
/--
Physical Interpretation: Equivalence between the non-vacuum Plebański equations (Eq 17) and
the standard tensorial Einstein Field Equations with matter:
`G_μν + Λ g_μν = 8πG T_μν`.
Mathematical Boundaries: Extends the vacuum bridge to incorporate arbitrary stress-energy fields
`tMuNu`. The predicates `isPlebanskiCurvature` and `isPlebanskiMatter` algebraically couple
the Plebański variables `(fIj, fBarIj)` and `(tTrace, tIj)` to `g` and `tMuNu`, closing
the decoupling exploit.
-/
class PlebanskiMatterToEinsteinEquivalence
    (g : Fin 4 → Fin 4 → ℝ)
    (gInv : Fin 4 → Fin 4 → ℝ)
    (einsteinTensor : Fin 4 → Fin 4 → ℝ)
    (tMuNu : Fin 4 → Fin 4 → ℝ)
    (lambda : ℝ)
    (gNewton : ℝ)
    (fIj fBarIj : Fin 3 → Fin 3 → ℂ)
    (tTrace : ℂ)
    (tIj : Fin 3 → Fin 3 → ℂ)
    (isPlebanskiCurvature : (Fin 4 → Fin 4 → ℝ) → (Fin 3 → Fin 3 → ℂ) → (Fin 3 → Fin 3 → ℂ) → Prop)
    (isPlebanskiMatter : (Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ) → ℂ → (Fin 3 → Fin 3 → ℂ) → Prop)
    (plebanskiMatterEqs : Prop)
    (isEinsteinTensor : (Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ) → Prop) : Prop where
  equivalenceIff :
    (∀ mu nu, (∑ alpha : Fin 4, g mu alpha * gInv alpha nu) = if mu = nu then 1 else 0) →
    isEinsteinTensor g einsteinTensor →
    isPlebanskiCurvature g fIj fBarIj →
    isPlebanskiMatter g tMuNu tTrace tIj →
    (plebanskiMatterEqs ↔
      (∀ mu nu, einsteinTensor mu nu + lambda * g mu nu = 8 * Real.pi * gNewton * tMuNu mu nu))

Litlib.equation "krasnov2011plebanski"
  eq "31_33"
  page "9"
  kind "theorem"
/--
Physical Interpretation: The explicit tetrad and self-dual basis 2-forms for the exact
Schwarzschild solution.
Mathematical Boundaries: Spacetime coordinates (r, theta) are mapped to `Fin 4` indices
(t=0, r=1, theta=2, phi=3) to prevent dimensional collapse.
-/
class Eq31_33
    (f gFunc : ℝ → ℝ)
    (eT eR eTheta ePhi : ℝ → ℝ → Fin 4 → ℝ)
    (sigma : ℝ → ℝ → Fin 3 → Fin 4 → Fin 4 → ℂ) : Prop where
  eT_def : ∀ r theta, eT r theta 0 = f r ∧ ∀ i, i ≠ 0 → eT r theta i = 0
  eR_def : ∀ r theta, eR r theta 1 = gFunc r ∧ ∀ i, i ≠ 1 → eR r theta i = 0
  eTheta_def : ∀ r theta, eTheta r theta 2 = r ∧ ∀ i, i ≠ 2 → eTheta r theta i = 0
  ePhi_def : ∀ r theta, ePhi r theta 3 = r * Real.sin theta ∧ ∀ i, i ≠ 3 → ePhi r theta i = 0
  sigma1_def : ∀ r theta mu nu,
    sigma r theta 0 mu nu =
      Complex.I * (eT r theta mu * eR r theta nu - eT r theta nu * eR r theta mu) -
      (eTheta r theta mu * ePhi r theta nu - eTheta r theta nu * ePhi r theta mu)
  sigma2_def : ∀ r theta mu nu,
    sigma r theta 1 mu nu =
      Complex.I * (eT r theta mu * eTheta r theta nu - eT r theta nu * eTheta r theta mu) -
      (ePhi r theta mu * eR r theta nu - ePhi r theta nu * eR r theta mu)
  sigma3_def : ∀ r theta mu nu,
    sigma r theta 2 mu nu =
      Complex.I * (eT r theta mu * ePhi r theta nu - eT r theta nu * ePhi r theta mu) -
      (eR r theta mu * eTheta r theta nu - eR r theta nu * eTheta r theta mu)

Litlib.equation "krasnov2011plebanski"
  eq "55_56"
  page "13"
  kind "theorem"
/--
Physical Interpretation: The explicit construction of the self-dual basis forms for the
homogeneous isotropic Universe (FLRW metric) parameterized by conformal time `eta`.
Mathematical Boundaries: Strictly defines spatial differentials using Kronecker deltas
over `Fin 4` indices to enforce 4-dimensional symmetry.
-/
class Eq55_56
    (a : ℝ → ℝ)
    (dEta : Fin 4 → ℝ)
    (dx : Fin 3 → Fin 4 → ℝ)
    (epsilonIjk : Fin 3 → Fin 3 → Fin 3 → ℝ)
    (sigma sigmaBar : ℝ → Fin 3 → Fin 4 → Fin 4 → ℂ) : Prop where
  dEta_def : ∀ mu, dEta mu = if mu = 0 then 1 else 0
  dx_def : ∀ i mu, dx i mu = if mu.val = i.val + 1 then 1 else 0
  sigmaDef : ∀ eta i mu nu,
    sigma eta i mu nu = (a eta)^2 * (
      Complex.I * (dEta mu * dx i nu - dEta nu * dx i mu) -
      (1 / 2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
        (dx j mu * dx k nu - dx j nu * dx k mu)
    )
  sigmaBarDef : ∀ eta i mu nu,
    sigmaBar eta i mu nu = (a eta)^2 * (
      Complex.I * (dEta mu * dx i nu - dEta nu * dx i mu) +
      (1 / 2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
        (dx j mu * dx k nu - dx j nu * dx k mu)
    )

Litlib.equation "krasnov2011plebanski"
  eq "62"
  page "14"
  kind "theorem"
/--
Physical Interpretation: The Bianchi identity in the Plebański formulation, mapping the covariant
exterior derivative of the Weyl curvature components wedged with the self-dual 2-forms to zero:
`D_A Ψⁱʲ ∧ Σʲ = 0`.
Mathematical Boundaries: Expressed rigorously as a vanishing 3-form by fully contracting with
the 4D Levi-Civita symbol.
-/
class Eq62
    (psi : (Fin 4 → ℝ) → Fin 3 → Fin 3 → ℂ)
    (covDerivPsi : (Fin 4 → ℝ) → Fin 3 → Fin 3 → Fin 4 → ℂ)
    (sigma : (Fin 4 → ℝ) → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) : Prop where
  bianchiIdentity : ∀ (x : Fin 4 → ℝ) (i : Fin 3) (mu : Fin 4),
    ∑ j : Fin 3, ∑ nu : Fin 4, ∑ rho : Fin 4, ∑ sigma_ : Fin 4,
      (epsilon4 mu nu rho sigma_ : ℂ) * covDerivPsi x i j nu * sigma x j rho sigma_ = 0

end Litlib.Y2011.krasnov2011plebanski
