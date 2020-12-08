﻿within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing;
record SupportingWall =
  BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=1,
    m={3},
    e={0.16},
    mat={BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={0}) "Supporting wall collective housing"                                                               annotation (
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
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
