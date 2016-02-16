within BuildSysPro.BuildingStock.Utilities.Records.WallData.CollectiveHousing;
record SupportingWall =
    BuildSysPro.Utilities.Icons.VerticalInternalWall (
      n=1,
      m={2},
      e={0.16},
      mat={
          BuildSysPro.Utilities.Data.Solids.Concrete()},
      positionIsolant={0}) "Refends LC"                                                               annotation (
    Icon(graphics), Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>Site de la bibliothèque des bâtiments types</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Frédéric Gastiger 01/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
