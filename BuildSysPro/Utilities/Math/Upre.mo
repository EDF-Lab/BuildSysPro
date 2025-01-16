within BuildSysPro.Utilities.Math;
model Upre "pre(u) per period"
  extends Modelica.Blocks.Interfaces.SIMO;

  parameter Real periode=3600 "the period [s]";

initial equation
  y=fill(u,nout);

equation

algorithm
   when sample(0, periode) then
     y[1]:=u;
     for i in 2:nout loop
       y[i]:=pre(y[i - 1]);
     end for;
   end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={170,255,170}), Text(
          extent={{-80,80},{78,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,170},
          textString="pre(u)")}),  Diagram(coordinateSystem(preserveAspectRatio=
           false)),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>
This model allows finding the previous value of a parameter U over the interval [period1, period2].</p>
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
end Upre;
