within BuildSysPro.BaseClasses.HeatTransfer.Sensors;
model HeatFlowSensor "Mesure le flux de chaleur"
  extends Modelica.Icons.RotationalSensor;

  Modelica.Blocks.Interfaces.RealOutput Q_flow
    "Heat flow from port_a to port_b"                                            annotation (Placement(
        transformation(
        origin={0,-100},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
                               annotation (Placement(transformation(extent={{
            -110,-10},{-90,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b
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
<p>Capteur mesurant le flux de chaleur entre deux modèles, dont la valeur peut être sortie par le connecteur output. La valeur sortie est positive si le flux va du port_a au port_b. A connecter entre deux modèles disposant d'au moin un connecteur thermique. N'a aucune incidence sur les phénomènes physiques. </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor\">HeatFlowSensor</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end HeatFlowSensor;
