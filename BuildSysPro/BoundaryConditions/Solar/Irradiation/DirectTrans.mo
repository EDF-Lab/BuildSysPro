within BuildSysPro.BoundaryConditions.Solar.Irradiation;
block DirectTrans
  "Calcul de la transmittivité directe d'un vitrage en fonction de l'incidence"
extends Modelica.Blocks.Interfaces.BlockIcon;

parameter Integer choix=2 "Formule utilisée" annotation(choices(
        choice=1 "Fauconnier",
        choice=2 "RT",
        choice=3 "Cardonnel",
        choice=4 "Linéaire avec cosi"));
parameter Real TrDir
    "Coefficient de transmission direct de la fenêtre à incidence normale";

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUX[3]
    "Informations de flux solaire surfacique incident 1-Flux Diffus, 2-Flux Direct 3-Cosi"
    annotation (Placement(transformation(extent={{-140,-26},{-100,14}}),
        iconTransformation(extent={{-120,-6},{-100,14}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput Direct
    "Calcul du flux direct transmis par le vitrage en fonction de l'incidence"
    annotation (Placement(transformation(extent={{80,-20},{120,20}}),
        iconTransformation(extent={{100,-8},{120,12}})));

// Variables internes
protected
Real cosi;
Real PondTransDir;
// Coefficients calculés pour la formule de Fauconnier
parameter Real c0 = 0.0139 - 0.1093*TrDir - 0.0079*TrDir^2;
parameter Real c1 = -0.0895 + 0.7662*TrDir + 0.4706*TrDir^2;
parameter Real c2 = 0.0751 + 0.3489*TrDir - 0.4563*TrDir^2;

// Coefficients calculés pour la formule de la RT
parameter Real tau30 = -7.068e-4 + TrDir*9.3967e-1 + (TrDir^2)*7.0476e-2;
parameter Real tau60 = -1.6265e-2 + TrDir*6.9767e-1 + (TrDir^2)*2.4509e-1;
parameter Real b1 = 6.4646*TrDir - 11.7745*tau30 + 9.4645*tau60;
parameter Real b2 = -20.3940*TrDir + 35.3234*tau30 - 20.3940*tau60;
parameter Real b3 = 14.9294*TrDir - 23.5489*tau30 + 10.9295*tau60;

algorithm
cosi := FLUX[3];
if choix == 1 then
  // Fauconnier
  PondTransDir := if noEvent(cosi>0.05) then max(0,c0/cosi + c1 + c2*cosi) else 0;
elseif choix ==2 then
  // RT
  PondTransDir := if noEvent(cosi>0) then b1*cosi + b2*cosi^2 + b3*cosi^3 else 0;
elseif choix ==3 then
 // Formule de Cardonnel
  PondTransDir := if noEvent(cosi>0) then (if noEvent(cosi>0.8) then TrDir else TrDir*2.5*cosi*(1-0.625*cosi)) else 0;
else
  PondTransDir := if noEvent(cosi>0) then cosi*TrDir else 0;
end if;

Direct := PondTransDir*FLUX[2];

  annotation (Icon(graphics={
    Polygon(
      points={{-80,84},{-85,62},{-74,62},{-80,84}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{-80,62},{-80,-88}}, color={95,95,95}),
    Line(points={{-90,-76},{82,-76}}, color={95,95,95}),
    Polygon(
      points={{90,-76},{68,-71},{68,-82},{90,-76}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{70,-84},{94,-96}},
      lineColor={0,0,0},
          textString="cosi"),
    Text(
      extent={{-100,95},{-44,84}},
      lineColor={0,0,0},
          textString="TrDirPond"),
        Line(
          points={{66,46},{38,46},{30,46},{22,44},{12,40},{-8,28},{-30,6},
              {-56,-30},{-80,-76}},
          color={0,0,0},
          smooth=Smooth.Bezier)}),
                                 Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i>Remarque : Il remplace le modèle PondTransDirect utilisé précédemment pour les vitrages</i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p><u><b>Bibliographie</b></u></p>
<p>Relations issues de la RT2000, de Fauconnier, de Cardonnel [1983] et pondération proportionnelles au cos i.</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Ce modèle permet de ressortir le flux direct en fonction du vecteur <b>FLUX</b> issu des conditions aux limites solaires.</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé (Comparaison feuille excel) - Aurélie Kaemmerlen 06/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 06/2012 - Correction de la formule de Fauconnier qui était instable numériquement lorsque cosi était proche de 0 (division par cosi) + sécurisation pour que la pondération soit toujours positive + changement de la formule par défaut</p>
<p>Aurélie Kaemmerlen 10/2012 - Ajout d'une pondération linéaire en cosi</p>
</html>"));
end DirectTrans;
