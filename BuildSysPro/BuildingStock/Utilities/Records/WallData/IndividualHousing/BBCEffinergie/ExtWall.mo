within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.BBCEffinergie;
record ExtWall =
  BuildSysPro.Utilities.Icons.ExtWall (
    n=3,
    m={2,2,1},
    e={0.2,0.15,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.HollowConcreteBlock(),
         BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene42(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0})
  "Exterior wall and wall on garage Mozart Mozart Ubat 0.3"
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
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
