within BuildSysPro.IBPSA.Media.Water;
function enthalpyOfLiquid "Return the specific enthalpy of liquid"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
  h := cp_const*(T-reference_T);
annotation (
  smoothOrder=5,
  Inline=true,
Documentation(info="<html>
<p>
Enthalpy of the water.
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2014 by Michael Wetter:<br/>
First implementation.
This function is used by
<a href=\"modelica://BuildSysPro.IBPSA.Fluid.MixingVolumes.MixingVolumeMoistAir\">
IBPSA.Fluid.MixingVolumes.MixingVolumeMoistAir</a>.
</li>
</ul>
</html>"));
end enthalpyOfLiquid;
