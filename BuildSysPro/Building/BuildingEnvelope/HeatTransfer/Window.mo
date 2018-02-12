within BuildSysPro.Building.BuildingEnvelope.HeatTransfer;
model Window "Generic window model"
  // Glazing options
parameter Boolean useVolet=false  annotation(Dialog(group="Options",compact=true),choices(choice=true
        "With shutter",                                                                                               choice=false
        "Without shutter",                                                                                                  radioButtons=true));
parameter Boolean useOuverture=false
 annotation(Dialog(group="Options",compact=true),choices(choice=true
        "With opening",                                                              choice=false
        "Without opening",                                                                                             radioButtons=true));
parameter Boolean useReduction=false
annotation(Dialog(group="Options",compact=true),choices(choice=true
        "With masking, frame",                                                             choice=false
        "Without masking, frame",                                                                                                  radioButtons=true));
parameter Boolean useEclairement=false
annotation(Dialog(group="Options",compact=true),choices(choice=true
        "With calculation of natural lighting",                                                             choice=false
        "Without calculation of natural lighting",                                                                                                  radioButtons=true));
  // General parameters
  parameter Modelica.SIunits.Area S=1 "Glazing surface"
                                                       annotation(Dialog(group="General parameters"));
  parameter Modelica.SIunits.Length H=1 "Height of the window" annotation(Dialog(group="General parameters"));
  parameter Modelica.SIunits.Length L=1 "Width of the window" annotation(Dialog(enable=useEclairement,group="General parameters"));

