within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model Window "Modèle de fenêtre déperditive générique"
  // Option du vitrage
parameter Boolean useVolet=false  annotation(dialog(group="Options",compact=true),choices(choice=true
        "Avec volet",                                                                                               choice=false
        "Sans volet",                                                                                                  radioButtons=true));
parameter Boolean useOuverture=false
 annotation(dialog(group="Options",compact=true),choices(choice=true
        "Avec ouverture",                                                              choice=false
        "Sans ouverture",                                                                                             radioButtons=true));
parameter Boolean useReduction=false
annotation(dialog(group="Options",compact=true),choices(choice=true
        "Avec masquage, menuiserie",                                                             choice=false
        "Sans masquage, menuiserie",                                                                                                  radioButtons=true));
parameter Boolean useEclairement=false
annotation(dialog(group="Options",compact=true),choices(choice=true
        "Avec calcul de l'éclairement naturel",                                                             choice=false
        "Sans calcul de l'éclairement naturel",                                                                                                  radioButtons=true));
  // Paramètres généraux
  parameter Modelica.SIunits.Area S=1 "Surface vitrée"
                                                       annotation(dialog(group="Paramètres généraux"));
  parameter Modelica.SIunits.Length H=1 "Hauteur vitre" annotation(dialog(group="Paramètres généraux"));
  parameter Modelica.SIunits.Length L=1 "Largeur vitre" annotation(dialog(enable=useEclairement,group="Paramètres généraux"));

// Coefficient de transmission et d'échanges tels que Uvitrage=3
parameter Modelica.SIunits.CoefficientOfHeatTransfer k=6.06
    "Coefficient de transmission surfacique k du vitrage - sans échanges convectifs; par défaut, k, hs_ext et hs_int pour que Uvitrage=3"
                                                                                                      annotation(dialog(group="Paramètres généraux"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=21
    "Coefficient d'échange surfacique sur la face extérieure" annotation(dialog(group="Paramètres généraux"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=8.29
    "Coefficient d'échange surfacique global sur la face intérieure" annotation(dialog(group="Paramètres généraux"));
parameter Modelica.SIunits.ThermalInsulance R_volet=0.2
    "Résistance thermique additionnelle (volet fermé)"                                                          annotation(Dialog(enable=useVolet,group="Paramètres généraux"));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Inclinaison de la surface par rapport à l'horizontale - vers le sol=180°, vers le ciel=0°, verticale=90°"
                                                                                                      annotation(dialog(group="Paramètres généraux"));
parameter Integer choix=1
    "Formule utilisée pour pondérer la transmission thermique du flux direct"
                                                                                                      annotation(dialog(group="Paramètres généraux"),choices(
        choice=1 "Fauconnier",
        choice=2 "RT",
        choice=3 "Cardonnel",
        choice=4 "Linéaire avec cosi"));

// Paramètres optiques
parameter Real TrDir=0.747 "Coefficient de transmission direct de la fenêtre" annotation(dialog(group="Propriétés optiques"));
parameter Real TrDif=0.665 "Coefficient de transmission diffus de la fenêtre" annotation(dialog(group="Propriétés optiques"));
parameter Real AbsDir=0.100 "Coefficient d'absorption direct de la fenêtre" annotation(dialog(group="Propriétés optiques"));
parameter Real AbsDif=0.108 "Coefficient d'absorption diffus de la fenêtre" annotation(dialog(group="Propriétés optiques"));
parameter Real eps=0.9 "Emissivité du vitrage en GLO" annotation(dialog(group="Propriétés optiques"));

// Facteurs de réduction des flux direct et diffus (masquage, menuiserie,...)
parameter Integer TypeFenetrePF=1
    "Choix du type de fenetre ou porte-fenetre (PF)"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"),
    choices( choice= 1 "Je ne sais pas - pas de menuiserie",
             choice= 2 "Battant Fenêtre Bois",
             choice= 3 "Battant Fenêtre Métal",
             choice= 4 "Battant PF avec soubassement Bois",
             choice= 5 "Battant PF sans soubassement Bois",
             choice= 6 "Battant PF sans soubassement Métal",
             choice= 7 "Coulissant Fenêtre Bois",
             choice= 8 "Coulissant Fenêtre Métal",
             choice= 9 "Coulissant PF avec soubassement Bois",
             choice= 10 "Coulissant PF sans soubassement Bois",
             choice= 11 "Coulissant PF sans soubassement Métal"));
parameter Real voilage=0.95 "Voilage : = 0.95 si oui et = 1 sinon"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"));
parameter Real position=0.90
    "Position du vitrage : = 0.9 si interieure et = 1 si exterieure"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"));
parameter Real rideaux=0.85 "Presence de rideaux : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"));
parameter Real ombrages=0.85
    "Ombrage d'obstacles (vegetation, voisinage) : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Type de vitrage",enable=useReduction,group="Paramètres"));
