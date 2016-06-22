within BuildSysPro.BaseClasses.HeatTransfer.Examples;
model ValidationLWRLinear
extends Modelica.Icons.Example;
  BuildSysPro.BaseClasses.HeatTransfer.Components.LinearExtLWR gLOextLinear(
      skyViewFactor=1/2, S=100)
    annotation (Placement(transformation(extent={{-2,32},{18,52}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-72,36},{-52,56}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperatureLINEAR(T=288.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,42})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile1
    annotation (Placement(transformation(extent={{-76,-58},{-56,-38}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtLWR gLOext(incl=90, S=100)
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperatureREFERENCE(T=288.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,-64})));
equation
  connect(gLOext.T_ext, meteofile1.Tseche) annotation (Line(
      points={{1,-57},{-30.5,-57},{-30.5,-45},{-57,-45}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gLOextLinear.T_ext, meteofile.Tseche) annotation (Line(
      points={{-1,47},{-26.5,47},{-26.5,49},{-53,49}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(meteofile.Tciel, gLOextLinear.T_ciel) annotation (Line(
      points={{-53,55},{-33.5,55},{-33.5,37},{-1,37}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile1.Tciel, gLOext.T_ciel) annotation (Line(
      points={{-57,-39},{-35.5,-39},{-35.5,-65},{1,-65}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(gLOextLinear.Ts_p, fixedTemperatureLINEAR.port) annotation (
      Line(
      points={{17,42},{70,42}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperatureREFERENCE.port, gLOext.Ts_p) annotation (Line(
      points={{72,-64},{46,-64},{46,-60},{19,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=3.1536e+007, Interval=600),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows to estimate the difference in results between a classic long wavelength radiation flux and a linearized one.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Simulate the model and observe the difference between the two modellings.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Gilles PLESSIS, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ValidationLWRLinear;
