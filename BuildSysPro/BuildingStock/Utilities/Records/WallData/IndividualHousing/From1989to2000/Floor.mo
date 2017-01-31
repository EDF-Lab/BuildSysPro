within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.From1989to2000;
record Floor =
    BuildSysPro.Utilities.Icons.Floor (
    n=2,
    m={2,4},
    e={0.08,0.18},
    mat={BuildSysPro.Utilities.Data.Solids.FibreBoard40(),
        BuildSysPro.Utilities.Data.Solids.Concrete()},
    positionIsolant={1,0}) "Floor Mozart 1989"
  annotation (Icon(graphics), Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>To get the same GV in CLIM 2000, take a Fibralith thickness of 6cm (instead of 8cm).</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
