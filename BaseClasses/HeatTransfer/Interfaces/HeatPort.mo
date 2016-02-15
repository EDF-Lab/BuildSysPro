within BuildSysPro.BaseClasses.HeatTransfer.Interfaces;
partial connector HeatPort "Port thermique pour transfert thermique 1-D"
   Modelica.SIunits.Temperature T "Port temperature";
  flow Modelica.SIunits.HeatFlowRate Q_flow
    "Flux de chaleur (positif si flux entrant)";
  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Interfaces.HeatPort\">HeatPort</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end HeatPort;
