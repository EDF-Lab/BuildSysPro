﻿within BuildSysPro.BuildingStock.Utilities.Functions;
function CalculGThermalBridges
  input Real ValeursK[:];
  input Real LongueursPonts[:];
  input Real TauPonts[:];
  output Modelica.SIunits.ThermalConductance G;

algorithm
  G:=0;

  for i in 1:size(ValeursK,1) loop
    G:=G+ValeursK[i]*LongueursPonts[i]*TauPonts[i];
  end for;

    annotation (Documentation(info="<html>
<p><b>Function computing the thermal bridges value G (W/K)</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This function allows the calculation of losses due to thermal bridges (in W/K).</p>
<p>As input, the function requires vectors containing:</p>
<ul><li>The lengths associated with linear losses (per unit length) located in the records <a href=\"modelica://BuildSysPro.BuildingStock.Utilities.Records.Geometry\">Geometry</a>.</li>
<li>Loss coefficients k values (in W/m.K) and weighting coefficients <i>tau</i> located in the records <a href=\"modelica://BuildSysPro.BuildingStock.Utilities.Records.BuildingData\">BuildingData</a> and characterizing thermal regulations.</li></ul>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Benoît Charrier 01/2018 : Changed wrong unit of G from thermal conductivity to thermal conductance.</p>
</html>"));
end CalculGThermalBridges;
