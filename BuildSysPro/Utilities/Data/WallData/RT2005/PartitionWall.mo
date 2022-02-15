within BuildSysPro.Utilities.Data.WallData.RT2005;
record PartitionWall =
  BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=1,
    m={6},
    e={0.2},
    mat={BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0}) "Partition wall RT2005"                                                                       annotation (Documentation(info="<html>
<p>RT2005 : Parameters of partition walls for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
