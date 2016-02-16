within BuildSysPro.BoundaryConditions.Solar.Utilities;
function CosDirSunVectorHeightAz
  "Cosinus directeurs du vecteur solaire + hauteur et Azimuth"
  input Real t0=0 "Temps en secondes à t=0";
  input Modelica.SIunits.Time t "Temps universel en secondes";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg longitude
    "Longitude en degrés";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg latitude
    "Latitude en degrés";
  output Real CosDir[3] "Cosinus de l'angle d'incidence";
  output Real Az;
  output Real Haut;
protected
  constant Real pi=Modelica.Constants.pi;
  constant Real d2r=pi/180;
  constant Real w=2*pi/365.25;
  Real d=mod((t+t0)/86400,365)+1;
//  Real d=mod(integer(t+t0)/86400,365);
  Real wd1=w*d;
  Real wd2=2*wd1;
  Real wd3=3*wd1;
  // Déclinaison du Soleil en radians
  Real delta= (0.302 - 22.93*cos(wd1) - 0.229*cos(wd2) - 0.243*cos(wd3)
                + 3.851*sin(wd1) + 0.002*sin(wd2) - 0.055*sin(wd3))*d2r;
  // Equation du temps en heures
  Real ET = 0.128*sin(w*(d-2)) + 0.164*sin(2*w*(d+10));
  // TempsSolaire Vrai en heures
  Real TSV= (t+t0)/3600+longitude/15-ET;
  // Angle horaire
  Real AH= (TSV-12)*pi/12;
  // Latitude en radians
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
<p>Fonction calculant le cosinus directeur du Soleil (CosDir[3]), sa hauteur (haut) et son azimut (Az) à (t0+t) en fonction de la longitude et la latitude. </p>
<p>L'année est supposée non bisextile.</p>
<p>t : Instant de calcul en secondes.</p>
<p>t0 : temps en secondes écoulé depuis le premier janvier à t=0s de la simulation.</p>
<p>En sortie, le Cosinus directeur du Soleil est un vecteur CosDir[3].</p>
<p>_________</p>
<p><u><b>Hypothèses et équations</b></u> </p>
<p>CosDir[1]=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(AH) (=sinh)</p>
<p>CosDir[2]=cos(delta)*sin(AH)</p>
<p>CosDir[3]=cos(delta)*sin(phi)*cos(AH)-sin(delta)*cos(phi)</p>
<p>phi : latitude convertie en radians</p>
<p>delta : déclinaison du Soleil en radians</p>
<p>AH : angle horaire en radians </p>
<p>Haut=asin(CosDir[1])*180/pi en degrés</p>
<p>Az est déterminé par son sinus et son cosinus :</p>
<p>sinAz=CosDir[2]/cosh</p>
<p>cosAz=CosDir[3]/cosh </p>
<p><u><b>Bibliographie</b></u></p>
<p>[1] : H. BOUIA, &QUOT;Amélioration du temps de calcul dans BuildSysPro par traitements numériques optimisés de la conduction et des calculs solaires&QUOT;, Note H-E14-2013-00715-FR, 03/2013. </p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Fonction validée - Hassan BOUIA 03/2013. </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 11/2013 : Modification du calcul (cosAz*0.999) pour éviter une discontinuité dûe au calcul de l'arcosinus de Modelica</p>
<p>Benoît Charrier 01/2016 : Correction d'une erreur dans le calcul du quantième : remplacement de la ligne <code>Real d=mod((t+t0)/86400,365);</code> par <code>Real d=mod((t+t0)/86400,365)+1;</code>.</p>
</html>"));
end CosDirSunVectorHeightAz;
