within BuildSysPro.Systems.Controls;
model PIDDualMode
  "Heating and cooling regulation with constant or prescribed setpoints"

  parameter Boolean use_sp_input=false "Temperature setpoints entry"
   annotation(Evaluate=true,HideResult=true,Dialog(group="Model configuration"),
   choices(choice=true "Prescribed", choice=false "Fixed", radioButtons=true));

  parameter Modelica.SIunits.Power power_nom_heat=1000
    "Nominal heating power of the system"
    annotation(Dialog(group="Heating and cooling system parameters"));
  parameter Modelica.SIunits.Power power_nom_cool=1000
    "Nominal cooling power of the system (defined as positive)"
    annotation(Dialog(group="Heating and cooling system parameters"));

  parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_heat=20
    "Heating setpoint temperature in °C"
    annotation(Dialog(group="Heating and cooling system parameters", enable=not use_sp_input));
  parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_cool=25
    "Cooling setpoint temperature in °C"
    annotation(Dialog(group="Heating and cooling system parameters", enable=not use_sp_input));

  parameter Real k(min=0) = 1e4 "Gain of controller"
    annotation(Dialog(group="PID parameters"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small, start=0.5)=60
    "Time constant of Integrator block"
    annotation(Dialog(group="PID parameters"));
  parameter Modelica.SIunits.Time Td(min=0, start= 0.1)=0
    "Time constant of Derivative block"
    annotation(Dialog(group="PID parameters"));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_room annotation (
     Placement(transformation(extent={{20,76},{40,96}}), iconTransformation(
          extent={{-100,-50},{-80,-30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor measT_room annotation (Placement(transformation(extent={{60,76},
            {80,96}})));

  Modelica.Blocks.Sources.Constant sp_heat_param(k=T_heat) if not use_sp_input
    "Temperature setpoint for heating (parameter) °C"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Modelica.Blocks.Sources.Constant sp_cool_param(k=T_cool) if not use_sp_input
    "Temperature setpoint for cooling (parameter) °C"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));

  Modelica.Blocks.Interfaces.RealInput sp_heat_input if use_sp_input
    "Temperature setpoint for heating (RealInput) °C"
    annotation (Placement(
        transformation(extent={{116,42},{80,78}}),
        iconTransformation(extent={{-100,69},
        {-78,91}})));
  Modelica.Blocks.Interfaces.RealInput sp_cool_input if use_sp_input
    "Temperature setpoint for cooling (RealInput) °C"
    annotation (Placement(
        transformation(extent={{116,-38},{80,-2}}),
        iconTransformation(extent={{-100,9},
        {-78,31}})));

  BaseClasses.HeatTransfer.Units.ToKelvin
                                    toKelvin_cool
    annotation (Placement(transformation(extent={{38,-9},{20,9}})));
  BaseClasses.HeatTransfer.Units.ToKelvin
                                    toKelvin_heat
    annotation (Placement(transformation(extent={{38,31},{20,49}})));

  Modelica.Blocks.Continuous.LimPID PID_heat(
    Ni=0.1,
    yMin=0.,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=power_nom_heat)
    annotation (Placement(transformation(extent={{0,30},{-20,50}})));
  Modelica.Blocks.Continuous.LimPID PID_cool(
    Ni=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    initType=Modelica.Blocks.Types.InitPID.NoInit,
    yMax=0,
    k=k,
    Ti=Ti,
    Td=Td,
    yMin=-power_nom_cool)
    annotation (Placement(transformation(extent={{0,10},{-20,-10}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeating if
       (use_sp_input or twoDifferentSetpoints)
    annotation (Placement(transformation(extent={{-30,31},{-50,52}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedCooling if
       (use_sp_input or twoDifferentSetpoints)
     annotation (Placement(transformation(extent={{-30,-9},{-50,12}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature if
      (not use_sp_input and not twoDifferentSetpoints)
    annotation (Placement(transformation(extent={{-20,60},{-40,80}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sensors.HeatFlowSensor heatFlux
    annotation (Placement(transformation(extent={{-70,10},{-90,30}})));

  Modelica.Blocks.Sources.Constant Zero(k=0)
    annotation (Placement(transformation(extent={{-76,-56},{-64,-44}})));
  Modelica.Blocks.Math.Max heatingFilter
    annotation (Placement(transformation(extent={{-52,-40},{-32,-20}})));
  Modelica.Blocks.Math.Min coolingFilter
    annotation (Placement(transformation(extent={{-52,-80},{-32,-60}})));

  Modelica.Blocks.Interfaces.RealOutput heatingPower_W "Heating Power [W]"
    annotation (Placement(transformation(extent={{4,-50},{24,-30}}),
        iconTransformation(extent={{72,70},{92,90}})));
  Modelica.Blocks.Math.Gain NegToPos(k=-1)
    annotation (Placement(transformation(extent={{-20,-76},{-8,-64}})));
  Modelica.Blocks.Interfaces.RealOutput coolingPower_W "Cooling Power [W]"
    annotation (Placement(transformation(extent={{4,-80},{24,-60}}),
        iconTransformation(extent={{72,-50},{92,-30}})));

  Modelica.Blocks.Continuous.Integrator integratorHeating(k=1/(1000*3600))
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Continuous.Integrator integratorCooling(k=1/(1000*3600))
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Interfaces.RealOutput heatingEnergy_kWh
    "Heating Energy [kWh]" annotation (Placement(transformation(extent={{80,-60},
            {100,-40}}), iconTransformation(extent={{72,30},{92,50}})));
  Modelica.Blocks.Interfaces.RealOutput coolingEnergy_kWh
    "Cooling Energy [kWh]" annotation (Placement(transformation(extent={{80,-90},{100,-70}}),
                         iconTransformation(extent={{72,-90},{92,-70}})));

protected
  parameter Boolean twoDifferentSetpoints = (T_heat <> T_cool);

equation

  if use_sp_input then
    connect(toKelvin_heat.Celsius, sp_heat_input) annotation (Line(points={{39.8,40},{50,
            40},{50,60},{98,60}},   color={0,0,127}));
    connect(toKelvin_cool.Celsius, sp_cool_input) annotation (Line(points={{39.8,0},{50,
            0},{50,-20},{98,-20}},                                                                  color={0,0,127}));
  else
    connect(sp_heat_param.y, toKelvin_heat.Celsius) annotation (Line(points={{59,40},
          {59,40},{39.8,40}},                                                            color={0,0,127}));
    connect(sp_cool_param.y, toKelvin_cool.Celsius) annotation (Line(points={{59,0},{39.8,
            0}},                                                                           color={0,0,127}));
  end if;

  connect(heatFlux.port_b, T_room) annotation (Line(
      points={{-90,20},{-94,20},{-94,86},{30,86}},
      color={191,0,0}, smooth=Smooth.None));
  connect(T_room,measT_room. port) annotation (Line(
      points={{30,86},{60,86}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(measT_room.T, PID_heat.u_m) annotation (Line(
      points={{80,86},{100,86},{100,20},{-10,20},{-10,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvin_heat.Kelvin, PID_heat.u_s) annotation (Line(points={{19.1,40},
          {19.1,40},{2,40}}, color={0,0,127}));
  connect(PID_heat.y, prescribedHeating.Q_flow) annotation (Line(
      points={{-21,40},{-24,40},{-24,40.03},{-31,40.03}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeating.port, heatFlux.port_a) annotation (Line(
      points={{-51,40.03},{-60,40.03},{-60,20},{-70,20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(measT_room.T, PID_cool.u_m) annotation (Line(
      points={{80,86},{100,86},{100,20},{-10,20},{-10,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvin_cool.Kelvin, PID_cool.u_s) annotation (Line(points={{19.1,0},{2,0}},      color={0,0,127}));
  connect(PID_cool.y, prescribedCooling.Q_flow) annotation (Line(points={{-21,0},
          {-10,0},{-10,0.03},{-31,0.03}},                                                                                 color={0,0,127}));
  connect(prescribedCooling.port, heatFlux.port_a)   annotation (Line(
      points={{-51,0.03},{-60,0.03},{-60,20},{-70,20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(toKelvin_heat.Kelvin, prescribedTemperature.T) annotation (Line(
        points={{19.1,40},{10,40},{10,70},{-18,70}}, color={0,0,127}));
  connect(prescribedTemperature.port, heatFlux.port_a) annotation (Line(points={{-40,70},
          {-60,70},{-60,20},{-70,20}},          color={191,0,0}));

  connect(heatFlux.Q_flow, heatingFilter.u1) annotation (Line(points={{-80,10},
          {-80,10},{-80,-24},{-54,-24}},color={0,0,127}));
  connect(heatFlux.Q_flow, coolingFilter.u2) annotation (Line(points={{-80,10},
          {-80,10},{-80,-76},{-54,-76}},color={0,0,127}));

  connect(Zero.y, heatingFilter.u2) annotation (Line(points={{-63.4,-50},{-60,
          -50},{-60,-36},{-54,-36}},
                                color={0,0,127}));
  connect(Zero.y, coolingFilter.u1) annotation (Line(points={{-63.4,-50},{-60,
          -50},{-60,-64},{-54,-64}},
                                color={0,0,127}));

  connect(heatingFilter.y, heatingPower_W) annotation (Line(points={{-31,-30},{-20,-30},
          {-20,-40},{14,-40}},         color={0,0,127}));
  connect(heatingFilter.y, integratorHeating.u) annotation (Line(points={{-31,-30},
          {-20,-30},{-20,-50},{38,-50}},
                                       color={0,0,127}));
  connect(integratorHeating.y, heatingEnergy_kWh) annotation (Line(points={{61,-50},
          {76,-50},{90,-50}},                                                                  color={0,0,127}));

  connect(coolingFilter.y, NegToPos.u) annotation (Line(points={{-31,-70},{-21.2,-70}}, color={0,0,127}));
  connect(NegToPos.y, coolingPower_W) annotation (Line(points={{-7.4,-70},{14,-70}},
                                                             color={0,0,127}));
  connect(NegToPos.y, integratorCooling.u) annotation (Line(points={{-7.4,-70},{0,-70},{
          0,-80},{38,-80}},                color={0,0,127}));
  connect(integratorCooling.y, coolingEnergy_kWh) annotation (Line(points={{61,-80},{76,-80},{90,-80}},     color={0,0,127}));

    annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}})),           Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,80},
              {12,40},{-12,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,40},{-12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,40},{12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
        Line(points={{-40,20},{-12,20}}, color={0,0,0}),
        Line(points={{-40,60},{-12,60}}, color={0,0,0}),
        Text(
          extent={{-110,134},{112,96}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{60,20},{100,100}},
          lineColor={0,0,127},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,-100},{100,-20}},
          lineColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{40,-40},{60,-40},{60,-40}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{40,20},{40,-80},{60,-80}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-78,80},{60,80}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{40,80},{40,40},{62,40}},
          color={255,0,0},
          thickness=0.5),
        Line(points={{-80,0}}, color={255,0,0}),
        Line(
          points={{-80,-40},{-12,-40}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-78,20},{40,20}},
          color={0,0,255},
          thickness=0.5)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Simple model of a heating and cooling system with fixed or prescribed temperature setpoints.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>The temperature setpoints for heating and cooling can be defined either :</p>
<ul>
<li>as fixed parameters if <code>use_sp_input=false</code> (by default) : respectively <code>T_heat</code> and <code>T_cool</code></li>
<li>as RealInput if <code>use_sp_input=true</code> : the connectors <code>sp_heat_input</code> and <code>sp_cool_input</code> shall be connected to blocks that generate the signal for respectively heating and cooling temperature setpoint</li>
</ul>
<p>These temperature setpoints are stated in &deg;C.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Of course, this model should not be used if <code>T_heat</code> &gt; <code>T_cool</code> or <code>sp_heat_input</code> &gt; <code>sp_cool_input</code>.</p>
<p>Safeguards should be added to prevent bug.</p>
<p><u><b>Validations</b></u></p>
<p>Validations through comparaison with PIDFixedDualMode and PIDPrescribedSingleMode and simulations within MERUBBI project - Mathias Bouquerel 01/2017<p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.0.0<br>
Author : Mathias BOUQUEREL, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions=""));
end PIDDualMode;
