within BuildSysPro.Systems.Solar.PV.BaseClasses.Optics;
model PVTransmissionFactors
  "Modèle de calcul des facteurs de transmission direct, diffus et albedo des rayons incidents sur un module photovoltaïque"

  //Paramètres du modèle
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=30
    "inclinaison du panneau PV par rapport à l'horizontale (0° vers le haut, 180° vers le sol)";
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut=0
    "azimut du panneau PV - orientation par rapport au Sud (S=0°, E=-90°, O=90°, N=180°)";
  parameter Integer salete=0
    "0 - Panneaux propres, 1 - Panneaux peu sales, 2 - Panneaux moyennement sales, 3 - Panneaux très sales"
    annotation (dialog(compact=true), choices(
      choice=0 "Panneaux propres",
      choice=1 "Panneaux peu sales",
      choice=2 "Panneaux moyennement sales",
      choice=3 "Panneaux très sales",
      radioButtons=true));

  //Variables intermédiaires
protected
  Real cosIncidence
    "cosinus de l'angle des rayons incidents par rapport à la normale";
  Modelica.SIunits.Conversions.NonSIunits.Angle_deg angle_incidence
    "angle d'incidence en °";
  Real transmittance_rel "transmittance relative due à la saleté";
  Real a_r "paramètre a_r";
  Real c2 "coefficient c2";

public
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput G[10]
    "Flux solaire : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut, Hauteur}"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealOutput FT_B "facteur de transmission direct"
                                     annotation (Placement(transformation(
          extent={{40,10},{60,30}}), iconTransformation(extent={{40,20},{60,
            40}})));
  Modelica.Blocks.Interfaces.RealOutput FT_D
    "facteur de transmission diffus isotrope" annotation (Placement(
        transformation(extent={{40,-10},{60,10}}), iconTransformation(
          extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealOutput FT_A
    "facteur de transmission réflexion albedo" annotation (Placement(
        transformation(extent={{40,-30},{60,-10}}), iconTransformation(
          extent={{40,-40},{60,-20}})));

equation
  cosIncidence = BuildSysPro.BoundaryConditions.Solar.Utilities.CosI(
    azimut=azimut,
    incl=incl,
    CosDir=G[6:8]);
  angle_incidence = 180*acos(cosIncidence)/Modelica.Constants.pi;

  if salete == 0 then
    transmittance_rel = 1;
    a_r = 0.17;
    c2 = -0.069;
  elseif salete == 1 then
    transmittance_rel = 0.98;
    a_r = 0.20;
    c2 = -0.054;
  elseif salete == 2 then
    transmittance_rel = 0.97;
    a_r = 0.21;
    c2 = -0.049;
  else
    transmittance_rel = 0.92;
    a_r = 0.27;
    c2 = -0.023;
  end if;

  FT_B = if noEvent(angle_incidence < 90) then transmittance_rel*(1 - (
    Modelica.Math.exp(-cosIncidence/a_r) - Modelica.Math.exp(-1/a_r)/(1 -
    Modelica.Math.exp(-1/a_r)))) else 0;
  FT_D = transmittance_rel*(1 - Modelica.Math.exp(-1/a_r*(4/(3*Modelica.Constants.pi)
    *(Modelica.Math.sin(incl*Modelica.Constants.pi/180) + (Modelica.Constants.pi
     - incl*Modelica.Constants.pi/180 - Modelica.Math.sin(incl*Modelica.Constants.pi
    /180))/(1 + Modelica.Math.cos(incl*Modelica.Constants.pi/180))) + c2*(
    Modelica.Math.sin(incl*Modelica.Constants.pi/180) + (Modelica.Constants.pi
     - incl*Modelica.Constants.pi/180 - Modelica.Math.sin(incl*Modelica.Constants.pi
    /180))/(1 + Modelica.Math.cos(incl*Modelica.Constants.pi/180)))^2)));
  FT_A = if noEvent(incl == 0) then 0 else transmittance_rel*(1 -
    Modelica.Math.exp(-1/a_r*(4/(3*Modelica.Constants.pi)*(
    Modelica.Math.sin(incl*Modelica.Constants.pi/180) + (incl*Modelica.Constants.pi
    /180 - Modelica.Math.sin(incl*Modelica.Constants.pi/180))/(1 -
    Modelica.Math.cos(incl*Modelica.Constants.pi/180))) + c2*(
    Modelica.Math.sin(incl*Modelica.Constants.pi/180) + (incl*Modelica.Constants.pi
    /180 - Modelica.Math.sin(incl*Modelica.Constants.pi/180))/(1 -
    Modelica.Math.cos(incl*Modelica.Constants.pi/180)))^2)));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),  graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                        graphics={Rectangle(extent={{-40,40},{40,-40}},
            lineColor={0,0,255}), Text(
          extent={{-40,66},{42,-66}},
          lineColor={0,0,255},
          textString="Transmission
PV"),                             Text(
          extent={{48,54},{60,26}},
          lineColor={0,0,255},
          textString="Direct"),   Text(
          extent={{48,24},{60,-4}},
          lineColor={0,0,255},
          textString="Diffus"),   Text(
          extent={{48,-6},{60,-34}},
          lineColor={0,0,255},
          textString="Albedo"),
        Line(
          points={{-40,10},{-76,52}},
          color={255,192,1},
          smooth=Smooth.None,
          pattern=LinePattern.Dot,
          thickness=0.5),
        Line(
          points={{-76,52},{-76,48}},
          color={255,192,1},
          pattern=LinePattern.Dot,
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,52},{-72,52}},
          color={255,192,1},
          pattern=LinePattern.Dot,
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-40,0},{40,32}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-40,0},{40,0}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-40,0},{40,-30}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,32},{34,32}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,32},{36,28}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,0},{36,2}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,-30},{38,-26}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{40,-30},{36,-32}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-40,-18},{-68,-68}},
          color={255,192,1},
          smooth=Smooth.None,
          pattern=LinePattern.Dot,
          thickness=0.5),
        Line(
          points={{-68,-64},{-68,-68}},
          color={255,192,1},
          pattern=LinePattern.Dot,
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-64,-66},{-68,-68}},
          color={255,192,1},
          pattern=LinePattern.Dot,
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{40,0},{36,-2}},
          color={255,192,1},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><i><b>Modèle de calcul des facteurs de transmission direct, diffus et albedo des rayons incidents sur un module photovolta&iuml;que.</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Ce modèle permet d'utiliser des formules analytiques pour évaluer les pertes optiques par réflexion sur les trois composantes du flux solaire : direct, diffus et réfléchi par le sol (albedo)</p>
