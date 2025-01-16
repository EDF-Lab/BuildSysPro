within BuildSysPro.Utilities.Data.Storage;
record Battery2kWh_3kW_2kW_5kW =
  BuildSysPro.Utilities.Records.GenericBattery (
    Cmax=2500,
    P_onduleur=3000,
    Pmaxc=2500,
    Pmaxd=5000) "2,5kWh / 3kW / 2,5kW / 5kW" annotation (Documentation(info="<html>
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
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Laura SUDRIES, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>
"));
