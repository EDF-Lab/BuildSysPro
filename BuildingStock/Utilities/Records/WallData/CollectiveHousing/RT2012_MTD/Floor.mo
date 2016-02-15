within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing.RT2012_MTD;
record Floor =
   BuildSysPro.Utilities.Icons.Floor (
      n=3,
      m={2,4,2},
      e={0.10,0.18,0.06},
      mat={
          BuildSysPro.Utilities.Data.Solids.FibreBoard(),
          BuildSysPro.Utilities.Data.Solids.Concrete(),
          BuildSysPro.Utilities.Data.Solids.Polyurethane25()},
      positionIsolant={1,0,1})
  "Plancher LC meilleure technologie disponible RT2012"
  annotation (Icon(graphics), Documentation(info="<html>
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
