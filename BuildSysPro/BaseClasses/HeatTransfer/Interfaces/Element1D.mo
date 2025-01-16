within BuildSysPro.BaseClasses.HeatTransfer.Interfaces;
partial model Element1D
  "Partial heat transfer element with two HeatPort connectors that does not store energy"

  Modelica.Units.SI.HeatFlowRate Q_flow "Heat flow rate from port_a -> port_b";
  Modelica.Units.SI.TemperatureDifference dT "port_a.T - port_b.T";

public
  HeatPort_a port_a annotation (Placement(transformation(extent={{-100,
            -10},{-80,10}}, rotation=0)));
  HeatPort_b port_b annotation (Placement(transformation(extent={{80,
            -10},{100,10}}, rotation=0)));
equation
  dT = port_a.T - port_b.T;
  port_a.Q_flow = Q_flow;
  port_b.Q_flow = -Q_flow;
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This partial model contains the basic connectors and variables to allow heat transfer models to be created that <b>do not store energy</b>, This model defines and includes equations for the temperature drop across the element, <b>dT</b>, and the heat flow rate through the element from port_a to port_b, <b>Q_flow</b>.</p>
<p>By extending this model, it is possible to write simple constitutive equations for many types of heat transfer components.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Interfaces.Element1D\">Element1D</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}),
     graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
            graphics));
end Element1D;
