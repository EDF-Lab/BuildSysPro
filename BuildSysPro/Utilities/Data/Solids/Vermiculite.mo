﻿within BuildSysPro.Utilities.Data.Solids;
record Vermiculite = BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.2,
    rho=325,
    c=1200) "Vermiculite (source RT2012)" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence RT2012 (lambda 0,14 > 0,2 W/m.K, rho 400 > 325 kg/m3, C 920 > 1200 J/kg.K)</p>
</html>"));
