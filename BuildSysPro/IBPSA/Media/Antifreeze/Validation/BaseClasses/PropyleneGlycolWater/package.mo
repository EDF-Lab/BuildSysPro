within BuildSysPro.IBPSA.Media.Antifreeze.Validation.BaseClasses;
package PropyleneGlycolWater "PropyleneGlycolWater with publicly accessible medium functions"
  extends IBPSA.Media.Antifreeze.PropyleneGlycolWater;

    replaceable function testDensity_TX_a
    "Evaluate density of antifreeze-water mixture"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.Temperature T "Temperature of antifreeze-water mixture";
    input Modelica.SIunits.MassFraction X_a "Mass fraction of antifreeze";
    output Modelica.SIunits.Density d "Density of antifreeze-water mixture";
    algorithm
    d := density_TX_a(T = T, X_a = X_a);

    annotation (Documentation(info="<html>
<p>
Function that makes
<a href=\"modelica://IBPSA.Media.Antifreeze.density_TX_a\">
IBPSA.Media.Antifreeze.density_TX_a</a>
publicly accessible as needed for the validation model
<a href=\"modelica://IBPSA.Media.Antifreeze.Validation.BaseClasses.FluidProperties\">
IBPSA.Media.Antifreeze.Validation.BaseClasses.FluidProperties</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 14, 2018 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
    end testDensity_TX_a;




annotation (Documentation(info="<html>
<p>
Media implementation that extends
<a href=\"modelica://IBPSA.Media.Antifreeze\">
IBPSA.Media.Antifreeze</a>
in order to make its thermophysical property functions
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
end PropyleneGlycolWater;
