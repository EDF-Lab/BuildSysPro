within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RTExisting_Reno;
record ExtWall =
  BuildSysPro.Utilities.Icons.ExtWall (
    n=3,
    m={2,1,1},
    e={0.2,0.09,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.HollowConcreteBlock(),
         BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene40(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0})
  "Exterior wall and wall on garage Mozart renovated according to RT Existing"                        annotation (
    Icon(graphics), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>RT 2012 and RT Existing - Réglementation thermique et efficacité énergétique - D. Molle, P-M. Patry 2011</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Béatrice Suplice, Frédéric Gastiger 04/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Béatrice SUPLICE, Frédéric GASTIGER, EDF (2016)<br>
--------------------------------------------------------------</b></p></html>"));
