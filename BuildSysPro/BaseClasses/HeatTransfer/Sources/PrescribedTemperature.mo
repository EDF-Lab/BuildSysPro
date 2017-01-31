within BuildSysPro.BaseClasses.HeatTransfer.Sources;
model PrescribedTemperature "Variable temperature boundary condition in Kelvin"

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput T
    "Température en K à imposer au niveau du port thermique"                                      annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}, rotation=0)));
equation
  port.T = T;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-102,0},{64,0}},
          color={191,0,0},
          thickness=0.5),
        Text(
          extent={{0,0},{-100,-100}},
          lineColor={0,0,0},
          textString="°K"),
        Text(
          extent={{-125,162},{115,102}},
          textString="%name",
          lineColor={0,0,255}),
        Polygon(
          points={{50,-20},{50,20},{90,0},{50,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
This model represents a variable temperature boundary condition. The temperature in [K] is given as input signal <b>T</b> to the model. The effect is that an instance of this model acts as an infinite reservoir able to absorb or generate as much energy as required to keep the temperature at the specified value.</p>
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
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature\">PrescribedTemperature</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{74,-38},{-100,-100}},
          lineColor={0,0,0},
          textString="K"),
        Line(
          points={{-102,0},{64,0}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{52,-20},{52,20},{90,0},{52,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}));
end PrescribedTemperature;
