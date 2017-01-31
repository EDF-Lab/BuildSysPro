within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RTExisting_Reno;
record AtticWall =
    BuildSysPro.Utilities.Icons.Ceiling (
    n=2,
    m={4,1},
    e={0.18,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.MineralWool40(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={1,0})
  "Attic wall Mozart renovated according to RT Existing"
  annotation (Icon(graphics),
                        Documentation(revisions="<html>
<p>Les valeurs ne sont pas exactes.</p>
</html>", info="<html>
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
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Béatrice SUPLICE, Frédéric GASTIGER, EDF (2016)<br>
--------------------------------------------------------------</b></p></html>"));
