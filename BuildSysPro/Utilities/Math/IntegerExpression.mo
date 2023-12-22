within BuildSysPro.Utilities.Math;
block IntegerExpression
  "Set output signal to a time varying Integer expression"

  Modelica.Blocks.Interfaces.RealOutput y=0 "Value of Integer output"
    annotation (                            Dialog(group=
          "Time varying output signal"), Placement(transformation(extent={{
            100,-10},{120,10}}, rotation=0)));

  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,
            -20},{-100,20}})));
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
          extent={{-96,15},{96,-15}},
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
<p>The <u>(time varying)</u> Integer output signal of this block can be defined in its parameter menu via variable <b>y</b>.</p>
<p>The purpose is to support the easy definition of Integer expressions in a block diagram.</p>
<p><u><b>Bibliography</b></u></p>
<p>Modification of the Modelica.Blocks.Sources.IntegerExpression model, adding the u input so that the expression of y can depend on another variable.</p>
<p><u><b>Instructions for use</b></u></p>
<p>For example, in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order to define that the output signal is one, if time &ge; 1 and otherwise it is zero.</p>
<p>Note that \"time\" is a built-in variable that is always accessible and represents the \"model time\" and that variable <b>y</b> is both a variable and a connector.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 07/2012 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Hassan BOUIA, EDF (2012)<br>
Initial model : <a href=\"Modelica.Blocks.Sources.IntegerExpression\">IntegerExpression</a>, Martin Otter, Copyright © Modelica Association and DLR.<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Benoit Charrier 12/2014 : sortie en Real pour ne pas avoir des problèmes de compatibilité output/input</p>
</html>"));

end IntegerExpression;
