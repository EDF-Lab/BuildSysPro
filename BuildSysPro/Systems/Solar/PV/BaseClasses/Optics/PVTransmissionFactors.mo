within BuildSysPro.Systems.Solar.PV.BaseClasses.Optics;
model PVTransmissionFactors
  "Calculation of direct, diffuse and albedo transmission factors of incident rays on a photovoltaic module"

  //Model parameters
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=30
    "PV panel tilt relative to the horizontal (0° upward, 180° downward)";
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut=0
    "PV panel azimuth - orientation relative to the South (S=0°, E=-90°, W=90°, N=180°)";
  parameter Integer salete=0
    "0 - Clean panels, 1 - Slightly dirt panels, 2 - Intermediately dirt panels, 3 - Very dirt panels"
    annotation (Dialog(compact=true), choices(
      choice=0 "Clean panels",
      choice=1 "Slightly dirt panels",
      choice=2 "Intermediately dirt panels",
      choice=3 "Very dirt panels",
      radioButtons=true));

  //Intermediate variables
protected
  Real cosIncidence "Cosine of incident rays angle relative to the normal";
  Modelica.SIunits.Conversions.NonSIunits.Angle_deg angle_incidence
    "Angle of incidence in °";
  Real transmittance_rel "Relative transmittance due to dirt";
  Real a_r "Parameter a_r";
  Real c2 "Coefficient c2";

public
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput G[10]
    "Solar flux: {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle, Solar elevation angle}"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
        iconTransformation(extent={{-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealOutput FT_B "Direct transmission factor"
                                     annotation (Placement(transformation(
          extent={{40,10},{60,30}}), iconTransformation(extent={{40,20},{60,
            40}})));
  Modelica.Blocks.Interfaces.RealOutput FT_D
    "Isotropic diffuse transmission factor" annotation (Placement(
        transformation(extent={{40,-10},{60,10}}), iconTransformation(
          extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealOutput FT_A
    "Albedo reflexion transmission factor" annotation (Placement(
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
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows the use of analytical formulas for evaluating optical losses due to reflection on the three components of the solar flux : direct, diffuse and reflected by the ground (albedo).</p>
<p>This model is a improvement of the model developed by ASHRAE which is not valid for angles of incidence higher than 80°.</p>
<p>- The expression of the transmittance factor for the direct incidence is given by :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/FT_B.png\" alt=\"FT_B(theta_S)=T_dirt/T_clean*(1-(exp(-cos(theta_S)/a_r)-exp(-1/a_r))/(1-exp(-1/a_r)))\"/></p>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/theta_S.png\" alt=\"theta_S\"/> : sun rays angle of incidence on the module.</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/transmission_salete.png\" alt=\"T_dirt/T_clean\"/> : module relative transmittance due to its degree of dirt.</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/a_r.png\" alt=\"a_r\"/> : coefficient characterizing the dirt of the module (<img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/a_r.png\" alt=\"a_r\"/> values are related to the values of the relative transmittance).</p>
<p><br><u>Note</u> : The formula used is not exactly the one that can be found in the literature, the multiplicative factor of relative transmittance can be included in the transmission factor as shown in equation (20.49) of the \"Handbook of Photovoltaic Science and Engineering\", P936.</p>
<p><br>- For diffuse radiation, the expression is :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/FT_D.png\" alt=\"FT_D(beta)=1-exp(-1/a_r*(c_1*(sin(beta)+(pi-beta*pi/180-sin(beta))/(1+cos(beta)))+c_2*(sin(beta)+(pi-beta*pi/180-sin(beta))/(1+cos(beta)))^2))\"/></p>
<p><br>- And for albedo radiation, the expression is :</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/FT_R.png\" alt=\"FT_R(beta)=1-exp(-1/a_r*(c_1*(sin(beta)+(beta*pi/180-sin(beta))/(1-cos(beta)))+c_2*(sin(beta)+(beta*pi/180-sin(beta))/(1-cos(beta)))^2))\"/></p>
<p><br><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/c_1.png\" alt=\"c_1=4/(3*pi)\"/> : constant coefficient.</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/c_2.png\" alt=\"c_2\"/> : coefficient linearly dependent of dirt coefficient <img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/a_r.png\" alt=\"a_r\"/> (automatically calculated in the model).</p>
<p><img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/beta.png\" alt=\"beta\"/> : module tilt angle.</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>Handbook of Photovoltaic Science and Engineering, Antonio Luque &amp; Steven Hegedus, Wiley, 2003, pp. 934-936</p>
<p>Martin N., Ruiz J, Solar Energy Materials &amp; Solar Cells 70, 25-38, 2001</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The values of the dirt parameter a_r have not been studied, validations have been made only considering a clean module.</p>
<p><u><b>Validations</b></u></p>
<p>Model validated by simulation - Sergeï Agapoff (stagiaire Benoît Braisaz) 08/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.2.0<br>
Author : Serge&iuml; AGAPOFF, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",
      revisions="<html>
<p>Agapoff Serge&iuml; 04/2012 : Création du modèle</p>
</html>"));
end PVTransmissionFactors;
