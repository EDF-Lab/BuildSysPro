within BuildSysPro.BoundaryConditions.Weather.Functions;
function CalculTsky_withoutRH
  "fonction calculant la température de ciel sans connaître l'humidité relative"
  input Modelica.SIunits.Time t "temps";
  input Real T_seche "température extérieure [K]";
  input Real G[10] "flux solaire";
  output Real T_ciel "température de ciel [K]";

protected
  constant Real d2r=Modelica.Constants.pi/180;
  constant Modelica.SIunits.HeatFlux Isc=1367 "constante solaire";
  Modelica.SIunits.HeatFlux I0
    "éclairement extraterrestre sur une surface horizontale (hors atmosphère)";
  Real Kt "clearness index";
  Real sinh "sinus de la hauteur du soleil";

algorithm
  sinh := G[6];
  I0 :=max(0, Isc*(1 + 0.033*cos((360*(floor((t + G[5])/86400) + 1)/365)*d2r))*
    sinh);
  Kt:=if noEvent(sinh>0.02 and I0>0) then (if noEvent(G[4]<I0) then G[4]/I0 else 1) else 0;
  T_ciel:=-29-19.9*Kt+1.09*T_seche;

  annotation (Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Cette fonction permet de calculer la température de ciel à partir du clearness index Kt et de la température sèche.</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/equations/Tciel_sansHR.png\" alt=\"T_ciel=-29-19.9*K_t+1.09*T_seche\"/></p>
<p>avec </p>
<p>Kt défini comme le rapport entre le global horizontal reçu au sol et le global horizontal reçu hors atmosphère.</p>
<p><u><b>Bibliographie</b></u></p>
<p>Longwave sky radiation parameterizations , M. Aubinet, Solar Energy n&deg;53 (version 2) pp. 147-154, 1994 </p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Cette estimation de la température de ciel est moins précise que celle obtenue avec CalculTciel_avecHR.</p>
<p>Bien entendu, il existe d'autres corrélations permettant de calculer la température de ciel.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 03/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end CalculTsky_withoutRH;
