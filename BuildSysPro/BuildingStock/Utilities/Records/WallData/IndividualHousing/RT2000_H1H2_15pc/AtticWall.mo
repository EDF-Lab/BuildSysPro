within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RT2000_H1H2_15pc;
record AtticWall =
    BuildSysPro.Utilities.Icons.Ceiling (
    n=2,
    m={4,1},
    e={0.23,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.MineralWool40(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={1,0}) "Attic wall Mozart Cref(RT2000 zones H1 H2) -15%"
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
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
