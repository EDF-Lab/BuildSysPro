within BuildSysPro.Utilities.Icons;
record Floor =          BuildSysPro.Utilities.Records.GenericWall
  "Icon used for floor records"
    annotation (Diagram(graphics), Icon(graphics={
      Rectangle(
        extent={{-40,100},{40,-100}},
        lineColor={0,0,0},
        fillColor={255,255,170},
        fillPattern=FillPattern.Solid,
        origin={0,-60},
        rotation=270),
      Rectangle(
        extent={{-40,100},{40,-100}},
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid,
        lineColor={0,0,0},
        origin={0,20},
        rotation=270),
      Line(
        points={{30,100},{-50,60},{70,20},{-50,-20},{70,-60},{-30,-100}},
        smooth=Smooth.Bezier,
        color={0,0,0},
        origin={0,-54},
        rotation=270),
      Rectangle(
        extent={{-20,100},{20,-100}},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineColor={0,0,0},
        origin={0,80},
        rotation=270)}),
  Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
