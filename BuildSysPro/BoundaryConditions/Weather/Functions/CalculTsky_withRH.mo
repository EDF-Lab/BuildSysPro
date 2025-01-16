within BuildSysPro.BoundaryConditions.Weather.Functions;
function CalculTsky_withRH
  "Compute the sky temperature knowing the relative humidity"
  input Modelica.Units.SI.Time t "Time";
  input Real T_seche "Dry  bulb temperature [K]";
  input Real G[10] "Solar information vector";
  input Real Pvap "Water vapor pressure [Pa]";
  output Real T_ciel "Sky tempereture [K]";

protected
  constant Real d2r=Modelica.Constants.pi/180;
  constant Modelica.Units.SI.HeatFlux Isc=1367 "Solar constant";
  Modelica.Units.SI.HeatFlux I0
    "Extraterrestrial irradiance on a horizontal surface (outside the atmosphere)";

  Real Kt "Clearness index";
  Real sin_h "Sine of the sun's elevation";

algorithm
  sin_h := G[6];
  I0 :=max(0, Isc*(1 + 0.033*cos((360*(floor((t + G[5])/86400) + 1)/365)*d2r))*
    sin_h);
  Kt:=if noEvent(sin_h>0.02 and I0>0) then (if noEvent(G[4]<I0) then G[4]/I0 else 1) else 0;
  T_ciel:=94+12.6*log(Pvap)-13*Kt+0.341*T_seche;

  annotation (Documentation(info="<html>
<p><i><b>This function returns the sky temperature from the water vapor pressure and the dry bulb temperature.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This function returns the sky temperature based on the following equation:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/Tciel_avecHR.png\" alt=\"T_ciel=94+12.6*ln(P_vap)-13*K_t+0.341*T_seche\"/></p>
<p>with:</p>
<ul>
<li>Kt defined as the ratio between the global horizontal received to the ground and the global horizontal received outside atmosphere.</li>
<li>Pvap the water vapor pressure.</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>Longwave sky radiation parameterizations ,  M. Aubinet, Solar Energy n&deg;53 (version 2) pp. 147-154, 1994 </p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Precautions for use</b></u></p>
<p>This sky temperature estimation is more  precise than the one obtained with <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Functions.CalculTsky_withoutRH\">CalculTsky_withoutRH model</a>.</p>
<p>Of course, there are other correlations to calculate the sky temperature.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 03/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end CalculTsky_withRH;
