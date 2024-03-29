within BuildSysPro.IBPSA.Fluid.Chillers.Validation;
model Carnot_TEva_LimitedCapacity
  "Test model for Carnot_TEva with limited heating capacity"
  extends Examples.Carnot_TEva(
    chi(QEva_flow_min=-100000));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://BuildSysPro/IBPSA/Resources/Scripts/Dymola/Fluid/Chillers/Validation/Carnot_TEva_LimitedCapacity.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example extends from
<a href=\"modelica://BuildSysPro.IBPSA.Fluid.Chillers.Examples.Carnot_TEva\">
IBPSA.Fluid.Chillers.Examples.Carnot_TEva</a>
but limits the cooling capacity.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TEva_LimitedCapacity;
