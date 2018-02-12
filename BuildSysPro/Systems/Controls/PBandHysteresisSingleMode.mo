within BuildSysPro.Systems.Controls;
model PBandHysteresisSingleMode

  Modelica.Blocks.Interfaces.RealInput X
    annotation (Placement(transformation(extent={{-110,40},{-90,60}})));
  Modelica.Blocks.Interfaces.RealInput X_ref
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));
  Modelica.Blocks.Interfaces.RealOutput epsilon
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  parameter Real epsmin=0.3 "Minimum value of the output parameter";
  parameter Real epsmax=1 "Maximum value of the output parameter";
  parameter Real Range=0.5
    "Maximum difference (X-X_ref) before output saturation";

protected
  Boolean preeps(start=true)
    "Boolean that characterizes the previous value of epsilon: 1 if epsilon>0, 0 if epsilon = 0";

algorithm
  if (X<X_ref-Range) then //If X-X_ref too negative, epsilon saturates at epsmax
    epsilon:=abs(epsmax);
    preeps := true;

  elseif X>X_ref+Range then     //If X-X_ref too positive, epsilon goes to 0
    epsilon := 0;
    preeps := false;
  else
    if preeps then       //Hysteresis loop: Linear regulation if X increases, or at 0 if X decreases
     epsilon := min(abs(epsmax),max(abs(epsmin),abs(epsmax - (X-(X_ref-Range))*(epsmax-epsmin)/(2*Range))));
    else
      epsilon := 0;
    end if;
  end if;

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
          points={{-88,64},{-38,64},{38,-16},{38,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-4,64},{4,64}},
          color={0,0,0},
          smooth=Smooth.None),
        Text(
          extent={{6,58},{22,70}},
          lineColor={0,0,0},
          textString="epsmax"),
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
          textString="epsilon"),
        Text(
          extent={{84,-38},{102,-24}},
          lineColor={0,0,0},
          textString="X-X_ref"),
        Text(
          extent={{-16,-20},{0,-8}},
          lineColor={0,0,0},
          textString="epsmin"),
        Line(
          points={{4,22},{6,18},{2,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{2,-42},{-2,-40},{2,-38}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,-26},{38,-30},{36,-26}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{88,-40},{-38,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{38,-40},{38,-16}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-38,-40},{-38,64}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-36,6},{-38,10},{-40,6}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>Regulation proportional to hysteresis</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The model returns a value between 0 and 1 from a value X and a setpoint X_ref.></p>
<p>The regulation is proportional, with a hysteresis loop:</p>
<ol>
<li>If X-X_ref &lt; - Range, epsilon = epsmax</li>
<li>If X-X_ref &gt; Range, epsilon = 0</li>
<li>If X belongs to [X_ref-Range; X_ref+Range], proportional regulation or epsilon = 0 according to the entry point in the proportional band.</li>
</ol>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>The width of proportional band (Range) must be defined, as well as minimum and maximum values of epsilon, which will determine the slope of the proportional law.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger, Sila Filfli 2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Frédéric GASTIGER, Sila FILFLI, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end PBandHysteresisSingleMode;
