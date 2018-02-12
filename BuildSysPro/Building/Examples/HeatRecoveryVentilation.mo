within BuildSysPro.Building.Examples;
model HeatRecoveryVentilation
extends Modelica.Icons.Example;
  AirFlow.HeatTransfer.HeatRecoveryVentilation doubleFlux(
    Qv=100,
    Cp=1000,
    use_Qv_in=false,
    use_Efficacite_in=false,
    Efficacite=0.5)
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Text
    annotation (Placement(transformation(extent={{-66,32},{-46,52}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=20,
    freqHz=2*3.14/3600/24,
    offset=283.15)
    annotation (Placement(transformation(extent={{-100,32},{-80,52}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=if Text.T + 5
         > Tint.T and Text.T < Tint.T then true else false)
    annotation (Placement(transformation(extent={{-56,-18},{-36,2}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=false)
    annotation (Placement(transformation(extent={{-66,68},{-46,88}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tint(T=293.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={48,42})));
  AirFlow.HeatTransfer.HeatRecoveryVentilation doubleFlux1(
    Qv=100,
    Cp=1000,
    use_Qv_in=false,
    use_Efficacite_in=false,
    Efficacite=0.5)
    annotation (Placement(transformation(extent={{-8,-54},{12,-34}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Text1
    annotation (Placement(transformation(extent={{-64,-54},{-44,-34}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=20,
    freqHz=2*3.14/3600/24,
    offset=283.15)
    annotation (Placement(transformation(extent={{-98,-54},{-78,-34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tint1(T=293.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-44})));
equation
  connect(Text.port, doubleFlux.port_a) annotation (Line(
      points={{-46,42},{-9,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, Text.T) annotation (Line(
      points={{-79,42},{-68,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanConstant.y, doubleFlux.Bypass) annotation (Line(
      points={{-45,78},{-6,78},{-6,51},{-7,51}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(doubleFlux.port_b, Tint.port) annotation (Line(
      points={{9,42},{38,42}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Text1.port, doubleFlux1.port_a) annotation (Line(
      points={{-44,-44},{-7,-44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine1.y, Text1.T) annotation (Line(
      points={{-77,-44},{-66,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(doubleFlux1.port_b, Tint1.port) annotation (Line(
      points={{11,-44},{40,-44}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(booleanExpression.y, doubleFlux1.Bypass) annotation (Line(
      points={{-35,-8},{-5,-8},{-5,-35}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics),
    experiment(
      StopTime=7200,
      Interval=600,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
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
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end HeatRecoveryVentilation;
