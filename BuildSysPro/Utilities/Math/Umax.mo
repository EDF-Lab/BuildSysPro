within BuildSysPro.Utilities.Math;
model Umax "max(u) for a period"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real periode1=3600 "step time[s]";
  parameter Real periode2=86400 "period [s]";
  discrete Real ymax "value of Umax";

initial equation
  ymax = u;
 y=u;
algorithm
  when sample(0, periode1) then
    ymax :=max(u, pre(ymax));
  end when;

  when sample(0, periode2) then
    y :=pre(ymax);
    ymax :=u;
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,170}), Text(
          extent={{-80,80},{78,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,170},
          textString="max(u)")}),  Diagram(coordinateSystem(preserveAspectRatio=
           false)),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p><html>
<p>The model allows calculating the maximum value of a quantity U over a time interval period2 with a step time period1.</p>
</html></p>
<p><u><b>Bibliography</b></u></p>
<p>none.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia, 07/2024</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Hassan Bouia, Kods GRISSA NACIB EDF (2024)<br>
--------------------------------------------------------------</b></p>
</html>"));
end Umax;
