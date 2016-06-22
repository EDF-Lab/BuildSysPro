within BuildSysPro.Utilities.Icons;
record Ceiling =        BuildSysPro.Utilities.Records.GenericWall
  "Icon used for ceiling records"
    annotation (Diagram(graphics), Icon(graphics={
      Rectangle(
        extent={{-80,100},{80,-100}},
        lineColor={0,0,0},
        fillColor={255,255,170},
        fillPattern=FillPattern.Solid,
        origin={0,20},
        rotation=90),
      Line(
        points={{30,100},{-48,60},{52,20},{-48,-20},{52,-60},{-30,-100}},
        smooth=Smooth.Bezier,
        color={0,0,0},
        origin={0,30},
        rotation=90),
      Rectangle(
        extent={{-20,100},{20,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        origin={0,-80},
        rotation=90)}),
  Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
