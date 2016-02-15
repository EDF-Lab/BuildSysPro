within BuildSysPro.BoundaryConditions.Solar.Interfaces;
connector SolarFluxOutput =
                      output Real
  "Informations de flux (GLO et CLO) données en sortie"
  annotation (defaultComponentName="Flux",
  Icon(graphics={                         Line(
        points={{-698,0},{-86,0}},
        color={255,192,1},
        smooth=Smooth.None,
        thickness=1),
                 Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={255,192,1},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)},
       coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true, initialScale=0.2)),
  Diagram(coordinateSystem(
        preserveAspectRatio=true, initialScale=0.2,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={Polygon(
          points={{0,50},{100,0},{0,-51},{0,50}},
          lineColor={255,192,1},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{25,79},{25,54}},
          lineColor={255,192,1},
          textString="%name")}),
    Documentation(info="<html>
<p>Connector with one output signal of type Real</p>
<p>A utiliser pour transporter des flux (CLO et GLO) afin de différencier <b>graphiquement</b> les grandeurs transportées. </p>
<p>Modèle validé - Aurélie Kaemmerlen 02/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
Initial model : <a href=\"Modelica.Blocks.Interfaces.RealOutput\">RealOutput</a>, Martin Otter, Copyright © Modelica Association and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
