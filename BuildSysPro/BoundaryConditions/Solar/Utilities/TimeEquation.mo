within BuildSysPro.BoundaryConditions.Solar.Utilities;
function TimeEquation "Equation of time"
  input Real t0=0 "Time in seconds at t=0";
  input Modelica.Units.SI.Time t "Time in seconds";
  output Real ET "Equation of time (in hour)";
protected
  Real w=2*Modelica.Constants.pi/365.25;
  Real d=mod((t+t0)/86400,365)+1;
algorithm
  ET:= 0.128*sin(w*(d-2)) + 0.164*sin(2*w*(d+10));
  annotation (Documentation(info="<html>
<p><i><b>Function computing the equation of time according to (t0 + t) given in seconds</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The function returns the equation of time in radians according to (t0 + t) given in seconds:</p>
<p>ET=0.128*sin(w*(d-2)) + 0.164*sin(2*w*(d+10)</p>
<p> Where w=2*pi/365.25 and d day of the year according to t0+t.</p>
<p>The year is supposed to be not bisextile.</p>
<p><u><b>Bibliography</b></u></p>
<p>H. BOUIA, \"Amélioration du temps de calcul dans BuildSysPro par traitements numériques optimisés de la conduction et des calculs solaires\", Note H-E14-2013-00715-FR, 03/2013. </p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013.</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>
",                                                                           revisions="<html>
<p>Hassan Bouia 03/2013 : Simplification de l'écriture et adaptation au nouveau modèle MeteoFile</p>
<p>Benoît Charrier 01/2016 : Correction d'une erreur dans le calcul du quantième : remplacement de la ligne <code>Real d=mod((t+t0)/86400,365);</code> par <code>Real d=mod((t+t0)/86400,365)+1;</code>.</p>
</html>"));
end TimeEquation;
