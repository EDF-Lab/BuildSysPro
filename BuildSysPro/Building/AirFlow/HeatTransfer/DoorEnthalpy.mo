within BuildSysPro.Building.AirFlow.HeatTransfer;
model DoorEnthalpy "Enthalpy transfer through a door"

extends BaseClasses.HeatTransfer.Interfaces.Element1D;

  parameter Modelica.Units.SI.Density rho=1.24;
  parameter Modelica.Units.SI.SpecificHeatCapacityAtConstantPressure Cp=1005;
parameter Real Cd=0.87 "Discharge coefficient";
  parameter Modelica.Units.SI.Length H "Height of the door";
  parameter Modelica.Units.SI.Length L "Width of the door";

equation
Q_flow = (Cd/3)*sqrt(Modelica.Constants.g_n*H^3)*rho*273.15*Cp*L*(2*dT/(port_a.T+port_b.T))^1.5;

  annotation (
Documentation(info="<HTML>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Adaptation of TF121 model from CLIM2000.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Reference temperature : 273.15 K</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : EDF (2010)<br>
--------------------------------------------------------------</b></p>
</HTML>
"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(
          points={{-78,8},{74,8},{64,14}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,8},{74,8},{64,2}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,-6},{74,-6},{64,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-78,-6},{74,-6},{64,-12}},
          color={0,128,255},
          smooth=Smooth.None),
        Polygon(
          points={{-40,100},{-40,-100},{14,-82},{14,90},{-40,100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          smooth=Smooth.None,
          fillColor={152,130,8}),
        Line(
          points={{-40,100},{20,100},{20,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,-100},{20,-100}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,-100},{20,-80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,80},{20,-82}},
          color={0,0,0},
          smooth=Smooth.None)}));
end DoorEnthalpy;
