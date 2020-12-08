within BuildSysPro.BoundaryConditions.Weather.Functions;
function ConvertLongitude "Longitude conversion for astronomical functions"

  input Boolean Est=true
    "East=true: input longitude given in °East; if not, in °Ouest";
  input Real LongIn "Input longitude of the given place";
  output Real LongOut "Longitude of the place converted into an output";

algorithm
  //The longitude is already inversed if it is given in °Ouest
  LongOut:=if Est then LongIn else -LongIn;
  // The longitude is replaced in the interval [-180° ; 180°[
  LongOut:=LongOut - 360*integer(LongOut/360 + 0.5);

  annotation (Documentation(info="<html>
<p><i><b>Function converting the longitude for astronomical application</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The conversion is performed as:</p>
<ul>
<li> <code>LongOut</code>&gt;0 in the East</li>
<li> <code>LongOut</code>&lt;0 in the West</li>
<li> <code>|LongOut|</code> &lt;180° </li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Aurélie Kaemmerlen 09/2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.4.0<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 06/2012 : correction de la fonction car le résultat était erroné lors d'une saisie en &deg;Ouest d'une longitude &gt;180&deg; et en &deg;Est d'une longitude &lt;-180&deg;</p>
<p>Hassan Bouia 03/2013 : simplification des formules</p>
</html>"));
end ConvertLongitude;
