within BuildSysPro.BaseClasses.HeatTransfer.Units;
model ToKelvin "Conversion block from degCelsius to Kelvin"

  Modelica.Blocks.Interfaces.RealInput Celsius(unit="degC")
     annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput Kelvin(unit="K")
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  Kelvin = Modelica.SIunits.Conversions.from_degC(Celsius);

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-40,-50},{-99,-99}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="degC"),
        Text(
          extent={{100,-47},{44,-100}},
          lineColor={0,0,0},
          textString="K"),
        Line(points={{-100,0},{-40,0}}, color={0,0,255}),
        Line(points={{41,0},{100,0}}, color={0,0,255})}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{124,-38},{52,-94}},
          lineColor={0,0,0},
          textString="K"),
        Text(
          extent={{-62,-38},{-141,-97}},
          lineColor={0,0,0},
          lineThickness=1,
          textString="degC"),
        Line(points={{-41,0},{-100,0}}, color={0,0,255}),
        Line(points={{100,0},{40,0}}, color={0,0,255}),
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This component converts an input signal from Celsius to Kelvin and provide is as output signal.</p>
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
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Celsius.ToKelvin\">ToKelvin</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end ToKelvin;
