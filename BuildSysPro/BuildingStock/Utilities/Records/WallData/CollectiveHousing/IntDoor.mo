﻿within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing;
record IntDoor =
  BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=1,
    m={2},
    e={0.04},
    mat={BuildSysPro.Utilities.Data.Solids.WoodInteriorDoor()},
    positionIsolant={0}) "Interior door collective housing"                          annotation (
    Icon(graphics), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
