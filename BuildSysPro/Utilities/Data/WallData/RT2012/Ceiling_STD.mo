within BuildSysPro.Utilities.Data.WallData.RT2012;
record Ceiling_STD =
  BuildSysPro.Utilities.Icons.Ceiling (
    n=2,
    m={3,1},
    e={0.24,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.MineralWool40(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={1,0}) "Ceiling STD RT2012"            annotation (
    Documentation(info="<html>
<p>RT2012 : Parameters of STD ceilings for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
