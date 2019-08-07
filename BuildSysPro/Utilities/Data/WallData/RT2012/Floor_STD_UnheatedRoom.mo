﻿within BuildSysPro.Utilities.Data.WallData.RT2012;
record Floor_STD_UnheatedRoom =
  BuildSysPro.Utilities.Icons.Floor (
    n=1,
    m={4},
    e={0.2},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={0}) "Floor LNC STD RT2012"             annotation (
    Documentation(info="<html>
<p>RT2012 : Parameters of STD LNC floors for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
