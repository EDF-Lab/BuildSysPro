within BuildSysPro.Utilities.Time;
function TimeElapsedFromJanuary1st
  "Elapsed time in seconds from January 1st, 0h0min0s to the given date"
  input String date="01/01_00:00:00"
    "Date at t=0s (start of the simulation) in the form de dd/mm_hh:mm:ss";
  output Modelica.SIunits.Time Instant0
    "Elapsed time in seconds since 01/01_00:00:00";
  // t[5] : day, month, hour, minute, second (2 digits over 3)
protected
  Integer t[5]={Modelica.Utilities.Strings.scanInteger(
     Modelica.Utilities.Strings.substring(date,3*i-2,3*i-1)) for i in 1:5};
  parameter Real fMois[13]={0,31,28,31,30,31,30,31,31,30,31,30,31};
  parameter Real cMois[13]={sum({fMois[i] for i in 1:j})  for j in 1:13};
algorithm
 Instant0:=86400*(cMois[t[2]]+t[1]-1)+t[5]+60*(t[4]+60*t[3]);

annotation (
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This function calculates the elapsed time in seconds since January 1st of the year.</p>
<p>As input, the date is entered at t=0s (of the simulation) in the form dd/mm_hh:mm:ss.</p>
<p>The days, months, hours, minutes and seconds are entered on 2 digits separated by exactly one any character.</p>
<p>As output, the elapsed time in seconds within the year from the 01/01 0:00:00.</p>
<p>This time is in the range [0 s; 31536000s[.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013. </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end TimeElapsedFromJanuary1st;
