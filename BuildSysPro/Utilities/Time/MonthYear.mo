within BuildSysPro.Utilities.Time;
function MonthYear
  "Month of the year at time t (year supposed to be not bisextile)"
  input Real t0=0 "Time in seconds at t=0";
  input Real t "Elapsed time since t=0 [s]";
  output Integer MA "Month of the year";
protected
  parameter Real d=1+mod(integer((t+t0)/86400),365);
  parameter Real fMois[13]={0,31,28,31,30,31,30,31,31,30,31,30,31};
  Real cMois[13];//={sum({fMois[i] for i in 1:j})  for j in 1:13};
algorithm
  cMois[1]:=0;
  for i in 2:13 loop
    cMois[i]:=cMois[i - 1] + fMois[i];
  end for;
  MA:=sum({if d > cMois[i]  and d <= cMois[i+1] then i else 0 for i in 1:12});

annotation (
Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Function computing the month of the year according to (t0 + t) given in seconds.</p>
<p>The year is supposed to be not bisextile.</p>
<p>t : calculation moment in seconds</p>
<p>t0: elapsed time in second since January 1st at t=0s of the simulation</p>
<p>As output, the function calculates the month of the year at (to + t), elapsed time in seconds since 01/01 00:00:00.</p>
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
end MonthYear;
