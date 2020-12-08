within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RTExisting_Reno;
record Floor =
  BuildSysPro.Utilities.Icons.Floor (
    n=2,
    m={1,3},
    e={0.09,0.18},
    mat={BuildSysPro.Utilities.Data.Solids.MineralWool40(),
         BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={1,0}) "Floor Mozart renovated according to RT Existing"
  annotation (Icon(graphics), Documentation(info="<html>
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
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Béatrice SUPLICE, Frédéric GASTIGER, EDF (2016)<br>
--------------------------------------------------------------</b></p></html>"));
