within BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART;
record MozartRenoExisting =
  BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    (
    redeclare replaceable parameter
      BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.From1989to2000_10pc.AtticWall
      ParoiSousCombles,
    redeclare replaceable parameter
      BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.From1989to2000_10pc.Door
      Porte,
    redeclare replaceable parameter
      BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.From1989to2000_10pc.Floor
      PlancherBas,
    redeclare replaceable parameter
      BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.From1989to2000_10pc.ExtWall
      Mur,
    redeclare replaceable parameter
      BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.PartitionWall
      Cloisons,
    redeclare replaceable parameter
      BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing.SupportingWall
      Refends,
    hsExtVert=16.67,
    hsIntVert=9.09,
    hsIntHorHaut=11.11,
    UvitrageAF=1.8,
    UvitrageSF=1.8,
    renouvAir=0.551,
    ValeursK={0.00,0.20,0.20,0.20,0.27,0.00,0.00,0.00,0.00},
    TauPonts={1,1,1,1,0.75,1,1,1,1},
    bLNC=0.75,
    bPlancher=0.75,
    bSousCombles=1)
  "Settings of Mozart individual housing renovated according to RT Existing"
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p>RT 2012 and RT Existing - Réglementation thermique et efficacité énergétique - D. Molle, P-M. Patry 2011</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Béatrice Suplice, Frédéric Gastiger 04/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Béatrice SUPLICE, Frédéric GASTIGER, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>"));
