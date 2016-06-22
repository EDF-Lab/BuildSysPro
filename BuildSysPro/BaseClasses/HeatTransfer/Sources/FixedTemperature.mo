within BuildSysPro.BaseClasses.HeatTransfer.Sources;
model FixedTemperature "Fixed temperature boundary condition in Kelvin"
  parameter Modelica.SIunits.Temperature T "Fixed temperature";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
                             annotation (Placement(transformation(
          extent={{90,-10},{110,10}}, rotation=0)));
equation
  port.T =T;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(extent={{-118,165},{122,105}}, textString="%name"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{52,-20},{52,20},{90,0},{52,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-145,-102},{135,-151}},
          lineColor={0,0,0},
          textString="T=%T"),
        Line(
          points={{-42,0},{66,0}},
          color={191,0,0},
          thickness=0.5),
        Text(
          extent={{0,-2},{-100,-102}},
          lineColor={0,0,0},
          textString="°K")}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model defines a fixed temperature T at its port in Kelvin, i.e., it defines a fixed temperature as a boundary condition.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Sources.FixedTemperature\">FixedTemperature</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
<p>Gilles Plessis 07/2012 : changement de l'ic&ocirc;ne (&deg;K au lieu de &deg;C !)</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                    graphics));
end FixedTemperature;
