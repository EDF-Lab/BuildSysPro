within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.BBCEffinergie;
record Floor =
  BuildSysPro.Utilities.Icons.Floor (
    n=3,
    m={2,3,1},
    e={0.1,0.2,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene30(),
         BuildSysPro.Utilities.Data.Solids.Concrete(),
         BuildSysPro.Utilities.Data.Solids.FloorTile()},
    positionIsolant={1,0,0}) "Floor Mozart Ubat 0.3"
 annotation (Icon(graphics),
                       Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
