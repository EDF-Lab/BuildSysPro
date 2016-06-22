within BuildSysPro.Utilities.Data.WallData.RT2012;
record PartitionWall =
   BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=1,
    m={4},
    e={0.2},
    mat={BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0}) "Partition wall RT2012"                                                                       annotation (Documentation(info="<html>
<p>RT2012 : Parameters of light partition walls for individual housing.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Céline ILIAS, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
