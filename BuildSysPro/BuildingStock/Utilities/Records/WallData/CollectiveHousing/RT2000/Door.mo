within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing.RT2000;
record Door =
  BuildSysPro.Utilities.Icons.Door (
    n=1,
    m={5},
    e={0.07},
    mat={BuildSysPro.Utilities.Data.Solids.MetalComplexDoor17()},
    positionIsolant={0}) "Door on landing collective housing RT2000"
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
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Benoît CHARRIER, Philippe PETIOT, EDF (2017)<br>
--------------------------------------------------------------</b></p></html>"));
