within BuildSysPro.Systems.Controls;
model Switch
  extends BuildSysPro.BaseClasses.HeatTransfer.Interfaces.Element1D;

  parameter Boolean valeur_On=true "OnOff value for which the flow exists";

  Modelica.Blocks.Interfaces.BooleanInput OnOff annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,60}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=-90,
        origin={0,46})));

equation
  if OnOff == valeur_On then
    dT = 0;
  else
    Q_flow = 0;
  end if;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-80,-60},{
            80,60}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-80,-60},{80,
            60}}), graphics={
        Text(
          extent={{-82,80},{78,60}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-66,0},{-44,0},{-22,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-22,2},{-18,-2}},
          lineColor={0,0,0},
          lineThickness=0),
        Line(
          points={{-18,2},{12,12}},
          color={0,0,0},
          thickness=0,
          smooth=Smooth.None),
        Rectangle(
          extent={{-78,24},{-64,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135}),
        Line(
          points={{8,0},{44,0},{66,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{64,24},{78,-38}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={135,135,135}),
        Rectangle(
          extent={{-78,32},{78,-46}},
          lineColor={0,0,0},
          lineThickness=0.2)}),
    Documentation(info="<html>
<p><b>All-or-nothing switch-controller to cut the connection between inputs and outputs</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Operation: </p>
<ul><li>If the switch is <u>closed</u>, there is equality between thermal ports temperatures (default if OnOff = 1)</li>
<li>If the switch is <u>opened</u>, no flow circulates between the two ports (default if OnOff &lt;&gt; 1)</li></ul>
<p>It is possible to change the value at which the switch is closed by changing the value of <code>valeur_On</code> parameter.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Amy Lindsay 04/2014 : modification du IntegerInput en BooleanInput, pour plus de logique</p>
</html>"));
end Switch;
