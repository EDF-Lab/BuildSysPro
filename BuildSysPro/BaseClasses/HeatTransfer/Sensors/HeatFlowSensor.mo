within BuildSysPro.BaseClasses.HeatTransfer.Sensors;
model HeatFlowSensor "Heat flow rate sensor"
  extends Modelica.Icons.RotationalSensor;

  Modelica.Blocks.Interfaces.RealOutput Q_flow
    "Heat flow from port_a to port_b as output signal"                                            annotation (Placement(
        transformation(
        origin={0,-100},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a
                               annotation (Placement(transformation(extent={{
            -110,-10},{-90,10}}, rotation=0)));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port_b
                               annotation (Placement(transformation(extent={{
            90,-10},{110,10}}, rotation=0)));
equation
  port_a.T = port_b.T;
  port_a.Q_flow + port_b.Q_flow = 0;
  Q_flow = port_a.Q_flow;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Line(points={{-70,0},{-95,0}}, color={191,0,0}),
        Line(points={{0,-70},{0,-90}}, color={0,0,255}),
        Line(points={{94,0},{69,0}}, color={191,0,0})}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{33,-58},{88,-116}},
          lineColor={0,0,0},
          textString="Q_flow"),
        Line(points={{-70,0},{-90,0}}, color={191,0,0}),
        Line(points={{69,0},{90,0}}, color={191,0,0}),
        Line(points={{0,-70},{0,-90}}, color={0,0,255}),
        Text(
          extent={{-132,144},{108,84}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model is capable of monitoring the heat flow rate flowing through this component. The sensed value of heat flow rate is the amount that passes through this sensor while keeping the temperature drop across the sensor zero. This is an ideal model so it does not absorb any energy and it has no direct effect on the thermal response of a system it is included in. The output signal is positive, if the heat flows from port_a to port_b.</p>
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
BuildSysPro version 3.2.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor\">HeatFlowSensor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>",
revisions="<html>
<p>Mathias Bouquerel 12/2016 : remplacement du port thermique Modelica par le port thermique BuildSysPro</p>
</html>"));
end HeatFlowSensor;
