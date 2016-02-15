within BuildSysPro.Utilities.Data.WallData;
record SupportingWall =
   BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=3,
    m={1,3,1},
    e={0.01,0.2,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.PlasterCoating(),
                                    BuildSysPro.Utilities.Data.Solids.HollowBuildingBrick50(),
        BuildSysPro.Utilities.Data.Solids.PlasterCoating()},
    positionIsolant={0,1,0}) "Internal supporting wall - 3 layers"
                                                    annotation (Documentation(info="<html>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
