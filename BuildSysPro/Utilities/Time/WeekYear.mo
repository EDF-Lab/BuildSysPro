within BuildSysPro.Utilities.Time;
function WeekYear
  "Week of the year at time t (year supposed to be not bisextile)"
  input Real t0=0 "Time in second at t=0";
  input Real t "Elapsed time since t=0 [s]";
  output Integer SA "Week of the year";
algorithm
  SA:=integer((t + t0)/604800) + 1; // "604800=7*24*3600"

annotation (
Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Function computing the week of the year according to (t0 + t) given in seconds.</p>
<p>The year is supposed to be not bisextile.</p>
<p>t : calculation moment in seconds.</p>
<p>t0 : elapsed time in seconds since January 1 at t=0s of the simulation.</p>
<p>As output, the week is a real number in the range [1, 52[. </p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p>Hassan BOUIA 03/2013 - Mise à jour des fonctions de temps en remplacement des anciennes (optimisation temps calcul)</p>
</html>"));
end WeekYear;
