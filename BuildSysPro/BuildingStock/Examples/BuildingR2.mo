within BuildSysPro.BuildingStock.Examples;
model BuildingR2
  extends Modelica.Icons.Example;
  BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.BuildingR2
    batimentR2_1(
    GLOEXT=false,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataGAUGUIN.Gauguin1989to2000
      paraMaisonRT_Gauguin,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO.Picasso1989to2000
      paraMaisonRT_Picasso,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.Matisse1989to2000
      paraMaisonRT_Matisse,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.UnheatedRoom1989to2000
      paraMaisonRT_LNC)
    annotation (Placement(transformation(extent={{-50,-88},{58,70}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-92,72},{-72,92}})));
equation
  connect(meteofile.G, batimentR2_1.G) annotation (Line(
      points={{-73,80},{-60,80},{-60,64.7333},{-46.0727,64.7333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.T_dry, batimentR2_1.T_ext) annotation (Line(
      points={{-73,85},{-5.81818,85},{-5.81818,65.6111}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
            -100,-100},{100,100}}), graphics), Documentation(info="<html>
<p><i><b>Use example of the <code>BuildingR2</code> model</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end BuildingR2;
