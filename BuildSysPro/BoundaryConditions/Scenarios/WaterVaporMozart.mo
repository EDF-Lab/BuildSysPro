within BuildSysPro.BoundaryConditions.Scenarios;
block WaterVaporMozart
  "Scénario de vapeur d'eau pour un bâtiment Mozart (6,2kg/jour ou perso)"

  parameter Integer ChoixScenario=1 "Scénario 6,2kg ou perso"                                      annotation(choices(
choice=1 "6,2 kg/jour", choice=2 "Perso"));

  parameter String tableName1="data1" annotation(Dialog(enable= ChoixScenario==2,group="A renseigner pour un scénario Perso"));
  parameter String fileName1="Nom du fichier 1" annotation(Dialog(enable= ChoixScenario==2,group="A renseigner pour un scénario Perso"));
  parameter String tableName2="data2" annotation(Dialog(enable= ChoixScenario==2,group="A renseigner pour un scénario Perso"));
  parameter String fileName2="Nom du fichier 2" annotation(Dialog(enable= ChoixScenario==2,group="A renseigner pour un scénario Perso"));

protected
  parameter String tableName1_p=if (ChoixScenario==1) then "data1" else tableName1;
  parameter String fileName1_p=if (ChoixScenario==1) then Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/Humidite_Mozart_6kgMonoz_1.txt") else fileName1;
  parameter String tableName2_p=if (ChoixScenario==1) then "data2" else tableName2;
parameter String fileName2_p=if (ChoixScenario==1) then Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/Humidite_Mozart_6kgMonoz_2.txt") else fileName2;

