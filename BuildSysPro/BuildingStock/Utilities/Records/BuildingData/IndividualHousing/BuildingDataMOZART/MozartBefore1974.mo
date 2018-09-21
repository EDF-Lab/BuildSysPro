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
    hsExtVert=16.67,
    hsIntVert=9.09,
    hsIntHorHaut=11.11,
    UvitrageAF=5.8,
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
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
