within BuildSysPro.BuildingStock.CollectiveHousing.Matisse;
model MatisseMonozone
  import BuildSysPro;

  // Choice of RT (French building regulation)
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    paraMaisonRT "French building regulation to use" annotation (
      choicesAllMatching=true, Dialog(group="Choice of RT"));

  // Orientation of the apartment
  parameter Real beta=0
    "Correction of azimuth for vertical walls such as azimuth=beta+azimuth, {beta=0 : N=180,S=0,E=-90,O=90}";
  parameter Integer EmplacementAppartement=5
    "From 1 to 9, define the position of the apartment : 1 to 3 last floor - 4 à 6 intermediate floor - 7 à 9 : ground floor (from west to east)";

  // Thermal flows
  parameter Boolean GLOEXT=false
    "Integration of LW radiation (infrared) toward the environment and the sky"
    annotation(Dialog(tab="Thermal flows"),
    choices(choice=true "Yes", choice=false "No", radioButtons=true));
  parameter Boolean CLOintPlancher=true
    "Floor : solar fluxes are absorbed only by the floor; All walls : solar fluxes are absorbed by all the walls and partition walls in proportion of surfaces"
    annotation(Dialog(tab="Thermal flows"),
    choices(choice=true "Floor", choice=false "All walls", radioButtons=true));
  parameter Boolean QVin=false
    "Input : controlled air change rate; Constant : constant air change rate"
    annotation(Dialog(tab="Thermal flows"),
    choices(choice=true "Input", choice=false "Constant", radioButtons=true));

  // Walls
  parameter Modelica.Units.SI.Temperature Tp=293.15
    "Initial temperature of walls" annotation (Dialog(tab="Walls"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type of initialization for walls"
    annotation (Dialog(tab="Walls"));

  // Windows
  parameter Boolean useVolet=false "Use of window shutters"
    annotation(Dialog(tab="Windows"),
    choices(choice=true "Yes", choice=false "No", radioButtons=true));
  parameter Boolean useOuverture=false "Control of windows opening"
    annotation(Dialog(tab="Windows"),
    choices(choice=true "Yes", choice=false "No", radioButtons=true));
  parameter Boolean useReduction=false
    "Implementation of solar reduction factors (masking, frame)"
    annotation (Dialog(tab="Windows"),
    choices(choice=true "Yes", choice=false "No", radioButtons=true));
  parameter Integer TypeFenetrePF=1 "Choice of type of window"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"),
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
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"));
  parameter Real position=0.90
    "Glazing position: = 0.9 if inner and = 1 if outer"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"));
  parameter Real rideaux=0.85
    "Presence of curtains: = 0.85 if yes and = 1 if not"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"));
  parameter Real ombrages=0.85
    "Obstacles shading (vegetation, neighborhood): = 0.85 if yes et = 1 if not"
    annotation (Dialog(tab="Windows",enable=useReduction,group="Parameters"));
  parameter Real r1=paraMaisonRT.transmissionMenuiserieFenetres
    "Reduction factor for direct radiation if useReduction = false"
    annotation (Dialog(tab="Windows",group="Reduction factor if useReduction = false",
    enable=not useReduction));
  parameter Real r2=paraMaisonRT.transmissionMenuiserieFenetres
    "Reduction factor for diffuse radiation if useReduction = false"
    annotation (Dialog(tab="Windows",group="Reduction factor if useReduction = false",
    enable=not useReduction));

  // Thermal bridges
  parameter Modelica.Units.SI.ThermalConductance G_ponts=
      BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPonts,
      TauPonts=paraMaisonRT.TauPonts) annotation (Dialog(tab="Thermal bridges"));

 // Protected parameters
protected
  parameter Boolean EmplacementEst= if EmplacementAppartement==3 or EmplacementAppartement==6 or EmplacementAppartement==9 then true else false;
  parameter Boolean EmplacementOuest= if EmplacementAppartement==1 or EmplacementAppartement==4 or EmplacementAppartement==7 then true else false;
  parameter Boolean EmplacementHaut= if EmplacementAppartement<=3 then true else false;
  parameter Boolean EmplacementBas= if EmplacementAppartement>=7 then true else false;

// Weighting coefficients
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(
      b=paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauLNC(b=
        paraMaisonRT.bLNC)
    annotation (Placement(transformation(extent={{-58,-60},{-38,-40}})));

// Horizontal walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Plafond(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlafondHaut,
    ParoiInterne=true,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsIntHorHaut,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=paraMaisonRT.PlafondMitoyen.n,
      m=paraMaisonRT.PlafondMitoyen.m,
      e=paraMaisonRT.PlafondMitoyen.e,
      mat=paraMaisonRT.PlafondMitoyen.mat,
      positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant)) if not EmplacementHaut
    annotation (Placement(transformation(extent={{-7,87},{7,101}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlafondImmeuble(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlafondHaut,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=paraMaisonRT.PlafondImmeuble.n,
      m=paraMaisonRT.PlafondImmeuble.m,
      e=paraMaisonRT.PlafondImmeuble.e,
      mat=paraMaisonRT.PlafondImmeuble.mat,
      positionIsolant=paraMaisonRT.PlafondImmeuble.positionIsolant),
    GLOext=GLOEXT,
    ParoiInterne=false,
    hs_ext=paraMaisonRT.hsExtHor,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps)     if EmplacementHaut
    annotation (Placement(transformation(extent={{-7,70},{7,84}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherBas,
    ParoiInterne=true,
    Tp=Tp,
    RadInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=paraMaisonRT.PlancherMitoyen.n,
      m=paraMaisonRT.PlancherMitoyen.m,
      e=paraMaisonRT.PlancherMitoyen.e,
      mat=paraMaisonRT.PlancherMitoyen.mat,
      positionIsolant=paraMaisonRT.PlancherMitoyen.positionIsolant),
    InitType=InitType) if not EmplacementBas annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBasImmeuble(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherBas,
    ParoiInterne=true,
    Tp=Tp,
    RadInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=paraMaisonRT.PlancherImmeuble.n,
      m=paraMaisonRT.PlancherImmeuble.m,
      e=paraMaisonRT.PlancherImmeuble.e,
      mat=paraMaisonRT.PlancherImmeuble.mat,
      positionIsolant=paraMaisonRT.PlancherImmeuble.positionIsolant),
    InitType=InitType) if EmplacementBas annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={71,-92})));

// Exterior vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Porte(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PorteEntree,
    Tp=Tp,
    InitType=InitType,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.Porte.n,
      m=paraMaisonRT.Porte.m,
      e=paraMaisonRT.Porte.e,
      mat=paraMaisonRT.Porte.mat,
      positionIsolant=paraMaisonRT.Porte.positionIsolant),
    ParoiInterne=true,
    GLOext=false,
    hs_ext=paraMaisonRT.hsIntVert)
    annotation (Placement(transformation(extent={{-7,-57},{7,-42}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEstExt(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurEst,
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
      n=paraMaisonRT.MurExt.n,
      m=paraMaisonRT.MurExt.m,
      e=paraMaisonRT.MurExt.e,
      mat=paraMaisonRT.MurExt.mat,
      positionIsolant=paraMaisonRT.MurExt.positionIsolant)) if EmplacementEst
    annotation (Placement(transformation(extent={{-7,34},{7,48}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurNord(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurNord,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurExt.n,
      m=paraMaisonRT.MurExt.m,
      e=paraMaisonRT.MurExt.e,
      mat=paraMaisonRT.MurExt.mat,
      positionIsolant=paraMaisonRT.MurExt.positionIsolant))
    annotation (Placement(transformation(extent={{-7,16},{7,30}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuestExt(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurOuest,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurExt.n,
      m=paraMaisonRT.MurExt.m,
      e=paraMaisonRT.MurExt.e,
      mat=paraMaisonRT.MurExt.mat,
      positionIsolant=paraMaisonRT.MurExt.positionIsolant)) if EmplacementOuest
    annotation (Placement(transformation(extent={{-7,-20},{7,-6}})));

// Internal vertical walls

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Cloisons(
    ParoiInterne=true,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_Cloison,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant)) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={51,20})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PortesInt(
    ParoiInterne=true,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PorteSeparations,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.PorteInt.n,
      m=paraMaisonRT.PorteInt.m,
      e=paraMaisonRT.PorteInt.e,
      mat=paraMaisonRT.PorteInt.mat,
      positionIsolant=paraMaisonRT.PorteInt.positionIsolant)) "Internal doors"
                                                              annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={51,0})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEst(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurEst,
    RadExterne=false,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurMitoyen.n,
      m=paraMaisonRT.MurMitoyen.m,
      e=paraMaisonRT.MurMitoyen.e,
      mat=paraMaisonRT.MurMitoyen.mat,
      positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
    ParoiInterne=true,
    GLOext=false,
    hs_ext=paraMaisonRT.hsIntVert)
                  if not EmplacementEst
    annotation (Placement(transformation(extent={{-7,52},{7,66}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSudLNC(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurSud,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurPalier.n,
      m=paraMaisonRT.MurPalier.m,
      e=paraMaisonRT.MurPalier.e,
      mat=paraMaisonRT.MurPalier.mat,
      positionIsolant=paraMaisonRT.MurPalier.positionIsolant),
    ParoiInterne=true,
    GLOext=false,
    hs_ext=paraMaisonRT.hsIntVert)
    annotation (Placement(transformation(extent={{-7,-38},{7,-24}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuest(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurOuest,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=paraMaisonRT.MurMitoyen.n,
      m=paraMaisonRT.MurMitoyen.m,
      e=paraMaisonRT.MurMitoyen.e,
      mat=paraMaisonRT.MurMitoyen.mat,
      positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
    ParoiInterne=true,
    GLOext=false,
    hs_ext=paraMaisonRT.hsIntVert)
                  if not EmplacementOuest
    annotation (Placement(transformation(extent={{-7,-2},{7,12}})));

// Glazings

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageNord(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_VitrageNord,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.H_VitrageNord,
    useVolet=useVolet,
    useOuverture=useOuverture,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert),
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    eps=paraMaisonRT.eps_vitrage,
    TypeFenetrePF=TypeFenetrePF,
    voilage=voilage,
    position=position,
    rideaux=rideaux,
    ombrages=ombrages,
    r1=r1,
    r2=r2,
    DifDirOut=false,
    useReduction=useReduction)
    annotation (Placement(transformation(extent={{-37,16},{-23,30}})));

// Thermal bridges
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

// Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky                     if GLOEXT==true
    annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{20,100},{40,120}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    np=6,
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlafondHaut,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurNord,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurSud,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurEst,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurOuest,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherBas},
    nf=1,
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_VitrageNord})
                                                                                         if not CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));

// Base components
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle"
      annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta)
    annotation (Placement(transformation(extent={{-86,56},{-66,76}})));


public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.VolumeMatisse,
      Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{-20,100},{0,120}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int annotation (
      Placement(transformation(extent={{80,-29},{100,-9}}), iconTransformation(
          extent={{37,-40},{57,-20}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.VolumeMatisse)
    annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir         if QVin==true "[m3/h]"
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{140,-16},{100,24}})));

  Modelica.Blocks.Interfaces.RealInput V[2] if useOuverture
    "Wind speed (m/s) and  direction (from 0° - North, 90° - East, 180° - South, 270 ° - West)"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[1] if useOuverture
    "Opening of north windows"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{-96,-30},{-74,-8}})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[1] if useVolet
    "Closing of north shutters"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{8,-14},{-14,8}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_common
    "Temperature of adjacent housings" annotation (Placement(transformation(
          extent={{-64,88},{-56,96}}), iconTransformation(extent={{-4,34},{4,42}})));

  BuildSysPro.BoundaryConditions.Weather.ZoneWind vENTzone(beta=beta)
                                                               if useOuverture
    annotation (Placement(transformation(extent={{-92,-26},{-72,-6}})));
equation
  if CLOintPlancher == false then
    connect(multiSum.y, PintdistriRad.RayEntrant) annotation (Line(
      points={{-14,-73.02},{-14,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[1], VitrageNord.FluxAbsInt) annotation (
      Line(
      points={{19,-80},{32,-80},{32,24.4},{-27.9,24.4}},
      color={0,0,127},
      smooth=Smooth.None));
    if EmplacementBas==true then
        connect(PintdistriRad.FLUXParois[6], PlancherBasImmeuble.FluxAbsInt) annotation (Line(
            points={{19,-83.1667},{67.5,-83.1667},{67.5,-89.9}},
            color={0,0,127},
            smooth=Smooth.None));
    else
        connect(PintdistriRad.FLUXParois[6], PlancherBas.FluxAbsInt) annotation (Line(
            points={{19,-83.1667},{47.5,-83.1667},{47.5,-89.9}},
            color={0,0,127},
            smooth=Smooth.None));
    end if;
    if EmplacementHaut==true then
        connect(PintdistriRad.FLUXParois[1], PlafondImmeuble.FluxAbsInt) annotation (Line(
            points={{19,-84.8333},{26,-84.8333},{26,-84},{32,-84},{32,80.5},{
              2.1,80.5}},
            color={0,0,127},
            smooth=Smooth.None));
    else
        connect(PintdistriRad.FLUXParois[1], Plafond.FluxAbsInt) annotation (Line(
            points={{19,-84.8333},{32,-84.8333},{32,97.5},{2.1,97.5}},
            color={0,0,127},
            smooth=Smooth.None));
    end if;
    if EmplacementEst==true then
        connect(PintdistriRad.FLUXParois[4], MurEstExt.FluxAbsInt) annotation (Line(
            points={{19,-83.8333},{32,-83.8333},{32,44.5},{2.1,44.5}},
            color={0,0,127},
            smooth=Smooth.None));
    else
        connect(PintdistriRad.FLUXParois[4], MurEst.FluxAbsInt) annotation (Line(
            points={{19,-83.8333},{32,-83.8333},{32,62.5},{2.1,62.5}},
            color={0,0,127},
            smooth=Smooth.None));
    end if;
      connect(PintdistriRad.FLUXParois[2], MurNord.FluxAbsInt) annotation (Line(
          points={{19,-84.5},{32,-84.5},{32,26.5},{2.1,26.5}},
          color={0,0,127},
          smooth=Smooth.None));
    if EmplacementOuest==true then
        connect(PintdistriRad.FLUXParois[5], MurOuestExt.FluxAbsInt) annotation (Line(
            points={{19,-83.5},{32,-83.5},{32,-9.5},{2.1,-9.5}},
            color={0,0,127},
            smooth=Smooth.None));
    else
        connect(PintdistriRad.FLUXParois[5], MurOuest.FluxAbsInt) annotation (Line(
            points={{19,-83.5},{32,-83.5},{32,8.5},{2.1,8.5}},
            color={0,0,127},
            smooth=Smooth.None));
    end if;
      connect(PintdistriRad.FLUXParois[3], MurSudLNC.FluxAbsInt) annotation (Line(
          points={{19,-84.1667},{32,-84.1667},{32,-27.5},{2.1,-27.5}},
          color={0,0,127},
          smooth=Smooth.None));

  else
    if EmplacementBas==true then
        connect(multiSum.y, PlancherBasImmeuble.FluxAbsInt) annotation (Line(
            points={{-14,-73.02},{68,-73.02},{68,-89.9},{67.5,-89.9}},
            color={0,0,127},
            smooth=Smooth.None));
    else
        connect(multiSum.y, PlancherBas.FluxAbsInt) annotation (Line(
            points={{-14,-73.02},{48,-73.02},{48,-89.9},{47.5,-89.9}},
            color={0,0,127},
            smooth=Smooth.None));
    end if;
  end if;

  if GLOEXT==true then
    connect(T_sky, VitrageNord.T_sky) annotation (Line(
        points={{-90,10},{-64,10},{-64,16.7},{-36.3,16.7}},
        color={191,0,0},
        smooth=Smooth.None));
    if EmplacementEst==true then
      connect(T_sky, MurEstExt.T_sky) annotation (Line(
          points={{-90,10},{-64,10},{-64,34.7},{-6.3,34.7}},
          color={191,0,0},
          smooth=Smooth.None));
    end if;
    connect(T_sky, MurNord.T_sky) annotation (Line(
        points={{-90,10},{-64,10},{-64,16.7},{-6.3,16.7}},
        color={191,0,0},
        smooth=Smooth.None));
    if EmplacementOuest==true then
      connect(T_sky, MurOuestExt.T_sky) annotation (Line(
          points={{-90,10},{-64,10},{-64,-19.3},{-6.3,-19.3}},
          color={191,0,0},
          smooth=Smooth.None));
    end if;
    if EmplacementHaut==true then
      connect(T_sky, PlafondImmeuble.T_sky) annotation (Line(
          points={{-90,10},{-64,10},{-64,70.7},{-6.3,70.7}},
          color={191,0,0},
          smooth=Smooth.None));
    end if;
  end if;

 connect(fLUXzone.G, G) annotation (Line(
      points={{-86.3,66.5},{-86.3,90},{-120,90}},
      color={0,0,127},
      smooth=Smooth.None));
  if QVin==true then
    connect(RenouvAir, renouvellementAir.Qv_in) annotation (Line(
      points={{100,-78},{92,-78},{92,-49},{80.68,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useVolet then
   connect(fermetureVolets[1], VitrageNord.fermeture_volet) annotation (
      Line(
      points={{-100,-80},{-76,-80},{-76,27.9},{-36.3,27.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  end if;
  if useOuverture then
   connect(ouvertureFenetres[1], VitrageNord.ouverture_fenetre) annotation (Line(
        points={{-100,-48},{-74,-48},{-74,23},{-32.1,23}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;

  connect(fLUXzone.FluxIncExtNorth, MurNord.FluxIncExt) annotation (Line(
      points={{-65,70.2},{-44,70.2},{-44,26},{-10,26},{-10,29.3},{-2.1,29.3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_ext, MurNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,20.9},{-6.3,20.9}},
      color={191,0,0},
      smooth=Smooth.None));
if EmplacementEst==true then
    connect(fLUXzone.FluxIncExtEast, MurEstExt.FluxIncExt) annotation (Line(
        points={{-65,62.4},{-44,62.4},{-44,46},{-10,46},{-10,47.3},{-2.1,47.3}},
        color={255,192,1},
        smooth=Smooth.None));

    connect(T_ext, MurEstExt.T_ext) annotation (Line(
        points={{-90,40},{-52,40},{-52,38.9},{-6.3,38.9}},
        color={191,0,0},
        smooth=Smooth.None));
      connect(MurEstExt.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,38.9},{40,38.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
else
    connect(T_int_common, MurEst.T_ext) annotation (Line(
        points={{-60,92},{-20,92},{-20,56.9},{-6.3,56.9}},
        color={128,0,255},
        smooth=Smooth.None));
      connect(MurEst.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,56.9},{40,56.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
end if;
if EmplacementOuest==true then
    connect(fLUXzone.FluxIncExtWest, MurOuestExt.FluxIncExt) annotation (Line(
        points={{-65,58.4},{-44,58.4},{-44,-6.7},{-2.1,-6.7}},
        color={255,192,1},
        smooth=Smooth.None));
    connect(T_ext, MurOuestExt.T_ext) annotation (Line(
        points={{-90,40},{-52,40},{-52,-15.1},{-6.3,-15.1}},
        color={191,0,0},
        smooth=Smooth.None));
      connect(MurOuestExt.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,-15.1},{40,-15.1},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
else
    connect(T_int_common, MurOuest.T_ext) annotation (Line(
        points={{-60,92},{-20,92},{-20,2.9},{-6.3,2.9}},
        color={128,0,255},
        smooth=Smooth.None));
      connect(MurOuest.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,2.9},{40,2.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
end if;
  connect(Cloisons.T_int, Cloisons.T_ext) annotation (Line(
      points={{52.8,25.4},{52.8,32},{64,32},{64,10},{52.8,10},{52.8,14.6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cloisons.T_ext, noeudAir.port_a) annotation (Line(
      points={{52.8,14.6},{52.8,10},{64,10},{64,22},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, PortesInt.T_ext) annotation (Line(
      points={{80,22},{64,22},{64,-10},{52.8,-10},{52.8,-5.4}},
      color={191,0,0}));
  connect(PortesInt.T_int, Cloisons.T_ext)
                                          annotation (Line(
      points={{52.8,5.4},{52.8,14.6}},
      color={191,0,0}));

if EmplacementHaut==true then
    connect(T_ext, PlafondImmeuble.T_ext) annotation (Line(
        points={{-90,40},{-52,40},{-52,74.9},{-6.3,74.9}},
        color={191,0,0},
        smooth=Smooth.None));
      connect(PlafondImmeuble.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,74.9},{40,74.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
    connect(fLUXzone.FluxIncExtRoof, PlafondImmeuble.FluxIncExt) annotation (
        Line(
        points={{-65,74.4},{-64,74.4},{-64,83.3},{-2.1,83.3}},
        color={255,192,1},
        smooth=Smooth.None));
else
      connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,91.9},{40,91.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
    connect(T_int_common, Plafond.T_ext) annotation (Line(
        points={{-60,92},{-34,92},{-34,91.9},{-6.3,91.9}},
        color={128,0,255},
        smooth=Smooth.None));
end if;
    connect(Porte.T_int, noeudAir.port_a) annotation (Line(
        points={{6.3,-51.75},{40,-51.75},{40,40},{80,40},{80,22}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
        points={{6.3,20.9},{40,20.9},{40,40},{80,40},{80,22}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(MurSudLNC.T_int, noeudAir.port_a) annotation (Line(
        points={{6.3,-33.1},{40,-33.1},{40,40},{80,40},{80,22}},
        color={255,0,0},
        smooth=Smooth.None));
if EmplacementBas==true then
      connect(PlancherBasImmeuble.T_int, noeudAir.port_a) annotation (Line(
          points={{73.1,-85.7},{73.1,-68},{53,-68},{53,-60},{40,-60},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));

      connect(TauPlancher.Tponder, PlancherBasImmeuble.T_ext) annotation (Line(
          points={{-44,-90},{28,-90},{28,-104},{73.1,-104},{73.1,-98.3}},
          color={191,0,0},
          smooth=Smooth.None));
else
      connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
          points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
    connect(T_int_common, PlancherBas.T_ext) annotation (Line(
        points={{-60,92},{-20,92},{-20,-100},{54,-100},{54,-98.3},{53.1,-98.3}},
        color={128,0,255},
        smooth=Smooth.None));

end if;
    connect(TauLNC.Tponder, MurSudLNC.T_ext) annotation (Line(
        points={{-44,-50},{-24.5,-50},{-24.5,-33.1},{-6.3,-33.1}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TauLNC.Tponder, Porte.T_ext) annotation (Line(
        points={{-44,-50},{-24.5,-50},{-24.5,-51.75},{-6.3,-51.75}},
        color={191,0,0},
        smooth=Smooth.None));

  connect(fLUXzone.FluxIncExtNorth, VitrageNord.FluxIncExt) annotation (Line(
      points={{-65,70.2},{-44,70.2},{-44,26.5},{-32.1,26.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_ext, VitrageNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,20.9},{-36.3,20.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-86},{-56,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, TauLNC.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-56,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageNord.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-23.7,26.5},{-14,26.5},{-14,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_ext, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(noeudAir.port_a, T_int) annotation (Line(
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
      points={{-56,-94},{-60,-94},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},
          {80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauLNC.port_int, noeudAir.port_a) annotation (Line(
      points={{-56,-54},{-60,-54},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},
          {80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{-43.75,-72.5},{-36,-72.5},{-36,-98},{30,-98},{30,-60},{40,-60},{40,
          40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(VitrageNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-23.7,20.9},{40,20.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(V, vENTzone.V) annotation (Line(
      points={{-120,-20},{-108,-20},{-108,-16.1},{-92.9,-16.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTNord, VitrageNord.V) annotation (Line(
      points={{-71,-11.8},{-62,-11.8},{-62,23},{-36.3,23}},
      color={0,0,127},
      smooth=Smooth.None));

annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Rectangle(
          extent={{-136,50},{-100,20}},
          fillColor={255,241,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-136,20},{-100,-100}},
          fillColor={255,241,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-136,-100},{-100,-130}},
          fillColor={255,241,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,-100},{100,-130}},
          fillColor={255,241,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{100,50},{136,20}},
          fillColor={255,241,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{100,21},{136,-99}},
          fillColor={255,241,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,50},{100,20}},
          fillColor={255,241,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,20},{100,-100}},
          lineColor={0,0,255},
          fillColor={197,133,81},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,4},{-14,-32}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-97,-65},{94,-89}},
          lineColor={0,0,0},
          textString="Matisse Monozone"),
        Ellipse(
          extent={{-91,175},{-31,119}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{70,16},{98,-12}},  lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={84,32},
          rotation=360),
        Ellipse(
          extent={{82,4},{86,0}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={46,-54},
          rotation=180),
        Line(
          points={{68,12},{84,20},{98,12}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{98,14},{100,10},{96,12},{98,14}},
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
          origin={54,2},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={84,-28},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={114,2},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={69,-8},
          rotation=90),
        Rectangle(
          extent={{-76,4},{-14,0}},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-76,-2},{-14,-6}},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-76,-8},{-14,-12}},
          lineThickness=0.5,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-76,4},{-76,-32},{-32,-54},{-32,-20},{-76,4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          lineThickness=0.5),
        Rectangle(
          extent={{100,-100},{136,-130}},
          fillColor={255,241,229},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-100,20},{-100,60}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{100,20},{100,60}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{100,-140},{100,-100}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{-100,-140},{-100,-100}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Line(
          points={{0,-20},{0,20}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          origin={120,20},
          rotation=90),
        Line(
          points={{0,-20},{0,20}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          origin={120,-100},
          rotation=90),
        Line(
          points={{0,-20},{0,20}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          origin={-120,-100},
          rotation=90),
        Line(
          points={{0,-20},{0,20}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          origin={-120,20},
          rotation=90),
        Ellipse(
          extent={{-101,65},{-99,63}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-101,75},{-99,73}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-101,70},{-99,68}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{99,67},{101,65}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{99,77},{101,75}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{99,72},{101,70}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{99,-153},{101,-155}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{99,-143},{101,-145}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{99,-148},{101,-150}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-101,-153},{-99,-155}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-101,-143},{-99,-145}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-101,-148},{-99,-150}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p><i><b>Matisse Monozone collective housing</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Parameter <code>paraMaisonRT</code> allows the user to chose a specific French building regulation for the building, so that building envelope parameters (walls, windows, ventilation...) will be automatically filled with data from the choosen record.</p>
<p>Detail of thermal bridge vectors :</p>
<ul>
<li>TauPonts[1] and ValeursK[1] : exterior wall / common wall</li>
<li>TauPonts[2] and ValeursK[2] : unheated room wall / common wall</li>
<li>TauPonts[3] and ValeursK[3] : exterior wall / intermediate floor</li>
<li>TauPonts[4] and ValeursK[4] : exterior wall / intermediate ceiling</li>
<li>TauPonts[5] and ValeursK[5] : unheated room wall / intermediate floor</li>
<li>TauPonts[6] and ValeursK[6] : unheated room wall / intermediate ceiling</li>
<li>TauPonts[7] and ValeursK[7] : door</li>
<li>TauPonts[8] and ValeursK[8] : windows</li>
</ul>
<ul>
<li>TauPontsPlancher[1] and ValeursKPlancher[1] : intermediate floor / exterior wall of basement</li>
<li>TauPontsPlancher[2] and ValeursKPlancher[2] : intermediate floor / unheated room wall of basement</li>
<li>TauPontsPlancher[3] and ValeursKPlancher[3] : intermediate floor / common wall of basement</li>
</ul>
<ul>
<li>TauPontsPlafond[1] and ValeursKPlafond[1] : intermediate ceiling / exterior wall of ceiling</li>
<li>TauPontsPlafond[2] and ValeursKPlafond[2] : intermediate ceiling / unheated room wall of ceiling</li>
<li>TauPontsPlafond[3] and ValeursKPlafond[3] : intermediate ceiling / common wall of ceiling</li>
</ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model by comparison of GV with Clim 2000 - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Stéphanie Froidurot - 10/2020 : Add internal doors</p>
</html>"));
end MatisseMonozone;
