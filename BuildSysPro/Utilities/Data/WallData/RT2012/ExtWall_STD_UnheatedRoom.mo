within BuildSysPro.Utilities.Data.WallData.RT2012;
record ExtWall_STD_UnheatedRoom =
  BuildSysPro.Utilities.Icons.ExtWall (
    n=1,
    m={2},
    e={0.2},
    mat={BuildSysPro.Utilities.Data.Solids.HollowConcreteBlock()},
    positionIsolant={0}) "External wall LNC STD RT2012"   annotation (
Documentation(info="<html>
<p>RT2012 : Parameters of STD LNC external walls for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
