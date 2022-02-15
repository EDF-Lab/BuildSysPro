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
    redeclare replaceable parameter WallData.IndividualHousing.InteriorDoor
      PorteInt,
    hsExtVert=25,
    hsIntVert=7.69,
    hsIntHorHaut=10,
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
<p>Detail of thermal bridge vectors :</p>
<ul>
<li>TauPonts[1] and ValeursK[1] : exterior wall / exterior wall</li>
<li>TauPonts[2] and ValeursK[2] : exterior wall / supporting wall</li>
<li>TauPonts[3] and ValeursK[3] : exterior wall / floor</li>
<li>TauPonts[4] and ValeursK[4] : floor / crawlspace</li>
<li>TauPonts[5] and ValeursK[5] : supporting wall / floor</li>
<li>TauPonts[6] and ValeursK[6] : exterior wall / attic wall</li>
<li>TauPonts[7] and ValeursK[7] : attic wall / attic</li>
<li>TauPonts[8] and ValeursK[8] : door</li>
<li>TauPonts[9] and ValeursK[9] : windows</li>
</ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Béatrice Suplice, Frédéric Gastiger 04/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Béatrice SUPLICE, Frédéric GASTIGER, EDF (2016)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p> 07/2020 - Correction of surface exchange coefficient on  walls (standardisation of all the record with values in agreement with ISO6946)</p>
</html>"));
