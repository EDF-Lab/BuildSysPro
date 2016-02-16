within BuildSysPro.BoundaryConditions.Solar.Irradiation;
block DirectAbs
  "Calcul de l'absorptivité directe d'un vitrage en fonction de l'incidence"
extends Modelica.Blocks.Interfaces.BlockIcon;

parameter Integer choix=2 "Formule utilisée" annotation(choices(
        choice=1 "Fauconnier",
        choice=2 "RT",
        choice=3 "Cardonnel",
        choice=4 "Linéaire avec cosi"));
parameter Real AbsDir
    "Coefficient de transmission direct de la fenêtre à incidence normale";

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput                                       FLUX[3]
    "Informations de flux solaire surfacique incident 1-Flux Diffus, 2-Flux Direct 3-Cosi"
    annotation (Placement(transformation(extent={{-140,-26},{-100,14}}),
        iconTransformation(extent={{-120,-6},{-100,14}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput                                       Direct
    "Calcul du flux direct transmis par le vitrage en fonction de l'incidence"
    annotation (Placement(transformation(extent={{80,-20},{120,20}}),
        iconTransformation(extent={{100,-8},{120,12}})));

// Variables internes
protected
Real cosi;
Real PondAbsDir;
// Coefficients calculés pour la formule de Fauconnier
parameter Real a0 = 0.0016 - 0.0619*AbsDir - 0.0368*AbsDir^2;
parameter Real a1 = -0.007 + 1.65*AbsDir - 0.443*AbsDir^2;
parameter Real a2 = 0.005 - 0.5849*AbsDir + 0.4835*AbsDir^2;

// Coefficients calculés pour la formule de la RT
parameter Real alpha30 = -8.5884e-4 + 1.0869*AbsDir - (6.1151e-2)*AbsDir^2;
parameter Real alpha60 = -1.7566e-3 + 1.2352*AbsDir - (2.7231e-1)*AbsDir^2;
parameter Real d1 = 6.4646*AbsDir - 11.7745*alpha30 + 9.4645*alpha60;
parameter Real d2 = -20.394*AbsDir + 35.3234*alpha30 - 20.394*alpha60;
parameter Real d3 = 14.9294*AbsDir - 23.5489*alpha30 + 10.9295*alpha60;

algorithm
cosi := FLUX[3];
if choix == 1 then
  // Fauconnier
  PondAbsDir := if noEvent(cosi>0.05) then max(0,a0/cosi + a1 + a2*cosi) else 0;
elseif choix ==2 then
  // RT
  PondAbsDir := if noEvent(cosi>0) then d1*cosi + d2*cosi^2 + d3*cosi^3 else 0;
elseif choix ==3 then
 // Formule de Cardonnel
  PondAbsDir := if noEvent(cosi>0) then (if noEvent(cosi>0.8) then AbsDir else AbsDir*2.5*cosi*(1-0.625*cosi)) else 0;
else
  PondAbsDir := if noEvent(cosi>0) then cosi*AbsDir else 0;
end if;

Direct := PondAbsDir*FLUX[2];

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
          textString="AbsDirPond"),
        Line(
          points={{66,-76},{54,-14},{42,48},{22,60},{4,62},{-16,60},{-36,54},{
              -56,52},{-80,52}},
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
</html>", revisions="<html>
<p>Aur&eacute;lie Kaemmerlen 06/2012 - Correction de la formule de Fauconnier qui &eacute;tait instable num&eacute;riquement lorsque cosi &eacute;tait proche de 0 (division par cosi) + s&eacute;curisation pour que la pond&eacute;ration soit toujours positive + changement de la formule par d&eacute;faut</p>
<p>Aur&eacute;lie Kaemmerlen 10/2012 - Ajout d&apos;une pond&eacute;ration lin&eacute;aire en cosi</p>
</html>"));
end DirectAbs;
