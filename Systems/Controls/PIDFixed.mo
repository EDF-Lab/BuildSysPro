within BuildSysPro.Systems.Controls;
model PIDFixed
  "Modèle de régulation PID connectable au noeud d'air intérieur d'un bâtiment"

  parameter Modelica.SIunits.Temperature Tc=293.15 "Temperature de consigne";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PID
    "Type of controller";
  parameter Real k=30 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=60 "Time constant of Integrator block";
  parameter Modelica.SIunits.Time Td=0 "Time constant of Derivative block";
  parameter Real yMax=10000 "Upper limit of output";
  parameter Real yMin=0 "Lower limit of output";
  parameter Real Ni=0.1 "Ni*Ti is time constant of anti-windup compensation";
  parameter Modelica.Blocks.Types.InitPID initType=Modelica.Blocks.Types.InitPID.SteadyState
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
    annotation (Placement(transformation(extent={{30,-20},{10,-40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-12,-48},{-32,-28}})));
  Modelica.Blocks.Sources.Constant const(k=Tc)
    annotation (Placement(transformation(extent={{66,-62},{46,-42}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{-60,-32},{-40,-12}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{68,-20},{48,0}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T
    "Température à réguler" annotation (Placement(transformation(extent={{0,
            80},{20,100}}), iconTransformation(extent={{0,80},{20,100}})));

equation
  connect(PID.y,prescribedHeatFlow. Q_flow) annotation (Line(
      points={{9,-30},{-2,-30},{-2,-39.4},{-13,-39.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y,PID. u_s) annotation (Line(
      points={{45,-52},{40,-52},{40,-30},{32,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port,heatFlowSensor. port_b) annotation (
      Line(
      points={{-33,-39.4},{-33,-28.7},{-40,-28.7},{-40,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T,PID. u_m) annotation (Line(
      points={{48,-10},{48,-6},{20,-6},{20,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatFlowSensor.port_a, T) annotation (Line(
      points={{-60,-22},{-80,-22},{-80,90},{10,90}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(T, temperatureSensor.port) annotation (Line(
      points={{10,90},{80,90},{80,-10},{68,-10}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p><h4>Modèle de régulation PID à connecter au noeud de température qu'il faut réguler (TairInt par exemple)</h4></p>
<p>- Température constante donnée en consigne</p>
<p>- Chauffage et rafraîchissement fournis en conséquent pour assurer la consigne</p>
<p><br>Modèle validé - Aurélie Kaemmerlen 2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p></html>",
      revisions="<html>
<p>Gilles Plessis Juin 2012 Validation effectuée</p>
<p><ul>
<li>Changement du modèle de capteur de température pour celui de la bibliothèque ENERBAT au lieu de la bibliothèque Modelica et modification de l'unité de température en K.</li>
</ul></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
                    graphics),
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
