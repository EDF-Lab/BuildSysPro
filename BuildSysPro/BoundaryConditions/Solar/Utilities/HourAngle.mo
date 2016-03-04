within BuildSysPro.BoundaryConditions.Solar.Utilities;
function HourAngle "Hour Angle (HA)"
  input Modelica.SIunits.Time t0=0 "Time in seconds at t=0";
  input Modelica.SIunits.Time t "Universal time in seconds";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg longitude
    "longitude in degrees";
  output Real AH "Hour Angle in radians: HA = 15*TSV*pi/180";
protected
  Real TSV=BuildSysPro.Utilities.Time.ApparentSolarTime(
      t0=t0,
      t=t,
      longitude=longitude);
algorithm
  AH:=(TSV-12)*Modelica.Constants.pi/12;
  annotation (Documentation(info="<html>
<p><i><b>Function returning Hour Angle at (t 0 + t) according to the True Solar Time</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p> Function returning Hour Angle at (t 0 + t) according to the True Solar Time:</p>
<p>AH = (TSV-12)*pi/12</p>

<p>The year is supposed to be not bisextile.</p>
<p><u><b>Bibliography</b></u></p>
<p>H. BOUIA, \"Amélioration du temps de calcul dans BuildSysPro par traitements numériques optimisés de la conduction et des calculs solaires\", Note H-E14-2013-00715-FR, 03/2013. </p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Hassan Bouia 03/2013 : Simplification de l'écriture et adaptation au nouveau modèle MeteoFile</p>
</html>"));
end HourAngle;
