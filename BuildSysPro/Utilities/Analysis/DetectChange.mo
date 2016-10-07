within BuildSysPro.Utilities.Analysis;
model DetectChange "Detect change in a signal value"
  parameter Real eps;
public
  Real last_value;
public
  Modelica.Blocks.Interfaces.RealInput signal
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanOutput change
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
initial algorithm
  last_value := signal;
algorithm
  when pre(change) then
    last_value := signal;
  end when;
  change := abs(signal-last_value)>=eps;

  annotation (Icon(graphics={
        Text(
          extent={{-38,96},{40,60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="True"),
        Line(
          points={{0,60},{0,-100}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Line(
          points={{-100,100},{-100,-100},{100,-100},{100,100},{-100,100}},
          color={0,0,0}),
        Line(
          points={{-100,-40},{0,-40},{0,20},{100,20}},
          color={0,0,255},
          thickness=0.5)}), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>If the current and the last signal values are identical, the Bollean output <code>change</code> is false.</p>
<p>If the current and the last signal values are different, the Bollean output <code>change</code> is true.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 09/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Benoît CHARRIER, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
end DetectChange;
