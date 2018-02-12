within BuildSysPro.Utilities.Records;
record GenericWall "Walls generic structure - from outdoor to indoor"

parameter Integer n=3 "Number of layers";
parameter Integer[n] m=fill(1,n) "Number of meshes per layer";
parameter Modelica.SIunits.Length[n] e=0.2*fill(1,n)
    "Thickness of layers (ext to int)";
  parameter BuildSysPro.Utilities.Records.GenericSolid mat[n]
    "Materials of the wall - from outdoor to indoor"
    annotation (choicesAllMatching=true);
 parameter Integer[n] positionIsolant=zeros(n)
    "Vector indicating the position of the insulating layers";

  annotation (Documentation(info="<html>
<h4>Data structure for the characterization of multi-layer walls</h4>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This <i>record </i>describes:</p>
<ul>
<li>n : number of layers of materials,</li>
<li>m : vector describing the number of meshes per layer of materials,</li>
<li>e : vecteur décrivant l'épaisseur de chaque couche de matériaux,</li>
<li>mat : vector describing the thickness of each layer of materials,</li>
<li>positionIsolant : vector identifying the location of insulating layers in the wall.</li>
</ul>
<p>This last vector allows functions to identify the insulating layers and so to parameterize a building according to its average thermal transmission coefficient (Ubat, W/K.m²).</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aurélie Kaemmerlen, Gilles Plessis 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
Author : Aurélie KAEMMERLEN, Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"),                                                                    Icon(graphics));
end GenericWall;
