within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record Mozart1989to2000_10pc =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    (
    redeclare replaceable parameter
      WallData.IndividualHousing.From1989to2000_10pc.AtticWall ParoiSousCombles,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1989to2000_10pc.Door Porte,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1989to2000_10pc.Floor PlancherBas,
    redeclare replaceable parameter
      WallData.IndividualHousing.From1989to2000_10pc.ExtWall Mur,
    redeclare replaceable parameter WallData.IndividualHousing.PartitionWall
      Cloisons,
    redeclare replaceable parameter WallData.IndividualHousing.SupportingWall
      Refends,
    hsExtVert=16.67,
    hsIntVert=9.09,
    hsIntHorHaut=11.11,
    UvitrageAF=2.1,
    UvitrageSF=2.1,
    renouvAir=0.551,
    ValeursK={0.00,0.20,0.20,0.20,0.27,0.00,0.00,0.00,0.00},
    TauPonts={1,1,1,1,0.75,1,1,1,1},
    bLNC=0.75,
    bPlancher=0.75,
    bSousCombles=1)
  "Settings of Mozart individual housing from 1989 to 2000 -10%"
  annotation (Documentation(info="<html>
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
