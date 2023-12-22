within BuildSysPro.BaseClasses.HeatTransfer.Interfaces;
partial connector HeatPort "Thermal port for 1-D heat transfer"
  Modelica.Units.SI.Temperature T "Port temperature";
  flow Modelica.Units.SI.HeatFlowRate Q_flow
    "Heat flow rate (positive if flowing from outside into the component)";
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Initial model : <a href=\"Modelica.Thermal.HeatTransfer.Interfaces.HeatPort\">HeatPort</a>, Anton Haumer, Copyright © Modelica Association, Michael Tiller and DLR.<br>
--------------------------------------------------------------</b></p>
</html>"));
end HeatPort;
