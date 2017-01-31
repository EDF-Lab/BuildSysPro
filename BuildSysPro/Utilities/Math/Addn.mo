within BuildSysPro.Utilities.Math;
block Addn "Gives the n dimension sum of two n dimension inputs"
      extends Modelica.Blocks.Interfaces.BlockIcon;

      parameter Real k1=+1 "Gain of upper input";
      parameter Real k2=+1 "Gain of lower input";
      parameter Integer n "Dimension of the inputs";

     Modelica.Blocks.Interfaces.RealInput u1[n]
    "Connector of Real input signal 1"
        annotation (Placement(transformation(extent={{-140,40},{-100,80}},
            rotation=0)));
      Modelica.Blocks.Interfaces.RealInput u2[n]
    "Connector of Real input signal 2"
        annotation (Placement(transformation(extent={{-140,-80},{-100,-40}},
            rotation=0)));
      Modelica.Blocks.Interfaces.RealOutput y[n]
    "Connector of Real output signal"
        annotation (Placement(transformation(extent={{100,-10},{120,10}},
            rotation=0)));

equation
    for i in 1:n loop
      y[i] = k1*u1[i] + k2*u2[i];
    end for;

      annotation (
        Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model returns the sum, element by element, of two n dimension inputs, weighted by two factors <b>k1</b> and <b>k2</b>.</p>
<p><u><b>Bibliography</b></u></p>
<p>Model based on Modelica.Blocks.Math.Add, adding the n dimension to input/ouput.</p>
<pre>y[1:n] = k1*u1[1:n] + k2*u2[1:n]</pre>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aurélie Kaemmerlen 11/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
Initial model : <a href=\"Modelica.Blocks.Math.Add\">Add</a>, Martin Otter, Copyright © Modelica Association and DLR.<br>
--------------------------------------------------------------</b></p></html>"),
        Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(
          extent={{-98,-52},{7,-92}},
          lineColor={0,0,0},
          textString="%k2"),
        Text(
          extent={{-100,90},{5,50}},
          lineColor={0,0,0},
          textString="%k1"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,255}),
        Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,255}),
        Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,255}),
        Line(points={{-15,-25.99},{15,25.99}}, color={0,0,0}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{50,0},{100,0}}, color={0,0,255}),
        Line(points={{-100,60},{-74,24},{-44,24}}, color={0,0,127}),
        Line(points={{-100,-60},{-74,-28},{-42,-28}}, color={0,0,127}),
        Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,127}),
        Line(points={{50,0},{100,0}}, color={0,0,127}),
        Text(
          extent={{-38,34},{38,-34}},
          lineColor={0,0,0},
          textString="+"),
        Text(
          extent={{-100,52},{5,92}},
          lineColor={0,0,0},
          textString="%k1"),
        Text(
          extent={{-100,-52},{5,-92}},
          lineColor={0,0,0},
          textString="%k2")}),
        Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,-52},{7,-92}},
          lineColor={0,0,0},
          textString="%k2"),
        Text(
          extent={{-100,90},{5,50}},
          lineColor={0,0,0},
          textString="%k1"),
        Line(points={{-100,60},{-40,60},{-30,40}}, color={0,0,255}),
        Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,255}),
        Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={0,0,255}),
        Line(points={{-15,-25.99},{15,25.99}}, color={0,0,0}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{50,0},{100,0}}, color={0,0,255}),
        Line(points={{-100,60},{-74,24},{-44,24}}, color={0,0,127}),
        Line(points={{-100,-60},{-74,-28},{-42,-28}}, color={0,0,127}),
        Ellipse(extent={{-50,50},{50,-50}}, lineColor={0,0,127}),
        Line(points={{50,0},{100,0}}, color={0,0,127}),
        Text(
          extent={{-38,34},{38,-34}},
          lineColor={0,0,0},
          textString="+"),
        Text(
          extent={{-100,52},{5,92}},
          lineColor={0,0,0},
          textString="k1"),
        Text(
          extent={{-100,-52},{5,-92}},
          lineColor={0,0,0},
          textString="k2")}));
end Addn;
