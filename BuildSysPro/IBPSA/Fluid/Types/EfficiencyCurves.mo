within BuildSysPro.IBPSA.Fluid.Types;
type EfficiencyCurves = enumeration(
    Constant "constant",
    Polynomial "Polynomial",
    QuadraticLinear "quadratic in x1, linear in x2")
  "Enumeration to define the efficiency curves";
