within BuildSysPro.Utilities.Records;
record SimulationOptions "Record for the configuration of simulation options"

  Real startTime=0 "Start time of simulation" annotation (Dialog(
      group="Simulation Interval",
      label="Start time",
      absoluteWidth=15));

  Real stopTime=31532400 "Simulation stop time" annotation (Dialog(
      group="Simulation Interval",
      label="Stop time",
      absoluteWidth=15));

  Real outputInterval=3600 "Recovery time step (if > 0)" annotation (
      Dialog(
      group="Output",
      label="Interval length",
      absoluteWidth=15));
/*  Integer numberOfIntervals=500 
"Number of intervals (if > 0 and Interval length == 0) "
    annotation (Dialog(
      group="Output",
      label="Number of intervals",
      absoluteWidth=15));*/
  Boolean saveEvents=false "Events logging" annotation (
      Dialog(
      group="Output"));
  BuildSysPro.Utilities.Types.IntegrationMethod integrationMethod=Types.IntegrationMethod.Dassl
    "Solver to use" annotation (Dialog(
      group="Integration",
      label="Algorithm",
      absoluteWidth=15));

 Real integrationTolerance=1e-3 "Relative error tolerance" annotation (
      Dialog(
      group="Integration",
      label="Tolerance",
      absoluteWidth=15));

 Real fixedStepSize=0 "Step size for fixed step integrators" annotation (
      Dialog(
      group="Integration",
      label="Fixed integrator step",
      absoluteWidth=15));

  annotation (Icon(graphics={
        Line(
          points={{-100,0},{100,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-100,20},{-100,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{100,20},{100,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,10},{-60,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,10},{-20,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,10},{20,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,10},{60,-10}},
          color={0,0,0},
          smooth=Smooth.None)}), Documentation(revisions="<html>
<p>Gilles Plessis : Ajout du booléen saveEvents pour permettre la sauvegarde, ou non, des événements de simulation via la fonctions Dymola experimentSetupOutput. Suppresion de la possibilité de paramétrer l'étude en nombre de pas de temps.</p>
</html>", info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end SimulationOptions;
