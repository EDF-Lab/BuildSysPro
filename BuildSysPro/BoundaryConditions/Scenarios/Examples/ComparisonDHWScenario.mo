within BuildSysPro.BoundaryConditions.Scenarios.Examples;
model ComparisonDHWScenario
extends Modelica.Icons.Example;
  BuildSysPro.BoundaryConditions.Scenarios.ScenarioRT scenarioRT
    annotation (Placement(transformation(extent={{-68,-2},{-26,40}})));

  ScenarioDHW scenarioAutre(ConsoAn=2459.96, ChoixScenario=1)
    annotation (Placement(transformation(extent={{14,10},{34,30}})));
  annotation (
    Diagram(graphics={Text(
          extent={{-76,90},{88,48}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Variables to visualize:
- ConsoECS of scenarioRT and Conso of scenarioAutre
- DebitECS of scenarioRT and Debit of scenarioAutre")}),
    experiment(StopTime=3.1536e+007, Interval=600),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
    
<p><i><b>Macro-model for the comparison of domestic hot water scenarios.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This macro model helps only to illustrate the difference of fetching profiles between the profile from the french building regulation and other profile (AICVF...).</p>
<p>The annual consumption value (consoAn= 2459.96 L) was arbitrarily defined to stick to a regulatory weekly consumption of 50 L.</p>
<p>The block <i>ScenarioAutre</i> was calibrated on the domestic hot water consumption of RT 2012 (french building regulation) profile through the parameter consoAn.</p>
<p><br><u><b>Bibliography</b></u></p>
<p>None</p>
<p><u><b>Instruction for use</b></u></p>
<p>Simulate then visualize on the same graph the DHW profiles. Do the same for consumptions on another graph.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>None</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 11/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p> 
</html>"));
end ComparisonDHWScenario;
