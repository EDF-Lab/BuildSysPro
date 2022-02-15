within BuildSysPro.Utilities.Data;
package WallData "Library of wall data"





  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This package regroups wall data, stored in different <i>records</i> characterized by the wall type and these parameters : </p>
<ul>
<li>n : number of materials layers,</li>
<li>m : vector describing the number of meshes by material layer,</li>
<li>e : vector describing the thickness of each material layer,</li>
<li>mat : vector describing the materials constituting the layers,</li>
<li>positionIsolant : vector describing the position of each insulating layer in the wall.</li>
</ul>
<p>The positionIsolant vector allows functions to identify the insulating layers in order to parameterize the building following its average thermal transmission coefficient (Ubat, W/K.m²).</p>
<p><u><b>Bibliography</b></u></p>
<p>Record based on the BESTEST one, adding the positionisolant vector.</p>
<p><u><b>Instructions for use</b></u></p>
<p>Create new wall records based on <a href=\"BuildSysPro.Utilities.Records.GenericWall\">GenericWall</a> then use it, or use directly one of the records declared in this package to define the composition of the walls.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 06/2012</p>
  <p><b>-----------------------------------------------------------------------<br>
  Licensed by EDF under a 3-clause BSD-license<br>
  Copyright &copy; EDF 2009 - 2021<br>
  This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of 3-clause BSD-license.<br>
  For license conditions (including the disclaimer of warranty) see <a href=\"modelica://BuildSysPro.UsersGuide.License\">BuildSysPro.UsersGuide.License</a>.<br>
  -----------------------------------------------------------------------</b></p>
</html>"));
end WallData;
