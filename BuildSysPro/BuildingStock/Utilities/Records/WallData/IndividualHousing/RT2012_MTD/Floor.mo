within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RT2012_MTD;
record Floor =
   BuildSysPro.Utilities.Icons.Floor (
    n=4,
    m={2,4,2,1},
    e={0.1,0.2,0.1,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.Polyurethane25(),
                                      BuildSysPro.Utilities.Data.Solids.Concrete(),
        BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
                                      BuildSysPro.Utilities.Data.Solids.FloorTile()},
    positionIsolant={1,0,1,0}) "Floor Mozart best available technology RT2012"
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
BuildSysPro version 2.1.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
