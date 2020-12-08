﻿within BuildSysPro.Utilities.Data.Solids;
record ExtrudedPolystyrene28 =
    BuildSysPro.Utilities.Records.GenericSolid (
    lambda=0.028,
    rho=35,
    c=1450) "Extruded polystyrene 0.028" annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 12/2015 : Correction du C (1210 > 1450 J/kg.K)</p>
</html>"));
