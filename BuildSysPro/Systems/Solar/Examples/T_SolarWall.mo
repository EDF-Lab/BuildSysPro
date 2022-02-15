within BuildSysPro.Systems.Solar.Examples;
model T_SolarWall
extends Modelica.Icons.Example;
  Thermal.SolarWall.ParallelTubesActiveSolarWall tubesParallelePAS(
    Stot=9,
    Tstart=293,
    n=10) annotation (Placement(transformation(extent={{-12,0},{8,20}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant annotation (
     Placement(transformation(extent={{-74,-10},{-62,2}})));
  BuildSysPro.BoundaryConditions.Weather.AnalyticIrradiance
    eclairementDeSynthese(
    DureeJour=8,
    H=1500,
    Gmax=300) annotation (Placement(transformation(extent={{-82,42},{-62,62}})));
  BuildSysPro.BoundaryConditions.Weather.AnalyticText textDeSynthese(Tmin=280,
      Tmax=290)
    annotation (Placement(transformation(extent={{-86,18},{-66,38}})));
  BaseClasses.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{-68,10},{-48,30}})));

  Building.AirFlow.HeatTransfer.AirNode noeudAir(V=27, Tair=293.15)
    annotation (Placement(transformation(extent={{36,8},{56,28}})));
equation
  connect(booleanConstant.y, tubesParallelePAS.ON) annotation (Line(
      points={{-61.4,-4},{-18,-4},{-18,5.9},{-10.7,5.9}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(eclairementDeSynthese.G, tubesParallelePAS.G) annotation (
      Line(
      points={{-63,57},{-38,57},{-38,16.3},{-11.5,16.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(textDeSynthese.T_ext, prescribedTemperature.T) annotation (Line(
      points={{-75,33},{-68,33},{-68,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, tubesParallelePAS.Tf)
    annotation (Line(
      points={{-48,20},{-44,20},{-44,11},{-11,11}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tubesParallelePAS.Tb, noeudAir.port_a) annotation (Line(
      points={{7,11},{26.5,11},{26.5,14},{46,14}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics), Documentation(
        info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Emmanuel AMY DE LA BRETEQUE, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>"));
end T_SolarWall;
