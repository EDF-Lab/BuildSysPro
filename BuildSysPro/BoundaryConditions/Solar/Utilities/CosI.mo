within BuildSysPro.BoundaryConditions.Solar.Utilities;
function CosI "Cosinus de l'angle d'incidence"
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut
    "Azimut du Soleil en degrés";
  input Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl
    "Inclinaison en degrés";
  input Real CosDir[3] "Cosinus Directeurs du Vecteur Solaire";
  output Real cosi "Cosinus de l'angle d'incidence";
protected
  constant Real d2r=Modelica.Constants.pi/180;
  Real s=incl*d2r "Inclinaison";
  Real g=azimut*d2r "Orientation";
  // Cosinus directeurs du plan
  Real l=cos(s);
  Real m=sin(s)*sin(g);
  Real n=sin(s)*cos(g);
algorithm
  //cosi:=max(0,l*CosDir[1]+m*CosDir[2]+n*CosDir[3]);
  cosi:=max(0,{l,m,n}*CosDir);

  annotation (Documentation(info="<html>
<p>Fonction calculant le cosinus (cosI) de l'angle d'incidence à (t0+t) en fonction de :&GT;/p&GT; </p>
<p>- l'inclinaison s et l'orientation g (azimut) de la paroi impactée par les rayons solaires ; </p>
<p>- le Cosinus directeur du Soleil (CosDir[3]).</p>
<p>L'année est supposée non bisextile.</p>
<p>t : Instant de calcul en secondes.</p>
<p>t0 : temps en secondes écoulé depuis le premier janvier à t=0s de la simulation.</p>
<p>En sortie, le cosI est un réel dans l'intervalle [0 ; 1].</p>
<p>_________</p>
<p><u><b>Hypothèses et équations</b></u> </p>
<p>cosi = max(0,l*CosDir[1]+m*CosDir[2]+n*CosDir[3])</p>
<p>avec :</p>
<p>l=cos(s)</p>
<p>m=sin(s)*sin(g)</p>
<p>n=sin(s)*cos(g) </p>
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
end CosI;
