within BuildSysPro.Utilities.Math;
function IGCD "Integers greatest common divisor (fr: PGCD)"
  input Integer a,b;
  output Integer c;
algorithm
  c := if b == 0 then a else IGCD(b, mod(a, b));
  annotation (Documentation(info="<html>
<p><i><b>Return the greatest common divisor of 2 integers.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Based on simple recursive algorithm.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Easy to use.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validation</b></u></p>
<p>Validated function - Hassan Bouia 02/2015</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Hassan BOUIA, EDF (2015)<br>
--------------------------------------------------------------</b></p>
</html>"));
end IGCD;
