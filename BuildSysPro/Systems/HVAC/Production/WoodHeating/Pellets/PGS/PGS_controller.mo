within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.PGS;
model PGS_controller

  Modelica.Blocks.Interfaces.RealInput Tconsigne "Temperature wanted"
                                                 annotation (Placement(
        transformation(extent={{-120,-10},{-80,30}}),iconTransformation(extent={{-100,0},
            {-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput fraction_of_max_power
    "fraction of maximum power that the stove has to power out"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

  parameter Modelica.Units.SI.Power Pcombmin=1700;
  parameter Modelica.Units.SI.Power Pcombmax=6580;
  Modelica.Units.SI.Power Power_forced=Pcombmax
    "Power wanted in forced going mode";

//------------------------------------------------------------------------------------
  Modelica.Blocks.Interfaces.BooleanInput presence
    "Indicates if the user is present in the house"
    annotation (Placement(transformation(extent={{-120,50},{-80,90}}),
        iconTransformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Interfaces.BooleanInput etatON
    "Indicates if \"forced going\" mode is activated"   annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-6,94}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,90})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a Tsens
    "Heat port connected to the room"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Continuous.LimPID    PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Td=60,
    Ti=600,
    yMin=Pcombmin/Pcombmax)
            annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{-74,-54},{-66,-46}})));
equation

if presence then
  if etatON then
    fraction_of_max_power=PID.y;
  else
  fraction_of_max_power=0;
  end if;
else
    fraction_of_max_power=0;
end if;

  connect(Tsens, temperatureSensor.port) annotation (Line(
      points={{-90,-50},{-74,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tconsigne, PID.u_s) annotation (Line(
      points={{-100,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T, PID.u_m) annotation (Line(
      points={{-65.6,-50},{-30,-50},{-30,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                      graphics={Rectangle(
          extent={{-70,74},{68,-70}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-48,54},{50,6}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
    Documentation(info="<html>
<p>PGS PELLET'S STOVE REGULATOR</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The purpose of this model is to be part of the PGS model</p>
<p>The control is done according to the difference between the actual romm temperature and the temperature wanted.</p>
<p>The only output is the fraction of maximum power delivered</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - EIFER 08/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EIFER  (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>H. Blervaque 09/2013 : Remplacement du contr&ocirc;le gradué par un contr&ocirc;leur PI car cela poser d'une part des problème de convergence et d'autre part ce type de régulation a été remplacé par un contr&ocirc;le plus souple (type PI) dans les équipements. Repositionnement des ic&ocirc;nes des variables d'entrées/sorties</p>
</html>"));
end PGS_controller;
