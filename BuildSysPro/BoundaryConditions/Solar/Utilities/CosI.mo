within BuildSysPro.BoundaryConditions.Solar.Utilities;
function CosI "Cosine of the angle of incidence"
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Surface azimuth in degree";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl
    "Surface tilt in degree";
  input Real CosDir[3] "Sun's direction cosines";
  output Real cosi "Cosine of the angle of incidence";
protected
  constant Real d2r=Modelica.Constants.pi/180;
  Real s=incl*d2r "Tilt";
  Real g=azimut*d2r "Orientation";
  // Direction cosines of the plane
  Real l=cos(s);
  Real m=sin(s)*sin(g);
  Real n=sin(s)*cos(g);
algorithm
  //cosi:=max(0,l*CosDir[1]+m*CosDir[2]+n*CosDir[3]);
  cosi:=max(0,{l,m,n}*CosDir);

  annotation (Documentation(info="<html>
<p><i><b>Function computing the cosine (cosI) of the angle of incidence at (t0 + t)</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p> 
<p>The function returns <b>cosI[3]</b> of the angle of incidence defined between the solar beam and surface normal. The output is of real type in the interval [0; 1]:</P>
<p>cosi = max(0,l*CosDir[1]+m*CosDir[2]+n*CosDir[3])</P>
<p>with:</P>
<ul>
<li>l=cos(s)</li>
<li>m=sin(s)*sin(g)</li>
<li>n=sin(s)*cos(g)</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated function - Hassan BOUIA 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Hassan Bouia 03/2013 : Simplification de l'écriture et adaptation au nouveau modèle MeteoFile</p>
</html>"));
end CosI;
