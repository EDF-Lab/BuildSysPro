﻿within BuildSysPro.Utilities.Data.WallData.RT2012;
record ExtWall_MTD =
  BuildSysPro.Utilities.Icons.ExtWall (
    n=3,
    m={5,2,1},
    e={0.2,0.14,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.HollowBuildingBrick25(),
         BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0}) "External wall MTD RT2012"  annotation (
Documentation(info="<html>
<p>RT2012 : Parameters of MTD external walls for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
