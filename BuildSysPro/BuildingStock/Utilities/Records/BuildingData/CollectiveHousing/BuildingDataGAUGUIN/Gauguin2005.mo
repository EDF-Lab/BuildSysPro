﻿within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataGAUGUIN;
record Gauguin2005 =
BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataGAUGUIN.BuildingType
    (
    UvitrageAF=1.9,
    redeclare parameter WallData.CollectiveHousing.IntermediateFloor
      PlancherInterm,
    redeclare parameter WallData.CollectiveHousing.RT2005.Door Porte,
    redeclare parameter WallData.CollectiveHousing.IntDoor PorteInt,
    redeclare parameter WallData.CollectiveHousing.RT2005.ExtWall
      MurExt,
    redeclare parameter WallData.CollectiveHousing.PartitionWall Cloisons,
    redeclare parameter WallData.CollectiveHousing.SupportingWall Refends,
    redeclare parameter WallData.CollectiveHousing.RT2005.LandingWall
      MurPalier,
    redeclare parameter WallData.CollectiveHousing.RT2005.ExtWall
      MurCage,
    redeclare parameter WallData.CollectiveHousing.RT2005.Ceiling
      ParoiSousCombles,
    redeclare parameter WallData.CollectiveHousing.RT2005.Floor
      PlancherBas,
    redeclare parameter WallData.CollectiveHousing.CommonWall MurMitoyen,
    PontsTh_Generique=0.00,
    PontsTh_Bas=0.00,
    PontsTh_Haut=0.00,
    TauxRenouvAir=0.426,
    Hsext=25,
    Hsint=7.69,
    HsParoiSousCombles=10)
  "Settings of Gauguin collective housing RT2005" annotation (
    Documentation(info="<html>
<p><i><b>Record of Gauguin collective housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Notes H-E10-1996-02908-FR  and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p style=\"color:red\">Warning : thermal bridges have been set to null because of a lack of data, it will be necessary to complete them when more details are available.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier, Philippe Petiot 06/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Benoît CHARRIER, Philippe PETIOT, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>"));