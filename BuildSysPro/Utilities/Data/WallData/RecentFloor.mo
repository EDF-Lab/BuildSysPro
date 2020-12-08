within BuildSysPro.Utilities.Data.WallData;
record RecentFloor =
  BuildSysPro.Utilities.Icons.Floor (
    n=3,
    m={3,3,1},
    e={0.16,0.2,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene30(),
         BuildSysPro.Utilities.Data.Solids.Concrete(),
         BuildSysPro.Utilities.Data.Solids.FloorTile()},
    positionIsolant={1,0,0}) "Recent floor with heavy inertia - 3 layers"
                                            annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
