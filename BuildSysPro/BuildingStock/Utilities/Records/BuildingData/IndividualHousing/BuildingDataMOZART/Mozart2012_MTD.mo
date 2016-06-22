within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record Mozart2012_MTD =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    (
    redeclare replaceable parameter
      WallData.IndividualHousing.RT2012_MTD.AtticWall ParoiSousCombles,
    redeclare replaceable parameter WallData.IndividualHousing.RT2012_MTD.Door
                                                 Porte,
    redeclare replaceable parameter WallData.IndividualHousing.RT2012_MTD.Floor
                                                  PlancherBas,
    redeclare replaceable parameter
      WallData.IndividualHousing.RT2012_MTD.ExtWall Mur,
    redeclare replaceable parameter WallData.IndividualHousing.PartitionWall
      Cloisons,
    redeclare replaceable parameter WallData.IndividualHousing.SupportingWall
      Refends,
    UvitrageAF=1.5,
    UvitrageSF=1.5,
    renouvAir=0.426,
    ValeursK={0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00},
    TauPonts={1,1,1,1,1,1,1,1,1},
    bLNC=0.95,
    bPlancher=1,
    bSousCombles=1)
  "Settings of Mozart individual housing best available technology 2012"
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Note H-E10-1996-02908-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Warning : thermal bridges have been set to null because of a lack of data, it will be necessary to complete them when more details are available.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
