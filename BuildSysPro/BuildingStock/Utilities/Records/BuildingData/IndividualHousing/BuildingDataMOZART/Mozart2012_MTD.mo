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
    renouvAir=0.3,
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
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p style=\"color:red\">Warning : thermal bridges have been set to null because of a lack of data, it will be necessary to complete them when more details are available.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Benoît Charrier 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 06/2017 : editing value of air renewal <code>renouvAir</code> from 0,426 to 0,3 vol/h to fit with a humidity sensitive ventilation system which is commonly used in RT2012</p>
</html>"));
