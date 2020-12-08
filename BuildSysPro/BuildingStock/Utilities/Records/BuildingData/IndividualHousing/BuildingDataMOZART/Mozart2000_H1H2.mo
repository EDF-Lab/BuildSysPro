within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record Mozart2000_H1H2 =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    (
    redeclare replaceable parameter
      WallData.IndividualHousing.RT2000_H1H2.AtticWall ParoiSousCombles,
    redeclare replaceable parameter WallData.IndividualHousing.RT2000_H1H2.Door
      Porte,
    redeclare replaceable parameter
      WallData.IndividualHousing.RT2000_H1H2.Floor PlancherBas,
    redeclare replaceable parameter
      WallData.IndividualHousing.RT2000_H1H2.ExtWall Mur,
    redeclare replaceable parameter WallData.IndividualHousing.PartitionWall
      Cloisons,
    redeclare replaceable parameter WallData.IndividualHousing.SupportingWall
      Refends,
    UvitrageAF=2,
    UvitrageSF=2.4,
    renouvAir=0.491,
    ValeursK={0.01,0.205,0.57,0.00,0.00,0.05,0.00,0.00,0.00},
    TauPonts={1,1,1,1,1,1,1,1,1},
    bPlancher=1,
    bLNC=0.95,
    bSousCombles=1) "Settings of Mozart individual housing 2000 CrefH1_H2"
                                                         annotation (
    Documentation(info="<html>
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
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
