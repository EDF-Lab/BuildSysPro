within BuildSysPro.BoundaryConditions.Solar.Utilities;
function CosDirSunVectorHeightAz
  "Compute the sun's direction cosine, the solar elevation and azimuth angle"

  input Real t0=0 "Time in seconds at t=0";
  input Modelica.SIunits.Time t "Universal time in seconds";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg longitude
    "Longitude in degrees";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg latitude
    "Latitude in degrees";
  output Real CosDir[3] "Sun's direction cosine";
  output Real Az "Solar azimuth angle";
  output Real Haut "Solar elevation angle";
protected
  constant Real pi=Modelica.Constants.pi;
  constant Real d2r=pi/180;
  constant Real w=2*pi/365.25;
  Real d=mod((t+t0)/86400,365)+1;
//  Real d=mod(integer(t+t0)/86400,365);
  Real wd1=w*d;
  Real wd2=2*wd1;
  Real wd3=3*wd1;
  // Sun's declination in radians
  Real delta= (0.302 - 22.93*cos(wd1) - 0.229*cos(wd2) - 0.243*cos(wd3)
                + 3.851*sin(wd1) + 0.002*sin(wd2) - 0.055*sin(wd3))*d2r;
  // Equation of time in hours
  Real ET = 0.128*sin(w*(d-2)) + 0.164*sin(2*w*(d+10));
  // Real Solar Time in hours
  Real TSV= (t+t0)/3600+longitude/15-ET;
  // Hour Angle
  Real AH= (TSV-12)*pi/12;
  // Latitude in radians
  Real phi=latitude*d2r;
  Real cosh;
  Real sinAz;
  Real cosAz;
algorithm
  CosDir[1]:=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(AH) "=CosV=SinH";
  CosDir[2]:=cos(delta)*sin(AH) "=CosW";
  CosDir[3]:=cos(delta)*sin(phi)*cos(AH)-sin(delta)*cos(phi) "=CosS";
  cosh:=if CosDir[1] > 0 then sqrt(1 - CosDir[1]*CosDir[1]) else 1;
  sinAz:=CosDir[2]/cosh;
  cosAz:=CosDir[3]/cosh;
  Haut:=asin(CosDir[1])/d2r;
  if sinAz>=0 then
      Az:=acos(cosAz*0.999)/d2r;
  else
      Az:=-acos(cosAz*0.999)/d2r;
  end if;
  annotation (Documentation(info="<html>
        <p><i><b>Function returning the sun's direction cosine, the solar elevation and azimuth angle</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Function computing the sun's direction cosine (CosDir[3]), the solar elevation and azimuth angle (Haut and Az) à (t0+t) according to latitude and longitude.</p>
<ul>
<li>CosDir[1]=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(HA) (=sinh)</li>
<li>CosDir[2]=cos(delta)*sin(HA)</li>
<li>CosDir[3]=cos(delta)*sin(phi)*cos(HA)-sin(delta)*cos(phi)</li>
<li>Height=asin(CosDir[1])*180/pi in degrees</li>
<li>Az is determined by its sine and cosine:</li>
<ul>
<li>sinAz=CosDir[2]/cosh</li>
<li>cosAz=CosDir[3]/cosh</li>
</ul>
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
<p>Validated function - Hassan BOUIA 03/2013.  </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.3.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 11/2013 : Modification du calcul (cosAz*0.999) pour éviter une discontinuité dûe au calcul de l'arcosinus de Modelica</p>
<p>Benoît Charrier 01/2016 : Correction d'une erreur dans le calcul du quantième : remplacement de la ligne <code>Real d=mod((t+t0)/86400,365);</code> par <code>Real d=mod((t+t0)/86400,365)+1;</code>.</p>
</html>"));
end CosDirSunVectorHeightAz;
