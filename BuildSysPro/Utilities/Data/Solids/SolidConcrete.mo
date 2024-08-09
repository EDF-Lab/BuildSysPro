﻿within BuildSysPro.Utilities.Data.Solids;
record SolidConcrete =
                BuildSysPro.Utilities.Records.GenericSolid (
    lambda=1.75,
    rho=2300,
    c=920) "Solid Concrete (RE2020)"               annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction des valeurs pour cohérence norme ISO 10456 et RT2012 (rho 2700 > 2500 kg/m3, C 900 > 750 J/kg.K)</p>
</html>"));