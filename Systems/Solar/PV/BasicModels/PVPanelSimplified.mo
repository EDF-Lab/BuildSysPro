within BuildSysPro.Systems.Solar.PV.BasicModels;
model PVPanelSimplified
  "Modèle physique détaillé de panneau photovoltaïque (capacité thermique)"

  // Paramètres de l'installation PV

  parameter Modelica.SIunits.Area surface=20 "surface des panneaux PV"
    annotation (Dialog(tab="Panneaux PV", group="L'installation PV"));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=30
    "inclinaison du panneau PV par rapport à l'horizontale (0° vers le haut, 180° vers le sol)"
    annotation (Dialog(tab="Panneaux PV", group="L'installation PV"));
  parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg azimut=0
    "azimut du panneau PV - orientation par rapport au Sud (S=0°, E=-90°, O=90°, N=180°)"
    annotation (Dialog(tab="Panneaux PV", group="L'installation PV"));

  // Caractéristiques des panneaux PV

  replaceable parameter BaseClasses.Thermal.ThermalRecordsPV.RecordTechnoPV
    technoPV "choix de la technologie PV" annotation (
      __Dymola_choicesAllMatching=true, dialog(
      compact=true,
      tab="Panneaux PV",
      group="caractéristiques des panneaux PV"));
  parameter Real eta_STC=0.15
    "rendement (électrique) dans les conditions STC (1000W/m², 25°C) du panneau PV"
    annotation (Dialog(tab="Panneaux PV", group=
          "caractéristiques des panneaux PV"));
  parameter Real mu_T=-0.5 "Coefficient de température sur le rendement %/K"
                                                      annotation (Dialog(
        tab="Panneaux PV", group="caractéristiques des panneaux PV"));
  parameter Integer salete=0
    "0 - Panneaux propres, 1 - Panneaux peu sales, 2 - Panneaux moyennement sales, 3 - Panneaux très sales"
    annotation (dialog(
      compact=true,
      tab="Panneaux PV",
      group="caractéristiques des panneaux PV"), choices(
      choice=0 "Panneaux propres",
      choice=1 "Panneaux peu sales",
      choice=2 "Panneaux moyennement sales",
      choice=3 "Panneaux très sales",
      radioButtons=true));

  // Intégration des panneaux PV au bâti

  parameter Integer Integre=1
    "intégré au bâti=1 ; non intégré au bâti (en champ)=2"
    annotation (dialog(
      compact=true,
      tab="Panneaux PV",
      group="Intégration au bâti"), choices(
      choice=1 "Panneaux intégrés au bâti",
      choice=2 "Panneaux non intégrés au bâti (en plein champ)",
      radioButtons=true));

  // Echanges thermiques

  parameter Integer convection_avant=2
    "on impose un coefficient convectif=1; on utilise le modèle de convection par défaut=2"
    annotation (dialog(
      compact=true,
      tab="Echanges thermiques",
      group="Echanges en face avant"), choices(choice=1
        "On impose un coefficient convectif", choice=2
        "On utilise le modèle de convection par défaut"));
  parameter Real h_conv_avant=8.55
    "coefficient convectif imposé en face avant (W/m².K)" annotation (
      dialog(
      compact=true,
      tab="Echanges thermiques",
      group="Echanges en face avant",
      enable=convection_avant == 1));

  parameter Integer VitesseExt=1
    "vitesse extérieure fiche météo =1; on impose une vitesse du vent =2; on néglige l'effet du vent=3"
    annotation (dialog(
      compact=true,
      tab="Echanges thermiques",
      group="Conditions extérieures",
      enable=convection_avant == 2), choices(
      choice=1 "Vent pris en compte via fichier météo",
      choice=2 "Vent pris en compte, vitesse imposée",
      choice=3 "Vent négligé"));
  parameter Modelica.SIunits.Velocity vitesse=1
    "vitesse du vent imposée en m/s" annotation (Dialog(
      tab="Echanges thermiques",
      group="Conditions extérieures",
      enable=VitesseExt == 2));

  // Caractéristiques du toit

  parameter Real R_toit=8 "résistance thermique du toit (m²K/W)"
    annotation (Dialog(
      tab="Bâti",
      group="Toit du bâti",
      enable=Integre == 1));

  // Caractéristiques de l'intérieur de la maison

  parameter Modelica.SIunits.Temperature Tint=293.15
    "température intérieure de la maison" annotation (Dialog(
      tab="Bâti",
      group="Température intérieure du bâti",
      enable=Integre == 1));

  // Variables internes
  Real flux_transmis;
  Real flux_thermique;

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel
    "température de ciel" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-95,61}), iconTransformation(extent={{10,60},{30,80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "température ambiante" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-95,81}), iconTransformation(extent={{-32,60},{-12,80}})));
  Modelica.Blocks.Interfaces.RealInput Vit[2]
    "1- vitesse du vent (m/s) 2- direction du vent (par rapport au Sud, en °)"
    annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=180,
        origin={-101,41}),iconTransformation(extent={{-8,-8},{8,8}}, origin=
           {-92,40})));