parameter Real r1=1 "Coef. réducteur pour le direct si useReduction = false"
    annotation (Dialog(tab="Type de vitrage",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));
parameter Real r2=1 "Coef. réducteur pour le diffus si useReduction = false"
    annotation (Dialog(tab="Type de vitrage",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));

    // Prise en compte de flux radiatifs à l'intérieur de la fenêtre
parameter Boolean RadInterne=false
    "Prise en compte de flux absorbés à l'intérieur" annotation(dialog(tab="Paramètres avancés",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
parameter Boolean DifDirOut=false
    "Sortie des flux direct et diffus au lieu du flux total" annotation(dialog(tab="Paramètres avancés",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));
parameter Boolean GLOext=false
    "Prise en compte de rayonnement GLO vers l'environnement et le ciel" annotation(dialog(tab="Paramètres avancés",compact=true),choices(choice=true "oui", choice=false "non", radioButtons=true));

protected
  parameter Real sigma[11]={1,0.7,0.7,0.63,0.74,0.74, 0.700,0.77,0.630,0.74,0.83}
    "Proportion de menuiserie pour chaque type de vitrage";
  parameter Real facteur=rideaux*sigma[TypeFenetrePF]*voilage*ombrages;
  parameter Real reduc_dir=if useReduction then facteur*position else 1;
  parameter Real reduc_dif=if useReduction then facteur else 1;
  parameter Real R_ouv_max= if TypeFenetrePF==7 or TypeFenetrePF==8 or TypeFenetrePF==9 or TypeFenetrePF==10 or TypeFenetrePF==11 then 0.4
 elseif
       TypeFenetrePF==2 or TypeFenetrePF==3 then 0.2 else 0.8;

  Real part_vitrage;
  Real part_vide;

  //Facteurs de transmission lumineuse
  Real Tlii_sp=TransLum.CoeffTransLum[1]-TransLum.CoeffTransLum[2] if useEclairement
    "Facteur de transmission lumineuse du flux incident direct transmis sous forme directe de la baie vitrée sans protection mobile en place";
  Real Tlii_ap_dir=Tld_ap_dif-Tlid_ap_dir if useEclairement
    "Facteur de transmission lumineuse du flux incident direct transmis sous forme directe de la baie vitrée avec protection mobile en place";
  Real Tlid_sp=TransLum.CoeffTransLum[2] if useEclairement
    "Facteur de transmission lumineuse du flux incident direct transmis sous forme diffuse de la baie vitrée sans protection mobile en place";
  Real Tld_ap_dif=TransLum.CoeffTransLum[3] if useEclairement
    "Facteur de transmission lumineuse global du flux incident diffus avec protection mobile en place";
  Real Tld_sp=TransLum.CoeffTransLum[1] if useEclairement
    "Facteur de transmission lumineuse global de la baie vitrée sans protection mobile en place";
  Real Tlid_ap_ref=TransLum.CoeffTransLum[4] if useEclairement
    "Facteur de transmission lumineuse du flux incident réfléchi par le sol sous forme directe transmis sous forme diffuse avec protection mobile en place";
  Real Tlid_ap_dir=TransLum.CoeffTransLum[4] if useEclairement
    "Facteur de transmission lumineuse du flux incident direct transmis sous forme diffuse avec protection mobile en place";
  Real Tlii_ap_ref=Tld_ap_dif-Tlid_ap_ref if useEclairement
    "Facteur de transmission lumineuse du flux incident réfléchi par le sol, transmis sous forme directe de la baie vitrée avec protection mobile en place";

// Connecteurs
public
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FLUX[3]
    "Informations de flux solaire surfacique incident 1-Flux Diffus, 2-Flux Direct 3-Cosi"
    annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
        iconTransformation(extent={{-40,40},{-20,60}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr if  not
  DifDirOut "Rayonnement CLO transmis à l'intérieur" annotation (Placement(
        transformation(extent={{60,50},{100,90}}), iconTransformation(extent={{
            80,40},{100,60}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr2[3] if
  DifDirOut
    "Rayonnement CLO transmis à l'intérieur 1-Diffus, 2-Direct, 3-cosi"
    annotation (Placement(transformation(extent={{60,20},{100,60}}),
        iconTransformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne
    "Flux (GLO/CLO) absorbés par le vitrage sur sa face intérieure"
    annotation (Placement(transformation(extent={{120,-10},{82,28}}),
        iconTransformation(extent={{40,10},{20,30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Température extérieure" annotation (Placement(transformation(
          extent={{-100,-40},{-80,-20}}), iconTransformation(extent={{-100,
            -40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Température de surface extérieure" annotation (Placement(
        transformation(extent={{-40,-40},{-20,-20}}),
        iconTransformation(extent={{-40,-40},{-20,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Température de surface intérieure" annotation (Placement(
        transformation(extent={{20,-40},{40,-20}}), iconTransformation(
          extent={{20,-40},{40,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Température intérieure" annotation (Placement(transformation(
          extent={{80,-40},{100,-20}}), iconTransformation(extent={{80,
            -40},{100,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ciel if         GLOext
    "Température du ciel" annotation (Placement(transformation(extent=
            {{-100,-100},{-80,-80}}), iconTransformation(extent={{-100,
            -100},{-80,-80}})));

  Modelica.Blocks.Interfaces.RealInput fermeture_volet if      useVolet
    "Taux de fermeture du volet (0 ouvert, 1 fermé)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={2,116}), iconTransformation(extent={{-100,60},{-80,80}},
          rotation=0)));
  Modelica.Blocks.Interfaces.BooleanInput ouverture_fenetre if useOuverture
    " Ouverture de la fenêtre (true=ouvert false=fermée)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-26,116}), iconTransformation(extent={{-40,-10},{-20,10}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput V if    useOuverture
    "Vitesse du vent normale au vitrage (m/s)" annotation (Placement(
        transformation(extent={{-120,60},{-80,100}}), iconTransformation(extent={{-100,
            -10},{-80,10}})));

// Composants

  BuildSysPro.BaseClasses.HeatTransfer.Components.ControlledThermalConductor
    conduction
    annotation (Placement(transformation(extent={{-12,-70},{8,-50}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=true) if
                useOuverture
    annotation (Placement(transformation(extent={{32,-98},{52,-78}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtLWR EchangesGLOext(
    S=S,
    eps=eps,
    incl=incl,
    GLO_env=GLOext,
    GLO_ciel=GLOext) if
                      GLOext annotation (Placement(transformation(
          extent={{-70,-98},{-50,-78}})));
protected
Modelica.Blocks.Math.Add Transmission(k1=1, k2=1)                  annotation (Placement(transformation(extent={{48,62},
            {68,82}})));
public
Modelica.Blocks.Math.Add AbsFenExt(                          k1=S, k2=S)
                                                                   annotation (Placement(transformation(extent={{-38,-6},
            {-58,14}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedCLOAbsExt annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={-75,5})));

  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedCLOAbsInt if
                         RadInterne annotation (Placement(
        transformation(
        extent={{-8,8},{8,-8}},
        rotation=180,
        origin={50,10})));

  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    echange_int(G=hs_int*S)
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    echange_ext(G=hs_ext*S) annotation (Placement(transformation(extent=
           {{-70,-70},{-50,-50}})));

Modelica.Blocks.Math.Gain FluxDirectTr(k=S)                        annotation (Placement(transformation(extent={{12,72},
            {26,86}})));
Modelica.Blocks.Math.Gain FluxDiffusTr(k=S)                        annotation (Placement(transformation(extent={{12,50},
            {26,64}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.DirectTrans
    transDirect(choix=choix, TrDir=TrDir)
    annotation (Placement(transformation(extent={{-46,70},{-30,86}})));

  BuildSysPro.Systems.Controls.Switch interrupteur(valeur_On=false) annotation (
     Placement(transformation(
        extent={{-8,6},{8,-6}},
        rotation=90,
        origin={-24,-52})));
  BuildSysPro.Building.AirFlow.HeatTransfer.WindowNaturalVentilation
    fenetreVentilationNaturelle(Hfenetre=H, Sfenetre=(if useReduction then
        R_ouv_max else 1)*S) if useOuverture
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor
    SensorText annotation (Placement(transformation(extent={{-76,-30},{
            -68,-22}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor
    SensorTint
    annotation (Placement(transformation(extent={{76,-32},{68,-24}})));

protected
  Modelica.Blocks.Interfaces.RealInput volet_internal
     annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-150,80}), iconTransformation(extent={{-88,66},{-60,94}},
          rotation=0)));
  Modelica.Blocks.Interfaces.BooleanInput ouverture_internal     annotation (Placement(transformation(extent={{-170,16},{-130,56}})));
  Modelica.Blocks.Interfaces.RealInput G_internal annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-150,0}), iconTransformation(extent={{-88,66},{-60,94}},
          rotation=0)));
public
  Modelica.Blocks.Interfaces.RealOutput Flum[3] if useEclairement
    "Flux lumineux transmis -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{100,-92},{146,-46}}),
        iconTransformation(extent={{80,90},{100,110}})));
  Modelica.Blocks.Interfaces.RealInput Ecl[3] if useEclairement
    "Eclairement incident -direct -diffus -réfléchi (lumen)"
    annotation (Placement(transformation(extent={{19,-19},{-19,19}},
        rotation=180,
        origin={-149,-37}),
        iconTransformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,100})));
  BoundaryConditions.Solar.Irradiation.LightTransCoeff TransLum(
    H=H,
    L=L,
    e=e,
    azimut=azimut,
    TLw=TLw,
    TLw_dif=TLw_dif,
    TLws=TLws,
    TLws_dif=TLws_dif,
    MasqueProche=MasqueProche,
    Protection=Protection) if useEclairement
    annotation (Placement(transformation(extent={{-78,84},{-58,104}})));
  parameter Real e=0.35
    "Epaisseur de la paroi verticale dans laquelle s'intègre le vitrage"                     annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real azimut=0
    "Azimut de la surface (Orientation par rapport au sud) - S=0°, E=-90°, O=90°, N=180°"
                                                                                              annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real TLw=0.5
    "Facteur de transmission lumineuse global de la baie sans protection" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real TLw_dif=0
    "Facteur de transmission lumineuse diffus de la baie sans protection" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real TLws=0
    "Facteur de transmission lumineuse global de la baie avec protection" annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Real TLws_dif=0
    "Facteur de transmission lumineuse diffus de la baie avec protection" annotation(enable=useEclairement,dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Boolean MasqueProche=false
    "True si modèle de masque utilisé en amont, false sinon"                                    annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
  parameter Boolean Protection=false
    "True si protection mobile extérieure en place, false sinon"                                  annotation(dialog(enable=useEclairement,group="Paramètres éclairement"));
public
  Modelica.Blocks.Interfaces.RealOutput Etp if useEclairement
    "Eclairement total incident sur la baie (lumen)"
    annotation (Placement(transformation(extent={{-23,-23},{23,23}},
        rotation=270,
        origin={13,-129}),
        iconTransformation(extent={{-13,-13},{13,13}},
        rotation=270,
        origin={1,-117})));
  Modelica.Blocks.Sources.RealExpression CalculETP(y=Ecl[1] + Ecl[2] + Ecl[3]) if useEclairement
    "Calcul de l'éclairement total incident sur la baie"
    annotation (Placement(transformation(extent={{-12,-110},{8,-90}})));
  Modelica.Blocks.Sources.RealExpression CalculFlum[3](y={
        if useVolet then S*(volet_internal*Tlii_ap_dir+(1-volet_internal)*Tlii_sp)*Ecl[1]
        else S*Tlii_sp*Ecl[1],
        if useVolet then S*((volet_internal*Tlid_ap_dir+(1-volet_internal)*Tlid_sp)*Ecl[1]+(volet_internal*Tld_ap_dif+(1-volet_internal)*Tld_sp)*Ecl[2]+(volet_internal*Tlid_ap_ref+(1-volet_internal)*Tlid_sp)*Ecl[3])
        else S*(Tlid_sp*Ecl[1]+Tld_sp*Ecl[2]+Tlid_sp*Ecl[3]),
        if useVolet then S*(volet_internal*Tlii_ap_ref+(1-volet_internal)*Tlii_sp)*Ecl[3]
        else S*Tlii_sp*Ecl[3]}) if useEclairement
    "Calcul du flux lumineux transmis -direct -diffus -réfléchi"
    annotation (Placement(transformation(extent={{66,-110},{86,-90}})));
  BoundaryConditions.Solar.Irradiation.DirectAbs absDirect(choix=choix, AbsDir=
        AbsDir)
    annotation (Placement(transformation(extent={{-46,32},{-30,48}})));
equation
  //Calcul de la conductance thermique de la fenêtre complète (vitrage+volet) hors convections
  connect(G_internal,conduction. G) annotation (Line(
      points={{-150,0},{-76,0},{-76,-18},{-2,-18},{-2,-52}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  if useVolet then
    if volet_internal>=0.95 then
      G_internal=S/(1/k+R_volet);
    else
      G_internal=k*S;
    end if;
  else
    G_internal=k*S;
  end if;
  connect(T_ext, echange_ext.port_a) annotation (Line(
      points={{-90,-30},{-90,-60},{-69,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(echange_ext.port_b, Ts_ext) annotation (Line(
      points={{-51,-60},{-30,-60},{-30,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(interrupteur.port_b, Ts_ext) annotation (Line(
      points={{-24,-43},{-24,-30},{-30,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(interrupteur.port_a,conduction. port_a) annotation (Line(
      points={{-24,-61},{-24,-60},{-11,-60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(conduction.port_b, Ts_int) annotation (Line(
      points={{7,-60},{30,-60},{30,-30}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(echange_int.port_b, T_int) annotation (Line(
      points={{59,-60},{90,-60},{90,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ts_int, echange_int.port_a) annotation (Line(
      points={{30,-30},{30,-60},{41,-60}},
      color={255,0,0},
      smooth=Smooth.None));
// Echanges CLO
  connect(prescribedCLOAbsExt.Q_flow, AbsFenExt.y)  annotation (Line(
      points={{-68.7,4.02},{-59.4,4.02},{-59.4,4},{-59,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Transmission.y, CLOTr)       annotation (Line(
      points={{69,72},{74,72},{74,70},{80,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.Q_flow, FluxAbsInt)
                                              annotation (Line(
      points={{57.2,8.88},{65.6,8.88},{65.6,9},{101,9}},
      color={0,0,127},
      smooth=Smooth.None));

  //Impact des occultations sur les flux transmis et absorbés
  //Le flux est transmis uniquement par la fenêtre (volet occultant)
  if S>0 then
  part_vitrage=(if useOuverture then (if ouverture_internal then (if useReduction then (1-R_ouv_max) else 0) else 1) else 1)*S;
  part_vide=S-part_vitrage;
  FluxDirectTr.u=reduc_dir*(1-volet_internal)*(transDirect.Direct*part_vitrage+FLUX[2]*part_vide)/S;
  FluxDiffusTr.u=reduc_dif*(1-volet_internal)*FLUX[1]*(TrDif*part_vitrage+part_vide)/S;
  AbsFenExt.u1=reduc_dir*(1-volet_internal)*(absDirect.Direct*part_vitrage+FLUX[2]*part_vide)/S;
  AbsFenExt.u2=reduc_dif*(1-volet_internal)*FLUX[1]*(AbsDif*part_vitrage+part_vide)/S;
  else
  part_vitrage=0;
  part_vide=0;
  FluxDirectTr.u=0;
  FluxDiffusTr.u=0;
  AbsFenExt.u1=0;
  AbsFenExt.u2=0;
  end if;

  connect(prescribedCLOAbsExt.port, Ts_ext) annotation (Line(
      points={{-82.7,4.02},{-92,4.02},{-92,-12},{-30,-12},{-30,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.port, Ts_int)   annotation (Line(
      points={{41.2,8.88},{30,8.88},{30,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FluxDiffusTr.y, Transmission.u2) annotation (Line(
      points={{26.7,57},{40.25,57},{40.25,66},{46,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FluxDirectTr.y, Transmission.u1) annotation (Line(
      points={{26.7,79},{34,79},{34,78},{46,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FluxDiffusTr.y, CLOTr2[1]) annotation (Line(
      points={{26.7,57},{40.35,57},{40.35,26.6667},{80,26.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FluxDirectTr.y, CLOTr2[2]) annotation (Line(
      points={{26.7,79},{34.35,79},{34.35,40},{80,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FLUX[3], CLOTr2[3]) annotation (Line(
      points={{-100,53.3333},{-56,53.3333},{-56,54},{-10,54},{-10,53.3333},{80,
          53.3333}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FLUX, transDirect.FLUX) annotation (Line(
      points={{-100,40},{-70,40},{-70,78.32},{-46.8,78.32}},
      color={255,192,1},
      smooth=Smooth.None));

  // Echanges GLO
  connect(EchangesGLOext.T_ext, T_ext) annotation (Line(
      points={{-69,-85},{-76,-85},{-76,-30},{-90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EchangesGLOext.T_ciel, T_ciel) annotation (Line(
      points={{-69,-93},{-79.5,-93},{-79.5,-90},{-90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EchangesGLOext.Ts_p, Ts_ext) annotation (Line(
      points={{-51,-88},{-30,-88},{-30,-30}},
      color={255,0,0},
      smooth=Smooth.None));

  // Ouverture de fenêtre

  connect(V, fenetreVentilationNaturelle.V) annotation (Line(
      points={{-100,80},{-60,80},{-60,30},{-10,30},{-10,8}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(T_ext, SensorText.port) annotation (Line(
      points={{-90,-30},{-83,-30},{-83,-26},{-76,-26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SensorText.T, fenetreVentilationNaturelle.T_ext) annotation (Line(
      points={{-68,-26},{-60,-26},{-60,-28},{-50,-28},{-50,-8},{-8,-8},{-8,0}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(SensorTint.port, T_int) annotation (Line(
      points={{76,-28},{84,-28},{84,-30},{90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(SensorTint.T, fenetreVentilationNaturelle.T_int) annotation (Line(
      points={{68,-28},{52,-28},{52,0},{8,0}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(fenetreVentilationNaturelle.Qfenetres, renouvellementAir.Qv_in)
    annotation (Line(
      points={{8,-6},{10,-6},{10,-74},{38,-74},{38,-79.2},{42,-79.2}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(T_ext, renouvellementAir.port_a) annotation (Line(
      points={{-90,-30},{-90,-72},{-8,-72},{-8,-88},{33,-88}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, T_int) annotation (Line(
      points={{51,-88},{90,-88},{90,-30}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(ouverture_fenetre, ouverture_internal) annotation (Line(
      points={{-26,116},{-26,36},{-150,36}},
      color={255,0,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  if not useOuverture then
    ouverture_internal=false;
  end if;

  connect(fenetreVentilationNaturelle.ouverture_fenetre, ouverture_internal)
    annotation (Line(
      points={{0,10},{0,36},{-150,36}},
      color={255,0,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(interrupteur.OnOff, ouverture_internal) annotation (Line(
      points={{-19.4,-52},{-14,-52},{-14,-118},{-136,-118},{-136,36},{-150,36}},
      color={255,0,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
//Volet
  connect(volet_internal, fermeture_volet) annotation (Line(
      points={{-150,80},{2,80},{2,116}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  if not useVolet then
    volet_internal=0;
  end if;

// Autres

  connect(CalculETP.y, Etp) annotation (Line(
      points={{9,-100},{13,-100},{13,-129}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CalculFlum.y, Flum) annotation (Line(
      points={{87,-100},{96,-100},{96,-69},{123,-69}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FLUX,absDirect. FLUX) annotation (Line(points={{-100,40},{-46.8,40},{
          -46.8,40.32}}, color={255,192,1}));
   annotation (Placement(transformation(extent={{-64,-44},{-44,-24}})),
      Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-98,144},{104,108}},
          lineColor={0,0,0},
          fillColor={225,206,155},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Line(
          points={{-92,-30},{92,-30}},
          smooth=Smooth.None,
          color={0,0,0}),
        Rectangle(
          extent={{-20,100},{20,-100}},
          lineColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={131,226,236}),
        Line(
          points={{-60,100},{-60,-100}},
          color={95,95,95},
          smooth=Smooth.None,
          thickness=1)}),
    Documentation(info="<html>
<p><u><b>Hypothèses et équations</b></u></p>
<ul>
<li>Les flux CLO incidents sur la face externe sont séparés en diffus et direct. Ils sont obtenus par calculs séparés après considération de l'inclinaison et de l'azimuth du vitrage. </li>
<li>Les échanges GLO avec l'environnement extérieur peuvent être pris en compte en reliant ce modèle à une température de ciel et en spécifiant l'inclinaison du vitrage </li>
<li>La transmittivité directe du vitrage est calculée en fonction de l'angle d'incidence selon la formule de Fauconnier (formules RT et Cardonnel disponibles)</li>
</ul>
<p><br>Concernant les volets roulants, les hypothèses retenues sont les suivantes:</p>
<ul>
<li>Pas de flux solaire transmis par la partie occultée par le volet</li>
<li>Flux absorbé inchangé (absorptivité du PVC proche de celle du verre)</li>
<li>Si le volet n'est pas complètement fermé (Coeff_Fermeture &LT;95%), résistance thermique inchangée</li>
<li>Si le volet est complètement fermé, résitance thermique augmentée d'une résistance thermique additionnelle, évaluée à 0.2 m&sup2;K/W (épaisseur de PVC de 12 mm env.)</li>
</ul>
<p><br>Lorsque la fenêtre est ouverture, il y a &QUOT;rupture&QUOT; de la conductance à travers la vitre, et à la place un débit de renouvellement d'air par ventilation naturelle est calculé (voir <a href=\"modelica://BuildSysPro.Building.AirFlow.HeatTransfer.WindowNaturalVentilation\">WindowNaturalVentilation</a>). De plus, l'absence de vitrage se traduit par une suppression des facteurs de transmission du direct et du diffus.</p>
<p><br>Des coefficients de réduction des flux direct et diffus peuvent également être pris en compte (si useReduction=True), en fonction de :</p>
<ul>
<li>type de fenêtres/ portes fenêtres (le % de menuiserie en est déduit)</li>
<li>coefficient représentant la diminution des flux à travers les voilages</li>
<li>coefficient représentant la diminution des flux en raison de la position de la fenêtre (intérieure ou extérieure)</li>
<li>coefficient représentant la diminution des flux à travers les rideaux.</li>
<li>coefficient représentant la diminution des flux en raison d'ombrages (NB: il existe aussi un modèle qui permet de calculer de façon précise les flux surfaciques sur une paroi verticale en cas de débords : <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.SolarMasks.FLUXsurfMask\">FLUXsurfMask</a>)</li>
</ul>
<p>Concernant le calcul de l'éclairement naturel, les facteurs de transmission lumineuse global et diffus qui doivent être renseignés correspondent aux TLw, TLw_dif, TLsw et TLsw_dif qui sont calculés précisément dans la norme EN 410. Cependant, il est possible de retrouver des valeurs tabulées dans le document <i>Valeurs tabulées des caractéristiques des parois vitrées et des correctifs associés aux baies</i> du CSTB. Ainsi, par défaut: </p>
<ul>
<li>Pour du double vitrage sans protection solaire: TLw=0.5, TLw_dif=0</li>
<li>Pour du double vitrage avec protection solaire opaque et sombre située à l'extérieur: TLsw=0, TLsw_dif=0</li>
<li>Pour du double vitrage avec protection solaire non opaque et claire située à l'extérieur: TLsw=0.09, TLsw_dif=0.03</li>
</ul>
<p><br><u><b>Bibliographie</b></u></p>
<p>TF1 CLIM2000</p>
<p>CSTB. 2005. Guide réglementaire RT 2005. Règle d'application Th-Bât Th-U 3/5 Parois vitrées.</p>
<p>Eclairement naturel : Règles Th-L - Caractérisation du facteur de transmission lumineuse des parois du bâtiment - CSTB Mars 2012, Valeurs tabulées des parois vitrées - CSTB Mars 2012</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>Les ports thermiques <b>T_ext</b> et <b>T_int</b> doivent être reliés à des noeuds de température (habituellement Tseche et Tint).</p>
<p>Les flux incidents externes <b>FLUX</b> peuvent provenir des modèles de conditions limites du package <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar\">BoundaryConditions.Solar</a> qui font la liaison entre les parois et les lecteurs Météo.</p>
<p>Le flux incident interne <b>FluxAbsInt</b> peut provenir des occupants, systèmes de chauffage mais aussi de la redistribution du flux solaire à l'intérieur d'une pièce (modèles du package <a href=\"modelica://BuildSysPro.BoundaryConditions.Radiation\">BoundaryConditions.Radiation</a>).</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<ul>
<li>Le coefficient <b>k</b> représente la conductivité du vitrage sans prise en compte des échanges convectifs (différent du Uvitrage usuellement utilisé).</li>
<li>Le coefficient d'échange convectif avec l'extérieur hs_ext par défaut est la valeur du coefficient combiné intégrant les échanges convectifs et radiatifs GLO. </li>
<li><u>Si les échanges avec l'environnement sont considérés, la valeur de hs_ext doit être modifiée</u> <i>- Par défaut on pourra prendre 16W/m&sup2;.K puisque la part radiative est évaluée à 5,13W/m&sup2;.K à l'extérieur, ce qui correspond à une température de l'environnement de 10&deg;C.</i></li>
</ul>
<p>Dans le cas du calcul de l'éclairement il faut penser à préciser s'il existe des masques en amont car alors la prise en compte des ombres dues à l'architecture se fait dans le modèle de masque.</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Procédure BESTEST de validation</p>
<p>Modèle validé - Aurélie Kaemmerlen 12/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Aurélie KAEMMERLEN, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Aurélie Kaemmerlen 02/2011 : Ajout du choix de considérer ou non des flux (GLO et CLO) sur la face interne via le booléen RadInterne</p>
<p>Aurélie Kaemmerlen 05/2011 : </p>
<ul>
<li>Ajout du choix de sortir soit le flux global CLO transmis, soit les flux CLO direct et le diffus, qui sont transmis par le vitrage via le booléen DifDirOut</li>
<li>Modification du nom du connecteur CLOabs changé en FluxAbsInt</li>
</ul>
<p><br>Aurélie Kaemmerlen 06/2011 : Remplacement de la fonction PondTransDirect par un modèle plus complet possédant plusieurs formules de pondération du rayonnement direct. Il faudra l'étendre à l'absorption si besoin</p>
<p>Aurélie Kaemmerlen 10/2011 : Ajout des échanges avec l'environnement (ciel et sol) </p>
<ul>
<li>Un nouveau booléen a été ajouté pour permettre de considérer ou non ces deux échanges</li>
<li>L'inclinaison et l'émissivité en GLO du vitrage ont ainsi été ajoutées pour caractériser ces échanges</li>
</ul>
<p><br>Aurélie Kaemmerlen 10/2012 - Ajout d'une pondération linéaire en cosi</p>
<p>Frédéric Gastiger 03/2014 : ajout de la possibilité de commander un volet (fermeture_volet qui varie entre 0 et 1 - 1 quand le volet est fermé, 0 quand le volet est ouvert), avec la résistance thermique supplémentaire que cela engendre.</p>
<p>Amy Lindsay 03/2014 : - ajout de la possibilité d'ouvrir la fenêtre (true quand la fenêtre est ouverte, false quand elle est fermée) avec le débit de ventilation naturelle que cela engendre.</p>
<p>- ajout des coefficients de réduction des flux diffus/direct en fonction du type de fenêtre / porte fenêtre, de la présence de voilages, rideaux etc. issus des stages de Raphaelle Mrejen (2012) et Alexandre Hautefeuille (2013)</p>
<p>- changement des FluxSolInput en RealInput pour les flux absorbés intérieur pour éviter les confusions (ces flux absorbés en GLO ou en CLO peuvent non seulement provenir du soleil, mais aussi d'autres sources radiative)</p>
<p>Gilles Plessis 03/2014 : Simplification du modèle.</p>
<p>Amy Lindsay 04/2014 : Prise en compte du fait qu'avec la fenêtre ouverte, la part non vitrée de l'ouverture n'impose plus de facteurs de transmission du direct et du diffus.</p>
<p>Frédéric Gastiger 04/2015 : Correction d'une erreur dans le calcul du flux direct transmis à travers une fenêtre ouverte.</p>
<p>Laura Sudries, Vincent Magnaudeix 05/2015 : Prise en compte des flux lumineux incidents sur la baie pour calculer les flux lumineux transmis à travers la baie considérée (direct, diffus, réfléchi par le sol). Equations issues de la RT2012.</p>
<p>Benoît Charrier 01/2016 : Ajout de la prise en compte de l'absorption variable en fonction de l'angle d'incidence.</p>
</html>"),      Placement(transformation(extent={{46,-50},{66,-30}})),
Documentation(info="<HTML>
<p>
Modèle de paroi éclairée assemblé à partir du modèle ParoiComplete et d'EclairementTouteSurface. 
Il reprend le TF1 de CLIM2000 à la différence près que le coefficient d'échange intégré au modèle permet de modéliser : 
<p>
- soit un échange global entre la température de surface et une ambiance, 
<p>
- soit uniquement un échange convectif vers l'air extérieur ; le noeud de surface reste disponible pour connecter un modèle d'échange radiatif (par exemple avec le ciel et le sol environnant);
 
<p>
Rm. L'entrée relative au flux solaire a vocation à être connectée au bloc météo générique ; elle contient les informations suivantes (dans l'ordre et pour mémoire) : 
<p>
- flux solaire diffus horizontal, 
<p>
- flux solaire direct normal, 
<p>
- latitude, 
<p>
- longitude, 
<p>
- TU à t0 (date du début de la simulation),
<p>
- quantième jour à t0
 </p>
EAB  avril 2010
 </HTML>
"),
Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-20,-20},{20,-100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,0},{-40,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,0},{80,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-80,90},{-40,50}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,124},{90,102}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),
                Placement(transformation(extent={{-74,16},{-54,36}})));
end Window;
