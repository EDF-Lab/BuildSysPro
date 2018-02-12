within BuildSysPro.BoundaryConditions.Solar.Utilities;
function SineH "Sine of the solar elevation angle"
  input Real t0=0 "Time in seconds at t=0";
  input Modelica.SIunits.Time t "Universal time in seconds";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg longitude
    "Longitude in degrees";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg latitude
    "Latitude in degrees";
  output Real sin_h "Sine of the solar elevation angle";
protected
  constant Real d2r=Modelica.Constants.pi/180;
  Real phi=latitude*d2r;
  Real AH=HourAngle(
      t0=t0,
      t=t,
      longitude=longitude);
  Real delta=SunDeclination(t0=t0, t=t);
algorithm
  sin_h:=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(AH);
  sin_h:=max(0, sin_h);
  annotation (Documentation(info="<html>
        <p><i><b>Return the sine of the solar elevation angle at (t0 + t) according to the longitude (in degrees) and the latitude (in degrees)</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The function computing the sine of the solar elevation angle at (t0 + t) according to the longitude (in degrees) and the latitude (in degrees).</p>
<p>Output <b>sin_h</b> is a real in the interval [0; 1] and computed as:</p>
<ol>
<li>sin(h)=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(HA)</li>
<li>sin(h)=max(0, sin(h))</li>
</ol>
<p>Where:</p>
<ul>
<li>phi: latitude converted in radians</li>
<li>delta: sun declination in radians </li>
<li>HA : hour angle in radians</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>H. BOUIA, \"Amélioration du temps de calcul dans BuildSysPro par traitements numériques optimisés de la conduction et des calculs solaires\", Note H-E14-2013-00715-FR, 03/2013. </p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function  - Hassan BOUIA 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Hassan Bouia 03/2013 : Simplification de l'écriture et adaptation au nouveau modèle MeteoFile</p>
<p>Benoît Charrier 01/2017 : Renommage de la sortie <code>sinh</code> en <code>sin_h</code> pour éviter toute confusion avec la fonction sinus hyperbolique de Modelica ayant le même nom</p>
</html>"));
end SineH;
