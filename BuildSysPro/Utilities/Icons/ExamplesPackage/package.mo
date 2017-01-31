within BuildSysPro.Utilities.Icons;
partial package ExamplesPackage "Icon used for example packages"


  annotation (             Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-100,-100},{80,50}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{-80,70},{100,70},{80,50},{-100,50}},
          lineColor={0,0,0},
          fillColor={179,179,119},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{100,70},{100,-80},{80,-100},{80,50},{100,70}},
          lineColor={0,0,0},
          fillColor={179,179,119},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));

end ExamplesPackage;
