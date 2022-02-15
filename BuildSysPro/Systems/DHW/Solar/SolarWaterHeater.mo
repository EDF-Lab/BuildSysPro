within BuildSysPro.Systems.DHW.Solar;
model SolarWaterHeater
  "Individual solar hot water heater model derived from the combination of a solar thermal panel and a thermodynamic tank"

  parameter Modelica.Units.SI.Volume Volume(displayUnit="l") = 0.3
    "Tank capacity" annotation (Dialog(group="Tank parameters"));
  parameter Modelica.Units.SI.Length Hauteur=1.8 "Tank height"
    annotation (Dialog(group="Tank parameters"));
  parameter Modelica.Units.SI.Power Pmax=2000 "Electrical resistance power"
    annotation (Dialog(group="Tank parameters"));
  parameter Boolean type_T_cold=false "Prescribed or fixed cold water temperature"   annotation(Evaluate=true,HideResult=true,Dialog(group="Tank parameters"),choices(choice=true
        "Prescribed",                                                                       choice=false "Fixed",   radioButtons=true));
  parameter Modelica.Units.SI.Temperature T_cold_fixed=283.15
    "Cold water temperature"
    annotation (Dialog(group="Tank parameters", enable=not type_T_cold));
  parameter Modelica.Units.SI.Temperature T_sp=337.15 "Setpoint temperature"
    annotation (Dialog(group="Tank parameters"));
  parameter Modelica.Units.SI.TemperatureDifference BP=3
    "Hysteresis on both sides of Tcons"
    annotation (Dialog(group="Tank parameters"));

  parameter Modelica.Units.NonSI.Angle_deg Azimut=0
    "Azimuth of the surface (orientation relative to the South) - S=0°, E=-90°, O=90°, N=180°"
    annotation (Dialog(group="Sensor parameters"));
  parameter Modelica.Units.NonSI.Angle_deg Inclinaison=30
    "Surface tilt of the relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°"
    annotation (Dialog(group="Sensor parameters"));
  parameter Real Albedo=0.2 "Albedo of environnement" annotation (Dialog(group="Sensor parameters"));
  parameter Modelica.Units.SI.Area Surface=4 "Solar sensor surface"
    annotation (Dialog(group="Sensor parameters"));
  parameter Real FacteurOptique=0.65
    "Optical factor (generally between 0.5 and 0.9)" annotation (Dialog(group="Sensor parameters"));
  parameter Real CoeffTransmission=4
    "Sensor transmission coefficient (depends on the insulation and on the nature of the coverage)"     annotation (Dialog(group="Sensor parameters"));

  Electric.WaterTank                eCSThermoSol(
    Volume=Volume,
    Pmax=Pmax,
    type_T_cold=type_T_cold,
    T_cold_fixed=T_cold_fixed,
    T_sp=T_sp,
    Hauteur=Hauteur,
    BP=BP,
    nc=10,
    ncInj=9) annotation (Placement(transformation(extent={{0,-44},{80,36}})));

  Modelica.Blocks.Interfaces.RealInput T_cold(start=0) if type_T_cold "Cold water temperature (K)"
                                                                     annotation (
      Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-100}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={66,-102})));

  Modelica.Blocks.Interfaces.RealInput debit(start=0) "Drawing rate in kg/h"
                                                                     annotation (
      Placement(transformation(extent={{-120,-120},{-80,-80}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,90})));

  Modelica.Blocks.Interfaces.RealOutput Pelec
    "Power consumed by the electrical backup" annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{
            100,20},{120,40}})));

  Modelica.Blocks.Interfaces.RealInput OnOff(start=20) "Electric backup ON/OFF"
                                                           annotation (
      Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-10,100}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,90})));
  Modelica.Blocks.Interfaces.RealInput G[10]
    "Meteo data: {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle, Solar elevation angle}"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-78,40},{-58,60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext annotation (
      Placement(transformation(extent={{-100,40},{-80,60}}), iconTransformation(
          extent={{-78,64},{-58,84}})));

  BuildSysPro.Systems.Solar.Thermal.SolarThermalCollector
    capteurSolaireThermiqueHeatPort(
    Azimut=Azimut,
    Inclinaison=Inclinaison,
    Albedo=Albedo,
    Surface=Surface,
    FacteurOptique=FacteurOptique,
    CoeffTransmission=CoeffTransmission)
    annotation (Placement(transformation(extent={{-80,-36},{-20,24}})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int
    "Room in which is located the tank - tank losses are injected there"
    annotation (Placement(transformation(extent={{30,80},{50,100}}),
        iconTransformation(extent={{56,80},{76,100}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=270,
        origin={40,62})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow InjectionPertes
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={85,65})));
  Modelica.Blocks.Interfaces.RealOutput Cons "Consumption" annotation (
      Placement(transformation(extent={{90,10},{110,30}}), iconTransformation(
          extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput T_out "Output water temperature (K)"
    annotation (Placement(transformation(extent={{88,32},{108,52}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,90})));

equation
  if type_T_cold then
    connect(eCSThermoSol.T_cold, T_cold);
  end if;

  connect(OnOff, eCSThermoSol.OnOff) annotation (Line(
      points={{-10,100},{-10,20},{4,20}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(eCSThermoSol.Pelec, Pelec) annotation (Line(
      points={{76,0},{100,0}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(debit, eCSThermoSol.debit) annotation (Line(
      points={{-100,-100},{-8,-100},{-8,-28},{4,-28}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(capteurSolaireThermiqueHeatPort.T_solar, eCSThermoSol.T_solar)
    annotation (Line(
      points={{-23,-21},{-23,-15.5},{4,-15.5},{4,-16}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(capteurSolaireThermiqueHeatPort.T_ext, T_ext) annotation (Line(
      points={{-68,16.2},{-68,50},{-90,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(capteurSolaireThermiqueHeatPort.G, G) annotation (Line(
      points={{-68,8.4},{-68,10},{-100,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_int, temperatureSensor.port) annotation (Line(
      points={{40,90},{40,66}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, eCSThermoSol.T_int) annotation (Line(
      points={{40,57.6},{40,57.6},{40,40},{12,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(InjectionPertes.port, T_int) annotation (Line(
      points={{80,65},{46.85,65},{46.85,90},{40,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(InjectionPertes.Q_flow, eCSThermoSol.Perte) annotation (
      Line(
      points={{90,65},{120,65},{120,-24},{76,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eCSThermoSol.Cons, Cons) annotation (Line(
      points={{76,9.6},{76,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eCSThermoSol.T_out, T_out) annotation (Line(points={{76,32},{84,32},{84,
          42},{98,42}}, color={0,0,127}));
  annotation (                   Icon(graphics={
        Ellipse(
          extent={{-98,92},{-38,32}},
          lineColor={255,170,85},
          fillColor={255,255,85},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,26},{-50,2},{-54,2},{-46,0},{-44,6},{-48,4},{-60,26}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,128,0}),
        Rectangle(
          extent={{34,70},{94,-92}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{34,70},{94,12}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{36,12},{94,12}},
          color={255,85,85},
          smooth=Smooth.None),
        Polygon(
          points={{-48,38},{-38,14},{-42,14},{-34,12},{-32,18},{-36,16},{-48,38}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,128,0}),
        Polygon(
          points={{-38,54},{-28,30},{-32,30},{-24,28},{-22,34},{-26,32},{-38,54}},
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={255,128,0}),
        Polygon(
          points={{-78,-70},{-18,30},{42,30},{-18,-92},{-78,-70}},
          smooth=Smooth.None,
          fillColor={44,44,44},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          lineThickness=1)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Called ISWH for individual solar hot water heater, this domestic hot water production system combines a solar sensor and a domestic hot water tank with an electric back-up.</p>
<p>It combines a solar sensor model and a domestic hot water model. Heat recovered by the plane sensor is transferred to the hot water tank.The hot water tank can be placed in a room heated or not. Refer to the sensor and the tank models for more information on their specificities.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>This is a simplified model that does not take into account the heat transfer fluid, thus neither the sensor inertia nor the consumption of fluid circulation auxiliary are not taken into account.</p>
<p>Take care to respect the units of inputs such as the drawing scenario rate in kg / h.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 06/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Hubert BLERVAQUE, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
<p>Hubert Blervaque 06/2012 : Modification de la sortie réelle <code>T_int</code> en un port thermique correspondant à la zone dans laquelle est située le ballon ECS et à laquelle les pertes du ballon sont appliquées.</p>
<p>Benoît Charrier 01/2018 : Added <code>T_out</code> (output water temperature). Added choice between prescribed or fixed for the cold water temperature.</p>
</html>"));
end SolarWaterHeater;
