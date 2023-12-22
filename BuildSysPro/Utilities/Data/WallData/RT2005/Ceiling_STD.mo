within BuildSysPro.Utilities.Data.WallData.RT2005;
record Ceiling_STD =
  BuildSysPro.Utilities.Icons.Ceiling (
    n=2,
    m={2,1},
    e={0.22,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.MineralWool40(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={1,0}) "Ceiling STD RT2005"            annotation (
    Documentation(info="<html>
<p>RT2005 : Parameters of STD ceilings for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
