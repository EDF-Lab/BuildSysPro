within BuildSysPro.Systems.Solar.PV.BasicModels;
model PVPanelSimplified
  "Detailed physical model of photovoltaic panel (thermal capacity)"

  // Parameters of the PV system
  parameter Modelica.SIunits.Area surface=20 "PV panels surface"
    annotation (Dialog(tab="PV panels", group="PV system"));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=30
    "PV panel tilt relative to the horizontal (0° upward, 180° toward the ground)"
    annotation (Dialog(tab="PV panels", group="PV system"));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut=0
    "Azimut of the surface (orientation relative to the South : S=0°, E=-90°, O=90°, N=180°)"
    annotation (Dialog(tab="PV panels", group="PV system"));

  // PV panels characteristics
  replaceable parameter BaseClasses.Thermal.ThermalRecordsPV.RecordTechnoPV
    technoPV "Choice of PV technology" annotation (
      choicesAllMatching=true, Dialog(
      compact=true,
      tab="PV panels",
      group="PV panels characteristics"));
  parameter Real eta_STC=0.15
    "PV panel (electric) efficiency in STC conditions (1000W/m², 25°C)"
    annotation (Dialog(tab="PV panels", group=
          "PV panels characteristics"));
  parameter Real mu_T=-0.5 "Temperature coefficient on the performance %/K"
                                                      annotation (Dialog(
        tab="PV panels", group="PV panels characteristics"));
  parameter Integer salete=0
    "0 - Clean panels, 1 - Slightly dirt panels, 2 - Intermediately dirt panels, 3 - Very dirt panels"
    annotation (Dialog(
      compact=true,
      tab="PV panels",
      group="PV panels characteristics"), choices(
      choice=0 "Clean panels",
      choice=1 "Slightly dirt panels",
      choice=2 "Intermediately dirt panels",
      choice=3 "Very dirt panels",
      radioButtons=true));

  // Integration of PV panels to the frame
  parameter Integer Integre=1
    "Integrated to the frame=1 ; Non integrated to the frame (in a field)=2"
    annotation (Dialog(
      compact=true,
      tab="PV panels",
      group="Integration to the frame"), choices(
      choice=1 "Panels integrated to the frame",
      choice=2 "Panels non integrated to the frame (in a field)",
      radioButtons=true));

  // Thermal exchanges
  parameter Integer convection_avant=2
    "A convective coefficient is imposed = 1; The convection model default is used = 2"
    annotation (Dialog(
      compact=true,
      tab="Thermal exchanges",
      group="Exchanges on front face"), choices(choice=1
        "A convective coefficient is imposed", choice=2
        "The convection model default is used"));
  parameter Real h_conv_avant=8.55
    "Convective coefficient is imposed on front face (W/m².K)" annotation (
      Dialog(
      compact=true,
      tab="Thermal exchanges",
      group="Exchanges on front face",
      enable=convection_avant == 1));

  parameter Integer VitesseExt=1
    "Wind considered through a meteo file = 1; A wind speed is imposed = 2; The wind effect is neglected = 3"
    annotation (Dialog(
      compact=true,
      tab="Thermal exchanges",
      group="External conditions",
      enable=convection_avant == 2), choices(
      choice=1 "Wind considered through a meteo file",
      choice=2 "Wind considered, speed imposed",
      choice=3 "Wind neglected"));
  parameter Modelica.SIunits.Velocity vitesse=1 "Wind speed imposed in m/s"
                                annotation (Dialog(
      tab="Thermal exchanges",
      group="External conditions",
      enable=VitesseExt == 2));

  // Roof characteristics
  parameter Real R_toit=8 "Roof thermal resistance (m²K/W)"
    annotation (Dialog(
      tab="Building",
      group="Building roof",
      enable=Integre == 1));

  // Indoors characteristics
  parameter Modelica.SIunits.Temperature Tint=293.15
    "Indoor temperature of the building" annotation (Dialog(
      tab="Building",
      group="Indoor temperature of the building",
      enable=Integre == 1));

