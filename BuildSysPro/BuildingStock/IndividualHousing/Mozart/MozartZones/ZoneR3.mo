within BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones;
model ZoneR3

  // Choice of RT (French building regulation)
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    paraMaisonRT "French building regulation to use" annotation (
      choicesAllMatching=true, Dialog(group="Choice of RT"));

  // Thermal flows
parameter Boolean GLOEXT=false
    "Integration of LW radiation (infrared) toward the environment and the sky"                         annotation(Dialog(tab="Thermal flows"));
parameter Boolean CLOintPlancher=true
    "True : solar fluxes are absorbed by the floor; False : solar fluxes are absorbed by all the walls and partition walls in proportion of surfaces"
                                                                                                        annotation(Dialog(tab="Thermal flows"));
parameter Boolean QVin=false
    "True : controlled air change rate; False : constant air change rate"                       annotation(Dialog(tab="Thermal flows"));

  // Walls
  parameter Modelica.Units.SI.Temperature Tp=293.15
    "Initial temperature of walls" annotation (Dialog(tab="Walls"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type of initialization for walls"
    annotation (Dialog(tab="Walls"));

  // Windows
parameter Boolean useVoletPF=false "True if shutter, false if not" annotation(Dialog(tab="Windows"));
parameter Boolean useOuverturePF=false
    "True if controlled opening, false if not" annotation(Dialog(tab="Windows"));
parameter Boolean useReduction1=false
    "True if solar reduction factors (masking, frame), false if not"
    annotation (Dialog(tab="Windows"));
parameter Integer TypeFenetrePF1=1 "Choice of type of window or French window"
    annotation (Dialog(tab="Windows",enable=useReduction1,group="Parameters"),
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
parameter Real voilage1=0.95
    "Presence of net curtains : = 0.95 if yes and = 1 if not"
    annotation (Dialog(tab="Windows",enable=useReduction1,group="Parameters"));
parameter Real position1=0.90
    "Glazing position: = 0.9 if inner and = 1 if outer"
    annotation (Dialog(tab="Windows",enable=useReduction1,group="Parameters"));
parameter Real rideaux1=0.85
    "Presence of curtains: = 0.85 if yes and = 1 if not"
    annotation (Dialog(tab="Windows",enable=useReduction1,group="Parameters"));
parameter Real ombrages1=0.85
    "Obstacles shading (vegetation, neighborhood): = 0.85 if yes et = 1 if not"
    annotation (Dialog(tab="Windows",enable=useReduction1,group="Parameters"));
parameter Real r11=paraMaisonRT.transmissionMenuiseriePortesFenetres
    "Reduction factor for direct radiation if useReduction = false"
    annotation (Dialog(tab="Windows",enable=not useReduction1,group="Reduction factor if useReduction = false"));
parameter Real r21=paraMaisonRT.transmissionMenuiseriePortesFenetres
    "Reduction factor for diffuse radiation if useReduction = false"
    annotation (Dialog(tab="Windows",enable=not useReduction1,group="Reduction factor if useReduction = false"));

  // Thermal bridges
  parameter Modelica.Units.SI.ThermalConductance G_ponts=
      Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsC3,
      TauPonts=paraMaisonRT.TauPonts) "Thermal bridges"
    annotation (Dialog(tab="Thermal bridges"));

    // Weighting coefficients
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(b=
        paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlafond(b=
        paraMaisonRT.bSousCombles)
    annotation (Placement(transformation(extent={{-58,80},{-38,100}})));

// Horizontal walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall ParoiSousCombles(
    ParoiInterne=true,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsIntHorHaut,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=paraMaisonRT.ParoiSousCombles.n,
      m=paraMaisonRT.ParoiSousCombles.m,
      e=paraMaisonRT.ParoiSousCombles.e,
      mat=paraMaisonRT.ParoiSousCombles.mat,
      positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC3)
    annotation (Placement(transformation(extent={{-7,82},{7,96}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    ParoiInterne=true,
    Tp=Tp,
    RadInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=paraMaisonRT.PlancherBas.n,
      m=paraMaisonRT.PlancherBas.m,
      e=paraMaisonRT.PlancherBas.e,
      mat=paraMaisonRT.PlancherBas.mat,
      positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC3)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

// Exterior vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEst(
    RadExterne=false,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.Mur.n,
      m=paraMaisonRT.Mur.m,
      e=paraMaisonRT.Mur.e,
      mat=paraMaisonRT.Mur.mat,
      positionIsolant=paraMaisonRT.Mur.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurEstC3)
    annotation (Placement(transformation(extent={{-7,42},{7,56}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.Mur.n,
      m=paraMaisonRT.Mur.m,
      e=paraMaisonRT.Mur.e,
      mat=paraMaisonRT.Mur.mat,
      positionIsolant=paraMaisonRT.Mur.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSudC3)
    annotation (Placement(transformation(extent={{-7,-18},{7,-4}})));

// Internal vertical walls

// Glazings
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageEst(
    RadInterne=not CLOintPlancher,
    GLOext=GLOEXT,
    useVolet=useVoletPF,
    useOuverture=useOuverturePF,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert),
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    eps=paraMaisonRT.eps_vitrage,
    useReduction=useReduction1,
    TypeFenetrePF=TypeFenetrePF1,
    voilage=voilage1,
    position=position1,
    rideaux=rideaux1,
    ombrages=ombrages1,
    r1=r11,
    r2=r21,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageEstC3,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageEstC3)
    annotation (Placement(transformation(extent={{-37,42},{-23,56}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageSudAF(
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    useVolet=useVoletPF,
    useOuverture=useOuverturePF,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert),
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    eps=paraMaisonRT.eps_vitrage,
    useReduction=useReduction1,
    TypeFenetrePF=TypeFenetrePF1,
    voilage=voilage1,
    position=position1,
    rideaux=rideaux1,
    ombrages=ombrages1,
    r1=r11,
    r2=r21,
    DifDirOut=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudC3,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageSudC3)
    annotation (Placement(transformation(extent={{-36,-38},{-22,-24}})));

// Thermal bridges
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

// Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{60,-100},{80,-80}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    np=7,
    nf=2,
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC3,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeC3,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSudC3,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurEstC3,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegC3SDB,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC3,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PorteIntEntreeC3},
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudC3,
    BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageEstC3}) if not
    CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

// Base components
protected
  Modelica.Blocks.Math.MultiSum multiSum(nu=2)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));
public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC3
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart, Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{20,-100},{40,-80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_room3
    annotation (Placement(transformation(extent={{80,-29},{100,-9}}),
        iconTransformation(extent={{-23,28},{-3,48}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC3
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart) annotation (
     Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir         if QVin==true
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{-7,7},{7,-7}},
        rotation=180,
        origin={71,-13})));

  Modelica.Blocks.Interfaces.RealInput VENTSud
                                            if useOuverturePF annotation (
      Placement(transformation(extent={{-112,-22},{-88,2}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-18,-90})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[2] if useOuverturePF
    "Opening of south and east windows"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-12,-46})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[2] if useVoletPF
    "Closing of south and east shutters"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={2,-46})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtSouth[3]
    annotation (Placement(transformation(extent={{-106,76},{-82,100}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={-60,-88})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxIncExtEast[3]
    annotation (Placement(transformation(extent={{-106,56},{-82,80}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=90,
        origin={-40,-88})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonEntree if not CLOintPlancher
    annotation (Placement(transformation(extent={{84,58},{104,78}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,90})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonSDB if not CLOintPlancher
    annotation (Placement(transformation(extent={{84,40},{104,60}}),
        iconTransformation(extent={{-80,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput VENTEst
                                            if useOuverturePF annotation (
      Placement(transformation(extent={{-112,-38},{-88,-14}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput FLUXporteEntree   if not CLOintPlancher
    annotation (Placement(transformation(extent={{84,80},{104,100}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-52,90})));
equation
  if CLOintPlancher==false then
    connect(multiSum.y, PintdistriRad.RayEntrant) annotation (Line(
      points={{-14,-73.02},{-14,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[1], VitrageSudAF.FluxAbsInt) annotation (
      Line(
      points={{19,-80.5},{24,-80.5},{24,-29.6},{-26.9,-29.6}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[2], VitrageEst.FluxAbsInt) annotation (
      Line(
      points={{19,-79.5},{24,-79.5},{24,50},{-2,50},{-2,50.4},{-27.9,50.4}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[1], ParoiSousCombles.FluxAbsInt) annotation (
     Line(
      points={{19,-84.8571},{24,-84.8571},{24,92.5},{2.1,92.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[2], FLUXcloisonEntree) annotation (Line(
      points={{19,-84.5714},{24,-84.5714},{24,68},{94,68}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[3], MurSud.FluxAbsInt) annotation (Line(
      points={{19,-84.2857},{24,-84.2857},{24,-7.5},{2.1,-7.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[4], MurEst.FluxAbsInt) annotation (Line(
      points={{19,-84},{24,-84},{24,52.5},{2.1,52.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[5], FLUXcloisonSDB) annotation (Line(
      points={{19,-83.7143},{24,-83.7143},{24,50},{94,50}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[6], PlancherBas.FluxAbsInt) annotation (Line(
      points={{19,-83.4286},{47.5,-83.4286},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[7], FLUXporteEntree) annotation (Line(
      points={{19,-83.1429},{24,-83.1429},{24,90},{94,90}},
      color={0,0,127}));
else
    connect(multiSum.y, PlancherBas.FluxAbsInt) annotation (Line(
      points={{-14,-73.02},{48,-73.02},{48,-89.9},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if GLOEXT==true then
    connect(T_sky, VitrageEst.T_sky) annotation (Line(
        points={{-90,10},{-64,10},{-64,42.7},{-36.3,42.7}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(T_sky, VitrageSudAF.T_sky) annotation (Line(
        points={{-90,10},{-64,10},{-64,-37.3},{-35.3,-37.3}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(T_sky, MurEst.T_sky) annotation (Line(
        points={{-90,10},{-64,10},{-64,42.7},{-6.3,42.7}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(T_sky, MurSud.T_sky) annotation (Line(
        points={{-90,10},{-64,10},{-64,-17.3},{-6.3,-17.3}},
        color={191,0,0},
        smooth=Smooth.None));
  end if;

  if QVin==true then
    connect(RenouvAir, renouvellementAir.Qv_in) annotation (Line(
      points={{100,-78},{92,-78},{92,-49},{80.68,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useVoletPF then
    connect(fermetureVolets[2], VitrageEst.fermeture_volet)
      annotation (Line(
      points={{-100,-70},{-76,-70},{-76,53.9},{-36.3,53.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
    connect(fermetureVolets[1], VitrageSudAF.fermeture_volet)
      annotation (
      Line(
      points={{-100,-90},{-76,-90},{-76,-26.1},{-35.3,-26.1}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  end if;

  if useOuverturePF then
    connect(ouvertureFenetres[2], VitrageEst.ouverture_fenetre)
      annotation (Line(
        points={{-100,-38},{-74,-38},{-74,49},{-32.1,49}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(ouvertureFenetres[1], VitrageSudAF.ouverture_fenetre)
      annotation (
      Line(
        points={{-100,-58},{-74,-58},{-74,-31},{-31.1,-31}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;

  connect(T_ext, MurEst.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,46.9},{-6.3,46.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, MurSud.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-13.1},{-6.3,-13.1}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlafond.Tponder, ParoiSousCombles.T_ext) annotation (Line(
      points={{-44,90},{-6.3,90},{-6.3,86.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlancher.Tponder, PlancherBas.T_ext) annotation (Line(
      points={{-44,-90},{34,-90},{34,-98.3},{53.1,-98.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(ParoiSousCombles.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,86.9},{40,86.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurEst.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,46.9},{40,46.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,-13.1},{40,-13.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_ext, VitrageEst.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,46.9},{-36.3,46.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, VitrageSudAF.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-33.1},{-35.3,-33.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-86},{-56,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, TauPlafond.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,80},{-64,80},{-64,94},{-56,94}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageEst.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-23.7,52.5},{-11.9,52.5},{-11.9,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageSudAF.CLOTr, multiSum.u[2]) annotation (Line(
      points={{-22.7,-27.5},{-16.1,-27.5},{-16.1,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_ext, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(noeudAir.port_a, T_int_room3) annotation (Line(
      points={{80,22},{80,-19},{90,-19}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, PontsThermiques.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-72.5},{-57.25,-72.5}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{71,-39.1},{71,-30},{40,-30},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TauPlancher.port_int, noeudAir.port_a) annotation (Line(
      points={{-56,-94},{-60,-94},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},{
          80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauPlafond.port_int, noeudAir.port_a) annotation (Line(
      points={{-56,86},{-60,86},{-60,82},{40,82},{40,40},{80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{-43.75,-72.5},{-36,-72.5},{-36,-98},{30,-98},{30,-60},{40,-60},{40,
          40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(VitrageSudAF.T_int, noeudAir.port_a) annotation (Line(
      points={{-22.7,-33.1},{40,-33.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(VitrageEst.T_int, noeudAir.port_a) annotation (Line(
      points={{-23.7,46.9},{40,46.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(FluxIncExtSouth, MurSud.FluxIncExt) annotation (Line(
      points={{-94,88},{-84,88},{-84,90},{-66,90},{-66,-4.7},{-2.1,-4.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtSouth, VitrageSudAF.FluxIncExt) annotation (Line(
      points={{-94,88},{-80,88},{-80,90},{-66,90},{-66,-27.5},{-31.1,-27.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtEast, VitrageEst.FluxIncExt) annotation (Line(
      points={{-94,68},{-66,68},{-66,52.5},{-32.1,52.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxIncExtEast, MurEst.FluxIncExt) annotation (Line(
      points={{-94,68},{-66,68},{-66,55.3},{-2.1,55.3}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(VENTSud, VitrageSudAF.V) annotation (Line(
      points={{-100,-10},{-70,-10},{-70,-31},{-35.3,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(VENTEst, VitrageEst.V) annotation (Line(
      points={{-100,-26},{-70,-26},{-70,49},{-36.3,49}},
      color={0,0,127},
      smooth=Smooth.None));

annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Bitmap(extent={{67,67},{-67,-67}}, fileName="modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Mozart/Chambre3.png",
          origin={-1,9},
          rotation=180),
        Ellipse(extent={{18,8},{46,-20}},   lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={32,24},
          rotation=360),
        Ellipse(
          extent={{30,-4},{34,-8}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-6,-62},
          rotation=180),
        Line(
          points={{16,4},{32,12},{46,4}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{46,6},{48,2},{44,4},{46,6}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={2,-6},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={32,-36},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={62,-6},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={17,-16},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Documentation(info="<html>
<p><i><b>Zone room 3 Mozart</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Parameter <code>paraMaisonRT</code> allows the user to chose a specific French building regulation for the building, so that building envelope parameters (walls, windows, ventilation...) will be automatically filled with data from the choosen record.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Stéphanie Froidurot - 10/2020 : Add flux for internal doors</p>
</html>"));
end ZoneR3;
