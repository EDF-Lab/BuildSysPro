﻿within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE;
record Matisse2005 =
  BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    (
    UvitrageAF=1.9,
    UvitrageSF=1.9,
    redeclare replaceable parameter
      WallData.CollectiveHousing.IntermediateFloor PlafondMitoyen,
    redeclare replaceable parameter WallData.CollectiveHousing.RT2005.Door
      Porte,
    redeclare parameter WallData.CollectiveHousing.IntDoor PorteInt,
    redeclare replaceable parameter
      WallData.CollectiveHousing.IntermediateFloor PlancherMitoyen,
    redeclare replaceable parameter
      WallData.CollectiveHousing.RT2005.ExtWall MurExt,
    redeclare replaceable parameter
      WallData.CollectiveHousing.RT2005.LandingWall MurPalier,
    redeclare replaceable parameter
      WallData.CollectiveHousing.RT2005.Ceiling PlafondImmeuble,
    redeclare replaceable parameter WallData.CollectiveHousing.RT2005.Floor
      PlancherImmeuble,
    redeclare replaceable parameter WallData.CollectiveHousing.CommonWall
      MurMitoyen,
    redeclare replaceable parameter WallData.CollectiveHousing.PartitionWall
      Cloisons,
    bLNC=0.1,
    bPlancher=0.80,
    bPlafond=1,
    ValeursK={0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00},
    TauPonts={1,1,1,1,1,1,1,1},
    ValeursKPlafond={0.00,0.00,0.00},
    ValeursKPlancher={0.00,0.00,0.00},
    TauPontsPlafond={1,1,1},
    TauPontsPlancher={1,1,1},
    PontsTh_Generique=0.00,
    PontsTh_Bas=0.00,
    PontsTh_Haut=0.00,
    renouvAir=0.426,
    hsExtVert=25,
    hsIntVert=7.69,
    hsExtHor=25,
    hsIntHorHaut=10) "Settings of Matisse collective housing RT2005"
  annotation (Documentation(info="<html>
<p><i><b>Record of Matisse collective housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p style=\"color:red\">Warning : thermal bridges have been set to null because of a lack of data, it will be necessary to complete them when more details are available.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier, Philippe Petiot 06/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Benoît CHARRIER, Philippe PETIOT, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Benoît Charrier 05/2015 : ajout de paramètres nécessaires au modèle MatisseAssemblageLC</p>
</html>"));
