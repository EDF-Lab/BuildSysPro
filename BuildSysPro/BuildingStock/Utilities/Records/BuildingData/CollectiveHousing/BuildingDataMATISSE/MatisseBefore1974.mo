within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE;
record MatisseBefore1974 =
BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    (
    UvitrageAF=5.8,
    UvitrageSF=5.8,
    redeclare replaceable parameter
      WallData.CollectiveHousing.IntermediateFloor PlafondMitoyen,
    redeclare replaceable parameter WallData.CollectiveHousing.Before1974.Door
      Porte,
    redeclare parameter WallData.CollectiveHousing.IntDoor PorteInt,
    redeclare replaceable parameter
      WallData.CollectiveHousing.IntermediateFloor PlancherMitoyen,
    redeclare replaceable parameter
      WallData.CollectiveHousing.Before1974.ExtWall MurExt,
    redeclare replaceable parameter
      WallData.CollectiveHousing.Before1974.LandingWall MurPalier,
    redeclare replaceable parameter
      WallData.CollectiveHousing.Before1974.Ceiling PlafondImmeuble,
    redeclare replaceable parameter WallData.CollectiveHousing.Before1974.Floor
      PlancherImmeuble,
    redeclare replaceable parameter WallData.CollectiveHousing.CommonWall
      MurMitoyen,
    redeclare replaceable parameter WallData.CollectiveHousing.PartitionWall
      Cloisons,
    bLNC=0.1,
    bPlancher=0.80,
    bPlafond=1,
    ValeursK={0.13,0.13,0.25,0.25,0.25,0.25,0.14,0.14},
    TauPonts={1,0.1,1,1,0.1,0.1,0.1,1},
    ValeursKPlafond={0.23,0.04,0.04},
    ValeursKPlancher={0.22,0.35,0.35},
    TauPontsPlafond={1,1,1},
    TauPontsPlancher={1,0.80,0.80},
    PontsTh_Generique=14.59,
    PontsTh_Bas=8.66,
    PontsTh_Haut=4.68,
    renouvAir=0.703,
    hsExtVert=16.67,
    hsIntVert=9.09,
    hsExtHor=20,
    hsIntHorHaut=11.11)
  "Paramètres caractérisant un appart matisse RT avant 1974 " annotation (
    Documentation(info="<html>
<p><i><b>Record pour renseigner les paramètres du LC Matisse en fonction de l'année de construction</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>Site de la bibliothèque des bâtiments types</p>
<p>Note H-E10-1996-02908-FR</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Benoît Charrier 05/2015 : ajout de paramètres nécessaires au modèle MatisseAssemblageLC</p>
</html>"));
