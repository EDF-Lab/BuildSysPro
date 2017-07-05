within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.RT2005;
record AtticWall =
    BuildSysPro.Utilities.Icons.Ceiling (
    n=2,
    m={7,1},
    e={0.26,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.MineralWool38(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={1,0}) "Attic wall Mozart RT2005"                   annotation (Icon(graphics),
                          Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier, Philippe Petiot 06/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Benoît CHARRIER, Philippe PETIOT, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>"));
