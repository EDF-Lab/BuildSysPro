﻿within BuildSysPro.Utilities.Data.WallData.RT2012;
record Ceiling_MTD_UnheatedRoom =
  BuildSysPro.Utilities.Icons.Ceiling (
    n=1,
    m={1},
    e={0.02},
    mat={BuildSysPro.Utilities.Data.Solids.FibreBoard120()},
    positionIsolant={0}) "Ceiling LNC MTD RT2012"            annotation (
    Documentation(info="<html>
<p>RT2012 : Parameters of MTD LNC ceilings for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
