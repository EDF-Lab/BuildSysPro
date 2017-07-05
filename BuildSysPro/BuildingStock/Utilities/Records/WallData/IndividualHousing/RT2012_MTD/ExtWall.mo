within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RT2012_MTD;
record ExtWall =
   BuildSysPro.Utilities.Icons.ExtWall (
    n=3,
    m={4,3,1},
    e={0.2,0.14,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.HollowBuildingBrick25(),
                                                BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0})
  "Exterior wall and wall on garage Mozart best available technology RT2012"
                                                                            annotation (
Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
