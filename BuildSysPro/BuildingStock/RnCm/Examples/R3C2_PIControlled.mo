within BuildSysPro.BuildingStock.RnCm.Examples;
model R3C2_PIControlled "Test of 2 R3C2 models in parallel"

  BuildSysPro.BuildingStock.RnCm.R3C2 R3C2_1 annotation (Placement(transformation(extent={{20,2},{40,22}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.RealExpression ApportsInt1
    annotation (Placement(transformation(extent={{-20,6},{2,30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor1
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-52,-20})));
  Modelica.Blocks.Continuous.PI PI1(k=87.787, T=1/0.0030396)
    annotation (Placement(transformation(extent={{10,-44},{30,-24}})));
  Modelica.Blocks.Sources.RealExpression Tcons1(y=295.15) annotation (Placement(
        transformation(
        extent={{-10,-11},{10,11}},
        rotation=0,
        origin={-50,-51})));
  Modelica.Blocks.Math.Add add1(k1=-1, k2=1)
    annotation (Placement(transformation(extent={{-24,-44},{-4,-24}})));
equation
  connect(ApportsInt1.y, R3C2_1.P_AI)
    annotation (Line(points={{3.1,18},{12,18},{17.9,18}}, color={0,0,127}));
  connect(temperatureSensor1.T, add1.u1) annotation (Line(points={{-42,-20},{-34,
          -20},{-34,-28},{-26,-28}}, color={0,0,127}));
  connect(Tcons1.y, add1.u2) annotation (Line(points={{-39,-51},{-32.5,-51},{-32.5,
          -40},{-26,-40}}, color={0,0,127}));
  connect(add1.y, PI1.u)
    annotation (Line(points={{-3,-34},{8,-34}}, color={0,0,127}));
  connect(meteofile.T_dry, R3C2_1.T_ext) annotation (Line(points={{-41,53},{46,
          53},{46,12},{41,12}}, color={191,0,0}));
  connect(meteofile.G,R3C2_1. G) annotation (Line(points={{-41,48},{-41,48},{-24,
          48},{-24,6},{18,6}}, color={0,0,127}));
  connect(R3C2_1.T_int, temperatureSensor1.port) annotation (Line(points={{30,4},
          {30,0},{-70,0},{-70,-20},{-62,-20}}, color={191,0,0}));
  connect(PI1.y, R3C2_1.P_Qch) annotation (Line(points={{31,-34},{40,-34},{40,-10},
          {8,-10},{8,12},{18,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {180,100}})),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 01/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Hassan BOUIA, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"),
    experiment(StopTime=3.1536e+007),
    __Dymola_experimentSetupOutput);
end R3C2_PIControlled;
