within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO;
record Picasso2000 =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO.BuildingType
    (
    UvitrageAF=2,
    redeclare parameter WallData.CollectiveHousing.RT2000.Door Porte,
    redeclare parameter WallData.CollectiveHousing.IntDoor PorteInt,
    redeclare parameter WallData.CollectiveHousing.IntermediateFloor
      PlancherInterm,
    redeclare parameter WallData.CollectiveHousing.RT2000.ExtWall
      MurExt,
    redeclare parameter WallData.CollectiveHousing.RT2000.LandingWall
      MurPalier,
    redeclare parameter WallData.CollectiveHousing.RT2000.Ceiling
      ParoiSousCombles,
    redeclare parameter WallData.CollectiveHousing.RT2000.Floor
      PlancherBas,
    redeclare parameter WallData.CollectiveHousing.PartitionWall Cloisons,
    PontsTh_Generique=11.26,
    PontsTh_Bas=5.36,
    PontsTh_Haut=3.33,
    TauxRenouvAir=0.426,
    Hsext=25,
    Hsint=7.69,
    HsParoiSousCombles=10) "Settings of Picasso collective housing RT2000"
                                                             annotation (
    Documentation(info="<html>
<p><i><b>Record of Picasso collective housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Notes H-E10-1996-02908-FR  and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p style=\"color:red\">Warning : thermal bridges have not been changed compared to RT1988 because of a lack of data, it will be necessary to complete them when more details are available.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier, Philippe Petiot 06/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Benoît CHARRIER, Philippe PETIOT, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>"));
