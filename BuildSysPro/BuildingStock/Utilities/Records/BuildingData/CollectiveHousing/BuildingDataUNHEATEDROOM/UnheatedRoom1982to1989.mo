within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM;
record UnheatedRoom1982to1989 =
   BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataUNHEATEDROOM.BuildingType
    (
    redeclare parameter WallData.CollectiveHousing.From1982to1989.Floor
                                                      PlancherBas,
    redeclare parameter WallData.CollectiveHousing.IntermediateFloor
                                                   PlancherInterm,
    redeclare parameter WallData.CollectiveHousing.From1982to1989.ExtWall
                                                        MurExt,
    redeclare parameter WallData.CollectiveHousing.From1982to1989.Ceiling
      ParoiSousCombles,
    PontsTh_Generique=5.8,
    PontsTh_Bas=1.32,
    PontsTh_Haut=1.38,
    TauxRenouvAir=0.592,
    b_SousSol=0.55)
  "Settings of unheated room collective housing from 1982 to 1989"
  annotation (Documentation(info="<html>
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
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
