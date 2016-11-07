within BuildSysPro.Systems.Controls;
model PBand

  Modelica.Blocks.Interfaces.RealInput X
    annotation (Placement(transformation(extent={{-108,40},{-92,56}})));
  Modelica.Blocks.Interfaces.RealInput X_ref
    annotation (Placement(transformation(extent={{-108,-54},{-92,-38}})));
  Modelica.Blocks.Interfaces.RealOutput Y
    annotation (Placement(transformation(extent={{96,-8},{112,8}})));

  parameter Real Ymin=0.3 "Minimum value of the output parameter";
  parameter Real Ymax=1 "Maximum value of the output parameter";
  parameter Real Range=0.5
    "Maximum difference (X-X_ref) before output saturation";

algorithm
    Y := max(Ymin,min(Ymax,Ymax - (X-(X_ref-Range))*(Ymax-Ymin)/(2*Range)));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-86},{0,88},{0,86},{0,82}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-88,-40},{86,-40},{30,-40},{20,-40}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-2,86},{2,86},{0,96},{-2,86}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{3,6},{-1,6},{1,-4},{3,6}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={92,-41},
          rotation=90),
        Line(
          points={{-88,64},{-38,64},{38,-16},{86,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-4,64},{4,64}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{6,58},{22,70}},
          lineColor={0,0,0},
          textString="Ymax"),
        Line(
          points={{-38,-44},{-38,-36}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{-44,-54},{-34,-44}},
          lineColor={0,0,0},
          textString="-e"),
        Text(
          extent={{34,-54},{44,-44}},
          lineColor={0,0,0},
          textString="e"),
        Line(
          points={{38,-44},{38,-36}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-4,-16},{4,-16}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{4,74},{24,86}},
          lineColor={0,0,0},
          textString="Y"),
        Text(
          extent={{84,-38},{102,-24}},
          lineColor={0,0,0},
          textString="X-X_ref"),
        Text(
          extent={{-16,-20},{0,-8}},
          lineColor={0,0,0},
          textString="Ymin")}),
    Documentation(info="<html>
<p>Proportional band management around a setpoint value.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>It returns a value that varies proportionally with the difference X - X_ref (setpoint). The signal is saturated at Ymin and Ymax in extreme conditions.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instruction for use</b></u></p>
<p>The model setup is:</p>
<ol>
<li>Ymin et Ymax, saturation values (eg. 0 and 1 to obtain a gain).</li>
<li>Value of the Range, i.e. half bandwidth size</li>
</ol>
<p><b>Note :</b> For Range &gt; 0, the proportional band will be decreasing. For an increasing function, all you need is Range &lt; 0, leaving other values unchanged.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end PBand;
