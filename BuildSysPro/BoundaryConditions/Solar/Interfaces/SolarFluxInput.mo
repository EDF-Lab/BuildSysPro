within BuildSysPro.BoundaryConditions.Solar.Interfaces;
connector SolarFluxInput =
                      input Real "Input irradiation connector"
  annotation (defaultComponentName="Flux",
  Icon(graphics={Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={255,192,1},
          fillColor={255,192,1},
          fillPattern=FillPattern.Solid), Line(
        points={{-698,0},{-86,0}},
        color={255,192,1},
        smooth=Smooth.None,
        thickness=1)},
       coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2)),
  Diagram(coordinateSystem(
        preserveAspectRatio=true, initialScale=0.2,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={Polygon(
          points={{0,50},{100,0},{0,-51},{0,50}},
          lineColor={255,192,1},
          fillColor={255,192,1},
          fillPattern=FillPattern.Solid), Text(
          extent={{25,79},{25,54}},
          lineColor={255,192,1},
          textString="%name")}),
    Documentation(info="<html>
<p><i><b>Solar irradiance connector</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Causal connector with one input signal of type Real.
To be used to transport short-wave and long-wave irradiation.</p>
<p>Can be used especially for solar irradiation.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aurélie Kaemmerlen 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>
"));
