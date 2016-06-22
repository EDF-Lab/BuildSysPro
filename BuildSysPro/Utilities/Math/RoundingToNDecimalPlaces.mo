within BuildSysPro.Utilities.Math;
model RoundingToNDecimalPlaces

parameter Integer n=1 "Rounded to n decimal places";

  Modelica.Blocks.Math.RealToInteger realToInteger
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.IntegerToReal integerToReal
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Math.Gain gain(k=10^n)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain gain1(k=1/(10^n))
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(realToInteger.y, integerToReal.u) annotation (Line(
      points={{-19,0},{18,0}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(gain.y, realToInteger.u) annotation (Line(
      points={{-59,0},{-42,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integerToReal.y, gain1.u) annotation (Line(
      points={{41,0},{58,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, u) annotation (Line(
      points={{-82,0},{-110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain1.y, y) annotation (Line(
      points={{81,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Documentation(info="<html>
<p><i><b>Model to round a real to n decimal places</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Bernard Clemençon 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Bernard CLEMENCON, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Aurélie Kaemmerlen 07/2012 - généralisation du modèle à n chiffres après la virgule</p>
</html>"));
end RoundingToNDecimalPlaces;
