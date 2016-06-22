within BuildSysPro.Utilities.Time;
function ApparentSolarTime "Real Solar Time (RST)"
  input Real t0=0 "Time in seconds at t=0";
  input Modelica.SIunits.Time t "Universal Time in seconds";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg longitude
    "Longitude in degrees";
  output Real TSV "Real Solar Time in hrs (RST = UT + longitude/15 - TM)";
algorithm
  TSV :=(t + t0)/3600 + longitude/15 -
    BoundaryConditions.Solar.Utilities.TimeEquation(t0=t0, t=t);
  TSV:=mod(TSV + 24, 24);
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Function computing the Real Solar Time according to (t0 + t) given in seconds.</p>
<p>The longitude is in degrees and the time equation (TE) in hours.</p>
<p>The year is supposed to be not bisextile.</p>
<p>t : calculation moment in seconds</p>
<p>t0: elapsed time in seconds since January 1st at t=0s of the simulation</p>
<p>As output, the solar time is in hours.</p>
<p>RST = (t+t0)/3600 + longitude/15 - TE</p>
<p>Then RST is converted to the hour of the day, in the range [0 ; 24[ modulo 24 : RST = mod(RST+24,24).</p>
<p><u><b>Bibliography</b></u></p>
<p>[1] : H. BOUIA, \"Amélioration du temps de calcul dans BuildSysPro par traitements numériques optimisés de la conduction et des calculs solaires\", Note H-E14-2013-00715-FR, 03/2013.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ApparentSolarTime;
