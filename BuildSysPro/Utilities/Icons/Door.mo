within BuildSysPro.Utilities.Icons;
record Door =  BuildSysPro.Utilities.Records.GenericWall
  "Icon used for door records"
    annotation (Diagram(graphics), Icon(graphics={
      Rectangle(
        extent={{-100,60},{100,-60}},
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid,
        lineColor={0,0,0},
        origin={0,0},
        rotation=90),
      Rectangle(
        extent={{-40,-52},{40,52}},
        lineColor={0,0,0},
        fillColor={85,170,255},
        fillPattern=FillPattern.Forward,
        origin={0,40},
        rotation=90),
      Rectangle(
        extent={{-100,20},{100,-20}},
        lineColor={0,0,0},
        fillColor={135,135,135},
        fillPattern=FillPattern.Solid,
        origin={-80,0},
        rotation=90),
      Rectangle(
        extent={{-100,20},{100,-20}},
        lineColor={0,0,0},
        fillColor={135,135,135},
        fillPattern=FillPattern.Solid,
        origin={80,0},
        rotation=90),
        Ellipse(
          extent={{46,-10},{54,-18}},
          lineColor={0,0,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