// Coefficient of transmission and exchanges such as Uglazing = 3
parameter Modelica.SIunits.CoefficientOfHeatTransfer k=6.06
    "Surface transmission coefficient k of the glazing - without convective exchanges; by default, k, hs_ext and hs_int lead to a Uvalue = 3 W/m2/K"
                                                                                                      annotation(Dialog(group="General parameters"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_ext=21
    "Global or convective surface exchange coefficient on the outer face depending on the selected mode (GLOext)" annotation(Dialog(group="General parameters"));
parameter Modelica.SIunits.CoefficientOfHeatTransfer hs_int=8.29
    "Surface exchange coefficient on the inner face" annotation(Dialog(group="General parameters"));
parameter Modelica.SIunits.ThermalInsulance R_volet=0.2
    "Additional thermal resistance (shutters closed)"                                                          annotation(Dialog(enable=useVolet,group="General parameters"));
parameter Modelica.SIunits.Conversions.NonSIunits.Angle_deg incl=90
    "Tilt of the surface relative to the horizontal - toward the ground=180°, toward the sky=0°, vertical=90°"
                                                                                                      annotation(Dialog(group="General parameters"));
parameter Integer choix=1
    "Formula to weight the thermal transmission of direct flux depending on the angle of incidence"   annotation(Dialog(group="Optical properties"),choices(
        choice=1 "Fauconnier",
        choice=2 "French building regulation (RT)",
        choice=3 "Cardonnel",
        choice=4 "Linear with cosi"));

// Optical parameters
parameter Real TrDir=0.747 "Direct transmission coefficient of the window" annotation(Dialog(group="Optical properties"));
parameter Real TrDif=0.665 "Diffuse transmission coefficient of the window" annotation(Dialog(group="Optical properties"));
parameter Real AbsDir=0.100 "Direct absorption coefficient of the window" annotation(Dialog(group="Optical properties"));
parameter Real AbsDif=0.108 "Diffuse absorption coefficient of the window" annotation(Dialog(group="Optical properties"));
parameter Real eps=0.9 "Glazing emissivity in LWR" annotation(Dialog(group="Optical properties"));

// Reduction factors of direct and diffuse fluxes (masking, frame, ...)
parameter Integer TypeFenetrePF=1 "Choice of type of window or French window"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"),
    choices( choice= 1 "I do not know - no frame",
             choice= 2 "Wood window sashes",
             choice= 3 "Metal window sashes",
             choice= 4 "French window sashes with wood bedrock",
             choice= 5 "French window sashes without wood bedrock",
             choice= 6 "French window sashes without metal bedrock",
             choice= 7 "Wood sliding window",
             choice= 8 "Metal sliding window",
             choice= 9 "Sliding French window with wood bedrock",
             choice= 10 "Sliding French window without wood bedrock",
             choice= 11 "Sliding French window without metal bedrock"));
parameter Real voilage=0.95
    "Presence of net curtains : = 0.95 if yes and = 1 if not"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"));
parameter Real position=0.90
    "Glazing position: = 0.9 if inner and = 1 if outer"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"));
parameter Real rideaux=0.85
    "Presence of curtains: = 0.85 if yes and = 1 if not"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"));
parameter Real ombrages=0.85
    "Obstacles shading (vegetation, neighborhood): = 0.85 if yes et = 1 if not"
    annotation (Dialog(tab="Type of glazing",enable=useReduction,group="Parameters"));
parameter Real r1=1
    "Reduction factor for direct radiation if useReduction = false"
    annotation (Dialog(tab="Type of glazing",enable=not useReduction,group="Reduction factor if useReduction = false"));
parameter Real r2=1
    "Reduction factor for diffuse radiation if useReduction = false"
    annotation (Dialog(tab="Type of glazing",enable=not useReduction,group="Reduction factor if useReduction = false"));

    // Consideration of radiative flux within the window
parameter Boolean RadInterne=false "Consideration of flux absorbed inside"
                                            annotation(Dialog(tab="Advanced parameters",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));
parameter Boolean DifDirOut=false
    "Output of direct and diffuse fluxes instead of the total flux" annotation(Dialog(tab="Advanced parameters",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));
parameter Boolean GLOext=false
    "Consideration of LW radiation toward the environment and the sky" annotation(Dialog(tab="Advanced parameters",compact=true),choices(choice=true "yes", choice=false "no", radioButtons=true));

protected
  parameter Real sigma[11]={1,0.7,0.7,0.63,0.74,0.74, 0.700,0.77,0.630,0.74,0.83}
    "Frame proportion for each type of glazing";
  parameter Real facteur=rideaux*sigma[TypeFenetrePF]*voilage*ombrages;
  parameter Real reduc_dir=if useReduction then facteur*position else 1;
  parameter Real reduc_dif=if useReduction then facteur else 1;
  parameter Real R_ouv_max= if TypeFenetrePF==7 or TypeFenetrePF==8 or TypeFenetrePF==9 or TypeFenetrePF==10 or TypeFenetrePF==11 then 0.4
 elseif
       TypeFenetrePF==2 or TypeFenetrePF==3 then 0.2 else 0.8;

  Real part_vitrage;
  Real part_vide;

  //Light transmission factors
  Real Tlii_sp=TransLum.CoeffTransLum[1]-TransLum.CoeffTransLum[2] if useEclairement
    "Light transmission factor of direct incident flux transmitted into a direct flux through the glazing without awning or blind";
  Real Tlii_ap_dir=Tld_ap_dif-Tlid_ap_dir if useEclairement
    "Light transmission factor of direct incident flux transmitted into a direct flux through the glazing with awning or blind";
  Real Tlid_sp=TransLum.CoeffTransLum[2] if useEclairement
    "Light transmission factor of direct incident flux transmitted into a diffuse flux through the glazing without awning or blind";
  Real Tld_ap_dif=TransLum.CoeffTransLum[3] if useEclairement
    "Global light transmission factor of diffuse incident flux through the glazing without awning or blind";
  Real Tld_sp=TransLum.CoeffTransLum[1] if useEclairement
    "Global light transmission factor through the glazing without awning or blind";
  Real Tlid_ap_ref=TransLum.CoeffTransLum[4] if useEclairement
    "Light transmission factor of incident flux reflected by the ground and transmitted into a diffuse flux through the glazing with awning or blind";
  Real Tlid_ap_dir=TransLum.CoeffTransLum[4] if useEclairement
    "Light transmission factor of direct incident flux transmitted into a diffuse flux through the glazing with awning or blind";
  Real Tlii_ap_ref=Tld_ap_dif-Tlid_ap_ref if useEclairement
    "Light transmission factor of incident flux reflected by the ground and transmitted into a direct flux through the glazing with awning or blind";

// Connectors
public
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExt[3]
    "Incident solar surface flux information 1-Diffuse flux [W/m2], 2-Direct flux [W/m2], 3-Cosi"
    annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
        iconTransformation(extent={{-40,40},{-20,60}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr if not
    DifDirOut "SW radiation transmitted inside [W]"
    annotation (Placement(transformation(extent={{60,50},{100,90}}),
        iconTransformation(extent={{80,40},{100,60}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxOutput CLOTr2[3] if
    DifDirOut "SW radiation transmitted inside 1-Diffuse [W], 2-Direct [W], 3-cosi"
    annotation (Placement(transformation(extent={{60,20},{100,60}}),
        iconTransformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Interfaces.RealInput                            FluxAbsInt if
    RadInterne "Flux (LWR/SWR) absorbed by the glazing on its inner face [W]"
    annotation (Placement(transformation(extent={{120,-10},{82,28}}),
        iconTransformation(extent={{40,10},{20,30}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Outdoor temperature" annotation (Placement(transformation(
          extent={{-100,-40},{-80,-20}}), iconTransformation(extent={{-100,
            -40},{-80,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Ts_ext
    "Outer surface temperature" annotation (Placement(
        transformation(extent={{-40,-40},{-20,-20}}),
        iconTransformation(extent={{-40,-40},{-20,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Ts_int
    "Inner surface temperature" annotation (Placement(
        transformation(extent={{20,-40},{40,-20}}), iconTransformation(
          extent={{20,-40},{40,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int
    "Indoor temperature" annotation (Placement(transformation(
          extent={{80,-40},{100,-20}}), iconTransformation(extent={{80,
            -40},{100,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky if  GLOext
    "Sky temperature" annotation (Placement(transformation(extent={{-100,-100},
            {-80,-80}}), iconTransformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Interfaces.RealInput fermeture_volet if      useVolet
    "Shutters closing rate (0 opened, 1 closed)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={2,116}), iconTransformation(extent={{-100,60},{-80,80}},
          rotation=0)));
  Modelica.Blocks.Interfaces.BooleanInput ouverture_fenetre if useOuverture
    "Opening of the window (true=opened false=closed)"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-26,116}), iconTransformation(extent={{-40,-10},{-20,10}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput V if    useOuverture
    "Wind speed perpendicular to the glazing (m/s)" annotation (Placement(
        transformation(extent={{-120,60},{-80,100}}), iconTransformation(extent={{-100,
            -10},{-80,10}})));

// Components

  BuildSysPro.BaseClasses.HeatTransfer.Components.ControlledThermalConductor
    conduction
    annotation (Placement(transformation(extent={{-12,-70},{8,-50}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=true) if useOuverture
    annotation (Placement(transformation(extent={{32,-98},{52,-78}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ExtLWR EchangesGLOext(
    S=S,
    eps=eps,
    incl=incl,
    GLO_env=GLOext,
    GLO_ciel=GLOext) if GLOext
                             annotation (Placement(transformation(
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
    prescribedCLOAbsInt if RadInterne
                                    annotation (Placement(
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
    "Tranmitted luminous fluxes -direct -diffuse -reflected (lumen)"
    annotation (Placement(transformation(extent={{100,-92},{146,-46}}),
        iconTransformation(extent={{80,90},{100,110}})));
  Modelica.Blocks.Interfaces.RealInput Ecl[3] if useEclairement
    "Incident illumination -direct -diffuse -reflected (lumen)"
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
    "Thickness of the vertical wall in which the glazing is integrated"                     annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real azimut=0
    "Azimuth (orientation compared to the south) - S=0°, E=-90°, W=90°, N=180°"           annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real TLw=0.5
    "Global light transmission factor of the window without protection" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real TLw_dif=0
    "Diffuse light transmission factor of the window  without protection" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real TLws=0
    "Global light transmission factor of the window  with protection" annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Real TLws_dif=0
    "Diffuse light transmission factor of the window  with protection" annotation(enable=useEclairement,Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Boolean MasqueProche=false
    "True if mask model used upstream, false if not"                                    annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
  parameter Boolean Protection=false
    "True if external mobile protection in place, false if not"                                  annotation(Dialog(enable=useEclairement,group="Illumination parameters"));
public
  Modelica.Blocks.Interfaces.RealOutput Etp if useEclairement
    "Total incident illumination on the glazing (lumen)"
    annotation (Placement(transformation(extent={{-23,-23},{23,23}},
        rotation=270,
        origin={13,-129}),
        iconTransformation(extent={{-13,-13},{13,13}},
        rotation=270,
        origin={1,-117})));
  Modelica.Blocks.Sources.RealExpression CalculETP(y=Ecl[1] + Ecl[2] + Ecl[3]) if useEclairement
    "Calculation of total incident illumination on the glazing"
    annotation (Placement(transformation(extent={{-12,-110},{8,-90}})));
  Modelica.Blocks.Sources.RealExpression CalculFlum[3](y={
        if useVolet then S*(volet_internal*Tlii_ap_dir+(1-volet_internal)*Tlii_sp)*Ecl[1]
        else S*Tlii_sp*Ecl[1],
        if useVolet then S*((volet_internal*Tlid_ap_dir+(1-volet_internal)*Tlid_sp)*Ecl[1]+(volet_internal*Tld_ap_dif+(1-volet_internal)*Tld_sp)*Ecl[2]+(volet_internal*Tlid_ap_ref+(1-volet_internal)*Tlid_sp)*Ecl[3])
        else S*(Tlid_sp*Ecl[1]+Tld_sp*Ecl[2]+Tlid_sp*Ecl[3]),
        if useVolet then S*(volet_internal*Tlii_ap_ref+(1-volet_internal)*Tlii_sp)*Ecl[3]
        else S*Tlii_sp*Ecl[3]}) if useEclairement
    "Calculation of transmitted illumination flux -direct -diffuse -reflected"
    annotation (Placement(transformation(extent={{66,-110},{86,-90}})));
  BoundaryConditions.Solar.Irradiation.DirectAbs absDirect(choix=choix, AbsDir=
        AbsDir)
    annotation (Placement(transformation(extent={{-46,32},{-30,48}})));
equation
  //Calculation of thermal conductance of the full window (glazing + shutters) excluding convection
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
// SWR exchanges
  connect(prescribedCLOAbsExt.Q_flow, AbsFenExt.y)  annotation (Line(
      points={{-68,5},{-59.4,5},{-59.4,4},{-59,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Transmission.y, CLOTr)       annotation (Line(
      points={{69,72},{74,72},{74,70},{80,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.Q_flow, FluxAbsInt)
                                              annotation (Line(
      points={{58,10},{65.6,10},{65.6,9},{101,9}},
      color={0,0,127},
      smooth=Smooth.None));

  //Impact of occultations on transmitted and absorbed fluxes
  //The flux is transmitted only through the window (blackout shutter)
  if S>0 then
  part_vitrage=(if useOuverture then (if ouverture_internal then (if useReduction then (1-R_ouv_max) else 0) else 1) else 1)*S;
  part_vide=S-part_vitrage;
  FluxDirectTr.u=reduc_dir*(1 - volet_internal)*(transDirect.FluxTrDir*
      part_vitrage + FluxIncExt[2]*part_vide)/S;
  FluxDiffusTr.u=reduc_dif*(1 - volet_internal)*FluxIncExt[1]*(TrDif*
      part_vitrage + part_vide)/S;
  AbsFenExt.u1=reduc_dir*(1 - volet_internal)*(absDirect.FluxAbsDir*
      part_vitrage + FluxIncExt[2]*part_vide)/S;
  AbsFenExt.u2=reduc_dif*(1 - volet_internal)*FluxIncExt[1]*(AbsDif*
      part_vitrage + part_vide)/S;
  else
  part_vitrage=0;
  part_vide=0;
  FluxDirectTr.u=0;
  FluxDiffusTr.u=0;
  AbsFenExt.u1=0;
  AbsFenExt.u2=0;
  end if;

  connect(prescribedCLOAbsExt.port, Ts_ext) annotation (Line(
      points={{-82,5},{-92,5},{-92,-12},{-30,-12},{-30,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedCLOAbsInt.port, Ts_int)   annotation (Line(
      points={{42,10},{30,10},{30,-30}},
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
  connect(FluxIncExt[3], CLOTr2[3]) annotation (Line(
      points={{-100,53.3333},{-56,53.3333},{-56,54},{-10,54},{-10,53.3333},{80,
          53.3333}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExt, transDirect.FluxIncExt) annotation (Line(
      points={{-100,40},{-70,40},{-70,78.32},{-46.8,78.32}},
      color={255,192,1},
      smooth=Smooth.None));

  // LWR exchanges
  connect(EchangesGLOext.T_ext, T_ext) annotation (Line(
      points={{-69,-84},{-76,-84},{-76,-30},{-90,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EchangesGLOext.T_sky, T_sky) annotation (Line(
      points={{-69,-92},{-79.5,-92},{-79.5,-90},{-90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EchangesGLOext.Ts_ext, Ts_ext) annotation (Line(
      points={{-51,-88},{-30,-88},{-30,-30}},
      color={255,0,0},
      smooth=Smooth.None));

  // Opening of the window

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
//Shutter
  connect(volet_internal, fermeture_volet) annotation (Line(
      points={{-150,80},{2,80},{2,116}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  if not useVolet then
    volet_internal=0;
  end if;

// Others

  connect(CalculETP.y, Etp) annotation (Line(
      points={{9,-100},{13,-100},{13,-129}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(CalculFlum.y, Flum) annotation (Line(
      points={{87,-100},{96,-100},{96,-69},{123,-69}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FluxIncExt, absDirect.FluxIncExt) annotation (Line(points={{-100,40},
          {-46.8,40},{-46.8,40.32}}, color={255,192,1}));
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
<p><u><b>Hypothesis and equations</b></u></p>
<ul>
<li>SW (short wavelength) radiations for solar irradiance on the outer face are separated into diffuse and direct. They are obtained by separate calculations after consideration of the glazing tilt and azimuth.</li>
<li>LW (long wavelength) radiations with the external environment can be taken into account by connecting this model to a sky temperature and by specifying surface tilt.</li>
<li>The direct transmitted irradiance is calculated based on the angle of incidence according to the Fauconnier formula (French building regulation RT and Cardonnel formulas available)</li>
</ul>
<p>Regarding the rolling shutters, the assumptions are :</p>
<ul>
<li>No solar flux transmitted by the part obscured by the shutters</li>
<li>Absorbed flux unchanged (PVC absorbency similar to that of glass)</li>
<li>If the shutter is not completely closed (<code>fermeture_volet</code> &lt; 95&#37;), unchanged thermal resistance</li>
<li>If the shutter is fully closed, increased thermal resistance of an additional thermal resistance, evaluated at 0.2 m&sup2;K / W (PVC thickness of 12 mm approx)</li>
</ul>
<p>When the window is open, the conductive heat transfer through the glass is not considered anymore, and instead of that an air renewal by natural ventilation is computed (refer to <a href=\"modelica://BuildSysPro.Building.AirFlow.HeatTransfer.WindowNaturalVentilation\"><code>WindowNaturalVentilation</code></a>). In addition, the absence of glazing results in a suppression of direct and diffuse transmission factors.</p>
<p>Reduction coefficients of direct and diffuse fluxes may also be considered (<code>useReduction=True</code>), based on :</p>
<ul>
<li>type of windows/ window doors (the &#37; of frame is deduced from that)</li>
<li>coefficient representing the decrease in fluxes through net curtains</li>
<li>coefficient representing the decrease in fluxes due to window position (inner or outer)</li>
<li>coefficient representing the decrease in fluxes through curtains</li>
<li>coefficient representing the decrease in fluxes due to shadows (NB: there is also a model that can calculate precisely the surface fluxes on a vertical wall in case of eaves: <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar.SolarMasks.FLUXsurfMask\"><code>FLUXsurfMask</code></a>)</li>
</ul>
<p>Concerning the calculation of natural lighting, the global and diffuse light transmission factors that must be filled correspond to <code>TLW</code>, <code>TLw_dif</code>, <code>TLsw</code> and <code>TLsw_dif</code> which are calculated precisely in the EN 410 norm. However, it is possible to find tabulated values in the document <i>Valeurs tabulées des caractéristiques des parois vitrées et des correctifs associés aux baies (Tabulated values of glass walls features and patches associated with windows</i>) from CSTB. Thus, by default :</p>
<ul>
<li>For double glazing without sunscreen: <code>TLW</code> = 0.5, <code>TLW dif</code> = 0</li>
<li>For double glazing with opaque and dark sunscreen on the outside: <code>TLsw</code> = 0, <code>TLsw_dif</code> = 0</li>
<li>For double glazing with non-opaque and clear sunscreen on the outside: <code>TLsw</code> = 0.09, <code>TLsw_dif</code> = 0.03</li>
</ul>
<p><u><b>Bibliography</b></u></p>
<p>TF1 CLIM2000</p>
<p>CSTB. 2005. Guide réglementaire RT 2005. Règle d'application Th-Bât Th-U 3/5 Parois vitrées.</p>
<p>Natural lighting : Règles Th-L - Caractérisation du facteur de transmission lumineuse des parois du bâtiment - CSTB Mars 2012, Valeurs tabulées des parois vitrées - CSTB Mars 2012</p>
<p><u><b>Instructions for use</b></u></p>
<p>The thermal ports <code>T_ext</code> and <code>T_int</code> must be connected to temperature nodes (connect <code>T_ext</code> to <code>T_dry</code> of <a href=\"modelica://BuildSysPro.BoundaryConditions.Weather.Meteofile\"><code>Meteofile</code></a>).</p>
<p>The external incident flows <code>FLUX</code> can come from <a href=\"modelica://BuildSysPro.BoundaryConditions.Solar\"><code>BoundaryConditions.Solar</code></a> models which are the link between walls and weather readers.</p>
<p>The internal incident flows <code>FluxAbsInt</code> can come from occupants, heating systems but also from the redistribution of solar flux within a room (models from <a href=\"modelica://BuildSysPro.BoundaryConditions.Radiation\"><code>BoundaryConditions.Radiation</code></a> package).</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>The following precautions should be considered:</p>
<ul>
<li>The coefficient <code>k</code> represents the conductivity of the glazing without consideration of convective exchanges (different from Uglazing usually used).</li>
<li>The coefficient <code>hs_ext</code> of convective transfer with outside default value is the value of the combined coefficient integrating LW convective and radiative exchanges.</li>
<li>If LWR with the environment are considered, the <code>hs_ext</code> value must be changed - <i>By default 16W / m&sup2;.K can be taken since the radiative share is estimated to 5,13W / m&sup2;.K outside, which corresponds to an environment temperature of 10 °C</i></li>
</ul>
<p>For the calculation of illuminance, it is needed to clarify whether there are upstream masks because then the consideration of shadows caused by the architecture is done in the mask model.</p>
<p><u><b>Validations</b></u></p>
<p>BESTEST validation procedure</p>
<p>Validated model - Aurélie Kaemmerlen 12/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2018<br>
BuildSysPro version 3.1.0<br>
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
