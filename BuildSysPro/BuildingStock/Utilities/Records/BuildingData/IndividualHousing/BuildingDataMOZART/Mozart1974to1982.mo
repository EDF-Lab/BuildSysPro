within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record Mozart1974to1982 =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    (
    redeclare replaceable parameter
      WallData.IndividualHousing.From1974to1982.AtticWall ParoiSousCombles,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1974to1982.Door Porte,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1974to1982.Floor PlancherBas,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1974to1982.ExtWall Mur,
    redeclare replaceable parameter WallData.IndividualHousing.PartitionWall
      Cloisons,
    redeclare replaceable parameter WallData.IndividualHousing.SupportingWall
      Refends,
    hsExtVert=25,
    hsIntVert=7.69,
    hsIntHorHaut=10,
    UvitrageAF=4.1,
    UvitrageSF=4.1,
    renouvAir=0.792,
    ValeursK={0.00,0.20,0.20,0.20,0.27,0.00,0.00,0.00,0.00},
    TauPonts={1,1,1,1,0.70,1,1,1,1},
    bLNC=0.75,
    bPlancher=0.70,
    bSousCombles=1) "Settings of Mozart individual housing from 1974 to 1982"
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
</html>", revisions="<html>
<p> 07/2020 - Correction of surface exchange coefficient on  walls (standardisation of all the record with values in agreement with ISO6946)</p>
</html>"));
