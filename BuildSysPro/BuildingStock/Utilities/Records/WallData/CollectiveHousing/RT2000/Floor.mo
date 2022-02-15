within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing.RT2000;
record Floor =
  BuildSysPro.Utilities.Icons.Floor (
    n=2,
    m={1,3},
    e={0.10,0.18},
    mat={BuildSysPro.Utilities.Data.Solids.MineralWool37(),
         BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={1,0}) "Floor collective housing RT2000"
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
<p>Validated model - Benoît Charrier, Philippe Petiot 06/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Benoît CHARRIER, Philippe PETIOT, EDF (2017)<br>
--------------------------------------------------------------</b></p></html>"));