<p><br>Ce modèle est une amélioration du modèle développé par l'ASHRAE qui n'est pas valable pour des angles d'incidence supérieurs à 80&deg;.</p>
<p>- L'expression du facteur de transmission pour l'incidence directe est donnée par :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/FT_B.png\" alt=\"FT_B(theta_S)=T_dirt/T_clean*(1-(exp(-cos(theta_S)/a_r)-exp(-1/a_r))/(1-exp(-1/a_r)))\"/></p>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/theta_S.png\" alt=\"theta_S\"/> : angle d'incidence des rayons du soleil sur le module</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/transmission_salete.png\" alt=\"T_dirt/T_clean\"/> : transmittance relative du module en raison du degré de saleté de celui-ci</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/a_r.png\" alt=\"a_r\"/> : coefficient caractérisant la saleté du module (les valeurs de <img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/a_r.png\" alt=\"a_r\"/> sont liées aux valeurs de la transmittance relative)</p>
<p><u><i>Remarque :</i></u> La formule retenue n'est pas exactement celle que l'on retrouve dans la littérature, le facteur multiplicatif de transmittance relative peut être englobé dans le facteur de transmission comme le montre l'équation (20.49) du &QUOT;Handbook of Photovoltaic Science and Engineering&QUOT;, p936.</p>
<p><br>- Pour le rayonnement diffus, l'expression est la suivante :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/FT_D.png\" alt=\"FT_D(beta)=1-exp(-1/a_r*(c_1*(sin(beta)+(pi-beta*pi/180-sin(beta))/(1+cos(beta)))+c_2*(sin(beta)+(pi-beta*pi/180-sin(beta))/(1+cos(beta)))^2))\"/></p>
<p><br>- Et pour le rayonnement albedo :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/FT_R.png\" alt=\"FT_R(beta)=1-exp(-1/a_r*(c_1*(sin(beta)+(beta*pi/180-sin(beta))/(1-cos(beta)))+c_2*(sin(beta)+(beta*pi/180-sin(beta))/(1-cos(beta)))^2))\"/></p>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/c_1.png\" alt=\"c_1=4/(3*pi)\"/> : coefficient constant</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/c_2.png\" alt=\"c_2\"/> : coefficient linéairement dépendant du coefficient de saleté <img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/a_r.png\" alt=\"a_r\"/> (calculé automatiquement dans le modèle)</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/beta.png\" alt=\"beta\"/> : angle d'inclinaison du module</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>Handbook of Photovoltaic Science and Engineering, Antonio Luque & Steven Hegedus, Wiley, 2003, pp. 934-936</p>
<p>Martin N., Ruiz J, Solar Energy Materials & Solar Cells 70, 25-38, 2001</p>
<p><br><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Les valeurs du paramètre de saleté a_r n'ont pas été étudiées, les validations effectuées n'ont été faites qu'en supposant le module propre.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé par simulation -Serge&iuml; Agapoff (stagiaire B.Braisaz) 08/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Serge&iuml; AGAPOFF, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Agapoff Serge&iuml; 04/2012 : Création du modèle</p>
</html>"));
end PVTransmissionFactors;
