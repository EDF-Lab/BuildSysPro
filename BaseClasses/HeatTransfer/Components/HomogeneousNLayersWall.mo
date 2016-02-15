within BuildSysPro.BaseClasses.HeatTransfer.Components;
model HomogeneousNLayersWall
  "Conduction thermique pure dans une paroi contenant N couches homogènes"

  parameter Integer n=2 "nombre de couches distinctes";
  parameter Integer m[n]=3*fill(1, n) "nombre de mailles par couches";
  parameter Modelica.SIunits.Area S=1;
    parameter Modelica.SIunits.Length[n] e=0.2*fill(1, n)
    "épaisseur des couches (ext vers int)";

  parameter BuildSysPro.Utilities.Records.GenericSolid mat[n]
    "matériaux constitutifs de la paroi, de l'extérieur vers l'intérieur"
    annotation (__Dymola_choicesAllMatching=true);

  parameter Modelica.SIunits.Temperature Tinit=293.15;
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState;

//extends BuildSysPro.ModelesAvances.ParoiNCouchesHomogenesCrypte(
extends BuildSysPro.BaseClasses.HeatTransfer.Components.Wall(
    nc=n,
    mc=m,
    Sc=S,
    ec=e,
    matc=mat,
    Tinitc=Tinit,
    InitTypec=InitType);

  annotation (Documentation(info="<html>
<h4>Modèle de Conduction thermique 1D dans un matériau à n couches</h4>
<p>Utilise le modèle Paroi qui dérive du modèle Materiau, qui dérive lui-même du modèle CoucheDeMateriau</p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>La variable <b>T</b> donne la température au centre de chaque noeud (<b>m</b> mailles équidistantes sur l'épaisseur <b>ep</b> donnée).</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Hassan Bouia 10/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hassan BOUIA, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Hassan Bouia 06/2012 : correction du bug qui empêchait le fonctionnement du modèle lorsqu'on ne saisissait qu'un seul matériau avec une seule couche.</p>
<p>Hassan Bouia 04/2014 : changement de la modélisation de la paroi - elle est désormais représentée par une Paroi composée de Materiau(x), eux-mêmes composés de CoucheDeMateriau.</p>
</html>"));
end HomogeneousNLayersWall;
