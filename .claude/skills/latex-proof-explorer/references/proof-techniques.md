# Proof Techniques Reference

Taxonomy of techniques applicable to mathematical and physics proof trajectories across domains. Use this to identify what connects a starting point to a target result.

## Table of Contents
1. Algebraic and Analytic Techniques
2. Geometric and Topological Techniques
3. Physical Reasoning Techniques
4. Proof Strategy Patterns
5. Sanity Checks

---

## 1. Algebraic and Analytic Techniques

**Substitution / Chain rule**
Replace one expression with its definition, then differentiate or simplify. Works when the target is a rearrangement of the starting equation. Common failure: the substitution is only valid in a restricted domain.

**Dimensional analysis**
Check that both sides of a proposed equation carry the same units. Can confirm structural form of a result without a full derivation, or rule out an equation quickly. Works in any system with well-defined dimensions; fails when quantities are defined implicitly in natural units that obscure the dimensional content.

**Inequality chaining**
Combine known inequalities (Cauchy-Schwarz, Jensen, AM-GM, triangle inequality, Holder, Markov, Pinsker, sub-additivity of entropy, etc.) to bound a quantity. Works when the target is an upper or lower bound. Common failure: the chain introduces too much slack and the bound is not tight enough to be useful.

**Generating functions / Fourier / Laplace transforms**
Map a recurrence or differential equation into an algebraic problem in transform space, solve, then invert. Works when the original equation has convolution or shift structure. Common failure: convergence of the transform is not established.

**Taylor / perturbation expansion**
Expand around a known solution (e.g., flat space, zero coupling, high/low temperature) and track corrections order by order. Works when a small parameter exists. Common failure: the expansion is asymptotic rather than convergent; the regime of interest is not small-parameter.

**Variational principle**
Show that the target quantity extremizes a functional (action, entropy, free energy, etc.) and use Euler-Lagrange equations. Works when the physics has a known action principle. Common failure: the boundary terms are not handled correctly; the extremum is a saddle not a minimum.

**Fixed-point / contraction mapping**
Show that a map is a contraction on a complete metric space, so a unique fixed point exists. Useful for existence and uniqueness proofs. Common failure: the space is not complete, or the contraction constant is not uniform.

**Spectral / eigenvalue methods**
Diagonalize an operator and work in the eigenbasis. Works for linear systems, stability analysis, and quantum mechanical observables. Common failure: the operator is not self-adjoint; the spectrum is continuous and eigenvectors are distributional.

---

## 2. Geometric and Topological Techniques

**Symmetry argument / Noether**
If a system has a continuous symmetry, use Noether's theorem to identify a conserved quantity. Works when the Lagrangian/action is known. Common failure: the symmetry is anomalous at the quantum level.

**Gauss / Stokes / divergence theorem**
Convert a volume integral to a surface integral (or vice versa). Ubiquitous for deriving field equations from integral conservation laws. Common failure: the boundary conditions at infinity or at singular surfaces are not specified.

**Topological invariants**
Show that a quantity is invariant under continuous deformation (winding number, Chern number, Euler characteristic, etc.). Works when the result should be robust to perturbations. Common failure: the invariant is only defined on compact spaces without boundary.

**Conformal / scaling argument**
Use scale invariance or conformal invariance to constrain the form of correlation functions or propagators. Works in systems at critical points or with conformal symmetry. Common failure: anomalous dimensions break the naive scaling.

---

## 3. Physical Reasoning Techniques

**Limiting case / correspondence principle**
Show that in a known limit (large N, weak coupling, classical limit, thermodynamic limit, flat space) the framework reproduces an established result. Verifies necessary conditions without proving sufficiency. Common failure: the limit is singular (the limit and the result do not commute).

**Thought experiment / gedanken argument**
Construct a specific physical scenario and track what the framework predicts. Compare to what experiment or established theory demands. Works for testing internal consistency. Common failure: the scenario is idealized in a way that avoids the hard case.

**Entropy / information-theoretic bounds**
Use sub-additivity, strong sub-additivity, data-processing inequality, Holevo bound, or area bounds (Bekenstein, Bousso) to constrain what is possible. Domain-agnostic: applies anywhere entropy is well-defined. Common failure: the bound is on the wrong quantity or uses a different definition of entropy.

**Equation of state / state function argument**
Show that a quantity is path-independent (depends only on endpoints, not the trajectory), analogous to a thermodynamic state function. Useful when the framework claims a quantity is well-defined independently of how the system got there. Common failure: the quantity is actually path-dependent; the proof only works for quasi-static processes.

**Consistency with energy-momentum conservation**
Check that the proposed equations do not violate conservation laws. Works as a necessary condition. Common failure: the conservation law takes a different form in the curved or non-equilibrium setting.

**Adiabatic / slow-roll approximation**
Assume the system evolves slowly compared to some relaxation timescale. Reduces dynamical equations to static ones. Common failure: the adiabatic condition breaks down precisely where the interesting physics occurs.

---

## 4. Proof Strategy Patterns

**Direct proof**: Assume hypotheses, derive conclusion by a chain of equalities or inequalities.

**Proof by contradiction**: Assume the negation of the conclusion, derive a known false statement.

**Proof by contrapositive**: Prove the logically equivalent "not B implies not A" instead of "A implies B".

**Induction (strong/weak)**: Establish a base case and an inductive step. Works for discrete or countable structures.

**Construction**: Prove existence by explicitly constructing the object. Often more informative than a non-constructive proof.

**Uniqueness via two solutions**: Assume two solutions exist, show they must be equal.

**Sandwiching**: Bound a quantity above and below by the same limit.

**Reduction to a known result**: Show that the new claim is a special case, reparametrization, or corollary of an already-proved theorem.

---

## 5. Sanity Checks (always run before finalizing a proof)

1. **Dimensional check**: Do all terms in every equation carry the same dimensions?
2. **Limit check**: Does the result reduce to the correct known answer in at least one solvable limit?
3. **Sign check**: Are the signs of all terms physically reasonable (e.g., entropy non-negative, energy bounded below)?
4. **Symmetry check**: Does the result respect the symmetries the framework claims to preserve?
5. **Order-of-magnitude check**: Does the result give sensible numerical values for a concrete example?
6. **Independence check**: Is every step of the proof independent of the conclusion being proved?
7. **Generality check**: Is the result claimed in the paper actually proved, or only proved in a special case?
