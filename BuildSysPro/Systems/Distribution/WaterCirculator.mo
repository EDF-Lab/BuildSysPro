within BuildSysPro.Systems.Distribution;
model WaterCirculator

  parameter Modelica.Units.SI.MassFlowRate m_flow=0.01
    "Nominal flow rate";

  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector including 1-fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector including 1-fluid temperature (K), 2-flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
equation
  WaterOut[1]=WaterIn[1];
  WaterOut[2]=m_flow;

  annotation (                   Icon(graphics={
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-42,44},{42,-42}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{42,42},{-42,-42}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-86,0},{-60,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{60,0},{86,0}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5)}),
    Documentation(revisions="<html>
<p>Hubert Blervaque 02/2013 : Première implémentation.</p>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>",
      info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Element of an hydraulic network to impose a flow rate</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p><i><b><font style=\"color: #ff0000; \">Be carful to respect the conservation of the flow rates within a loop, impossibility of putting two circulators in a row. </font></b></i></p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Sila Filfli - 01/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Hubert BLERVAQUE, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end WaterCirculator;
