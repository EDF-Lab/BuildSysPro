within BuildSysPro.BoundaryConditions.Solar.Utilities;
function HourAngle "Angle horaire (AH)"
  input Modelica.SIunits.Time t0=0 "Temps en secondes à t=0";
  input Modelica.SIunits.Time t "Temps universel en secondes";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg longitude
    "longitude en degrés";
  output Real AH "Angle horaire en radians : AH = 15*TSV*pi/180";
protected
  Real TSV=BuildSysPro.Utilities.Time.ApparentSolarTime(
      t0=t0,
      t=t,
      longitude=longitude);
algorithm
  AH:=(TSV-12)*Modelica.Constants.pi/12;
  annotation (Documentation(info="<html>
<p>Fonction calculant l'angle horaire à (t0+t) en fonction du temps solaire vrai TSV;</p>
<p>l'année étant supposée non bisextile.</p>
<p>t : Instant de calcul en secondes.</p>
<p>t0 : temps en secondes écoulé depuis le premier janvier à t=0s de la simulation.</p>
<p>En sortie, l'angle horaire est en radians.</p>
<p>_________</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>AH = (TSV-12)*pi/12. </p>
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
end HourAngle;
