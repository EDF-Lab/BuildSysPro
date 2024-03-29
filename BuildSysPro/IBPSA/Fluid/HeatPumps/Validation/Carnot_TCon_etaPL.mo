within BuildSysPro.IBPSA.Fluid.HeatPumps.Validation;
model Carnot_TCon_etaPL
  "Test model for the part load efficiency curve with condenser leaving temperature as input signal"
  extends Examples.Carnot_TCon(
    heaPum(a={0.7,0.3}),
    TConLvg(height=10, offset=273.15 + 25));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://BuildSysPro/IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/Carnot_TCon_etaPL.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example extends from
<a href=\"modelica://BuildSysPro.IBPSA.Fluid.HeatPumps.Examples.Carnot_TCon\">
IBPSA.Fluid.HeatPumps.Examples.Carnot_TCon</a>
but has a part load efficiency that varies with the load.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TCon_etaPL;
