within BuildSysPro.Systems.Controls;
model PIDSingleOrDualMode
  "Heating and cooling regulation with constant or prescribed setpoints"

  parameter Boolean heating_mode=true "Activation of heating"
    annotation(Evaluate=true,Dialog(group="Model configuration"),
    choices(choice=true "Activated", choice=false "Not Activated", radioButtons=true));
  parameter Boolean cooling_mode=true "Activation of cooling"
    annotation(Evaluate=true,Dialog(group="Model configuration"),
    choices(choice=true "Activated", choice=false "Not Activated", radioButtons=true));
  parameter Boolean use_T_input=false "Temperature setpoints entry"
    annotation(Evaluate=true,Dialog(group="Model configuration"),
    choices(choice=true "Prescribed", choice=false "Fixed", radioButtons=true));
  parameter Boolean use_power_integrators=false "Integrators on the heating and cooling power outputs"
    annotation(Evaluate=true,Dialog(group="Model configuration"),
    choices(choice=true "Yes", choice=false "No", radioButtons=true));

  parameter Modelica.Units.SI.Power power_nom_heat=1e4
    "Nominal heating power of the system"
    annotation (Dialog(group="Heating and cooling system parameters"));
  parameter Modelica.Units.SI.Power power_nom_cool=1e4
    "Nominal cooling power of the system (defined as positive)"
    annotation (Dialog(group="Heating and cooling system parameters"));

  parameter Modelica.Units.NonSI.Temperature_degC T_heat_sp_degC=20
    "Heating setpoint temperature [degC]" annotation (Dialog(group=
          "Heating and cooling system parameters", enable=not use_T_input and
          activated_mode <> 3));
  parameter Modelica.Units.NonSI.Temperature_degC T_cool_sp_degC=25
    "Cooling setpoint temperature [degC]" annotation (Dialog(group=
          "Heating and cooling system parameters", enable=not use_T_input and
          activated_mode <> 2));

  parameter Real k(min=0) = 1e5 "Gain of controller"
    annotation(Dialog(group="PID parameters"));
  parameter Modelica.Units.SI.Time Ti(
    min=Modelica.Constants.small,
    start=0.5) = 900 "Time constant of Integrator block"
    annotation (Dialog(group="PID parameters"));
  parameter Modelica.Units.SI.Time Td(
    min=0,
    start=0.1) = 0 "Time constant of Derivative block"
    annotation (Dialog(group="PID parameters"));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_room
   annotation (Placement(transformation(extent={{20,76},{40,96}}),
     iconTransformation(extent={{-90,-10},{-70,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor measT_room
    annotation (Placement(transformation(extent={{60,76},{80,96}})));

  Modelica.Blocks.Sources.Constant T_heat_param(k=T_heat_sp_degC) if
    (heating_mode and not use_T_input)
    "Temperature setpoint for heating (parameter) [degC]"
    annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Modelica.Blocks.Sources.Constant T_cool_param(k=T_cool_sp_degC) if
    (cooling_mode and not use_T_input)
    "Temperature setpoint for cooling (parameter) [degC]"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));

  Modelica.Blocks.Interfaces.RealInput T_heat_sp_input_degC if
    (heating_mode and use_T_input)
    "Temperature setpoint for heating (RealInput) [degC]"
    annotation (Placement(transformation(extent={{110,30},{70,70}}),
      iconTransformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Interfaces.RealInput T_cool_sp_input_degC if
    (cooling_mode and use_T_input)
    "Temperature setpoint for cooling (RealInput) [degC]"
      annotation (Placement(transformation(extent={{110,-80},{70,-40}}),
        iconTransformation(extent={{-50,-50},{-30,-30}})));

  BuildSysPro.BaseClasses.HeatTransfer.Units.ToKelvin toKelvin_heat if heating_mode
    annotation (Placement(transformation(extent={{38,11},{20,29}})));
  BuildSysPro.BaseClasses.HeatTransfer.Units.ToKelvin toKelvin_cool if cooling_mode
    annotation (Placement(transformation(extent={{38,-29},{20,-11}})));

  Modelica.Blocks.Continuous.LimPID PID_heat(
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=power_nom_heat,
    yMin=0.,
    initType=Modelica.Blocks.Types.Init.InitialState) if heating_mode
    annotation (Placement(transformation(extent={{0,10},{-20,30}})));
  Modelica.Blocks.Continuous.LimPID PID_cool(
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=0,
    yMin=-power_nom_cool,
    initType=Modelica.Blocks.Types.Init.InitialState) if cooling_mode
    annotation (Placement(transformation(extent={{0,-10},{-20,-30}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeating if heating_mode
    annotation (Placement(transformation(extent={{-60,10},{-80,30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCooling if cooling_mode
    annotation (Placement(transformation(extent={{-60,-30},{-80,-10}})));

  Modelica.Blocks.Interfaces.RealOutput heating_power_W if heating_mode
    "Heating Power [W]"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}}),
        iconTransformation(extent={{70,50},{90,70}})));
  Modelica.Blocks.Math.Gain NegToPos(k=-1) if cooling_mode
    annotation (Placement(transformation(extent={{-32,-76},{-20,-64}})));
  Modelica.Blocks.Interfaces.RealOutput cooling_power_W if cooling_mode
    "Cooling Power [W]"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}}),
        iconTransformation(extent={{70,-30},{90,-10}})));

  Modelica.Blocks.Continuous.Integrator integratorHeating(k=1/(1000*3600)) if
    (heating_mode and use_power_integrators)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.Blocks.Continuous.Integrator integratorCooling(k=1/(1000*3600)) if
    (cooling_mode and use_power_integrators)
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Blocks.Interfaces.RealOutput heating_energy_kWh if
    (heating_mode and use_power_integrators)
    "Heating Energy [kWh]"
    annotation (Placement(transformation(extent={{40,50},{60,70}}),
      iconTransformation(extent={{70,10},{90,30}})));
  Modelica.Blocks.Interfaces.RealOutput cooling_energy_kWh if
    (cooling_mode and use_power_integrators)
    "Cooling Energy [kWh]"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}}),
      iconTransformation(extent={{70,-70},{90,-50}})));

