within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing.From1989to2000_10pc;
record Ceiling =
  BuildSysPro.Utilities.Icons.Ceiling (
    n=4,
    m={1,2,4,1},
    e={0.01,0.06,0.18,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.BitumenFelt(),
        BuildSysPro.Utilities.Data.Solids.Polyurethane25(),
        BuildSysPro.Utilities.Data.Solids.Concrete(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0,0}) "Ceiling collective housing GV(1989) -10%"
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
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
