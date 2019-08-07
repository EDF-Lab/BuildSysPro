within BuildSysPro.Utilities.Time;
function Date
  input Real t0=0 "Elapsed time in second at t=0";
  input Real t "Elapsed time since t=0 [s]";
  output Integer d "Number of the day in the month = 0 for the first day";
algorithm
  d := integer((t+t0)/86400);
annotation (
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Function computing the day number of the month in the year at the time (t0 + t) given in seconds depending on t and t0.</p>
<p>The year is supposed to be not bisextile.</p>
<p>t : calculation moment in seconds</p>
<p>t0: elapsed time in seconds since January 1st at t=0s of the simulation</p>
<p>As output, the function calculates the day number of the month in the year at (t0 + t), elapsed time in seconds since 01/01 0:00:00.</p>
<p><b>N.B.</b> : 0 is the day number of the month on January 1st.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",
        revisions="<html>
<p>Hassan BOUIA 03/2013 - Mise à jour des fonctions de temps en remplacement des anciennes (optimisation temps calcul)</p>
</html>"));
end Date;
