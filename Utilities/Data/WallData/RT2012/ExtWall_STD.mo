within BuildSysPro.Utilities.Data.WallData.RT2012;
record ExtWall_STD =
   BuildSysPro.Utilities.Icons.ExtWall (
    n=3,
    m={4,3,1},
    e={0.2,0.1,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.HollowConcreteBlock(),
                                BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0}) "External wall STD RT2012" annotation (
Documentation(info="<html>
<p>RT2012 : Parameters of STD external walls for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
