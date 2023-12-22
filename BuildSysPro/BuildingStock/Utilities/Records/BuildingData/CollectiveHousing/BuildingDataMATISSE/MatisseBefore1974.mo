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
    hsExtVert=25,
    hsIntVert=7.69,
    hsExtHor=25,
    hsIntHorHaut=10) "Settings of Matisse collective housing before 1974"
                                                        annotation (
    Documentation(info="<html>
<p><i><b>Record of Matisse collective housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Note H-E10-1996-02908-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>Detail of thermal bridge vectors :</p>
<ul>
<li>TauPonts[1] and ValeursK[1] : exterior wall / common wall</li>
<li>TauPonts[2] and ValeursK[2] : unheated room wall / common wall</li>
<li>TauPonts[3] and ValeursK[3] : exterior wall / intermediate floor</li>
<li>TauPonts[4] and ValeursK[4] : exterior wall / intermediate ceiling</li>
<li>TauPonts[5] and ValeursK[5] : unheated room wall / intermediate floor</li>
<li>TauPonts[6] and ValeursK[6] : unheated room wall / intermediate ceiling</li>
<li>TauPonts[7] and ValeursK[7] : door</li>
<li>TauPonts[8] and ValeursK[8] : windows</li>
</ul>
<ul>
<li>TauPontsPlancher[1] and ValeursKPlancher[1] : intermediate floor / exterior wall of basement</li>
<li>TauPontsPlancher[2] and ValeursKPlancher[2] : intermediate floor / unheated room wall of basement</li>
<li>TauPontsPlancher[3] and ValeursKPlancher[3] : intermediate floor / common wall of basement</li>
</ul>
<ul>
<li>TauPontsPlafond[1] and ValeursKPlafond[1] : intermediate ceiling / exterior wall of ceiling</li>
<li>TauPontsPlafond[2] and ValeursKPlafond[2] : intermediate ceiling / unheated room wall of ceiling</li>
<li>TauPontsPlafond[3] and ValeursKPlafond[3] : intermediate ceiling / common wall of ceiling</li>
</ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Benoît Charrier 05/2015 : ajout de paramètres nécessaires au modèle MatisseAssemblageLC</p>
</html>"));
