within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing.BBCEffinergie;
record Ceiling =
  BuildSysPro.Utilities.Icons.Ceiling (
    n=4,
    m={1,3,3,1},
    e={0.01,0.12,0.18,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.BitumenFelt(),
         BuildSysPro.Utilities.Data.Solids.Polyurethane23(),
         BuildSysPro.Utilities.Data.Solids.Concrete(),
         BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0,0}) "Ceiling collective housing BBC (low-energy building)"
  annotation (Icon(graphics),
                        Documentation(revisions="<html>
<p>Les valeurs ne sont pas exactes.</p>
</html>", info="<html>
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
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Benoît CHARRIER, Philippe PETIOT, EDF (2017)<br>
--------------------------------------------------------------</b></p></html>"));
