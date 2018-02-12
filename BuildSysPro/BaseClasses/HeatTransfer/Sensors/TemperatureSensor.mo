within BuildSysPro.BaseClasses.HeatTransfer.Sensors;
model TemperatureSensor "Absolute temperature sensor in Kelvin"

  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port
                             annotation (Placement(transformation(extent={{
            -110,-10},{-90,10}}, rotation=0)));
equation
  T = port.T;
  port.Q_flow = 0;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{12,0},{90,0}}, color={0,0,255}),
        Line(points={{-94,0},{-14,0}}, color={191,0,0}),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,
              86},{12,80},{12,40},{-12,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,40},{-12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,40},{12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
        Line(points={{-40,20},{-12,20}}, color={0,0,0}),
        Line(points={{-40,60},{-12,60}}, color={0,0,0}),
        Text(
          extent={{102,-28},{60,-78}},
          lineColor={0,0,0},
          textString="K")}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{12,0},{90,0}}, color={0,0,255}),
        Line(points={{-90,0},{-12,0}}, color={191,0,0}),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{
              10,86},{12,80},{12,40},{-12,40}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-12,40},{-12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{12,40},{12,-64}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-40,-20},{-12,-20}}, color={0,0,0}),
        Line(points={{-40,20},{-12,20}}, color={0,0,0}),
        Line(points={{-40,60},{-12,60}}, color={0,0,0}),
        Text(
          extent={{126,-20},{26,-120}},
          lineColor={0,0,0},
          textString="K"),
        Text(
          extent={{-132,144},{108,84}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This is an ideal absolute temperature sensor which returns the temperature of the connected port in Kelvin as an output signal. The sensor itself has no thermal interaction with whatever it is connected to. Furthermore, no thermocouple-like lags are associated with this sensor model.</p>
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
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor\">TemperatureSensor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
<p>Mathias Bouquerel 12/2016 : remplacement du port thermique Modelica par le port thermique BuildSysPro</p>
</html>"));
end TemperatureSensor;