equation

  connect(toKelvin_heat.Celsius, T_heat_sp_input_degC) annotation (Line(points={
          {39.8,20},{50,20},{50,50},{90,50}}, color={0,0,127}));
  connect(toKelvin_cool.Celsius, T_cool_sp_input_degC) annotation (Line(points={
          {39.8,-20},{50,-20},{50,-60},{90,-60}}, color={0,0,127}));
  connect(T_heat_param.y, toKelvin_heat.Celsius) annotation (Line(
    points={{59,20},{39.8,20}}, color={0,0,127}));
  connect(T_cool_param.y, toKelvin_cool.Celsius) annotation (Line(
    points={{59,-20},{39.8,-20}},color={0,0,127}));

  connect(measT_room.T, PID_heat.u_m) annotation (Line(
    points={{80,86},{100,86},{100,0},{-10,0},{-10,8}},color={0,0,127}));
  connect(toKelvin_heat.Kelvin, PID_heat.u_s) annotation (Line(
    points={{19.1,20},{2,20}},color={0,0,127}));
  connect(PID_heat.y, prescribedHeating.Q_flow) annotation (Line(
    points={{-21,20},{-60,20}},color={0,0,127}));

  connect(measT_room.T, PID_cool.u_m) annotation (Line(
    points={{80,86},{100,86},{100,0},{-10,0},{-10,-8}},color={0,0,127}));
  connect(toKelvin_cool.Kelvin, PID_cool.u_s) annotation (Line(
    points={{19.1,-20},{2,-20}},color={0,0,127}));
  connect(PID_cool.y, prescribedCooling.Q_flow) annotation (Line(
    points={{-21,-20},{-60,-20}},color={0,0,127}));

  connect(prescribedCooling.port, T_room) annotation (Line(
    points={{-80,-20},{-90,-20},{-90,86},{30,86}},color={191,0,0}));
  connect(prescribedHeating.port, T_room) annotation (Line(
    points={{-80,20},{-90,20},{-90,86},{30,86}},color={191,0,0}));
  connect(T_room,measT_room. port) annotation (Line(
    points={{30,86},{60,86}},color={191,0,0}));

  connect(PID_heat.y, heating_power_W) annotation (Line(
    points={{-21,20},{-50,20},{-50,70},{-30,70}}, color={0,0,127}));
  connect(PID_heat.y, integratorHeating.u) annotation (Line(
    points={{-21,20},{-50,20},{-50,60},{-2,60}}, color={0,0,127}));
  connect(integratorHeating.y, heating_energy_kWh)
    annotation (Line(points={{21,60},{50,60}},color={0,0,127}));

  connect(PID_cool.y, NegToPos.u) annotation (Line(
    points={{-21,-20},{-50,-20},{-50,-70},{-33.2,-70}}, color={0,0,127}));
  connect(NegToPos.y, cooling_power_W) annotation (Line(
    points={{-19.4,-70},{-10,-70},{-10,-50},{10,-50}},color={0,0,127}));
  connect(NegToPos.y, integratorCooling.u) annotation (Line(
    points={{-19.4,-70},{-10,-70},{-10,-80},{-2,-80}},color={0,0,127}));
  connect(integratorCooling.y, cooling_energy_kWh)
    annotation (Line(points={{21,-80},{50,-80}},color={0,0,127}));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
      {100,100}})),           Icon(coordinateSystem(preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}), graphics={
    Ellipse(
      extent={{-20,-98},{20,-60}},
      lineColor={0,0,0},
      lineThickness=0.5,
      fillColor={0,0,255},
      fillPattern=FillPattern.Solid),
    Rectangle(
      extent={{-12,0},{12,-68}},
      fillColor={0,0,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Rectangle(
      extent={{-12,60},{12,0}},
      lineColor={255,0,0},
      fillColor={255,0,0},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-12,60},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,
        80},{12,60},{-12,60}},
      lineColor={0,0,0},
      lineThickness=0.5),
    Line(
      points={{-12,60},{-12,-64}},
      color={0,0,0},
      thickness=0.5),
    Line(
      points={{12,60},{12,-64}},
      color={0,0,0},
      thickness=0.5),
    Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
    Line(points={{-40,0},{-12,0}},   color={0,0,0}),
    Line(points={{-40,60},{-12,60}}, color={0,0,0}),
    Text(
      extent={{-120,140},{120,100}},
      lineColor={0,0,255},
      textString="%name"),
    Rectangle(
      extent={{64,4},{94,76}},
      lineColor={0,0,127},
      fillColor={255,0,0},
      fillPattern=FillPattern.Solid),
    Rectangle(
      extent={{64,-76},{96,-4}},
      lineColor={0,0,127},
      fillColor={0,0,255},
      fillPattern=FillPattern.Solid),
    Line(
      points={{12,40},{64,40}},
      color={255,0,0},
      thickness=0.5),
    Line(points={{-80,0}}, color={255,0,0}),
    Line(
      points={{-80,0},{-2,0}},
      color={255,0,0},
      thickness=0.5),
    Line(
      points={{12,-40},{64,-40}},
      color={0,0,255},
      thickness=0.5)}),
  Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Simple model based on PIDs for the calculation of heating and/or cooling energy needs, with fixed or prescribed temperature setpoints.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>The temperature setpoints can be defined either :</p>