public
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput G[10]
    "Flux solaire : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut, Hauteur}"
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
    "Température du ciel"
    annotation (Placement(transformation(extent={{51,89},{53,91}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel2
    "Température du ciel"
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
  Modelica.Blocks.Interfaces.BooleanInput OnOff_conv_avant=if convection_avant==1 then true else false;
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
  Modelica.Blocks.Interfaces.BooleanInput OnOff_integre=if Integre==1 then true else false;

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
  Modelica.Blocks.Interfaces.RealOutput Pelec "puissance elec (W)"
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
    "température des cellules" annotation (Placement(transformation(extent={{
            74,-6},{86,6}}), iconTransformation(extent={{60,-10},{80,10}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int
    "température intérieure" annotation (
    Placement(transformation(extent={{70,-96},{80,-86}}), iconTransformation(
          extent={{-10,-80},{10,-60}})),
    HideResult=true,
    enable=Integre == 1);
public
  Modelica.Blocks.Sources.RealExpression realExpression(y=flux_thermique);

  Modelica.Blocks.Interfaces.RealOutput prod_kWh "production elec (kWh)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-56}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-80})));
equation
  flux_transmis = fLUXsurf.FLUX[2]*facteursTransmission.FT_B + (fLUXsurf.FLUX[
    1] - fLUXsurf.AzHSol[3])*facteursTransmission.FT_D + fLUXsurf.AzHSol[3]
    *facteursTransmission.FT_A;
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
  connect(gLOext1.T_ciel, T_ciel1) annotation (Line(
      points={{51,71.4},{51,84},{52,84},{52,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(gLOext1.T_ext, T_ext1) annotation (Line(
      points={{46.2,71.4},{46,76},{46,80},{40,80},{40,90}},
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
      points={{38.2,-79.4},{38,-88},{26,-88},{26,-96}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(GLOext.T_ciel, T_ciel2) annotation (Line(
      points={{43,-79.4},{43,-90.7},{44,-90.7},{44,-96}},
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

  connect(GLOext.Ts_p, interrupteur_non_integre.port_b) annotation (Line(
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
      points={{14.7,0.02},{27.35,0.02},{27.35,-3},{39,-3}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, interrupteur1_coeff_impose.port_a)
    annotation (Line(
      points={{39,-3},{39,42},{14,42},{14,48.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, interrupteur1_modele_conv.port_a) annotation (
     Line(
      points={{39,-3},{39,42},{30,42},{30,48.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, gLOext1.Ts_p) annotation (Line(
      points={{39,-3},{39,42},{48,42},{48,60.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, interrupteur_non_integre.port_a) annotation (
      Line(
      points={{39,-3},{39,-36},{29,-36},{29,-46.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, interrupteur_integre_bati.port_a) annotation (
     Line(
      points={{39,-3},{39,-38},{73,-38},{73,-48.375}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow2.port, temperatureSensor.port) annotation (
      Line(
      points={{14.7,0.02},{14.7,24},{-2,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, T_cellule) annotation (Line(
      points={{39,-3},{59.5,-3},{59.5,0},{80,0}},
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
<p><i><b>Modèle physique détaillé de panneau photovolta&iuml;que (capacité thermique)</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>Modèle permettant de calculer : la température du module, la puissance électrique instantanée et la production PV cumulée</p>
<p><br>Ce modèle prend en compte :</p>
<ul>
<li>la capacité thermique du panneau photovolta&iuml;que</li>
<li>les échanges par convection forcée due au vent en face avant <img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/phy_capa/hconv_vent.png\" alt=\"U_L=8.55+2.56*V\"/></li>
<li>les échanges par convection libre en face arrière s'il s'agit d'un champ photovolta&iuml;que. Il s'agit d'un modèle convectif non-linéaire et <img src=\"modelica://BuildSysPro/Resources/Images/PV/equations/phy_capa/hconv_libre.png\" alt=\"h_conv=1.31*dT^(1/3)\"/></li>
<li>les échanges par rayonnement en GLO avec la voûte céleste et l'environnement</li>
<li>le rayonnement en CLO reçu par le panneau PV en provenance du soleil (prise en compte des pertes optiques par réflexion et de la conversion en électricité d'une partie de ce rayonnement incident)</li>
</ul>
<p>Le rendement photovolta&iuml;que est calculé par le RendementFctTemperature de la BoiteAOutils.</p>
<p><br><u><b>Bibliographie</b></u></p>
<p>A thermal model for photovoltaic systems, A.D. Jones and C.P. Underwood, Solar Energy Vol.70, pp.349-359, 2001</p>
<p>A thermal model for photovoltaic panels under varying atmospheric conditions, S. Armstrong and W.G. Hurley, Applied Thermal Engineering Vol.30, pp.1488-1495, 2010</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>Ce modèle a l'avantage d'être détaillé au niveau de la réalité physique tout en diminuant le temps de calcul (en regroupant toutes les couches du panneau PV en une seule capacité thermique).</p>
<p><b>Attention ! </b>A ce jour, ce modèle ne peut être utilisé que pour une technologie silicium cristallin. Pour les autres technologies, utiliser le modèle PVmodeleNOCT et bien lire le mode d'emploi.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 03/2013</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Amy LINDSAY, EDF (2013)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>11/2013 : changement du modèle de diffus de HDKR à isotrope car plus en accord avec les données relevées sur site</p>
</html>"));
end PVPanelSimplified;
