within BuildSysPro.BuildingStock.Utilities.Functions;
function CalculGThermalBridges
  input Real ValeursK[:];
  input Real LongueursPonts[:];
  input Real TauPonts[:];
  output Modelica.SIunits.ThermalConductivity G;

algorithm
  G:=0;

  for i in 1:size(ValeursK,1) loop
    G:=G+ValeursK[i]*LongueursPonts[i]*TauPonts[i];
  end for;

    annotation (Documentation(info="<html>
<p><i><b>Fonction calculant le G(W/K) des ponts thermiques</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Cette fonction permet le calcul des déperditions dues aux ponts thermiques (en W/K)</p>
<p>La fonction a besoin en entrée des vecteurs contenant :</p>
<p>- les longueurs associées aux déperditions linéiques situé dans les records &QUOT;Geometrie&QUOT;</p>
<p>- les valeurs des coefficients de déperdition k (en W/m.K) et coefficients de pondération tau situé dans les records &QUOT;LogementType&QUOT; et caractérisant les réglementations thermiques</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end CalculGThermalBridges;
