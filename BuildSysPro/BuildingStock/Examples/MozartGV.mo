within BuildSysPro.BuildingStock.Examples;
model MozartGV
  extends Modelica.Icons.Example;

  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartMonozone mozartMonozone(redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.MozartBefore1974
      paraMaisonRT)
    annotation (Placement(transformation(extent={{-32,-32},{30,38}})));
  Modelica.Blocks.Sources.RealExpression G[10](y=fill(0, 10))
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=293.15)
    annotation (Placement(transformation(extent={{68,-24},{48,-4}})));
equation
  connect(G.y, mozartMonozone.G) annotation (Line(
      points={{-79,28},{-58,28},{-58,28.4545},{-38.2,28.4545}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port, mozartMonozone.Text) annotation (Line(
      points={{-80,0},{-60,0},{-60,3},{-35.1,3}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mozartMonozone.Tair, fixedTemperature1.port) annotation (Line(
      points={{13.57,-9.72727},{29.785,-9.72727},{29.785,-14},{48,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p><i><b>Exemple d'utilisation du Mozart Monozone</b></i></p>
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
end MozartGV;
