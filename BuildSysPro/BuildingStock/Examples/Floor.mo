within BuildSysPro.BuildingStock.Examples;
model Floor
  extends Modelica.Icons.Example;
  BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.BuildingR2.GenericFloor
    etageGenerique(
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataGAUGUIN.GauguinBefore1974
      paraMaisonRT_Gauguin,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO.PicassoBefore1974
      paraMaisonRT_Picasso,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.MatisseBefore1974
      paraMaisonRT_Matisse,
    redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.UnheatedRoomBefore1974
      paraMaisonRT_LNC,
    PositionEtage=3)
    annotation (Placement(transformation(extent={{-36,-24},{70,34}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-90,18},{-70,38}})));
equation
  connect(meteofile.G, etageGenerique.G) annotation (Line(
      points={{-71,26},{-52,26},{-52,30.1333},{-33.7286,30.1333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.T_dry, etageGenerique.T_ext) annotation (Line(
      points={{-71,31},{-5.5,31},{-5.5,32.0667},{60.5357,32.0667}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
            -100,-100},{100,100}}), graphics), Documentation(info="<html>
<p><i><b>Use example of the <code>GenericFloor</code> model</b></i></p>
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
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end Floor;
