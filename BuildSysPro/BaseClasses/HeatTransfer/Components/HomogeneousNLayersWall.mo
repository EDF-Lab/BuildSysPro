within BuildSysPro.BaseClasses.HeatTransfer.Components;
model HomogeneousNLayersWall
  "Pure thermal conduction in an N homogeneous layers wall"

  parameter Integer n=2 "Number of distinct layers";
  parameter Integer m[n]=3*fill(1, n) "Number of meshes by layer";
  parameter Modelica.Units.SI.Area S=1;
  parameter Modelica.Units.SI.Length[n] e=0.2*fill(1, n)
    "Layers thickness (from outside to inside)";

  parameter BuildSysPro.Utilities.Records.GenericSolid mat[n]
    "Constituting materials of the wall (from outside to inside)"
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Temperature Tinit=293.15;
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
<h4>Model of 1-D thermal conduction in an N layers material</h4>
<p>Uses the <a href=\"modelica://BuildSysPro.BaseClasses.HeatTransfer.Components.Wall\"><code>Wall</code></a> component, which derives from the <a href=\"modelica://BuildSysPro.BaseClasses.HeatTransfer.Components.Material\"><code>Material</code></a> and <a href=\"modelica://BuildSysPro.BaseClasses.HeatTransfer.Components.MaterialLayer\"><code>MaterialLayer</code></a> components.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The <code>T</code> variable gives the temperature in the middle of each node (<code>m</code> equidistants meshes on the given <code>ep</code> thickness).</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 10/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Hassan BOUIA, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Hassan Bouia 06/2012 : correction du bug qui empêchait le fonctionnement du modèle lorsqu'on ne saisissait qu'un seul matériau avec une seule couche.</p>
<p>Hassan Bouia 04/2014 : changement de la modélisation de la paroi - elle est désormais représentée par une Paroi composée de Materiau(x), eux-mêmes composés de CoucheDeMateriau.</p>
</html>"));
end HomogeneousNLayersWall;
