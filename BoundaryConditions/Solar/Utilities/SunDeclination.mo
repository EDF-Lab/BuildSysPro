within BuildSysPro.BoundaryConditions.Solar.Utilities;
function SunDeclination "Déclinaison du soleil"
  input Real t0=0 "Temps en secondes à t=0";
  input Modelica.SIunits.Time t "Temps en secondes";
  output Modelica.SIunits.Angle delta
    "Déclinaison du soleil (angle en radians)";
protected
  constant Real pi=Modelica.Constants.pi;
  Real wd1=(2*pi/365.25)*mod((t+t0)/86400,365);
  Real wd2=2*wd1;
  Real wd3=3*wd1;
algorithm
  delta:=(0.302 - 22.93*cos(wd1) - 0.229*cos(wd2) - 0.243*cos(wd3)
                + 3.851*sin(wd1) + 0.002*sin(wd2) - 0.055*sin(wd3))*pi/180;
  annotation (Documentation(info="<html>
<p>Fonction calculant la déclinaison du Soleil en fonction de (t0+t) donné en secondes ;</p>
<p>l'année étant supposée non bisextile.</p>
<p>t : Instant de calcul en secondes.</p>
<p>t0 : temps en secondes écoulé depuis le premier janvier à t=0s de la simulation.</p>
<p>En sortie, la déclinaison est en radians.</p>
<p>_________</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>La déclinaison est donnée par l'équation suivante : </p>
<p>delta:=(0.302 - 22.93*cos(wd) - 0.229*cos(2*wd) - 0.243*cos(3*wd)</p>
<p>+ 3.851*sin(wd) + 0.002*sin(2*wd) - 0.055*sin(3*wd))*pi/180;</p>
<p>avec : wd=2*pi/365.25 * d (d jour de l'année en fonction de t0+t).</p>
<p><u><b>Bibliographie</b></u></p>
<p>[1] : H. BOUIA, &QUOT;Amélioration du temps de calcul dans BuildSysPro par traitements numériques optimisés de la conduction et des calculs solaires&QUOT;, Note H-E14-2013-00715-FR, 03/2013.</p>
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
end SunDeclination;
