within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing.BBCEffinergie;
record ExtWall =
  BuildSysPro.Utilities.Icons.ExtWall (
    n=3,
    m={3,2,1},
    e={0.20,0.12,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete(),
         BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0}) "Exterior wall collective housing BBC (low-energy building)"                                       annotation (
    Icon(graphics), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier, Philippe Petiot 06/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Benoît CHARRIER, Philippe PETIOT, EDF (2017)<br>
--------------------------------------------------------------</b></p></html>"));
