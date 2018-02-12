within BuildSysPro.Utilities.Icons;
record HorizontalInternalWall =
    BuildSysPro.Utilities.Records.GenericWall
  "Icon used for horizontal internal wall records"
    annotation (Diagram(graphics), Icon(graphics={
      Rectangle(
        extent={{-60,100},{60,-100}},
        lineColor={0,0,0},
        fillColor={215,215,215},
        fillPattern=FillPattern.CrossDiag,
          origin={0,0},
          rotation=270),
      Rectangle(
        extent={{-20,100},{20,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
          origin={0,80},
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
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