protected
  parameter Modelica.Blocks.Interfaces.BooleanInput OnOff_conv_avant=if convection_avant==1 then true else false;
  parameter Modelica.Blocks.Interfaces.BooleanInput OnOff_integre=if Integre==1 then true else false;

  // Internal variables
public
  Real flux_transmis;
  Real flux_thermique;

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel
    "Sky temperature" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-95,61}), iconTransformation(extent={{10,60},{30,80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Ambient temperature" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-95,81}), iconTransformation(extent={{-32,60},{-12,80}})));
  Modelica.Blocks.Interfaces.RealInput Vit[2]
    "1- Wind speed (m/s) 2- Wind direction (relative to the South, in °)"
    annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=180,
        origin={-101,41}),iconTransformation(extent={{-8,-8},{8,8}}, origin=
           {-92,40})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput G[10]
    "Solar flux: {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle, Solar elevation angle}"
    annotation (Placement(transformation(extent={{-116,-16},{-84,16}}),
        iconTransformation(extent={{-100,-16},{-68,16}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_ext2
    annotation (Placement(transformation(extent={{25,-97},{27,-95}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext1
    annotation (Placement(transformation(extent={{39,89},{41,91}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel1
    "Sky temperature"
    annotation (Placement(transformation(extent={{51,89},{53,91}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel2
    "Sky temperature"
    annotation (Placement(transformation(extent={{43,-97},{45,-95}})));

public
  BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf(
    azimut=azimut,
    incl=incl,
    diffus_isotrope=1) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={-75,-19})));
  BaseClasses.Optics.PVTransmissionFactors facteursTransmission(
    incl=incl,
    azimut=azimut,
    salete=salete)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  BaseClasses.Thermal.EfficiencyFunctionOfTemp rendementFctTemperature(eta_STC=
        eta_STC, mu_T=mu_T)
    annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
public
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-8,24})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2
    annotation (Placement(transformation(extent={{0,-6},{14,8}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=Tint)
    annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=180,
        origin={94,-92})));

  Modelica.Blocks.Sources.RealExpression vitesse_conv(y=if VitesseExt == 2
         then vitesse elseif VitesseExt == 3 then 0 else Vit[1]);
  Modelica.Blocks.Sources.RealExpression vitesse_nulle(y=0);

  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtLWR gLOext1(
    incl=incl,
    eps=technoPV.eps_fg,
    S=surface) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={48,66})));

  Controls.Switch interrupteur1_modele_conv(valeur_On=false) annotation (
      Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={30,53})));
  Controls.Switch interrupteur1_coeff_impose annotation (Placement(
        transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={14,53})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtConvection
    convection_modele1(
    S=surface,
    n=1,
    a=2.56,
    b=8.55) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={30,66})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtConvection
    convection_coeff_impose1(
    n=1,
    a=2.56,
    S=surface,
    b=h_conv_avant) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={14,66})));

  Controls.Switch interrupteur_non_integre(valeur_On=false) annotation (
      Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=-90,
        origin={29,-52})));

public
  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtLWR GLOext(
    incl=180 - incl,
    S=surface,
    eps=technoPV.eps_bg) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={40,-74})));

  Controls.Switch interrupteur_integre_bati annotation (Placement(
        transformation(
        extent={{-5,-4},{5,4}},
        rotation=-90,
        origin={73,-54})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalResistance thermalResistance(R=R_toit/
        surface) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={74,-74})));
  Modelica.Blocks.Interfaces.RealOutput Pelec "Elec power (W)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-28,-56}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-50})));

  BuildSysPro.BaseClasses.HeatTransfer.Components.NonLinearConvective
    convectifNonLineaire(
    a=1.31,
    S=surface,
    n=1/3,
    b=0) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={17,-75})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=
        technoPV.cp_surf*surface)
    annotation (Placement(transformation(extent={{28,-4},{48,16}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_cellule
    "Cells temperature" annotation (Placement(transformation(extent={{
            74,-6},{86,6}}), iconTransformation(extent={{60,-10},{80,10}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int
    "Indoor temperature" annotation (
    Placement(transformation(extent={{70,-96},{80,-86}}), iconTransformation(
          extent={{-10,-80},{10,-60}})),
    HideResult=true,
    enable=Integre == 1);
public
  Modelica.Blocks.Sources.RealExpression realExpression(y=flux_thermique);

  Modelica.Blocks.Interfaces.RealOutput prod_kWh "Elec production (kWh)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-56}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-80})));
equation
  flux_transmis =fLUXsurf.FluxIncExt[2]*facteursTransmission.FT_B + (fLUXsurf.FluxIncExt[
    1] - fLUXsurf.AzHSol[3])*facteursTransmission.FT_D + fLUXsurf.AzHSol[3]*
    facteursTransmission.FT_A;
  flux_thermique = (technoPV.alpha_tau_n - rendementFctTemperature.eta)*
    surface*flux_transmis;
  Pelec = flux_transmis*surface*rendementFctTemperature.eta;
  der(prod_kWh)=Pelec/(3600*1000);

  connect(temperatureSensor.T, rendementFctTemperature.T) annotation (Line(
      points={{-14,24},{-28,24},{-28,6.2}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(interrupteur1_modele_conv.OnOff, OnOff_conv_avant);
  connect(interrupteur1_coeff_impose.OnOff, OnOff_conv_avant);
  connect(gLOext1.T_sky, T_ciel1) annotation (Line(
      points={{50.4,71.4},{50.4,84},{52,84},{52,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gLOext1.T_ext, T_ext1) annotation (Line(
      points={{45.6,71.4},{45.6,76},{45.6,80},{40,80},{40,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(interrupteur1_modele_conv.port_b, convection_modele1.port_b)
    annotation (Line(
      points={{30,57.5},{30,60.6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(interrupteur1_coeff_impose.port_b, convection_coeff_impose1.port_b)
    annotation (Line(
      points={{14,57.5},{14,60.6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(convection_coeff_impose1.port_a, T_ext1) annotation (Line(
      points={{14,71.4},{14,80},{40,80},{40,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection_modele1.port_a, T_ext1) annotation (Line(
      points={{30,71.4},{30,80},{40,80},{40,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vitesse_conv.y, convection_modele1.v);
  connect(vitesse_nulle.y, convection_coeff_impose1.v);
  connect(T_ext1, T_ext);
  connect(T_ciel1, T_ciel);

  connect(interrupteur_non_integre.OnOff, OnOff_integre);
  connect(GLOext.T_ext, T_ext2) annotation (Line(
      points={{37.6,-79.4},{37.6,-88},{26,-88},{26,-96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GLOext.T_sky, T_ciel2) annotation (Line(
      points={{42.4,-79.4},{42.4,-90.7},{44,-90.7},{44,-96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext2, T_ext);
  connect(T_ciel2, T_ciel);

  connect(interrupteur_integre_bati.OnOff, OnOff_integre);
  connect(thermalResistance.port_a, interrupteur_integre_bati.port_b)
    annotation (Line(
      points={{74,-68.6},{74,-59.625},{73,-59.625}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(GLOext.Ts_ext, interrupteur_non_integre.port_b) annotation (Line(
      points={{40,-68.6},{40,-62},{29,-62},{29,-57.625}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(convectifNonLineaire.port_a, interrupteur_non_integre.port_b)
    annotation (Line(
      points={{17,-68.7},{17,-60},{29,-60},{29,-57.625}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convectifNonLineaire.port_b, T_ext2) annotation (Line(
      points={{17,-81.3},{17,-86},{26,-86},{26,-96}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow2.port, heatCapacitor.port) annotation (Line(
      points={{14,1},{27.35,1},{27.35,-2},{38,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, interrupteur1_coeff_impose.port_a)
    annotation (Line(
      points={{38,-2},{38,42},{14,42},{14,48.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, interrupteur1_modele_conv.port_a) annotation (
     Line(
      points={{38,-2},{38,42},{30,42},{30,48.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, gLOext1.Ts_ext) annotation (Line(
      points={{38,-2},{38,42},{48,42},{48,60.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, interrupteur_non_integre.port_a) annotation (
      Line(
      points={{38,-2},{38,-36},{29,-36},{29,-46.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, interrupteur_integre_bati.port_a) annotation (
     Line(
      points={{38,-2},{38,-38},{73,-38},{73,-48.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow2.port, temperatureSensor.port) annotation (
      Line(
      points={{14,1},{14,24},{-2,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, T_cellule) annotation (Line(
      points={{38,-2},{59.5,-2},{59.5,0},{80,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, T_int) annotation (Line(
      points={{90,-92},{84,-92},{84,-91},{75,-91}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int, thermalResistance.port_b) annotation (Line(
      points={{75,-91},{75,-85.5},{74,-85.5},{74,-79.4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(realExpression.y, prescribedHeatFlow2.Q_flow);
  connect(G, facteursTransmission.G) annotation (Line(
      points={{-100,0},{-66,0}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(G, fLUXsurf.G) annotation (Line(
      points={{-100,0},{-86,0},{-86,-19},{-82.7,-19}},
      color={255,192,1},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),  graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                        graphics={Rectangle(extent={{-60,20},{60,-20}},
            lineColor={0,0,255}),
        Text(
          extent={{84,-30},{98,-44}},
          lineColor={0,0,255},
          textString="Pelec"),
        Text(
          extent={{86,-62},{100,-76}},
          lineColor={0,0,255},
          textString="kWh")}),
    Documentation(info="<html>
<p><i><b>Detailed physical model of photovoltaic panel (thermal capacity)</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Model to calculate: module temperature, instantaneous electric power and cumulative PV production</p>
<p>This model considers:</p>
<ul>
<li>the photovoltaic panel thermal capacity </li>
<li>exchanges by forced convection due to wind on front face <img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/phy_capa/hconv_vent.png\" alt=\"U_L=8.55+2.56*V\"/></li>
<li>exchanges by free convection on the back face in the case of a photovoltaic field. This is a non-linear convective model  and <img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/phy_capa/hconv_libre.png\" alt=\"h_conv=1.31*dT^(1/3)\"/></li>
<li>exchanges by LW radiation with the sky and the environment</li>
<li>SW radiation received by the PV panel from the sun (consideration of optical reflexion losses and conversion into electricity of a part of this incident radiation)</li>
</ul>
<p>The photovoltaic efficiency is calculated by the <a href=\"modelica://BuildSysPro.Systems.Solar.PV.BaseClasses.Thermal.EfficiencyFunctionOfTemp\"><code>EfficiencyFunctionOfTemp</code></a> model.</p>
<p><u><b>Bibliography</b></u></p>
<p>A thermal model for photovoltaic systems, A.D. Jones and C.P. Underwood, Solar Energy Vol.70, pp.349-359, 2001</p>
<p>A thermal model for photovoltaic panels under varying atmospheric conditions, S. Armstrong and W.G. Hurley, Applied Thermal Engineering Vol.30, pp.1488-1495, 2010</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>This model has the advantage of being detailed in terms of physical reality while reducing the computation time (by grouping all layers of the PV panel in a single thermal capacity).</p>
<p><b>Warning !</b> Up to now, this model can be used only for a crystalline silicon technology. For other technologies, use  PVPanelNOCT model and read the user manual.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>11/2013 : changement du modèle de diffus de HDKR à isotrope car plus en accord avec les données relevées sur site</p>
</html>"));
end PVPanelSimplified;
