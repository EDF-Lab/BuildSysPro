within BuildSysPro.BoundaryConditions.Solar.SolarMasks;
function PointOnSurface "Function to determine if a point belongs to a surface"

input Modelica.SIunits.Distance Lf "Surface width";
input Modelica.SIunits.Distance Hf "Surface height";
input Real X0 "X coordinate of the point";
input Real Y0 "Y coordinate of the point";

output Boolean Inclus "=true if the point belongs to surface";

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
<p><i><b> Function to determine if a point belongs to a surface</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Aurélie Kaemmerlen 04/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>
"));
end PointOnSurface;
