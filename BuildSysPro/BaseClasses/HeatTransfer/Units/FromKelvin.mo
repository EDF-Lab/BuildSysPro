within BuildSysPro.BaseClasses.HeatTransfer.Units;
model FromKelvin "Conversion from Kelvin to degCelsius"

  Modelica.Blocks.Interfaces.RealInput Kelvin(unit="K")
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput Celsius(unit="degC")
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  Celsius =Modelica.Units.Conversions.to_degC(Kelvin);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          lineColor={0,0,255}),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,-46},{-152,-108}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="K"),
        Text(
          extent={{122,-48},{38,-109}},
          lineColor={0,0,0},
          textString="degC"),
        Line(points={{-40,0},{-100,0}}, color={0,0,255}),
        Line(points={{40,0},{100,0}}, color={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-42,-41},{-101,-98}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="K"),
        Text(
          extent={{100,-40},{30,-100}},
          lineColor={0,0,0},
          textString="degC"),
        Line(points={{-100,0},{-40,0}}, color={0,0,255}),
        Line(points={{40,0},{100,0}}, color={0,0,255})}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This component converts an input signal from Kelvin to Celsius and provides is as output signal.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Celsius.FromKelvin\">ToKelvin</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end FromKelvin;
