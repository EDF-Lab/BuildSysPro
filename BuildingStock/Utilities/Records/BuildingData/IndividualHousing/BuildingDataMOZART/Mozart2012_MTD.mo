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
  "Paramètres caractérisant une maison Mozart meilleure technologie disponible RT2012"
  annotation (Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Attention : les ponts thermiques ont été caractérisés comme nuls à cause d'un manque de données, il sera nécessaire de les mettre à jour lorsque davantage de données seront disponibles.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Benoît Charrier 12/2015</p>
  <p><b>--------------------------------------------------------------<br>
  Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
