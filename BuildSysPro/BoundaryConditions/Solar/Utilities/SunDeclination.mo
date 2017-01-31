within BuildSysPro.BoundaryConditions.Solar.Utilities;
function SunDeclination "Sun declination"
  input Real t0=0 "Time in seconds at t=0";
  input Modelica.SIunits.Time t "Time in seconds";
  output Modelica.SIunits.Angle delta "Sun's declination (angle in radians)";
protected
  constant Real pi=Modelica.Constants.pi;
  Real wd1=(2*pi/365.25)*mod((t+t0)/86400,365);
  Real wd2=2*wd1;
  Real wd3=3*wd1;
algorithm
  delta:=(0.302 - 22.93*cos(wd1) - 0.229*cos(wd2) - 0.243*cos(wd3)
                + 3.851*sin(wd1) + 0.002*sin(wd2) - 0.055*sin(wd3))*pi/180;
  annotation (Documentation(info="<html>
<p><i><b>Function computing the Sun's declination depending on (t0 + t) given in seconds</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<P>The function return the Sun's declination in radians given by the following equation:</p>
<P>delta:=(0.302 - 22.93*cos(wd) - 0.229*cos(2*wd) - 0.243*cos(3*wd)
+ 3.851*sin(wd) + 0.002*sin(2*wd) - 0.055*sin(3*wd))*pi/180</p>
<p> Where wd=2*pi/365<.25 * d (d day of the year according to t0+t)</p>

<p>The year is supposed to be not bisextile.</p>
<p><u><b>Bibliography</b></u></p>
<p>H. BOUIA, \"Amélioration du temps de calcul dans BuildSysPro par traitements numériques optimisés de la conduction et des calculs solaires\", Note H-E14-2013-00715-FR, 03/2013. </p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013.  </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Hassan Bouia 03/2013 : Simplification de l'écriture et adaptation au nouveau modèle MeteoFile</p>
</html>"));
end SunDeclination;
