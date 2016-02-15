within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing.RT2012_STD;
record LandingWall =
    BuildSysPro.Utilities.Icons.VerticalInternalWall (
      n=3,
      m={5,3,1},
      e={0.20,0.10,0.01},
      mat={
          BuildSysPro.Utilities.Data.Solids.Concrete(),
          BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene32(),
          BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
      positionIsolant={0,1,0}) "Murs sur palier LC standard RT2012"      annotation (
    Icon(graphics), Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Benoît Charrier 12/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
