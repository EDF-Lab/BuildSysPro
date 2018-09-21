within BuildSysPro.Building.AirFlow.HeatTransfer;
model AirNode "Air node"

  parameter Modelica.SIunits.Volume V "Air node volume [m3]";
  parameter Modelica.SIunits.Temperature Tair "Initial air temperature";
  constant Modelica.SIunits.SpecificHeatCapacityAtConstantVolume Cv=713
    "Isochoric heat capacity of air [J/kg.K]";
  constant Modelica.SIunits.Density rho=1.24 "Air density [kg/m3]";

  BaseClasses.HeatTransfer.Components.HeatCapacitor VolAir(C=Cv*rho*V, T(start=
          Tair, displayUnit="degC")) annotation (Placement(transformation(
          extent={{-20,24},{0,44}}, rotation=0)));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a annotation (Placement(
        transformation(extent={{-8,-54},{6,-40}}, rotation=0),
        iconTransformation(extent={{-20,-60},{20,-20}})));

equation
  connect(VolAir.port, port_a) annotation (Line(
      points={{-9,25},{-9,11.5},{-1,11.5},{-1,-47}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(extent={{-148.5,-105},{148.5,105}},
          preserveAspectRatio=true), graphics),                             Icon(coordinateSystem(extent={{-100,
            -100},{100,100}}, preserveAspectRatio=true), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,128,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
          Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None), Text(
          extent={{-117,18},{111,-22}},
          lineColor={0,0,0},
          textString="V=%V m3")}),
    Documentation(info="<html>
<p><i><b>Air node in pure thermal modelling</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model is used to represent the thermal inertia of an air node in pure thermal modelling, meaning that no mass flow rate is considered explicitelly.</p>
<p>This model can be used to represent a room or even multiple homogeneous thermal zone (same temperature setpoint, same boundary conditions...</p>
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
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>
"));
end AirNode;
