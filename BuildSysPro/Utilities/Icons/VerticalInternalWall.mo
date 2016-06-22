within BuildSysPro.Utilities.Icons;
record VerticalInternalWall =
    BuildSysPro.Utilities.Records.GenericWall
  "Icon used for vertical internal wall records"
    annotation (Diagram(graphics), Icon(graphics={
      Rectangle(
        extent={{-60,100},{60,-100}},
        lineColor={0,0,0},
        fillColor={215,215,215},
        fillPattern=FillPattern.CrossDiag),
      Rectangle(
        extent={{60,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-100,100},{-60,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
