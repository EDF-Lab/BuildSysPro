within BuildSysPro.Utilities.Data.WallData.RT2012;
record Floor_MTD =
   BuildSysPro.Utilities.Icons.Floor (
    n=4,
    m={2,4,2,1},
    e={0.1,0.2,0.1,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.Polyurethane25(),
                                      BuildSysPro.Utilities.Data.Solids.Concrete(),
        BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
                                      BuildSysPro.Utilities.Data.Solids.FloorTile()},
    positionIsolant={1,0,1,0}) "Floor MTD RT2012"            annotation (
    Documentation(info="<html>
<p>RT2012 : Parameters of MTD floors for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
