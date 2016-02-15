within BuildSysPro.BoundaryConditions.Weather.Functions;
function ConvertLongitude
  "Fonction convertissant la longitude pour les fonctions astro"

  input Boolean Est=true
    "Est=true : longitude en entrée donnée en °Est; sinon, en °Ouest";
  input Real LongIn "Longitude du lieu donnée en entrée";
  output Real LongOut "Longitude du lieu convertie en sortie";

algorithm
  // On inverse déjà la longitude si elle est donnée en °Ouest
  LongOut:=if Est then LongIn else -LongIn;
  // On remet la longitude dans l'intervalle [-180° ; 180°[
  LongOut:=LongOut - 360*integer(LongOut/360 + 0.5);

  annotation (Documentation(info="<html>
<p>Cette fonction convertie la longitude afin qu'elle soit utilisable par les fonctions astro </p>
<ul>
<li>&GT;0 a l'Est</li>
<li>&LT;0 a l'Ouest</li>
<li>de valeur absolue &LT;180&deg;</li>
</ul>
<p>Fonction validée par calculs analytiques simples - Aurélie Kaemmerlen 09/2010 </p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 06/2012 : correction de la fonction car le résultat était erroné lors d'une saisie en &deg;Ouest d'une longitude &GT;180&deg; et en &deg;Est d'une longitude &LT;-180&deg;</p>
<p>Hassan Bouia 03/2013 : simplification des formules</p>
</html>"));
end ConvertLongitude;
