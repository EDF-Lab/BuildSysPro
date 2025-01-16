within BuildSysPro.Utilities.Time;
function DayMonth "Day of the month at time t"
  input Real t0=0 "Time in second at t=0";
  input Real t "Elapsed time since t=0 [s]";
  output Real JM "Day of the month at time t";

protected
  parameter Integer fMois[13]={0,31,28,31,30,31,30,31,31,30,31,30,31};
  Integer cMois[13];//={sum({fMois[i] for i in 1:j}) for j in 1:13};
  Integer tJour=integer(mod((t+t0)/86400,365))+1;
algorithm

  cMois[1]:=0;
  for i in 2:13 loop
    cMois[i]:=cMois[i - 1] + fMois[i];
  end for;

  JM:=max({(if tJour > cMois[i] and tJour <= cMois[i + 1] then tJour - cMois[i] else 0) for i in 1:12});

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Function computing the day of the month according to (t0 + t) given in seconds.</p>
<p>The year is supposed to be not bisextile.</p>
<p>t : calculation moment in seconds</p>
<p>t0: elapsed time in seconds since January 1st at t=0s of the simulation</p>
<p>As output, the day is a real number in the range [0, 31[.</p>
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
end DayMonth;
