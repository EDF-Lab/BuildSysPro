﻿within BuildSysPro.Utilities.Time;
function DayWeek "Day of the week at time t"
  input Real t0=0 "Time in seconds at t=0";
  input Real t "Elapsed time since t=0 [s]";
  output Real JS "Day of the week at time t";

algorithm
  JS:=mod((t + t0)/86400, 7);

annotation (
Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Function computing the day of the week according to (t0 + t) given in seconds.</p>
<p>The year is supposed to be not bisextile.</p>
<p>t : calculation moment in seconds</p>
<p>t0: elapsed time in seconds since January 1 at t=0s of the simulation</p>
<p>As output, the day is a real number in the range [0, 7[.</p>
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
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",
    revisions="<html>
<p>Hassan BOUIA 03/2013 - Mise à jour des fonctions de temps en remplacement des anciennes (optimisation temps calcul)</p>
</html>"));
end DayWeek;
