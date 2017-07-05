within BuildSysPro.Systems.DHW.Examples;
model DHWResistiveWaterHeater

extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression Tef(y=12)
    "Température d'eau froide en °C"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Modelica.Blocks.Sources.RealExpression MA(y=if H.y < 8 then 1 else 0)
    "Température d'eau froide en °C"
    annotation (Placement(transformation(extent={{-80,6},{-12,26}})));
  ResistiveWaterHeater eCSisotherme(dT=1.5, T_sp=333.15)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.RealExpression H(y=mod(time/3600, 24))
    "Heure de de la journée"
    annotation (Placement(transformation(extent={{-80,40},{-12,60}})));
  Modelica.Blocks.Sources.RealExpression Tamb(y=273.15 + 10 + 10*sin(6.28*H.y
        /sqrt(10))) "Température d'eau froide en °C"
    annotation (Placement(transformation(extent={{-40,-94},{28,-74}})));
  inner Modelica_LinearSystems2.Controller.SampleClock sampleClock(blockType = Modelica_LinearSystems2.Controller.Types.BlockType.Discrete, sampleTime=
        3600) annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica_LinearSystems2.Controller.Noise debit(              y_max=0.0015, y_min=0)
    "Débit en kg/s (Signal aléatoire : débit compris entre 0.0002 et 0.0015)"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tambiante
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,10})));
equation
  connect(MA.y, eCSisotherme.OnOff) annotation (Line(
      points={{-8.6,16},{2,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tef.y, eCSisotherme.T_cold) annotation (Line(
      points={{1,-20},{6,-20},{6,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(debit.y, eCSisotherme.debit) annotation (Line(
      points={{1,-50},{14,-50},{14,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eCSisotherme.T_int, Tambiante.port) annotation (Line(
      points={{17,10},{28.5,10},{28.5,10},{40,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tamb.y, Tambiante.T) annotation (Line(
      points={{31.4,-84},{80,-84},{80,10},{62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=864000, Interval=3600),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Use example of <a href=\"modelica://BuildSysPro.Systems.DHW.ResistiveWaterHeater\">ResistiveWaterHeater</a> model.</p>
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
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end DHWResistiveWaterHeater;
