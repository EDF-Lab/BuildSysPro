within BuildSysPro.BoundaryConditions.Solar.Utilities;
function TimeEquationClim2000 "Equation of time"
  input Real t0=0 "Time in seconds at t=0";
  input Modelica.SIunits.Time t "Time in seconds";
  output Real ET "Equation of time (in hour)";
protected
  constant Real pi=Modelica.Constants.pi;
  Real wd1=(2*pi/365.25)*mod((t+t0)/86400,365);
  Real wd2=2*wd1;
  Real wd3=3*wd1;
algorithm
  ET:=(0.0002 - 0.4197*cos(wd1) + 3.2265*cos(wd2) + 0.0903*cos(wd3)
              + 7.3509*sin(wd1) + 9.3912*sin(wd2) + 0.3361*sin(wd3))/60.0;
  annotation (Documentation(info="<html>
<p><i><b>Function computing the equation of time according to (t0 + t) given in seconds using the method from CLIM2000</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The function returns the equation of time according to (t0 + t) given in seconds using the method from CLIM2000:</p>
<p>ET=(0.0002 - 0.4197*cos(wd) + 3.2265*cos(2*wd) + 0.0903*cos(3*wd)
+ 7.3509*sin(wd) + 9.3912*sin(2*wd) + 0.3361*sin(3*wd))/60.0</p>
<p> Where wd=2*pi/365.25*d et day of the year according to t0+t</p>
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
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.3.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end TimeEquationClim2000;
