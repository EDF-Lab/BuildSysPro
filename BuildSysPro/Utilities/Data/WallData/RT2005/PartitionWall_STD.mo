within BuildSysPro.Utilities.Data.WallData.RT2005;
record PartitionWall_STD =
   BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=3,
    m={1,3,1},
    e={0.02,0.14,0.02},
    mat={BuildSysPro.Utilities.Data.Solids.PlasterBoard(),
                                    BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0}) "Partition wall STD RT2005"                                                                       annotation (Documentation(info="<html>
<p>RT2005 : Parameters of STD partition walls for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
