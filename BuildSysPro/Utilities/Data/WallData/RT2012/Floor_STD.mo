within BuildSysPro.Utilities.Data.WallData.RT2012;
record Floor_STD =
  BuildSysPro.Utilities.Icons.Floor (
    n=4,
    m={1,3,1,1},
    e={0.06,0.2,0.08,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.Polyurethane25(),
         BuildSysPro.Utilities.Data.Solids.Concrete(),
         BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
         BuildSysPro.Utilities.Data.Solids.FloorTile()},
    positionIsolant={1,0,1,0}) "Floor STD RT2012"            annotation (
    Documentation(info="<html>
<p>RT2012 : Parameters of STD floors for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
