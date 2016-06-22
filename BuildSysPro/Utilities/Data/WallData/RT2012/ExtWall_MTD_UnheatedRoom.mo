within BuildSysPro.Utilities.Data.WallData.RT2012;
record ExtWall_MTD_UnheatedRoom =
   BuildSysPro.Utilities.Icons.ExtWall (
    n=1,
    m={4},
    e={0.2},
    mat={BuildSysPro.Utilities.Data.Solids.HollowBuildingBrick25()},
    positionIsolant={0}) "External wall LNC MTD RT2012"  annotation (
Documentation(info="<html>
<p>RT2012 : Parameters of MTD LNC external walls for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
