within BuildSysPro.BuildingStock.Examples;
model MatisseGV
  extends Modelica.Icons.Example;

  BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseMonozone matisseMonozone(redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.MatisseBefore1974
      paraMaisonRT)
    annotation (Placement(transformation(extent={{-32,-32},{30,38}})));
  Modelica.Blocks.Sources.RealExpression G[10](y=fill(0, 10))
    annotation (Placement(transformation(extent={{-100,34},{-80,54}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,90})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=293.15)
    annotation (Placement(transformation(extent={{68,-24},{48,-4}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T=293.15)
    annotation (Placement(transformation(extent={{68,32},{48,52}})));
equation
  connect(G.y, matisseMonozone.G) annotation (Line(
      points={{-79,44},{-58,44},{-58,44.3636},{-38.2,44.3636}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(matisseMonozone.Tair, fixedTemperature1.port) annotation (Line(
      points={{13.57,-9.72727},{29.785,-9.72727},{29.785,-14},{48,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(matisseMonozone.Tmit, fixedTemperature2.port) annotation (Line(
      points={{-1,11.9091},{-1,24},{26,24},{26,42},{48,42}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, matisseMonozone.Text) annotation (Line(
      points={{0,80},{0,44},{-4.1,44},{-4.1,34.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p><i><b>Exemple d'utilisation du Matisse Monozone</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MatisseGV;
