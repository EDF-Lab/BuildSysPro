within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model ThermalBridge "Linear thermal bridge model"
  parameter Modelica.Units.SI.Length L "Length of the thermal bridge";
  parameter Modelica.Units.SI.ThermalConductivity k
    "Thermal conductivity of the thermal bridge";

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Indoor temperature"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    thermalConductor(G=k*L)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(thermalConductor.port_b, T_int) annotation (Line(
      points={{9,0},{90,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_a, T_ext) annotation (Line(
      points={{-9,0},{-90,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-60,100},{-40,-102}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10.5,55.5},{10.5,-55.5}},
          origin={14.5,-0.5},
          rotation=90,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,100},{-30,10}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-12},{-30,-102}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-24,0},{-70,0},{-64,4},{-70,0},{-64,-4}},
          color={255,0,0},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Model based on the basic component <a href=\"modelica://BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor\"><code>ThermalConductor</code></a>.</p>
<p>The thermal conductance G is calculated with the following equation :
<pre>    G = k*L
    k: Thermal conductivity [W/(m.K)]
    L: Length of the thermal bridge [m]</pre></p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 08/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Gilles PLESSIS, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ThermalBridge;
