within BuildSysPro.BoundaryConditions.Solar.Irradiation;
block DirectAbs
  "Compute the direct solar irradiation absorbed by a glazing surface"
extends Modelica.Blocks.Interfaces.BlockIcon;

parameter Integer choix=2 "Formula used" annotation(choices(
        choice=1 "Fauconnier",
        choice=2 "RT",
        choice=3 "Cardonnel",
        choice=4 "Weighting factor of cos i"));
parameter Real AbsDir "Direct window absorptance at normal incidence";

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput                                       FLUX[3]
    "Input connector for solar irradiation 1-Diffuse, 2-Direct, 3-Cos i"
    annotation (Placement(transformation(extent={{-140,-26},{-100,14}}),
        iconTransformation(extent={{-120,-6},{-100,14}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput                                       Direct
    "Direct irradiation absorbed in the glazing surface"
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
<html>
<p><i><b> Compute the direct solar irradiation transmited through a glazing surface considering the incidence angle</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>

<p><u><b>Bibliography</b></u></p>
<p>Relations from RT2000 (french building regulation), Fauconnier, Cardonnel [1983] and proportional weighting of cos i.</p>
<p><u><b>Instructions for use</b></u></p>
<p>This model returns the direct irradiation according to the incident irradiation. This information is provided through the <b>FLUX</b> input connector and could be calculated by a solar preprocessing (e.g. <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf\"><code>FLUXSurf</code></a> model)</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (excel sheet comparison) - Aurélie Kaemmerlen 06/2011</b></p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Aur&eacute;lie Kaemmerlen 06/2012 - Correction de la formule de Fauconnier qui &eacute;tait instable num&eacute;riquement lorsque cosi &eacute;tait proche de 0 (division par cosi) + s&eacute;curisation pour que la pond&eacute;ration soit toujours positive + changement de la formule par d&eacute;faut</p>
<p>Aur&eacute;lie Kaemmerlen 10/2012 - Ajout d&apos;une pond&eacute;ration lin&eacute;aire en cosi</p>
</html>"));
end DirectAbs;
