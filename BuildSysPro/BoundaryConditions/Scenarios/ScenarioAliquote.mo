within BuildSysPro.BoundaryConditions.Scenarios;
model ScenarioAliquote

  Modelica.Blocks.Tables.CombiTable1Ds Scenario(
    tableOnFile=true,
    tableName="data",
    columns={2},
    fileName=fileNameScenario)
    annotation (Placement(transformation(extent={{-52,14},{-32,34}})));
  Modelica.Blocks.Sources.RealExpression Jour(y=1 + integer(time/86400))
    annotation (Placement(transformation(extent={{-100,14},{-64,34}})));
  Modelica.Blocks.Sources.RealExpression Heure(y=integer(mod(time/3600, 24)))
    annotation (Placement(transformation(extent={{-100,50},{-64,68}})));
  Modelica.Blocks.Tables.CombiTable2D Valeur(
    tableOnFile=true,
    tableName="data",
    fileName=fileNameTable)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.RealExpression Mois(y=Utilities.Time.MonthYear(t=time))
    annotation (Placement(transformation(extent={{-100,-50},{-26,-30}})));
  Modelica.Blocks.Tables.CombiTable1Ds Coef_mensuel(
    tableName="data",
    columns={2},
    tableOnFile=false,
    table=table,
    fileName="NoName")
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Math.Gain Valeur_Corrigee(k=coefficient_multiplicatif)
    "Average hourly consumption"
    annotation (Placement(transformation(extent={{68,-30},{88,-10}})));
  Modelica.Blocks.Continuous.Integrator Integrateur(k=1/3600)
    "Integral of the corrected value"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput Integrale_Signal "Signal integral"
    annotation (Placement(transformation(extent={{140,70},{160,90}}),
        iconTransformation(extent={{140,70},{160,90}})));
  Modelica.Blocks.Interfaces.RealOutput Signal "Signal" annotation (Placement(
        transformation(extent={{140,-58},{160,-38}}), iconTransformation(extent=
           {{140,-10},{160,10}})));
  parameter String fileNameScenario="NoName" "Daily scenario";
  parameter String fileNameTable="NoName" "Hourly scenario";
  parameter Real table[12,2]=[1, 1; 2, 1; 3, 1; 4, 1; 5, 1; 6, 1; 7, 1; 8, 1; 9, 1; 10,1; 11,1; 12, 1]
    "Monthly corrective coefficients";
  parameter Real coefficient_multiplicatif=1
    "Multiplier coefficients of signal values";
equation
  connect(Jour.y, Scenario.u) annotation (Line(
      points={{-62.2,24},{-54,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Heure.y, Valeur.u1)  annotation (Line(
      points={{-62.2,59},{-10,59},{-10,-4},{-2,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Scenario.y[1], Valeur.u2)  annotation (Line(
      points={{-31,24},{-20,24},{-20,-16},{-2,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Mois.y, Coef_mensuel.u) annotation (Line(
      points={{-22.3,-40},{-2,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, Valeur_Corrigee.u)
                                      annotation (Line(
      points={{61,-20},{66,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Coef_mensuel.y[1], product1.u2) annotation (Line(
      points={{21,-40},{28,-40},{28,-26},{38,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Valeur.y, product1.u1)  annotation (Line(
      points={{21,-10},{30,-10},{30,-14},{38,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Valeur_Corrigee.y, Integrateur.u)
                                          annotation (Line(
      points={{89,-20},{98,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Valeur_Corrigee.y, Signal) annotation (Line(
      points={{89,-20},{94,-20},{94,-48},{150,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Integrateur.y, Integrale_Signal) annotation (Line(
      points={{121,-20},{130,-20},{130,80},{150,80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{140,
            100}}),     graphics),
    experiment(
      StopTime=3.1524e+007,
      Interval=3600,
      __Dymola_Algorithm="Esdirk23a"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{140,100}}, preserveAspectRatio=false),
        graphics={
        Rectangle(
          extent={{-40,40},{-10,20}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(points={{-10,40},{-40,20}}, color={0,0,0}),
        Line(points={{-40,40},{-10,20}}, color={0,0,0}),
        Rectangle(extent={{-100,100},{140,-100}}, lineColor={0,0,255}),
        Rectangle(
          extent={{-10,40},{20,20}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,40},{50,20}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,40},{80,20}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{-10,0}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,0},{-10,-20}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-20},{-10,-40}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,20},{20,0}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,20},{50,0}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,20},{80,0}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,0},{20,-20}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,0},{50,-20}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,0},{80,-20}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,-20},{20,-40}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,-20},{50,-40}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,-20},{80,-40}},
          lineColor={0,0,255},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
    
  
<p><i><b>Scenario tool to set a daily scenario different for every day of the year</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Scenario tool to set a daily scenario different for every day of the year, with monthly modulation.</p>
<p><br><u><b>Bibliography</b></u></p>
<p>None</p>
<p><u><b>Instruction for use</b></u></p>
<p>In the folder Resources/Donnees/Scenarios, it is for example possible to use Scenarios_horaires_occultation.txt for fileNameTable (time scenario) and Scenario_journalier_occultation.txt for fileNameScenario (daily scenario) in order to see the formalism required for text files.</p>
<p>Scenarios_horaires_occultation.txt defines 15 hourly scenarios which are different over 24 hours and Scenario_journalier_occultation.txt maches each day of the year with one of the 15 different hourly scenarios contained in Scenarios_horaires_occultation.txt.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 03/2014</p>  

<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Hassan BOUIA, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ScenarioAliquote;
