within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing.From1989to2000_10pc;
record LandingWall =
  BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=3,
    m={3,1,1},
    e={0.20,0.05,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete(),
         BuildSysPro.Utilities.Data.Solids.ExtrudedPolystyrene28(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0}) "Landing wall collective housing GV(1989) -10%"
                                                                            annotation (
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
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
