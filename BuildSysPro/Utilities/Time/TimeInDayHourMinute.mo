within BuildSysPro.Utilities.Time;
model TimeInDayHourMinute

  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Modelica.Blocks.Math.UnitConversions.To_day to_day
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Blocks.Math.UnitConversions.To_hour to_hour
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.Blocks.Math.UnitConversions.To_minute to_minute
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
equation
  connect(clock.y,to_day. u) annotation (Line(
      points={{-9,40},{0,40},{0,70},{8,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_hour.u,clock. y) annotation (Line(
      points={{8,40},{-9,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(clock.y, to_minute.u) annotation (Line(
      points={{-9,40},{0,40},{0,10},{8,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=0.1, NumberOfIntervals=225),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><i><b>Model to get a real rounded to n decimal places</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Warning, this model gives only equivalent number of seconds to hour, minute and day - regardless of possible weather data offsets</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Bernard Clemençon 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Bernard CLEMENCON, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={236,236,236},
          fillPattern=FillPattern.Solid),
    Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
    Line(points={{0,80},{0,60}}, color={160,160,164}),
    Line(points={{80,0},{60,0}}, color={160,160,164}),
    Line(points={{0,-80},{0,-60}}, color={160,160,164}),
    Line(points={{-80,0},{-60,0}}, color={160,160,164}),
    Line(points={{37,70},{26,50}}, color={160,160,164}),
    Line(points={{70,38},{49,26}}, color={160,160,164}),
    Line(points={{71,-37},{52,-27}}, color={160,160,164}),
    Line(points={{39,-70},{29,-51}}, color={160,160,164}),
    Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
    Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
    Line(points={{-71,37},{-54,28}}, color={160,160,164}),
    Line(points={{-38,70},{-28,51}}, color={160,160,164}),
    Line(
      points={{0,0},{-50,50}},
      color={0,0,0},
      thickness=0.5),
    Line(
      points={{0,0},{40,0}},
      color={0,0,0},
      thickness=0.5)}));
end TimeInDayHourMinute;
