within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM;
record UnheatedRoomBefore1974 =
BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.BuildingType
    (
    redeclare parameter WallData.CollectiveHousing.Before1974.Floor
      PlancherBas,
    redeclare parameter WallData.CollectiveHousing.IntermediateFloor
                                                   PlancherInterm,
    redeclare parameter WallData.CollectiveHousing.Before1974.ExtWall
                                                    MurExt,
    redeclare parameter WallData.CollectiveHousing.Before1974.Ceiling
      ParoiSousCombles,
    PontsTh_Generique=4.3,
    PontsTh_Bas=1.32,
    PontsTh_Haut=1.38,
    TauxRenouvAir=0.703,
    b_SousSol=0.2) "Settings of unheated room collective housing before 1974"
                                                             annotation (
    Documentation(info="<html>
<p><i><b>Record of unheated room collective housing settings according to the date of construction</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of the building stock library</p>
<p>Notes H-E10-1996-02908-FR  and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
