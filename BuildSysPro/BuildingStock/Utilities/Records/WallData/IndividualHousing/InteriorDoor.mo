within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing;
record InteriorDoor =
BuildSysPro.Utilities.Icons.Door (
    n=1,
    m={1},
    e={0.04},
    mat={BuildSysPro.Utilities.Data.Solids.WoodInteriorDoor()},
    positionIsolant={0}) "Interior door Mozart"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}),
                   graphics), Documentation(info="<html>
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
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));