public
  BuildSysPro.BoundaryConditions.Scenarios.StepFunctionMat combiStep1Ds1(
    tableName2=tableName2_p,
    fileName1=fileName1_p,
    fileName2=fileName2_p,
    tableOnFile1=true,
    tableOnFile2=true,
    columns2={2,3,4,5,6,7,8,9,10},
    tableName1=tableName1_p)
    annotation (Placement(transformation(extent={{-66,44},{-34,76}})));
  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Modelica.Blocks.Interfaces.RealOutput SdB
    "Debit en kg/s de vapeur d'eau dans la salle de bain"
    annotation (Placement(transformation(extent={{-14,24},{8,46}}),
        iconTransformation(extent={{-74,40},{-54,60}})));
  Modelica.Blocks.Interfaces.RealOutput Cuisine
    "Debit en kg/s de vapeur d'eau dans la cuisine" annotation (Placement(
        transformation(extent={{-14,48},{8,70}}), iconTransformation(extent={{-74,
            70},{-54,90}})));
  Modelica.Blocks.Interfaces.RealOutput Chambre1
    "Debit en kg/s de vapeur d'eau dans la chambre 1" annotation (Placement(
        transformation(extent={{-14,-2},{8,20}}), iconTransformation(extent={{-74,
            0},{-54,20}})));
  Modelica.Blocks.Interfaces.RealOutput Chambre2
    "Debit en kg/s de vapeur d'eau dans la chambre 2" annotation (Placement(
        transformation(extent={{-14,-28},{8,-6}}), iconTransformation(extent={{-74,
            -30},{-54,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Chambre3
    "Debit en kg/s de vapeur d'eau dans la chambre 3" annotation (Placement(
        transformation(extent={{-14,-54},{8,-32}}), iconTransformation(extent={{
            -74,-60},{-54,-40}})));
  Modelica.Blocks.Interfaces.RealOutput Sejour
    "Debit en kg/s de vapeur d'eau dans le séjour" annotation (Placement(
        transformation(extent={{-14,-80},{8,-58}}), iconTransformation(extent={{
            -74,-90},{-54,-70}})));
  Modelica.Blocks.Interfaces.RealOutput ZoneService
    "Debit en kg/s de vapeur d'eau dans la zone de service (cuisine + sdb)"
    annotation (Placement(transformation(extent={{40,40},{62,62}}),
        iconTransformation(extent={{-14,50},{6,70}})));
  Modelica.Blocks.Interfaces.RealOutput ZoneVie
    "Debit en kg/s de vapeur d'eau dans la zone de vie (3 chambres + séjour)"
    annotation (Placement(transformation(extent={{40,-38},{62,-16}}),
        iconTransformation(extent={{-14,-50},{6,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Monozone
    "Debit en kg/s de vapeur d'eau total" annotation (Placement(transformation(
          extent={{88,14},{110,36}}),iconTransformation(extent={{46,10},{66,30}})));
equation

  connect(clock.y, combiStep1Ds1.u) annotation (Line(
      points={{-79,60},{-69.2,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[2], SdB) annotation (Line(
      points={{-32.4,58.9333},{-26,58.9333},{-26,35},{-3,35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[1], Cuisine) annotation (Line(
      points={{-32.4,58.5778},{-18,58.5778},{-18,59},{-3,59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[3], Chambre1) annotation (Line(
      points={{-32.4,59.2889},{-26,59.2889},{-26,9},{-3,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[4], Chambre2) annotation (Line(
      points={{-32.4,59.6444},{-26,59.6444},{-26,-17},{-3,-17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[5], Chambre3) annotation (Line(
      points={{-32.4,60},{-26,60},{-26,-43},{-3,-43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[6], Sejour) annotation (Line(
      points={{-32.4,60.3556},{-26,60.3556},{-26,-69},{-3,-69}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[7], ZoneService) annotation (Line(
      points={{-32.4,60.7111},{-26,60.7111},{-26,51},{51,51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[8], ZoneVie) annotation (Line(
      points={{-32.4,61.0667},{-26,61.0667},{-26,-27},{51,-27}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[9], Monozone) annotation (Line(
      points={{-32.4,61.4222},{-26,61.4222},{-26,25},{99,25}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),      graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-80,94},{-48,30}},
          lineColor={85,170,255},
          lineThickness=0.5),
        Rectangle(
          extent={{-80,26},{-48,-96}},
          lineColor={85,170,255},
          lineThickness=0.5),
        Rectangle(
          extent={{-20,74},{12,-56}},
          lineColor={85,170,255},
          lineThickness=0.5),
        Rectangle(
          extent={{40,36},{72,4}},
          lineColor={85,170,255},
          lineThickness=0.5),
        Rectangle(
          extent={{-100,100},{100,-100}},
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-20,60},{-48,60}},
          color={85,170,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-20,-40},{-48,-40}},
          color={85,170,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,20},{12,20}},
          color={85,170,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(extent={{34,-46},{54,-66}}, lineColor={0,128,255}),
        Ellipse(
          extent={{34,-56},{54,-76}},
          lineColor={0,128,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{46,-36},{74,-62}}, lineColor={0,128,255}),
        Ellipse(extent={{68,-46},{88,-66}}, lineColor={0,128,255}),
        Rectangle(
          extent={{46,-54},{74,-70}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{68,-56},{88,-76}},
          lineColor={0,128,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,-46},{74,-64}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{46,-44},{74,-70}},
          lineColor={0,128,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,-60},{74,-76}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{56,-94},{48,-68}},
          smooth=Smooth.None,
          color={0,128,255}),
        Line(
          points={{60,-94},{60,-60}},
          smooth=Smooth.None,
          color={0,128,255}),
        Line(
          points={{64,-94},{72,-68}},
          smooth=Smooth.None,
          color={0,128,255})}),
                Placement(transformation(extent={{98,-10},{118,10}})),
    Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Scénario de production interne de vapeur d'eau journalière pour la maison Mozart (3 chambres, séjour, cuisine, SdB/WC). On suppose qu'il n'y a pas de production de vapeur dans l'entrée/couloir.</p>
<p>Il s'agit du scénario utilisé pour une production journalière de <b>6,2 kg</b> de vapeur d'eau (famille de 4 personnes : 2 adultes + 2 enfants, un adulte + 2 enfants rentrant pour déjeuner en pause méridienne, occupation intermittente l'après-midi par 1 adulte).</p>
<p>Pour une exécution plus rapide, ce modèle lit les valeurs prédéfinies dans un fichier, y comprend pour les sommes par zone.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Pour les données générales de production de vapeur d'eau <a href=\"modelica://BuildSysPro/Resources/Images/Aeraulique/Prod_vapeur_comparaison.pdf\">voir ici</a></p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Chaque sortie délivre un débit massique (en kg/s). La production de vapeur au détail de chaque pièce est disponible, ainsi que les sommes par zone (service et vie) et totale (monozone). Les sorties utiles sont à connecter avec le connecteur adéquat de la zone d'air humide correspondante. Ce débit est intégré dans l'équation de bilan de masse d'air sec et de vapeur. Dans l'équation de bilan enthalpique, ce flux de vapeur est supposé<b> être produit à la même température que celle de la zone.</b></p>
<p>Il est également possible d'utiliser un scénario personnalisé.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>L'échelle de temps mini est la 1/2h. En dessous on utilise des fractions d'occupation (1/2 personne par exemple).</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Benoît Charrier 06/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Gilles Plessis 09/2015 : Utilisation de la fonction <code>Modelica.Utilities.Files.loadResource</code> pour le chargement de fichiers, pour une meilleure compatibilité avec le standard Modelica.</p>
</html>"));
end WaterVaporMozart;
