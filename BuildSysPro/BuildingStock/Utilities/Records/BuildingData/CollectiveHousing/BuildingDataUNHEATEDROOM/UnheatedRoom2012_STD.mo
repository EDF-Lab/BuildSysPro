within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM;
record UnheatedRoom2012_STD =
   BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.BuildingType
    (
    redeclare parameter WallData.CollectiveHousing.RT2012_STD.Floor PlancherBas,
    redeclare parameter WallData.CollectiveHousing.IntermediateFloor
                                                   PlancherInterm,
    redeclare parameter WallData.CollectiveHousing.RT2012_STD.ExtWall MurExt,
    redeclare parameter WallData.CollectiveHousing.RT2012_STD.Ceiling
      ParoiSousCombles,
    PontsTh_Generique=0.00,
    PontsTh_Bas=0.00,
    PontsTh_Haut=0.00,
    TauxRenouvAir=0.3,
    b_SousSol=0.55)
  "Settings of unheated room collective housing standard 2012"
  annotation (Documentation(info="<html>
<p><i><b>Record of unheated room collective housing settings according to the date of construction</b></i></p>
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
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Benoît Charrier 06/2017 : <ul><li>editing value of air renewal <code>renouvAir</code> from 0,426 to 0,3 vol/h to fit with a humidity sensitive ventilation system which is commonly used in RT2012</li>
<li>setting thermal bridge values to null because actual values are not representative, will need to be adjusted when more data is available</li></ul></p>
</html>"));
