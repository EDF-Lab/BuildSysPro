within BuildSysPro.Systems.Controls;
model PIDFixed
  "PID control model connectable to an indoor air port of a building "

  parameter Modelica.SIunits.Temperature Tc=293.15 "Setpoint temperature";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PID
    "Type of controller";
  parameter Real k=30 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=60 "Time constant of Integrator block";
  parameter Modelica.SIunits.Time Td=0 "Time constant of Derivative block";
  parameter Real yMax=10000 "Upper limit of output";
  parameter Real yMin=0 "Lower limit of output";
  parameter Real Ni=0.1 "Ni*Ti is time constant of anti-windup compensation";
  parameter Modelica.Blocks.Types.InitPID initType=Modelica.Blocks.Types.InitPID.InitialState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)";
  parameter Boolean limitsAtInit=true
    "= false, if limits are ignored during initializiation";

  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    yMax=yMax,
    yMin=yMin,
    Ni=Ni,
    initType=initType,
    limitsAtInit=limitsAtInit)
    annotation (Placement(transformation(extent={{32,-4},{12,-24}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-10,-38},{-30,-18}})));
  Modelica.Blocks.Sources.Constant setpoint(k=Tc)
    annotation (Placement(transformation(extent={{90,-62},{70,-42}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{-54,-39},{-74,-18}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{68,18},{48,38}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_room
    "Temperature to control" annotation (Placement(transformation(extent={{40,
            76},{60,96}}), iconTransformation(extent={{40,76},{60,96}})));

  Modelica.Blocks.Interfaces.RealOutput Power
    "Flux of heating and cooling system" annotation (Placement(transformation(
          extent={{-6,-88},{24,-58}}), iconTransformation(extent={{80,-80},{100,
            -60}})));

equation
  connect(PID.y,prescribedHeatFlow. Q_flow) annotation (Line(
      points={{11,-14},{-2,-14},{-2,-28},{-10,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setpoint.y, PID.u_s) annotation (Line(
      points={{69,-52},{40,-52},{40,-14},{34,-14}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(T_room, temperatureSensor.port) annotation (Line(
      points={{50,86},{80,86},{80,28},{68,28}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, PID.u_m) annotation (Line(points={{48,28},{22,28},
          {22,-2},{22,-2}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, heatFlowSensor.port_a) annotation (Line(
        points={{-30,-28},{-41.5,-28},{-41.5,-28.5},{-54,-28.5}},     color={191,
          0,0}));
  connect(heatFlowSensor.port_b, T_room) annotation (Line(points={{-74,-28.5},{
          -78,-28.5},{-86,-28.5},{-86,86},{50,86}}, color={191,0,0}));
  connect(Power, heatFlowSensor.Q_flow)
    annotation (Line(points={{9,-73},{-64,-73},{-64,-39}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>PID control model to be connected to the air port of the temperature that must be regulated (eg TairInt).</p>
<p>Constant temperature given as setpoint.</p>
<p>Heating and cooling supplied to ensure the setpoint.</p>
<p>The output <b>Power</b> is positive when heating is needed, and negative when cooling is needed.<p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aurélie Kaemmerlen 2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p></html>",
      revisions="<html>
<p>Gilles Plessis Juin 2012 Validation effectuée</p>
<p><ul>
<li>Changement du modèle de capteur de température pour celui de la bibliothèque BuildSysPro au lieu de la bibliothèque Modelica et modification de l'unité de température en K.</li>
</ul></p>
<p>Mathias Bouquerel 12/2016 : inversion du sens du HeatFlowSensor pour avoir un flux positif pour le chauffage et négatif pour la climatisation, et utilisation du modèle BuildSysPro pour ce HeatFlowSensor au lieu de celui de Modelica.</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-82,58},{-82,-86}}, color={192,192,192}),
        Polygon(
          points={{-82,68},{-90,46},{-74,46},{-82,68}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-92,-86},{80,-86}}, color={192,192,192}),
        Polygon(
          points={{88,-86},{66,-78},{66,-94},{88,-86}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-82,-86},{-82,16},{-82,-38},{28,42},{78,42}},
            color={0,0,127}),
        Text(
          extent={{-14,-26},{58,-66}},
          lineColor={192,192,192},
          textString="PID"),
        Text(
          extent={{-82,84},{110,36}},
          lineColor={0,0,0},
          textString="Tc=%Tc °C")}));
end PIDFixed;
