within BuildSysPro.BoundaryConditions.Scenarios.Examples;
model StepFunctionExample
extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.RealExpression HeureDansLajournee(y=mod(time/3600,
        24))
    annotation (Placement(transformation(extent={{-80,-60},{-40,-40}})));
  BuildSysPro.BoundaryConditions.Scenarios.StepFunctionMat fctEsc2(table1=[0,1;
        6,2; 12,3; 14,4; 22,5; 24,5], table2=[1,1; 2,0; 3,0.5; 4,0; 5,1])
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  BuildSysPro.BoundaryConditions.Scenarios.StepFunctionSimpleXY fctEscPer1(
    X={0,6,12,14,22,24},
    Y={1,0,0.5,0,1,1},
    periode=24) annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.RealExpression TempsEnHeure(y=time/3600)
    annotation (Placement(transformation(extent={{-80,40},{-40,60}})));
  BuildSysPro.BoundaryConditions.Scenarios.StepFunctionSimpleXY fctEsc1(
    X={0,6,12,14,22,24},
    Y={1,0,0.5,0,1,1},
    periode=-1) annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  BuildSysPro.BoundaryConditions.Scenarios.StepFunctionMatPeriodic fctEscPer2(
    table1=[0,1; 6,2; 12,3; 14,4; 22,5; 24,5],
    table2=[1,1; 2,0; 3,0.5; 4,0; 5,1],
    periode=24) annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(HeureDansLajournee.y, fctEsc2.u) annotation (Line(
      points={{-38,-50},{-20,-50},{-20,-70},{-2,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TempsEnHeure.y, fctEscPer1.x) annotation (Line(
      points={{-38,50},{-20,50},{-20,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HeureDansLajournee.y, fctEsc1.x) annotation (Line(
      points={{-38,-50},{-20,-50},{-20,-30},{-2,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TempsEnHeure.y, fctEscPer2.u) annotation (Line(
      points={{-38,50},{-20,50},{-20,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                                                 Diagram(graphics={
        Ellipse(extent={{90,58},{40,86}}, lineColor={0,0,255}),
        Text(
          extent={{38,72},{90,68}},
          lineColor={0,0,255},
          textString="Simple periodic table"),
        Ellipse(extent={{98,16},{32,42}}, lineColor={0,0,255}),
        Text(
          extent={{34,28},{96,26}},
          lineColor={0,0,255},
          textString="Periodic matrix - general case"),
        Text(
          extent={{48,-26},{86,-30}},
          lineColor={0,0,255},
          textString="Simple table"),
        Ellipse(extent={{90,-42},{40,-14}}, lineColor={0,0,255}),
        Text(
          extent={{46,-68},{84,-72}},
          lineColor={0,0,255},
          textString="Matrix - general case"),
        Ellipse(extent={{90,-82},{40,-54}}, lineColor={0,0,255})}), Documentation(info="<html>
<p><i><b>Example of step profile</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This example shows the use of different periodic or not step scenarios models.</p>
<p>The two vectors X and Y are:</p>
<p>X = {0,6,12,14,22,24} in hours (in the example)</p>
<p>Y = {1,0,0.5,0,1,1} (step control X-dependent)</p>
<p>When used, the period is 24hrs.</p>
<p>Models used are periodic or not:</p>
<p>- Either simple defining a 2D table by the vectors X and Y.</p>
<p>- Either complex defining a matrix with several columns</p>
<p>In this example, 2 columns [X, Y] split into two tables as advocated in the StepFunctionMat model documentation).</p>
<p>The input signal is:</p>
<p>- the time in hour for periodic models</p>
<p>- time in the day for non-periodic models</p>
<p><br>The goal is to compare the output signals from these 4 models: they must be identical</p>
<p><u><b>Bibliography</b></u></p>
<p>None</p>
<p><u><b>Instructions for use</b></u></p>
<p>None</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 07/2012</p>        
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"),
    experiment(StopTime=864000, Interval=60),
    __Dymola_experimentSetupOutput);
end StepFunctionExample;
