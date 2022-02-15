within BuildSysPro.Utilities.Data.Storage;
record Battery5kWh_5kW_5kW_10kW =
  BuildSysPro.Utilities.Records.GenericBattery (
    Cmax=5000,
    P_onduleur=5000,
    Pmaxc=5000,
    Pmaxd=10000) "5kWh / 5kW / 5kW / 10kW" annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Description of the battery characteristics.</p>
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
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Laura SUDRIES, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>
"));
