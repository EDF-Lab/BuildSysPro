within BuildSysPro.BoundaryConditions.Solar.Utilities;
function SineH "Sinus de la hauteur du Soleil"
  input Real t0=0 "Temps en secondes à t=0";
  input Modelica.SIunits.Time t "Temps universel en secondes";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg longitude
    "Longitude en degrés";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg latitude
    "Latitude en degrés";
  output Real sinh "Sinus de la hauteur du Soleil";
protected
  constant Real d2r=Modelica.Constants.pi/180;
  Real phi=latitude*d2r;
  Real AH=HourAngle(
      t0=t0,
      t=t,
      longitude=longitude);
  Real delta=SunDeclination(t0=t0, t=t);
algorithm
  sinh:=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(AH);
  sinh:=max(0, sinh);
  annotation (Documentation(info="<html>
<p>Fonction calculant le sinus de la hauteur du Soleil à (t0+t) en fonction de la longitude (en degrés) et de la latitude (en degrés);</p>
<p>l'année étant supposée non bisextile.</p>
<p>t : Instant de calcul en secondes.</p>
<p>t0 : temps en secondes écoulé depuis le premier janvier à t=0s de la simulation.</p>
<p>En sortie, le sinus est un réel dans l'intervalle [0 ; 1].</p>
<p>_________</p>
<p><u><b>Hypothèses et équations</b></u> </p>
<p>sin(h)=sin(phi)*sin(delta)+cos(phi)*cos(delta)*cos(AH)</p>
<p>sin(h)=max(0, sin(h))</p>
<p>phi : latitude convertie en radians</p>
<p>delta : déclinaison du Soleil en radians</p>
<p>AH : angle horaire en radians </p>
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
<p>Hassan Bouia 03/2013 : Simplification de l'écriture et adaptation au nouveau modèle MeteoFile</p>
</html>"));
end SineH;
