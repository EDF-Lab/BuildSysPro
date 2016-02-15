within BuildSysPro.BaseClasses.HeatTransfer.Interfaces;
partial model Element1D
  "Modèle partiel permettant un transfert thermique entre les deux ports thermiques du modèle, sans stocker d'énergie"

  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate from port_a -> port_b";
  Modelica.SIunits.TemperatureDifference dT "port_a.T - port_b.T";

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
<p>This partial model contains the basic connectors and variables to allow heat transfer models to be created that <b>do not store energy</b>, This model defines and includes equations for the temperature drop across the element, <b>dT</b>, and the heat flow rate through the element from port_a to port_b, <b>Q_flow</b>. </p>
<p>By extending this model, it is possible to write simple constitutive equations for many types of heat transfer components. </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
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
