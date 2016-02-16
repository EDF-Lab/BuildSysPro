within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
function PointOnSurface
  "Fonction de recherche si un point appartient à une fenêtre"

input Modelica.SIunits.Distance Lf "Largeur de la fenêtre";
input Modelica.SIunits.Distance Hf "Hauteur de la fenêtre";
input Real X0 "Coordonnée selon X du point";
input Real Y0 "Coordonnée selon Y du point";

output Boolean Inclus "=true si le point appartient à la surface";

algorithm
if (X0 < 0) or (X0 > Lf) then
  Inclus := false;
else
  if (Y0 < 0) or (Y0 > Hf) then
    Inclus :=false;
  else
    Inclus := true;
  end if;
end if;

  annotation (Documentation(info="<html>
<p>Modèle validé - Aurélie Kaemmerlen 04/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end PointOnSurface;
