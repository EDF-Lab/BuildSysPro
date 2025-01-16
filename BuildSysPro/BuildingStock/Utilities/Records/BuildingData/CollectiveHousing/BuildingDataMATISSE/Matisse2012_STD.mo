within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE;
record Matisse2012_STD =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    (
    UvitrageAF=1.5,
    UvitrageSF=1.5,
    redeclare replaceable parameter
      WallData.CollectiveHousing.IntermediateFloor PlafondMitoyen,
    redeclare replaceable parameter WallData.CollectiveHousing.RT2012_STD.Door
      Porte,
    redeclare parameter WallData.CollectiveHousing.IntDoor PorteInt,
    redeclare replaceable parameter
      WallData.CollectiveHousing.IntermediateFloor PlancherMitoyen,
    redeclare replaceable parameter
      WallData.CollectiveHousing.RT2012_STD.ExtWall MurExt,
    redeclare replaceable parameter
      WallData.CollectiveHousing.RT2012_STD.LandingWall MurPalier,
    redeclare replaceable parameter
      WallData.CollectiveHousing.RT2012_STD.Ceiling PlafondImmeuble,
    redeclare replaceable parameter WallData.CollectiveHousing.RT2012_STD.Floor
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
    renouvAir=0.3,
    hsExtVert=25,
    hsIntVert=7.69,
    hsExtHor=25,
    hsIntHorHaut=10) "Settings of Matisse collective housing standard 2012"
  annotation (Documentation(info="<html>
<p><i><b>Record of Matisse collective housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
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
<p style=\"color:red\">Warning : thermal bridges have been set to null because of a lack of data, it will be necessary to complete them when more details are available.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Benoît Charrier 05/2015 : ajout de paramètres nécessaires au modèle MatisseAssemblageLC</p>
<p>Benoît Charrier 06/2017 : <ul><li>editing value of air renewal <code>renouvAir</code> from 0,426 to 0,3 vol/h to fit with a humidity sensitive ventilation system which is commonly used in RT2012</li>
<li>editing value of U glazings <code>UvitrageAF</code> and <code>UvitrageSF</code> from 1,2 to 1,5 W/m2.K which is more representative of RT2012</li>
<li>setting thermal bridge values to null because actual values are not representative, will need to be adjusted when more data is available</li></ul></p>
</html>"));
