within BuildSysPro.Utilities.Data.WallData.RT2012;
record Ceiling_MTD =
  BuildSysPro.Utilities.Icons.Ceiling (
    n=2,
    m={5,1},
    e={0.40,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.MineralWool40(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={1,0}) "Ceiling MTD RT2012"             annotation (
    Documentation(info="<html>
<p>RT2012 : Parameters of MTD ceilings for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
