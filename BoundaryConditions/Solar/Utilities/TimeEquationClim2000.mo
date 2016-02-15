within BuildSysPro.BoundaryConditions.Solar.Utilities;
function TimeEquationClim2000 "Equation du temps"
  input Real t0=0 "Temps en secondes à t=0";
  input Modelica.SIunits.Time t "Temps en secondes";
  output Real ET "Equation du temps (en heures)";
protected
  constant Real pi=Modelica.Constants.pi;
  Real wd1=(2*pi/365.25)*mod((t+t0)/86400,365);
  Real wd2=2*wd1;
  Real wd3=3*wd1;
algorithm
  ET:=(0.0002 - 0.4197*cos(wd1) + 3.2265*cos(wd2) + 0.0903*cos(wd3)
              + 7.3509*sin(wd1) + 9.3912*sin(wd2) + 0.3361*sin(wd3))/60.0;
  annotation (Documentation(info="<html>
<p>Fonction calculant l'équation du temps en fonction de (t0+t) donné en secondes avec la méthode de calcul de CLIM2000;</p>
<p>l'année étant supposée non bisextile.</p>
<p>t : Instant de calcul en secondes.</p>
<p>t0 : temps en secondes écoulé depuis le premier janvier à t=0s de la simulation.</p>
<p>En sortie, l'équation du temps est en heures.</p>
<p>_________</p>
<p><u><b>Hypothèses et équations</b></u> </p>
<p>ET=(0.0002 - 0.4197*cos(wd) + 3.2265*cos(2*wd) + 0.0903*cos(3*wd)</p>
<p>+ 7.3509*sin(wd) + 9.3912*sin(2*wd) + 0.3361*sin(3*wd))/60.0;</p>
<p>avec : wd=2*pi/365.25*d et d jour de l'année en fonction de t0+t.</p>
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
</html>"));
end TimeEquationClim2000;
