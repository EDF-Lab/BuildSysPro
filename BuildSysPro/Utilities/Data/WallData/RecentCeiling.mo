within BuildSysPro.Utilities.Data.WallData;
record RecentCeiling =
  BuildSysPro.Utilities.Icons.Ceiling (
    n=2,
    m={5,1},
    e={0.25,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.InsulationMaterialAndJoists(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={1,0}) "Recent ceiling - 2 layers"
  annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
