within BuildSysPro.Utilities.Math;
block RealExpression "Set output signal to a time varying Real expression"

  Modelica.Blocks.Interfaces.RealOutput y=0.0 "Value of Real output"
    annotation (                            Dialog(group=
          "Time varying output signal"), Placement(transformation(extent={{100,-10},
            {120,10}},          rotation=0), iconTransformation(extent={{100,-10},
            {120,10}})));

  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-98,21},{94,-9}},
          lineColor={0,0,0},
          textString="%y"),
        Text(
          extent={{-150,90},{140,50}},
          textString="%name",
          lineColor={0,0,255})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The <u>(time varying)</u> Real output signal of this block can be defined in its parameter menu via variable <b>y</b>.</p>
<p>The purpose is to support the easy definition of Real expressions in a block diagram.</p>
<p><u><b>Bibliography</b></u></p>
<p>Modification of the Modelica.Blocks.Sources.RealExpression model, adding the u input so that the expression of y can depend on another variable.</p>
<p><u><b>Instructions for use</b></u></p>
<p>For example, in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order to define that the output signal is one, if time &ge; 1 and otherwise it is zero.</p>
<p>Note that \"time\" is a built-in variable that is always accessible and represents the \"model time\" and that Variable <b>y</b> is both a variable and a connector.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 10/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Hassan BOUIA, EDF (2011)<br>
Initial model : <a href=\"Modelica.Blocks.Sources.RealExpression\">RealExpression</a>, Martin Otter, Copyright © Modelica Association and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end RealExpression;
