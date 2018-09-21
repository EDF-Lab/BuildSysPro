within BuildSysPro.IBPSA.Media.Antifreeze.Validation.BaseClasses.PropyleneGlycolWater;
function testSpecificHeatCapacityCp_TX_a
  "Evaluate specific heat capacity of antifreeze-water mixture"
    extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature of antifreeze-water mixture";
  input Modelica.SIunits.MassFraction X_a "Mass fraction of antifreeze";
  output Modelica.SIunits.SpecificHeatCapacity cp "Specific heat capacity of antifreeze-water mixture";
algorithm
  cp := specificHeatCapacityCp_TX_a(T = T, X_a = X_a);

  annotation (Documentation(info="<html>
<p>
Function that makes
<a href=\"modelica://IBPSA.Media.Antifreeze.specificHeatCapacityCp_TX_a\">
IBPSA.Media.Antifreeze.specificHeatCapacityCp_TX_a</a>
publicly accessible as needed for the validation model
<a href=\"modelica://IBPSA.Media.Antifreeze.Validation.BaseClasses.FluidProperties\">
IBPSA.Media.Antifreeze.Validation.BaseClasses.FluidProperties</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
May 14, 2018 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end testSpecificHeatCapacityCp_TX_a;
