within BuildSysPro.Systems.Solar;
package PV "Solaire photovoltaïque"


annotation (Documentation(info="<html>
<p><i><b>Modèles permettant d'évaluer la production de panneaux photovolta&iuml;ques</b></i></p>
<p>Informations sur la structure du package :</p>
<p>- BoiteAOutils : modèles élémentaires qui servent à la fois aux modèles simplifiés ModelesSimplifies et aux modèles plus complexes ModelesElectriques</p>
<p>- ModelesSimplifies : modèles simples qui permettent de déterminer le productible et la puissance d'un panneau photovolta&iuml;que à partir de données fournisseur (datasheet)</p>
<p>- ModelesElectriques : modèles nécessitant des données supplémentaires par rapport aux données fournisseur (datasheet). Ils permettent en revanche de connaître en plus du productible et de la puissance, la tension et l'intensité en sortie de l'installation, ce qui est très important pour certaines études (impact réseau, charge de batterie,...). Pour la modélisation électrique des panneaux photovolta&iuml;ques, il faut des flashs expérimentaux (I-V) pour déterminer les paramètres dits &QUOT;2 diodes&QUOT;. Pour la modélisation électrique de l'onduleur, il faut un simulateur de champ photovolta&iuml;que afin de déterminer expérimentalement les courbes de rendement à différents niveaux de tension, et à partir de là extraire les paramètres nécessaires pour le modèle Sandia</p>
<p>Pour toute question quant à la modélisation des panneaux photovolta&iuml;ques, se référer aux notes H-E16-2013-00785-FR et H-E14-2013-01767-FR</p>
  <p><b>-----------------------------------------------------------------------<br>
  Licensed by EDF under the Modelica License 2<br>
  Copyright &copy; EDF 2009 - 2016<br>
  This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2.<br>
  For license conditions (including the disclaimer of warranty) see <a href=\"modelica://BuildSysPro.UsersGuide.ModelicaLicense2\">BuildSysPro.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\">http://www.modelica.org/licenses/ModelicaLicense2</a>.<br>
  -----------------------------------------------------------------------</b></p>
</html>"));
end PV;
