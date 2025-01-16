within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RT2012_STD;
record Floor =
  BuildSysPro.Utilities.Icons.Floor (
    n=4,
    m={1,3,1,1},
    e={0.06,0.2,0.08,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.Polyurethane25(),
         BuildSysPro.Utilities.Data.Solids.Concrete(),
         BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
         BuildSysPro.Utilities.Data.Solids.FloorTile()},
    positionIsolant={1,0,1,0}) "Floor Mozart standard RT2012"       annotation (
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
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
