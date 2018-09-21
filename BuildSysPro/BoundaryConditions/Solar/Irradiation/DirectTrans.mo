within BuildSysPro.BoundaryConditions.Solar.Irradiation;
block DirectTrans
  "Compute the direct solar irradiation transmited through a glazing surface"
extends Modelica.Blocks.Interfaces.BlockIcon;

parameter Integer choix=2 "Formula used" annotation(choices(
        choice=1 "Fauconnier",
        choice=2 "RT",
        choice=3 "Cardonnel",
        choice=4 "Weighting factor of cos i"));
parameter Real TrDir "Direct window transmittance at normal incidence";

  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt[3]
    "Input connector for solar irradiation 1-Diffuse, 2-Direct, 3-Cos i"
    annotation (Placement(transformation(extent={{-140,-26},{-100,14}}),
        iconTransformation(extent={{-120,-6},{-100,14}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput FluxTrDir
    "Direct irradiation transmitted through the glazing surface" annotation (
      Placement(transformation(extent={{80,-20},{120,20}}), iconTransformation(
          extent={{100,-8},{120,12}})));

// Internal variables
protected
Real cosi;
Real PondTransDir;
// Coefficients calculated for the Fauconnier formula
parameter Real c0 = 0.0139 - 0.1093*TrDir - 0.0079*TrDir^2;
parameter Real c1 = -0.0895 + 0.7662*TrDir + 0.4706*TrDir^2;
parameter Real c2 = 0.0751 + 0.3489*TrDir - 0.4563*TrDir^2;

// Coefficients calculated for the RT formula
parameter Real tau30 = -7.068e-4 + TrDir*9.3967e-1 + (TrDir^2)*7.0476e-2;
parameter Real tau60 = -1.6265e-2 + TrDir*6.9767e-1 + (TrDir^2)*2.4509e-1;
parameter Real b1 = 6.4646*TrDir - 11.7745*tau30 + 9.4645*tau60;
parameter Real b2 = -20.3940*TrDir + 35.3234*tau30 - 20.3940*tau60;
parameter Real b3 = 14.9294*TrDir - 23.5489*tau30 + 10.9295*tau60;

algorithm
cosi :=FluxIncExt[3];
if choix == 1 then
  // Fauconnier
  PondTransDir := if noEvent(cosi>0.05) then max(0,c0/cosi + c1 + c2*cosi) else 0;
elseif choix ==2 then
  // RT
  PondTransDir := if noEvent(cosi>0) then b1*cosi + b2*cosi^2 + b3*cosi^3 else 0;
elseif choix ==3 then
 // Cardonnel formula
  PondTransDir := if noEvent(cosi>0) then (if noEvent(cosi>0.8) then TrDir else TrDir*2.5*cosi*(1-0.625*cosi)) else 0;
else
  PondTransDir := if noEvent(cosi>0) then cosi*TrDir else 0;
end if;

  FluxTrDir := PondTransDir*FluxIncExt[2];

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
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><i><b>Compute the direct solar irradiation transmited through a glazing surface considering the incidence angle</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Relations from RT2000 (French building regulation), Fauconnier, Cardonnel [1983] and proportional weighting of cos i.</p>
<p><u><b>Instructions for use</b></u></p>
<p>This model returns the direct irradiation according to the incident irradiation. This information is provided through the <b>FLUX</b> input connector and could be calculated by a solar preprocessing (e.g. <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf\"><code>FLUXSurf</code></a> model)</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model (excel sheet comparison) - Aurélie Kaemmerlen 06/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright © EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Aurélie KAEMMERLEN, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 06/2012 - Correction de la formule de Fauconnier qui était instable numériquement lorsque cosi était proche de 0 (division par cosi) + sécurisation pour que la pondération soit toujours positive + changement de la formule par défaut</p>
<p>Aurélie Kaemmerlen 10/2012 - Ajout d'une pondération linéaire en cosi</p>
</html>"));
end DirectTrans;
