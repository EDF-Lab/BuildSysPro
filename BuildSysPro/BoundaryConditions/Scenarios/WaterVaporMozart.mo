within BuildSysPro.BoundaryConditions.Scenarios;
block WaterVaporMozart "Water vapour generation scenario"

  parameter Integer ChoixScenario=1 "Scenario choice"                                      annotation(choices(
  choice=1 "Mozart 6.2 kg/day", choice=2 "User-defined"));

  parameter String tableName1="data1" annotation(Dialog(enable= ChoixScenario==2,group="User-defined scenario"));
  parameter String fileName1="Nom du fichier 1" annotation(Dialog(enable= ChoixScenario==2,group="User-defined scenario"));
  parameter String tableName2="data2" annotation(Dialog(enable= ChoixScenario==2,group="User-defined scenario"));
  parameter String fileName2="Nom du fichier 2" annotation(Dialog(enable= ChoixScenario==2,group="User-defined scenario"));

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
    "Flow of water vapor in the bathroom, in kg/s"
    annotation (Placement(transformation(extent={{-14,24},{8,46}}),
        iconTransformation(extent={{-74,40},{-54,60}})));
  Modelica.Blocks.Interfaces.RealOutput Cuisine
    "Flow of water vapor in the kitchen, in kg/s" annotation (Placement(
        transformation(extent={{-14,48},{8,70}}), iconTransformation(extent={{-74,
            70},{-54,90}})));
  Modelica.Blocks.Interfaces.RealOutput Chambre1
    "Flow of water vapor in the bedroom 1, in kg/s" annotation (Placement(
        transformation(extent={{-14,-2},{8,20}}), iconTransformation(extent={{-74,
            0},{-54,20}})));
  Modelica.Blocks.Interfaces.RealOutput Chambre2
    "Flow of water vapor in the bedroom 2, in kg/s" annotation (Placement(
        transformation(extent={{-14,-28},{8,-6}}), iconTransformation(extent={{-74,
            -30},{-54,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Chambre3
    "Flow of water vapor in the bedroom 3, in kg/s" annotation (Placement(
        transformation(extent={{-14,-54},{8,-32}}), iconTransformation(extent={{
            -74,-60},{-54,-40}})));
  Modelica.Blocks.Interfaces.RealOutput Sejour
    "Flow of water vapor in the living room, in kg/s" annotation (Placement(
        transformation(extent={{-14,-80},{8,-58}}), iconTransformation(extent={{
            -74,-90},{-54,-70}})));
  Modelica.Blocks.Interfaces.RealOutput ZoneService
    "Flow of water vapor in the service zone (kitchen + bathroom), in kg/s"
    annotation (Placement(transformation(extent={{40,40},{62,62}}),
        iconTransformation(extent={{-14,50},{6,70}})));
  Modelica.Blocks.Interfaces.RealOutput ZoneVie
    "Flow of water vapor in the living zone (3 bedrooms + living room), in kg/s"
    annotation (Placement(transformation(extent={{40,-38},{62,-16}}),
        iconTransformation(extent={{-14,-50},{6,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Monozone "Total flow of water vapor"
                                annotation (Placement(transformation(
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
<p><i><b>Water vapour scenario for Mozart building (6.2 kg/day)</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Scenario of daily water vapour production for the Mozart dwelling  archetype (3 bedrooms, living room, kitchen, bathroom/ WC). It is assumed that there is no water vapour in the entrance/corridor.
<p>It represents a daily production of 6.2 kg of water vapour assumed to be generated by a family of 4 individuals: 2 adults + 2 children. 
In terms of occupancy , one adult and 2 children are coming back home for lunch during meridian break and it is assumed an intermittent occupancy the afternoon by 1 adult.</p>
<p>This flow is considered into the conservation equation (for mass balance of gases) and in the energy balance equation. This water vapour flow is assumed to be produced at the temperature zone.</p>
<p>For faster execution, this model reads the preset values in a file, including totals per zone</p>
<p><u><b>Bibliography</b></u></p>
<p>For general data on water vapour production <a href=\"modelica://BuildSysPro/Resources/Images/Aeraulique/Prod_vapeur_comparaison.pdf\">see here</a></p>
<p><u><b>Instructions for use</b></u></p>
<p>Each output supplies a mass flow rate in [kg/s]. Water vapour production per room is available, as well as the total flow per zone (service and life) and the total for onezone model.</p>
<p>Useful outputs are to be connected with the appropriate connector of the corresponding air node.</p>
<p>It is also possible to use a customized scenario.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The minimum time scale is 1/2h. Below, occupancy fractions are used (1/2 person for example).</p>
<p><u><b>Validations</b></u></p>
<p>Validated model  - Benoît Charrier 06/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Benoît CHARRIER, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>
",        revisions="<html>
<p>Gilles Plessis 09/2015 : Utilisation de la fonction <code>Modelica.Utilities.Files.loadResource</code> pour le chargement de fichiers, pour une meilleure compatibilité avec le standard Modelica.</p>
</html>"));
end WaterVaporMozart;
