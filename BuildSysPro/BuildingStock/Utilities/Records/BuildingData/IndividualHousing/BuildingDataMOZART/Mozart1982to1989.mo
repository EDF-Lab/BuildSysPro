within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record Mozart1982to1989 =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    (
    redeclare replaceable parameter
      WallData.IndividualHousing.From1982to1989.AtticWall ParoiSousCombles,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1982to1989.Door Porte,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1982to1989.Floor PlancherBas,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1982to1989.ExtWall Mur,
    redeclare replaceable parameter WallData.IndividualHousing.PartitionWall
      Cloisons,
    redeclare replaceable parameter WallData.IndividualHousing.SupportingWall
      Refends,
    hsExtVert=16.67,
    hsIntVert=9.09,
    hsIntHorHaut=11.11,
    UvitrageAF=3,
    UvitrageSF=3,
    renouvAir=0.581,
    ValeursK={0.00,0.20,0.20,0.20,0.27,0.00,0.00,0.00,0.00},
    TauPonts={1,1,1,1,0.70,1,1,1,1},
    bLNC=0.75,
    bPlancher=0.70,
    bSousCombles=1) "Settings of Mozart individual housing from 1982 to 1989"
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
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
