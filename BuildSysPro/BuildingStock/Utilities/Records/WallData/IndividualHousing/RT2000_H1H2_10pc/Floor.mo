within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RT2000_H1H2_10pc;
record Floor =
  BuildSysPro.Utilities.Icons.Floor (
    n=4,
    m={2,3,1,1},
    e={0.12,0.18,0.04,0.05},
    mat={BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene38(),
         BuildSysPro.Utilities.Data.Solids.Concrete(),
         BuildSysPro.Utilities.Data.Solids.FloorScreedInsulation(),
         BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={1,0,0,0}) "Floor Mozart Cref(RT2000 zones H1 H2) -10%"
  annotation (Icon(graphics), Documentation(info="<html>
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
