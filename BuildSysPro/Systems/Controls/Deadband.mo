within BuildSysPro.Systems.Controls;
model Deadband

  parameter Real e=0.5
    "Upper and lower difference accepted with respect to the setpoint";

  Modelica.Blocks.Interfaces.RealInput Setpoint
    annotation (Placement(transformation(extent={{-128,0},{-88,40}}),
        iconTransformation(extent={{-108,0},{-88,20}})));

  Modelica.Blocks.Interfaces.RealInput Variable
    annotation (Placement(transformation(extent={{-118,-42},{-78,-2}}),
        iconTransformation(extent={{-106,-62},{-86,-42}})));
  Modelica.Blocks.Interfaces.BooleanOutput OnOff
    annotation (Placement(transformation(extent={{102,-42},{142,-2}}),
        iconTransformation(extent={{88,-60},{108,-40}})));
equation
  if Variable < (Setpoint-e) then
    OnOff= true;
  elseif Variable > (Setpoint+e) then
    OnOff = false;
  else
    OnOff = pre(OnOff);
  end if;

  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-100,70},{100,-70}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,-42},{-50,42},{-24,-20},{14,42},{60,-20},{84,42}},
          color={0,0,255},
          smooth=Smooth.None),
    Line(points={{-88,10},{88,10}},color={0,0,0}),
    Line(points={{-86,42},{90,42}},color={192,192,192}),
    Line(points={{-88,-20},{88,-20}},
                                   color={192,192,192}),
        Text(
          extent={{58,-46},{88,-54}},
          lineColor={255,85,170},
          textString="On/Off")}),
    Diagram(graphics={
        Rectangle(
          extent={{-100,80},{100,-60}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
    Line(points={{-88,20},{88,20}},color={0,0,0}),
    Line(points={{-86,52},{90,52}},color={192,192,192}),
    Line(points={{-88,-10},{88,-10}},
                                   color={192,192,192}),
        Line(
          points={{-90,-32},{-50,52},{-24,-10},{14,52},{60,-10},{84,52}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-74,52},{-74,20}},
          color={175,175,175},
          smooth=Smooth.None,
          pattern=LinePattern.Dash,
          arrow={Arrow.Filled,Arrow.Filled}),
        Text(
          extent={{-78,48},{-58,34}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="e"),
        Text(
          extent={{-18,-26},{12,-40}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="On"),
        Text(
          extent={{24,-26},{50,-40}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="Off"),
        Line(
          points={{-24,62},{-24,-40}},
          color={255,85,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{60,62},{60,-40}},
          color={255,85,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{14,62},{14,-40}},
          color={255,85,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash)}),
    DymolaStoredErrors,
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>All-or-nothing management around a setpoint value plus or minus a hysteresis effect band.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 05/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Hubert BLERVAQUE, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end Deadband;
