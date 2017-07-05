within BuildSysPro.BoundaryConditions.Solar.Utilities;
function CosDirSunVector "Sun's direction cosines"
  input Real t0=0 "Time in seconds at t=0";
  input Modelica.SIunits.Time t "Universal time in seconds";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg longitude
    "Longitude in degrees";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg latitude
    "Latitude in degrees";
  output Real CosDir[3] "Sun's direction cosine";
protected
  constant Real pi=Modelica.Constants.pi;
  constant Real d2r=pi/180;
  constant Real w=2*pi/365.25;
  Real d=mod((t+t0)/86400,365)+1;
//  Real d=mod(integer(t+t0)/86400,365);
  Real wd1=w*d;
  Real wd2=2*wd1;
  Real wd3=3*wd1;
  // Sun declination in radians
  Real delta= (0.302 - 22.93*cos(wd1) - 0.229*cos(wd2) - 0.243*cos(wd3)
                + 3.851*sin(wd1) + 0.002*sin(wd2) - 0.055*sin(wd3))*d2r;
  // Equation of time in hours
  Real ET = 0.128*sin(w*(d-2)) + 0.164*sin(2*w*(d+10));
  // Real solar time in radians
  Real TSV= (t+t0)/3600+longitude/15-ET;
  // Hour angle
  Real AH= (TSV-12)*pi/12;
  // Latitude in radians
  Real phi=latitude*d2r;
algorithm
  CosDir[1]:=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(AH) "=CosV=SinH";
  CosDir[2]:=cos(delta)*sin(AH) "=CosW";
  CosDir[3]:=cos(delta)*sin(phi)*cos(AH)-sin(delta)*cos(phi) "=CosS";
  annotation (Documentation(info="<html>
<p><i><b>Function computing the sun's direction cosines at (t0 + t) depending on longitude and latitude</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The function returns the direction cosine of solar beam as a vector <b>CosDir[3] </b></p>
<ul>
<li>CosDir[1]=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(HA) (=sinh)</li>
<li>CosDir[2]=cos(delta)*sin(HA)</li>
<li>CosDir[3]=cos(delta)*sin(phi)*cos(HA)-sin(delta)*cos(phi)</li>
</ul>
<p>Where:</p>
<ul>
<li>phi : latitude converted in radians</li>
<li>delta : Sun's declination in radians</li>
<li>HA : hour angle in radians</li>
</ul>
<p>The year is supposed to be not bisextile.</p>
<p><u><b>Bibliography</b></u></p>
<p>H. BOUIA, \"Amélioration du temps de calcul dans BuildSysPro par traitements numériques optimisés de la conduction et des calculs solaires\", Note H-E14-2013-00715-FR, 03/2013. </p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013. </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 01/2016 : Correction d'une erreur dans le calcul du quantième : remplacement de la ligne <code>Real d=mod((t+t0)/86400,365);</code> par <code>Real d=mod((t+t0)/86400,365)+1;</code>.</p>
</html>"));
end CosDirSunVector;
