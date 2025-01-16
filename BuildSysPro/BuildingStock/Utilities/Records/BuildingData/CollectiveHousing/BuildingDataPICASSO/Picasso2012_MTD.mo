within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO;
record Picasso2012_MTD =
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO.BuildingType
    (
    UvitrageAF=1.5,
    redeclare parameter WallData.CollectiveHousing.RT2012_MTD.Door Porte,
    redeclare parameter WallData.CollectiveHousing.IntDoor PorteInt,
    redeclare parameter WallData.CollectiveHousing.IntermediateFloor
      PlancherInterm,
    redeclare parameter WallData.CollectiveHousing.RT2012_MTD.ExtWall MurExt,
    redeclare parameter WallData.CollectiveHousing.RT2012_MTD.LandingWall
      MurPalier,
    redeclare parameter WallData.CollectiveHousing.RT2012_MTD.Ceiling
      ParoiSousCombles,
    redeclare parameter WallData.CollectiveHousing.RT2012_MTD.Floor PlancherBas,
    redeclare parameter WallData.CollectiveHousing.PartitionWall Cloisons,
    PontsTh_Generique=0.00,
    PontsTh_Bas=0.00,
    PontsTh_Haut=0.00,
    TauxRenouvAir=0.3,
    Hsext=25,
    Hsint=7.69,
    HsParoiSousCombles=10)
  "Settings of Picasso collective housing best available technology 2012"
                                                         annotation (
    Documentation(info="<html>
<p><i><b>Record of Picasso collective housing settings according to the date of construction</b></i></p>
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
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Benoît Charrier 06/2017 : <ul><li>editing value of air renewal <code>renouvAir</code> from 0,426 to 0,3 vol/h to fit with a humidity sensitive ventilation system which is commonly used in RT2012</li>
<li>editing value of U glazings <code>UvitrageAF</code> and <code>UvitrageSF</code> from 1,2 to 1,5 W/m2.K which is more representative of RT2012</li>
<li>setting thermal bridge values to null because actual values are not representative, will need to be adjusted when more data is available</li></ul></p>
</html>"));
