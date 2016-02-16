within BuildSysPro.BoundaryConditions.Scenarios;
block ScenarioDHW

  parameter Integer ChoixScenario=3
    "Scénarios AICVF, M324 or Personal scenario"                                                                      annotation(choices(
choice=1 "AICVF", choice=2 "M324", choice=3 "Personal scenario"));

  parameter String tableName1="data1" annotation(Dialog(enable= ChoixScenario==3,group="To fill in for a scenario Perso"));
  parameter String fileName1="File path 2" annotation(Dialog(enable= ChoixScenario==3,group="To fill in for a scenario Perso",
  __Dymola_loadSelector(filter="Text files (*.txt);;Text files (*.prn);;Matlab files (*.mat)",caption="Opening file2")));
  parameter String tableName2="data2" annotation(Dialog(enable= ChoixScenario==3,group="To fill in for a scenario Perso"));
  parameter String fileName2="File path 2" annotation(Dialog(enable= ChoixScenario==3,group="To fill in for a scenario Perso",
    __Dymola_loadSelector(filter="Text files (*.txt);;Text files (*.prn);;Matlab files (*.mat)",caption="Opening file2")));

  parameter Real ConsoAn=32000 "Total annual consumption in L";

  Modelica.Blocks.Math.Gain gain(k=ConsoAn) "Annual consumption in L"
      annotation (Placement(transformation(extent={{42,-10},{62,10}})));
  Modelica.Blocks.Interfaces.RealOutput Debit "Volume flow rate in L/h"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Modelica.Blocks.Interfaces.RealOutput Conso "Consumption en L"
    annotation (Placement(transformation(extent={{94,60},{114,80}})));

  BuildSysPro.BoundaryConditions.Scenarios.StepFunctionMat combiStep1Ds1(
    tableName1=if (ChoixScenario == 1 or ChoixScenario == 2) then "data1" else
        tableName1,
    tableName2=if (ChoixScenario == 1 or ChoixScenario == 2) then "data2" else
        tableName2,
    fileName1=if (ChoixScenario == 1) then
        Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ECS_AICVF_1.prn") else if (ChoixScenario
         == 2) then Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ECS_M324_1.prn") else
        fileName1,
    fileName2=if (ChoixScenario == 1) then
        Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ECS_AICVF_2.prn") else if (ChoixScenario
         == 2) then Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ECS_M324_2.prn") else
        fileName2,
    tableOnFile1=true,
    tableOnFile2=true,
    columns2={2})
    annotation (Placement(transformation(extent={{-46,-16},{-14,16}})));

  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-94,42},{-74,62}})));
equation
  der(Conso)=Debit/3600;

  connect(gain.y, Debit)     annotation (Line(
      points={{63,0},{104,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(clock.y, combiStep1Ds1.u) annotation (Line(
      points={{-73,52},{-62,52},{-62,0},{-49.2,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(combiStep1Ds1.y[1], gain.u) annotation (Line(
      points={{-12.4,0},{40,0}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Placement(transformation(extent={{42,-10},{62,10}})),
              Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),      graphics), Icon(coordinateSystem(
          preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{-80,80},{-86,58},{-74,58},{-80,80}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,58},{-80,-90}}, color={95,95,95}),
        Line(
          points={{-80,-28},{0,-28},{0,40},{80,40}},
          color={0,0,255},
          thickness=0.5),
        Line(points={{-90,-80},{82,-80}}, color={95,95,95}),
        Polygon(
          points={{90,-80},{68,-74},{68,-86},{90,-80}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{51,-50},{97,-68}},
          lineColor={0,0,0},
          textString="time"),
        Polygon(
          points={{0,40},{-81,40},{0,40}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-59,80}},
          lineColor={0,0,0},
          textString="y")}),
                Placement(transformation(extent={{98,-10},{118,10}})),
    Documentation(info="<html>

<p><u><b>Hypothesis and equations</b></u></p>
<p>None</p>
<p><u><b>Bibliography</b></u></p>
<p>None</p>
<p><u><b>Instructions for use</b></u></p>
<p>2 Predefined scenarios can be selected via the drop-down menu (&QUOT;AICVF&QUOT; and &QUOT;M324&QUOT;). If &QUOT;Personal scenario&QUOT; is chosen, then <code>filename1</code>, <code>data1</code>, <code>filename2</code> and <code>data2</code> must be filled.</p>
<p><code>data1</code> and <code>data2</code> are respectively the name of the data table specified in <code>fileName1</code> with heading &QUOT;<code>double data1(13450,2)</code>&QUOT; and in <code>fileName2</code> with heading &QUOT;<code>double data2(13450,2)&QUOT;</code>.</p>
<p>In this example, 13450 indicates the number of x-coordinates and 2 indicates the number of data y (number of columns - here the time + 1 data).</p>
<p>See <a href=\"BuildSysPro.BoundaryConditions.Scenarios.StepFunctionMat\">BuildSysPro.BoundaryConditions.Scenarios.StepFunctionMat</a> block instructions for use.</p>
<p><u><b>Known limits / Precautions for use</span></b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 10/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 10/2011 - Paramétrage des choix des scénarios AICVF, M324 et scénarios personnels</p>
<p>Aurélie Kaemmerlen 06/2012 :</p>
<p><ul>
<li>Blocage des paramètres propres aux scénarios perso lorsque les scénarios pré-établis sont sélectionnés (AICVF et M324)</li>
<li>Remplacement du modèle CombiStep1Ds par le nouveau scénario &QUOT;FctEscalierMat&QUOT;</li>
</ul></p>
<p><br>Aurélie Kaemmerlen 10/2013 : Suppression des paramètres en protected avec les équations conditionnelles définissant les chemins vers les fichiers AICVF et M324 - Donnait une erreur lors de l'exécution après chiffrement du modèle !</p>
</html>"));
end ScenarioDHW;
