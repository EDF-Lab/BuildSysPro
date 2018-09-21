within BuildSysPro.BoundaryConditions.Weather.Functions;
function CalculTsky_withoutRH
  "Compute the sky temperature not knowing the relative humidity"
  input Modelica.SIunits.Time t "Time";
  input Real T_seche "Dry bulb temperature [K]";
  input Real G[10] "Solar information vector";
  output Real T_ciel "Sky tempereture [K]";

protected
  constant Real d2r=Modelica.Constants.pi/180;
  constant Modelica.SIunits.HeatFlux Isc=1367 "constante solaire";
  Modelica.SIunits.HeatFlux I0
    "éclairement extraterrestre sur une surface horizontale (hors atmosphère)";
  Real Kt "clearness index";
  Real sin_h "sinus de la hauteur du soleil";

algorithm
  sin_h := G[6];
  I0 :=max(0, Isc*(1 + 0.033*cos((360*(floor((t + G[5])/86400) + 1)/365)*d2r))*
    sin_h);
  Kt:=if noEvent(sin_h>0.02 and I0>0) then (if noEvent(G[4]<I0) then G[4]/I0 else 1) else 0;
  T_ciel:=-29-19.9*Kt+1.09*T_seche;

  annotation (Documentation(info="<html>
<p><i><b>This function returns the sky temperature from the clearness index Kt and the dry bulb temperature.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This function returns the sky temperature based on the following equation:</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/Tciel_sansHR.png\" alt=\"T_ciel=-29-19.9*K_t+1.09*T_seche\"/></p>
<p>with Kt defined as the ratio between the global horizontal received to the ground and the global horizontal received outside atmosphere.</p>
<p><u><b>Bibliography</b></u></p>
<p>Longwave sky radiation parameterizations ,  M. Aubinet, Solar Energy n&deg;53 (version 2) pp. 147-154, 1994 </p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Precautions for use</b></u></p>
<p>This sky temperature estimation is less precise than the one obtained with <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Functions.CalculTsky_withRH\">CalculTsky_withRH model</a>.</p>
<p>Of course, there are other correlations to calculate the sky temperature.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 03/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end CalculTsky_withoutRH;
