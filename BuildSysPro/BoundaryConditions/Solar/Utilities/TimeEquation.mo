within BuildSysPro.BoundaryConditions.Solar.Utilities;
function TimeEquation "Equation du temps"
  input Real t0=0 "Temps en secondes à t=0";
  input Modelica.SIunits.Time t "Temps en secondes";
  output Real ET "Equation du temps (en heures)";
protected
  Real w=2*Modelica.Constants.pi/365.25;
  Real d=mod((t+t0)/86400,365)+1;
algorithm
  ET:= 0.128*sin(w*(d-2)) + 0.164*sin(2*w*(d+10));
  annotation (Documentation(info="<html>
<p>Fonction calculant l'équation du temps en fonction de (t0+t) donné en secondes ;</p>
<p>l'année étant supposée non bisextile.</p>
<p>t : Instant de calcul en secondes.</p>
<p>t0 : temps en secondes écoulé depuis le premier janvier à t=0s de la simulation.</p>
<p>En sortie, l'équation du temps est en radians.</p>
<p>_________</p>
<p><u><b>Hypothèses et équations</b></u> </p>
<p>ET=0.128*sin(w*(d-2)) + 0.164*sin(2*w*(d+10)</p>
<p>avec : w=2*pi/365.25 et d jour de l'année en fonction de t0+t.</p>
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
<p>Benoît Charrier 01/2016 : Correction d'une erreur dans le calcul du quantième : remplacement de la ligne <code>Real d=mod((t+t0)/86400,365);</code> par <code>Real d=mod((t+t0)/86400,365)+1;</code>.</p>
</html>"));
end TimeEquation;