<ul>
<li>for <i>heating</i> if <code>heating_mode=true</code></li>
<li>for <i>cooling</i> if <span style=\"font-family: Courier New;\">cooling_mode=true</span></li>
<li>as fixed parameters if <span style=\"font-family: Courier New;\">use_T_input=false</span> (by default) : respectively <span style=\"font-family: Courier New;\">T_heat_sp_degC</span> and/or <span style=\"font-family: Courier New;\">T_cool_sp_degC</span></li>
<li>as RealInput if <span style=\"font-family: Courier New;\">use_T_input=true</span> : the connectors <span style=\"font-family: Courier New;\">T_heat_input_degC</span> and/or <span style=\"font-family: Courier New;\">T_cool_input_degC</span> shall be connected to blocks that generate the signal for respectively heating and cooling temperature setpoint</li>
</ul>
<p>These temperature setpoints are stated in degree Celsius.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Of course, this model should not be used if <span style=\"font-family: Courier New;\">T_heat_sp</span> &gt; <span style=\"font-family: Courier New;\">T_cool_sp</span> or <span style=\"font-family: Courier New;\">T_heat_sp_input</span> &gt; <span style=\"font-family: Courier New;\">T_cool_sp_input</span>.</p>
<p>Safeguards should be added to prevent bug.</p>
<p><u><b>Validations</b></u></p>
<p>Validations through comparaison with PIDFixedDualMode and PIDPrescribedSingleMode and simulations within the ANR MERUBBI project - Mathias Bouquerel 05/2019</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2019<br>
BuildSysPro version 3.5.0<br>
Author : Mathias BOUQUEREL, EDF (2019)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
</html>"));
end PIDSingleOrDualMode;
