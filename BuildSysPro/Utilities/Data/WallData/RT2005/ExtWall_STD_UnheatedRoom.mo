﻿within BuildSysPro.Utilities.Data.WallData.RT2005;
record ExtWall_STD_UnheatedRoom =
  BuildSysPro.Utilities.Icons.ExtWall (
    n=1,
    m={4},
    e={0.2},
    mat={BuildSysPro.Utilities.Data.Solids.HollowConcreteBlock()},
    positionIsolant={0}) "External wall LNC STD RT2005" annotation (
Documentation(info="<html>
<p>RT2005 : Parameters of STD LNC external walls for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
