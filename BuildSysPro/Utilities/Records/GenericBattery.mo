within BuildSysPro.Utilities.Records;
record GenericBattery "Cmax / Puiss. inverter / Pmax ch. / Pmax dis."

parameter Real Cmax "Battery capacity (Wh)";
parameter Real P_onduleur "Inverter power (W)";
parameter Real Pmaxc "Maximum charge power (W)";
parameter Real Pmaxd "Maximum discharge power (W)";

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Description of the lithium-ion battery characteristics.</p>
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
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Laura SUDRIES, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>
"));
end GenericBattery;
