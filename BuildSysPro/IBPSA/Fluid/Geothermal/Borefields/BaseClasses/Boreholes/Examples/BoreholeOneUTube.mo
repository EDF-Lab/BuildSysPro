within BuildSysPro.IBPSA.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.Examples;
model BoreholeOneUTube "Test for the single U-tube borehole model"
  extends Modelica.Icons.Example;
  extends
    IBPSA.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.Examples.BaseClasses.PartialBorehole(
      redeclare
      IBPSA.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube borHol(
        energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

  annotation (
    __Dymola_Commands( file="modelica://BuildSysPro/IBPSA/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/Examples/BoreholeOneUTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
This example illustrates the use of the
<a href=\"modelica://BuildSysPro.IBPSA.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube\">
IBPSA.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTubes</a>
model. It simulates the behavior of a borehole with a prescribed
borehole wall temperature boundary condition.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
Adjusted the example following major changes to the IBPSA.Fluid.HeatExchangers.Ground package.
Additionally, implemented a partial example model.
</li>
<li>
August 30, 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StopTime=360000));
end BoreholeOneUTube;
