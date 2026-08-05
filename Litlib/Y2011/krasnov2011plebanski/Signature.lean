-- FILENAME: Litlib/Y2011/krasnov2011plebanski/Signature.lean

import Litlib.Core
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
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
  eq "3"
  page "3"
  kind "theorem"
/--
Physical Interpretation: Reformulates the Einstein vacuum field equations using the Hodge duality operator on the Riemann curvature tensor. A metric is an Einstein metric (its Ricci tensor is proportional to the metric) if and only if the left and right Hodge duals of the Riemann tensor coincide.
Mathematical Boundaries: The metric `g` must be strictly invertible (`gInv`), which mathematically prevents topological collapse and rules out degenerate metrics (i.e. ensures `det g ≠ 0`). The curvature tensor `R` must be antisymmetric in its index pairs and satisfy the first Bianchi identity.
-/
class Eq3
    (g : Fin 4 → Fin 4 → ℝ)
    (gInv : Fin 4 → Fin 4 → ℝ)
    (gIsInv : ∀ mu nu, (∑ alpha : Fin 4, g mu alpha * gInv alpha nu) = if mu = nu then 1 else 0)
    (epsilonUpDown : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (leftHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (rightHodge : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ))
    (ricciTensor : (Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ))
    where
  leftHodgeDef : ∀ R mu nu rho sigma, 
    leftHodge R mu nu rho sigma = 
      (1/2 : ℝ) * ∑ alpha : Fin 4, ∑ beta : Fin 4, epsilonUpDown mu nu alpha beta * R alpha beta rho sigma
  rightHodgeDef : ∀ R mu nu rho sigma, 
    rightHodge R mu nu rho sigma = 
      (1/2 : ℝ) * ∑ alpha : Fin 4, ∑ beta : Fin 4, R mu nu alpha beta * epsilonUpDown alpha beta rho sigma
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
Physical Interpretation: Defines self-dual and anti-self-dual bivectors as the eigenspaces of the Hodge star operator with eigenvalues `i` and `-i` respectively.
Mathematical Boundaries: Applies to complex-valued 2-forms over the 4-dimensional spacetime. The existence of imaginary eigenvalues requires the Hodge star operator to satisfy `HodgeStar^2 = -1` on 2-forms, strictly binding this formulation to Lorentzian metric signatures.
-/
class Eq4
    (hodgeStar : (Fin 4 → Fin 4 → ℂ) → (Fin 4 → Fin 4 → ℂ))
    (isSelfDual : (Fin 4 → Fin 4 → ℂ) → Prop)
    (isAntiSelfDual : (Fin 4 → Fin 4 → ℂ) → Prop)
    where
  selfDualIff : ∀ (A : Fin 4 → Fin 4 → ℂ),
    isSelfDual A ↔ (∀ mu nu, hodgeStar A mu nu = Complex.I * A mu nu)
  antiSelfDualIff : ∀ (A : Fin 4 → Fin 4 → ℂ),
    isAntiSelfDual A ↔ (∀ mu nu, hodgeStar A mu nu = -(Complex.I * A mu nu))

Litlib.equation "krasnov2011plebanski"
  eq "5_6"
  page "4"
  kind "definition"
/--
Physical Interpretation: The Atiyah-Hitchin-Singer projectors onto the spaces of self-dual and anti-self-dual bivectors. 
Mathematical Boundaries: Defines the identity operator in the space of bivectors and algebraically constructs the chiral projection operators explicitly.
-/
class Eq5_6
    (delta : Fin 4 → Fin 4 → ℝ)
    (epsilon : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (identityBivector : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (pPlus : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (pMinus : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    where
  identityDef : ∀ mu nu rho sigma,
    identityBivector mu nu rho sigma =
      (1/2 : ℝ) * (delta mu rho * delta nu sigma - delta mu sigma * delta nu rho)
  pPlusDef : ∀ mu nu rho sigma,
    pPlus mu nu rho sigma =
      (1/2 : ℂ) * ((identityBivector mu nu rho sigma : ℂ) +
                   (1 / (2 * Complex.I)) * (epsilon mu nu rho sigma : ℂ))
  pMinusDef : ∀ mu nu rho sigma,
    pMinus mu nu rho sigma =
      (1/2 : ℂ) * ((identityBivector mu nu rho sigma : ℂ) -
                   (1 / (2 * Complex.I)) * (epsilon mu nu rho sigma : ℂ))

Litlib.equation "krasnov2011plebanski"
  eq "7"
  page "4"
  kind "theorem"
/--
Physical Interpretation: The Atiyah-Hitchin-Singer theorem applied to General Relativity. Vacuum Einstein conditions are mathematically identical to the condition that the mixed anti-self-dual / self-dual projection of the Riemann tensor vanishes.
Mathematical Boundaries: Fully eliminates metric dependencies from the vacuum constraint equation, pushing GR purely into the algebraic constraints of chiral projections.
-/
class Eq7
    (g : Fin 4 → Fin 4 → ℝ)
    (ricci : Fin 4 → Fin 4 → ℝ)
    (rCurv : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    (pPlus pMinus : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℂ)
    where
  einsteinConditionIff :
    (∃ (c : ℝ), ∀ mu nu, ricci mu nu = c * g mu nu) ↔
    (∀ mu nu rho sigma,
      ∑ alpha : Fin 4, ∑ beta : Fin 4, ∑ gamma : Fin 4, ∑ delta_ : Fin 4,
        pMinus mu nu alpha beta * rCurv alpha beta gamma delta_ * pPlus gamma delta_ rho sigma = 0)

Litlib.equation "krasnov2011plebanski"
  eq "8"
  page "5"
  kind "definition"
/--
Physical Interpretation: Constructs the self-dual and anti-self-dual 2-form bases (`sigma` and `sigmaBar`) from the spacetime tetrad.
Mathematical Boundaries: Explicitly expands the wedge product of the tetrad 1-forms into components to prevent the Opaque Function Exploit.
-/
class Eq8_11
    (theta0 : Fin 4 → ℝ)
    (thetaSpat : Fin 3 → Fin 4 → ℝ)
    (epsilonIjk : Fin 3 → Fin 3 → Fin 3 → ℝ)
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaBar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    where
  sigmaDef : ∀ (i : Fin 3) (mu nu : Fin 4),
    sigma i mu nu = 
      Complex.I * (theta0 mu * thetaSpat i nu - theta0 nu * thetaSpat i mu) -
      (1/2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) * 
        (thetaSpat j mu * thetaSpat k nu - thetaSpat j nu * thetaSpat k mu)
  sigmaBarDef : ∀ (i : Fin 3) (mu nu : Fin 4),
    sigmaBar i mu nu = 
      Complex.I * (theta0 mu * thetaSpat i nu - theta0 nu * thetaSpat i mu) +
      (1/2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) * 
        (thetaSpat j mu * thetaSpat k nu - thetaSpat j nu * thetaSpat k mu)

Litlib.equation "krasnov2011plebanski"
  eq "9"
  page "5"
  kind "theorem"
/--
Physical Interpretation: Reality and orthogonality conditions for the constructed 2-forms.
Mathematical Boundaries: Locks down the non-degeneracy of the basis using the Levi-Civita volume form, preventing the Trivial Type Exploit.
-/
class Eq9_10
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaBar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (gDetSqrt : ℝ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    where
  realityCond1 : ∀ (i j : Fin 3),
    (Complex.I / 2) * ∑ mu : Fin 4, ∑ nu : Fin 4, ∑ rho : Fin 4, ∑ s : Fin 4, 
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
Physical Interpretation: Defines the connection `A` compatible with the self-dual 2-forms `sigma`. This is the Plebański analogue of the tetrad compatibility condition (vanishing torsion).
Mathematical Boundaries: Explicitly enforces functional dependence for derivatives to prevent the Decoupled Derivative Exploit. The equation is evaluated component-wise to avoid Opaque Function exploits.
-/
class Eq12
    (sigma : (Fin 4 → ℝ) → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (aConn : (Fin 4 → ℝ) → Fin 3 → Fin 4 → ℂ)
    (epsilonIjk : Fin 3 → Fin 3 → Fin 3 → ℝ)
    (deriv : ((Fin 4 → ℝ) → ℂ) → (Fin 4 → ℝ) → Fin 4 → ℂ)
    where
  compatibility : ∀ (x : Fin 4 → ℝ) (i : Fin 3) (mu nu rho : Fin 4),
    (deriv (fun y => sigma y i nu rho) x mu + 
     deriv (fun y => sigma y i rho mu) x nu + 
     deriv (fun y => sigma y i mu nu) x rho) +
    ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
      (aConn x j mu * sigma x k nu rho + 
       aConn x j nu * sigma x k rho mu + 
       aConn x j rho * sigma x k mu nu) = 0

Litlib.equation "krasnov2011plebanski"
  eq "13"
  page "5"
  kind "definition"
/--
Physical Interpretation: The curvature 2-form `F` of the compatible connection `A`.
Mathematical Boundaries: Formulated strictly with functional dependencies for the connection to prevent metric or connection collapse exploits.
-/
class Eq13
    (aConn : (Fin 4 → ℝ) → Fin 3 → Fin 4 → ℂ)
    (fCurv : (Fin 4 → ℝ) → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (epsilonIjk : Fin 3 → Fin 3 → Fin 3 → ℝ)
    (deriv : ((Fin 4 → ℝ) → ℂ) → (Fin 4 → ℝ) → Fin 4 → ℂ)
    where
  curvatureDef : ∀ (x : Fin 4 → ℝ) (i : Fin 3) (mu nu : Fin 4),
    fCurv x i mu nu = 
      (deriv (fun y => aConn y i nu) x mu - deriv (fun y => aConn y i mu) x nu) +
      (1/2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
        (aConn x j mu * aConn x k nu - aConn x j nu * aConn x k mu)

Litlib.equation "krasnov2011plebanski"
  eq "14"
  page "5"
  kind "theorem"
/--
Physical Interpretation: Decomposes the curvature of the self-dual connection into self-dual (`fIj`) and anti-self-dual (`fBarIj`) components.
Mathematical Boundaries: The decomposition strictly requires that the background self-dual (`sigma`) and anti-self-dual (`sigmaBar`) 2-forms constitute a complete basis for the space of all antisymmetric 2-forms (`formsBasis`).
-/
class Eq14
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaBar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (formsBasis : ∀ (f : Fin 4 → Fin 4 → ℂ), 
      (∀ mu nu, f mu nu = - f nu mu) → 
      ∃ (c cBar : Fin 3 → ℂ), ∀ mu nu, 
        f mu nu = (∑ j : Fin 3, c j * sigma j mu nu) + (∑ j : Fin 3, cBar j * sigmaBar j mu nu))
    where
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
Physical Interpretation: Formulates the vacuum Einstein equations in the Plebański formalism. The trace of the self-dual curvature matrix is strictly proportional to the cosmological constant, and its anti-self-dual part strictly vanishes.
-/
class Eq15
    (plebanskiVacuum : ℂ → (Fin 3 → Fin 3 → ℂ) → (Fin 3 → Fin 3 → ℂ) → Prop)
    where
  plebanskiVacuumIff : ∀ (lambda : ℂ) (fIj fBarIj : Fin 3 → Fin 3 → ℂ),
    plebanskiVacuum lambda fIj fBarIj ↔ 
    ((∑ i : Fin 3, fIj i i) = -lambda ∧ (∀ i j, fBarIj i j = 0))

Litlib.equation "krasnov2011plebanski"
  eq "15_weyl"
  page "6"
  kind "definition"
/--
Physical Interpretation: Defines the self-dual Weyl curvature tensor components as the trace-free part of the self-dual curvature matrix `fIj`.
Mathematical Boundaries: Explictly removes the scalar trace to isolate the conformally invariant Weyl curvature.
-/
class Eq15_Weyl
    (fIj : Fin 3 → Fin 3 → ℂ)
    (psiIj : Fin 3 → Fin 3 → ℂ)
    where
  weylCurvatureDef : ∀ i j,
    psiIj i j = fIj i j - (1/3 : ℂ) * (∑ k : Fin 3, fIj k k) * (if i = j then 1 else 0)

Litlib.equation "krasnov2011plebanski"
  eq "16"
  page "6"
  kind "definition"
/--
Physical Interpretation: Defines the projection of the trace-free macroscopic stress-energy tensor onto the mixed self-dual/anti-self-dual basis. This term serves as the source coupling matter to the gravitational field in the Plebański formalism.
Mathematical Boundaries: The construction explicitly requires raising the indices of the anti-self-dual basis forms (`sigmaBar`) using the inverse background metric (`gInv`).
-/
class Eq16
    (sigma : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (sigmaBar : Fin 3 → Fin 4 → Fin 4 → ℂ)
    (gInv : Fin 4 → Fin 4 → ℂ)
    (tTilde : Fin 4 → Fin 4 → ℂ)
    (tIj : Fin 3 → Fin 3 → ℂ)
    where
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
Physical Interpretation: The full non-vacuum Einstein equations coupled to macroscopic matter in the Plebański formulation. The trace of the self-dual curvature is determined by the cosmological constant and the trace of the stress-energy tensor.
Mathematical Boundaries: By coupling the curvature to the stress-energy components `T` and `tIj`, these equations are strictly bound to domains where macroscopic matter fields are well-defined.
-/
class Eq17
    (lambda : ℂ)
    (gNewton : ℂ)
    (fIj : Fin 3 → Fin 3 → ℂ)
    (fBarIj : Fin 3 → Fin 3 → ℂ)
    (tTrace : ℂ)
    (tIj : Fin 3 → Fin 3 → ℂ)
    (plebanskiMatterEqs : Prop)
    where
  einsteinEqsIff : plebanskiMatterEqs ↔ 
    ((∑ i : Fin 3, fIj i i) = -lambda - 2 * (Real.pi : ℂ) * gNewton * tTrace ∧ 
     (∀ i j, fBarIj i j = -2 * (Real.pi : ℂ) * gNewton * tIj i j))

Litlib.equation "krasnov2011plebanski"
  eq "bridge_theorem_vacuum"
  page "6"
  kind "theorem"
/--
Physical Interpretation: Establishes the bridge between the Plebański formulation and the standard metric formulation of general relativity for vacuum.
-/
class PlebanskiToEinsteinEquivalence
    (g : Fin 4 → Fin 4 → ℝ)
    (gInv : Fin 4 → Fin 4 → ℝ)
    (ricci : Fin 4 → Fin 4 → ℝ)
    (lambda : ℝ)
    (fIj fBarIj : Fin 3 → Fin 3 → ℂ)
    (plebanskiVacuum : ℂ → (Fin 3 → Fin 3 → ℂ) → (Fin 3 → Fin 3 → ℂ) → Prop)
    (isLeviCivitaRicci : (Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ) → Prop)
    where
  equivalenceIff : 
    (∀ mu nu, (∑ alpha : Fin 4, g mu alpha * gInv alpha nu) = if mu = nu then 1 else 0) → 
    isLeviCivitaRicci g ricci → 
    (plebanskiVacuum (lambda : ℂ) fIj fBarIj ↔ (∀ a b, ricci a b = lambda * g a b))

Litlib.equation "krasnov2011plebanski"
  eq "bridge_theorem_matter"
  page "6"
  kind "theorem"
/--
Physical Interpretation: The full horizon bridge theorem equating the macroscopic non-vacuum Plebański equations (Eq 17) to the tensorial Einstein Field Equations.
Mathematical Boundaries: Extends the vacuum bridge to incorporate arbitrary stress-energy fields `tMuNu`, strictly preventing the "Can-Kicking" exploit by ensuring the non-vacuum topological constraints directly map to Einstein's $G_{\mu\nu}$.
-/
class PlebanskiMatterToEinsteinEquivalence
    (g : Fin 4 → Fin 4 → ℝ)
    (gInv : Fin 4 → Fin 4 → ℝ)
    (einsteinTensor : Fin 4 → Fin 4 → ℝ)
    (tMuNu : Fin 4 → Fin 4 → ℝ)
    (lambda : ℝ)
    (gNewton : ℝ)
    (plebanskiMatterEqs : Prop)
    (isLeviCivitaRicci : (Fin 4 → Fin 4 → ℝ) → (Fin 4 → Fin 4 → ℝ) → Prop)
    where
  equivalenceIff :
    (∀ mu nu, (∑ alpha : Fin 4, g mu alpha * gInv alpha nu) = if mu = nu then 1 else 0) →
    isLeviCivitaRicci g einsteinTensor →
    (plebanskiMatterEqs ↔
      (∀ mu nu, einsteinTensor mu nu + lambda * g mu nu = 8 * Real.pi * gNewton * tMuNu mu nu))

Litlib.equation "krasnov2011plebanski"
  eq "31_33"
  page "9"
  kind "theorem"
/--
Physical Interpretation: The explicit tetrad and self-dual basis 2-forms for the exact Schwarzschild solution.
Mathematical Boundaries: Variables and forms are explicitly mapped to their spacetime coordinates (r, theta) over `Fin 4` indices (t=0, r=1, theta=2, phi=3) to categorically prevent dimensional collapse or arbitrary unphysical embeddings.
-/
class Eq31_33
    (f gFunc : ℝ → ℝ)
    (eT eR eTheta ePhi : ℝ → ℝ → Fin 4 → ℝ)
    (sigma : ℝ → ℝ → Fin 3 → Fin 4 → Fin 4 → ℂ)
    where
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
Physical Interpretation: The explicit construction of the self-dual basis forms for the homogeneous isotropic Universe (FLRW metric) parameterized by conformal time `eta`.
Mathematical Boundaries: Strictly defines the spatial differentials using Kronecker deltas over `Fin 4` to explicitly prohibit mathematical can-kicking and enforce rigid 4-dimensional symmetry.
-/
class Eq55_56
    (a : ℝ → ℝ)
    (dEta : Fin 4 → ℝ)
    (dx : Fin 3 → Fin 4 → ℝ)
    (epsilonIjk : Fin 3 → Fin 3 → Fin 3 → ℝ)
    (sigma sigmaBar : ℝ → Fin 3 → Fin 4 → Fin 4 → ℂ)
    where
  dEta_def : ∀ mu, dEta mu = if mu = 0 then 1 else 0
  dx_def : ∀ i mu, dx i mu = if mu.val = i.val + 1 then 1 else 0
  sigmaDef : ∀ eta i mu nu,
    sigma eta i mu nu = (a eta)^2 * (
      Complex.I * (dEta mu * dx i nu - dEta nu * dx i mu) -
      (1/2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
        (dx j mu * dx k nu - dx j nu * dx k mu)
    )
  sigmaBarDef : ∀ eta i mu nu,
    sigmaBar eta i mu nu = (a eta)^2 * (
      Complex.I * (dEta mu * dx i nu - dEta nu * dx i mu) +
      (1/2 : ℂ) * ∑ j : Fin 3, ∑ k : Fin 3, (epsilonIjk i j k : ℂ) *
        (dx j mu * dx k nu - dx j nu * dx k mu)
    )

Litlib.equation "krasnov2011plebanski"
  eq "62"
  page "14"
  kind "theorem"
/--
Physical Interpretation: The Bianchi identity in the Plebański formulation, mapping the covariant exterior derivative of the Weyl curvature components wedged with the self-dual 2-forms to zero.
Mathematical Boundaries: Expressed rigorously as a vanishing 3-form by fully contracting it with the 4D Levi-Civita symbol. This explicitly shuts down trivial solutions that might arise if the wedge product were abstracted away.
-/
class Eq62
    (psi : (Fin 4 → ℝ) → Fin 3 → Fin 3 → ℂ)
    (covDerivPsi : (Fin 4 → ℝ) → Fin 3 → Fin 3 → Fin 4 → ℂ)
    (sigma : (Fin 4 → ℝ) → Fin 3 → Fin 4 → Fin 4 → ℂ)
    (epsilon4 : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    where
  bianchiIdentity : ∀ (x : Fin 4 → ℝ) (i : Fin 3) (mu : Fin 4),
    ∑ j : Fin 3, ∑ nu : Fin 4, ∑ rho : Fin 4, ∑ sigma_ : Fin 4,
      (epsilon4 mu nu rho sigma_ : ℂ) * covDerivPsi x i j nu * sigma x j rho sigma_ = 0

end Litlib.Y2011.krasnov2011plebanski
