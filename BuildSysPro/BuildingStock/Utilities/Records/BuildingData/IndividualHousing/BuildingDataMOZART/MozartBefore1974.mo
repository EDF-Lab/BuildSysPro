within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record MozartBefore1974 =
BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    (
    redeclare replaceable parameter
      WallData.IndividualHousing.Before1974.AtticWall ParoiSousCombles,
    redeclare replaceable parameter WallData.IndividualHousing.Before1974.Door
      Porte,
    redeclare replaceable parameter WallData.IndividualHousing.Before1974.Floor
      PlancherBas,
    redeclare replaceable parameter
      WallData.IndividualHousing.Before1974.ExtWall Mur,
    redeclare replaceable parameter WallData.IndividualHousing.PartitionWall
      Cloisons,
    redeclare replaceable parameter WallData.IndividualHousing.SupportingWall
      Refends,
    redeclare replaceable parameter WallData.IndividualHousing.InteriorDoor
      PorteInt,
    hsExtVert=25,
    hsIntVert=7.69,
    hsIntHorHaut=10,
    UvitrageAF=5.88,
    UvitrageSF=5.8,
    renouvAir=0.792,
    ValeursK={0.08,0.08,0.07,0.07,0.18,0.07,0.07,0.13,0.13},
    TauPonts={1,1,1,1,0.55,1,1,1,1},
    bLNC=0.75,
    bPlancher=0.55,
    bSousCombles=1) "Settings of Mozart individual housing before 1974"
                                                       annotation (
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Note H-E10-1996-02908-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>Detail of thermal bridge vectors :</p>
<ul>
<li>TauPonts[1] and ValeursK[1] : exterior wall / exterior wall</li>
<li>TauPonts[2] and ValeursK[2] : exterior wall / supporting wall</li>
<li>TauPonts[3] and ValeursK[3] : exterior wall / floor</li>
<li>TauPonts[4] and ValeursK[4] : floor / crawlspace</li>
<li>TauPonts[5] and ValeursK[5] : supporting wall / floor</li>
<li>TauPonts[6] and ValeursK[6] : exterior wall / attic wall</li>
<li>TauPonts[7] and ValeursK[7] : attic wall / attic</li>
<li>TauPonts[8] and ValeursK[8] : door</li>
<li>TauPonts[9] and ValeursK[9] : windows</li>
</ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p> 07/2020 - Correction of surface exchange coefficient on  walls (standardisation of all the record with values in agreement with ISO6946)</p>

</html>"));
