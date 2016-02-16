within BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing;
record PartitionWall =
      BuildSysPro.Utilities.Icons.VerticalInternalWall (
    n=3,
    m={1,1,1},
    e={0.01,0.03,0.01},
    mat={BuildSysPro.Utilities.Data.Solids.PlasterBoard(),
        BuildSysPro.Utilities.Data.Solids.Air30(),
        BuildSysPro.Utilities.Data.Solids.PlasterBoard()},
    positionIsolant={0,1,0}) "Cloisons Mozart"
                            annotation (
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
<p>Modèle validé - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
