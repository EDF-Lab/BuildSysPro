within BuildSysPro.IBPSA.Media.Specialized.Air.PerfectGas;
function saturationPressureLiquid
    "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 373.16 K"

  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature Tsat "saturation temperature";
  output Modelica.SIunits.AbsolutePressure psat "saturation pressure";
  // This function is declared here explicitly, instead of referencing the function in its
  // base class, since otherwise Dymola 7.3 does not find the derivative for the model
  // IBPSA.Fluid.Sensors.Examples.MassFraction
algorithm
  psat := 611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719));
  annotation (
    smoothOrder=5,
    Inline=true,
    derivative=IBPSA.Media.Specialized.Air.PerfectGas.saturationPressureLiquid_der,
    Documentation(info="<html>
Saturation pressure of water above the triple point temperature is computed from temperature. It's range of validity is between
273.16 and 373.16 K. Outside these limits a less accurate result is returned.
</html>"));
end saturationPressureLiquid;
