within BuildSysPro.Utilities.Icons;
record ExtWall =BuildSysPro.Utilities.Records.GenericWall
  "Record avec icône pour une paroi type décrivant une paroi extérieure"
    annotation (Diagram(graphics), Icon(graphics={
      Rectangle(
        extent={{-100,100},{-40,-100}},
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid,
        lineColor={0,0,0}),
      Rectangle(
        extent={{-40,100},{60,-100}},
        lineColor={0,0,0},
        fillColor={255,255,170},
        fillPattern=FillPattern.Solid),
      Line(
        points={{40,100},{-40,60},{60,20},{-40,-20},{60,-60},{-20,-100}},
        smooth=Smooth.Bezier,
        color={0,0,0}),
      Rectangle(
        extent={{60,100},{100,-100}},
        lineColor={0,0,0},
         fillColor={255,255,255},
         fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
