within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE;
record Matisse1974to1982 =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    (
    UvitrageAF=4.1,
    UvitrageSF=4.1,
    redeclare replaceable parameter
      WallData.CollectiveHousing.IntermediateFloor PlafondMitoyen,
    redeclare replaceable parameter
      WallData.CollectiveHousing.From1974to1982.Door Porte,
    redeclare parameter WallData.CollectiveHousing.IntDoor PorteInt,
    redeclare replaceable parameter
      WallData.CollectiveHousing.IntermediateFloor PlancherMitoyen,
    redeclare replaceable parameter
      WallData.CollectiveHousing.From1974to1982.ExtWall MurExt,
    redeclare replaceable parameter
      WallData.CollectiveHousing.From1974to1982.LandingWall MurPalier,
    redeclare replaceable parameter
      WallData.CollectiveHousing.From1974to1982.Ceiling PlafondImmeuble,
    redeclare replaceable parameter
      WallData.CollectiveHousing.From1974to1982.Floor PlancherImmeuble,
    redeclare replaceable parameter WallData.CollectiveHousing.CommonWall
      MurMitoyen,
    redeclare replaceable parameter WallData.CollectiveHousing.PartitionWall
      Cloisons,
    bLNC=0.10,
    bPlancher=0.80,
    bPlafond=1,
    ValeursK={0.28,0.12,0.25,0.25,0.27,0.27,0.00,0.00},
    TauPonts={1,0.1,1,1,0.1,0.1,0.1,1},
    ValeursKPlafond={0.23,0.04,0.04},
    ValeursKPlancher={0.22,0.35,0.35},
    TauPontsPlafond={1,1,1},
    TauPontsPlancher={1,0.80,0.80},
    PontsTh_Generique=10.73,
    PontsTh_Bas=8.66,
    PontsTh_Haut=4.68,
    renouvAir=0.703,
    hsExtVert=16.67,
    hsIntVert=9.09,
    hsExtHor=20,
    hsIntHorHaut=11.11)
  "Settings of Matisse collective housing from 1974 to 1982" annotation (
    Documentation(info="<html>
<p><i><b>Record of Matisse collective housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Note H-E10-1996-02908-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Benoît Charrier 05/2015 : ajout de paramètres nécessaires au modèle MatisseAssemblageLC</p>
</html>"));
