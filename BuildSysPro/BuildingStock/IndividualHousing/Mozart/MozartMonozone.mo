within BuildSysPro.BuildingStock.IndividualHousing.Mozart;
model MozartMonozone
  import BuildSysPro;

  // Choice of RT (French building regulation)
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    paraMaisonRT "French building regulation to use" annotation (
      choicesAllMatching=true, Dialog(group="Choice of RT"));

protected
  parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.MozartRenoExisting
    paraMaisonRenoRTExistant "French building regulation to use"
    annotation (Dialog(group="Building renovation"));

   // Choice of renovated elements
public
      parameter Boolean renoPlafond=false
    "Ceiling renovation according to RT Existing"                                       annotation(Dialog(group="Building renovation according to RT Existing"),choices(radioButtons=true));
      parameter Boolean renoPlancher=false
    "Floor renovation according to RT Existing"                                        annotation(Dialog(group="Building renovation according to RT Existing"),choices(radioButtons=true));
      parameter Boolean renoFenetre=false
    "Windows renovation according to RT Existing"                                       annotation(Dialog(group="Building renovation according to RT Existing"),choices(radioButtons=true));
      parameter Boolean renoMurExt=false
    "Exterior walls renovation according to RT Existing"                                      annotation(Dialog(group="Building renovation according to RT Existing"),choices(radioButtons=true));

  // Orientation of the house
parameter Real beta=0
    "Correction of azimuth for vertical walls such as azimuth=beta+azimuth, {beta=0 : N=180,S=0,E=-90,O=90}";

  // Thermal flows
parameter Boolean GLOEXT=false
    "Integration of LW radiation (infrared) toward the environment and the sky"                         annotation(Dialog(tab="Thermal flows"));
parameter Boolean CLOintPlancher=true
    "True : solar fluxes are absorbed by the floor; False : solar fluxes are absorbed by all the walls and partition walls in proportion of surfaces"
                                                                                                        annotation(Dialog(tab="Thermal flows"));
parameter Boolean QVin=false
    "True : controlled air change rate; False : constant air change rate"                       annotation(Dialog(tab="Thermal flows"));

  // Walls
parameter Modelica.SIunits.Temperature Tp=293.15 "Initial temperature of walls"
    annotation(Dialog(tab="Walls"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type of initialization for walls"
    annotation (Dialog(tab="Walls"));

  // Windows
parameter Boolean useVolet=false "True if shutter, false if not" annotation(Dialog(tab="Windows"));
parameter Boolean useOuverture=false "True if controlled opening, false if not"
                                               annotation(Dialog(tab="Windows"));
parameter Boolean useReduction=false
    "True if solar reduction factors (masking, frame), false if not"
    annotation (Dialog(tab="Windows"));
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
    annotation (Dialog(tab="Windows",enable=not useReduction,group="Reduction factor if useReduction = false"));
parameter Real r2=paraMaisonRT.transmissionMenuiserieFenetres
    "Reduction factor for diffuse radiation if useReduction = false"
    annotation (Dialog(tab="Windows",enable=not useReduction,group="Reduction factor if useReduction = false"));

  // French windows
parameter Boolean useVoletPF=false "True if shutter, false if not" annotation(Dialog(tab="French windows"));
parameter Boolean useOuverturePF=false
    "True if controlled opening, false if not" annotation(Dialog(tab="French windows"));
parameter Boolean useReduction1=false
    "True if solar reduction factors (masking, frame), false if not"
    annotation (Dialog(tab="French windows"));
parameter Integer TypeFenetrePF1=1 "Choice of type of French window"
    annotation (Dialog(tab="French windows",enable=useReduction1,group="Parameters"),
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
parameter Real voilage1=0.95
    "Presence of net curtains : = 0.95 if yes and = 1 if not"
    annotation (Dialog(tab="French windows",enable=useReduction1,group="Parameters"));
parameter Real position1=0.90
    "Glazing position: = 0.9 if inner and = 1 if outer"
    annotation (Dialog(tab="French windows",enable=useReduction1,group="Parameters"));
parameter Real rideaux1=0.85
    "Presence of curtains: = 0.85 if yes and = 1 if not"
    annotation (Dialog(tab="French windows",enable=useReduction1,group="Parameters"));
parameter Real ombrages1=0.85
    "Obstacles shading (vegetation, neighborhood): = 0.85 if yes et = 1 if not"
    annotation (Dialog(tab="French windows",enable=useReduction1,group="Parameters"));
parameter Real r11=paraMaisonRT.transmissionMenuiseriePortesFenetres
    "Reduction factor for direct radiation if useReduction = false"
    annotation (Dialog(tab="French windows",enable=not useReduction1,group="Reduction factor if useReduction = false"));
parameter Real r21=paraMaisonRT.transmissionMenuiseriePortesFenetres
    "Reduction factor for diffuse radiation if useReduction = false"
    annotation (Dialog(tab="French windows",enable=not useReduction1,group="Reduction factor if useReduction = false"));

  // Ponts thermiques
  parameter Modelica.SIunits.ThermalConductance G_ponts=
      BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPonts,
      TauPonts=paraMaisonRT.TauPonts) "Thermal bridges"
    annotation (Dialog(tab="Thermal bridges"));

    // Weighting coefficients
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(
      b=paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauLNC(b=
        paraMaisonRT.bLNC)
    annotation (Placement(transformation(extent={{-58,-60},{-38,-40}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlafond(
      b=paraMaisonRT.bSousCombles)
    annotation (Placement(transformation(extent={{-58,80},{-38,100}})));

// Horizontal walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall ParoiSousCombles(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_ParoiSousCombles,
    ParoiInterne=true,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsIntHorHaut,
    hs_int=paraMaisonRT.hsIntHorHaut,
    caracParoi(
      n=if not (renoPlafond) then paraMaisonRT.ParoiSousCombles.n else paraMaisonRenoRTExistant.ParoiSousCombles.n,
      m=if not (renoPlafond) then paraMaisonRT.ParoiSousCombles.m else paraMaisonRenoRTExistant.ParoiSousCombles.m,
      e=if not (renoPlafond) then paraMaisonRT.ParoiSousCombles.e else paraMaisonRenoRTExistant.ParoiSousCombles.e,
      mat=if not (renoPlafond) then paraMaisonRT.ParoiSousCombles.mat else paraMaisonRenoRTExistant.ParoiSousCombles.mat,
      positionIsolant=if not (renoPlafond) then paraMaisonRT.ParoiSousCombles.positionIsolant else paraMaisonRenoRTExistant.ParoiSousCombles.positionIsolant))
    annotation (Placement(transformation(extent={{-7,82},{7,96}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherBas,
    ParoiInterne=true,
    Tp=Tp,
    RadInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    hs_int=paraMaisonRT.hsIntHorBas,
    caracParoi(
      n=if not (renoPlancher) then paraMaisonRT.PlancherBas.n else paraMaisonRenoRTExistant.PlancherBas.n,
      m=if not (renoPlancher) then paraMaisonRT.PlancherBas.m else paraMaisonRenoRTExistant.PlancherBas.m,
      e=if not (renoPlancher) then paraMaisonRT.PlancherBas.e else paraMaisonRenoRTExistant.PlancherBas.e,
      mat=if not (renoPlancher) then paraMaisonRT.PlancherBas.mat else paraMaisonRenoRTExistant.PlancherBas.mat,
      positionIsolant=if not (renoPlancher) then paraMaisonRT.PlancherBas.positionIsolant else paraMaisonRenoRTExistant.PlancherBas.positionIsolant),
    InitType=InitType) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

// Exterior vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Porte(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PorteEntree,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    hs_ext=paraMaisonRT.hsExtVert,
    caracParoi(
      n=paraMaisonRT.Porte.n,
      m=paraMaisonRT.Porte.m,
      e=paraMaisonRT.Porte.e,
      mat=paraMaisonRT.Porte.mat,
      positionIsolant=paraMaisonRT.Porte.positionIsolant))
    annotation (Placement(transformation(extent={{-7,61},{7,76}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEst(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurEst,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=if not (renoMurExt) then paraMaisonRT.Mur.n else paraMaisonRenoRTExistant.Mur.n,
      m=if not (renoMurExt) then paraMaisonRT.Mur.m else paraMaisonRenoRTExistant.Mur.m,
      e=if not (renoMurExt) then paraMaisonRT.Mur.e else paraMaisonRenoRTExistant.Mur.e,
      mat=if not (renoMurExt) then paraMaisonRT.Mur.mat else paraMaisonRenoRTExistant.Mur.mat,
      positionIsolant=if not (renoMurExt) then paraMaisonRT.Mur.positionIsolant else paraMaisonRenoRTExistant.Mur.positionIsolant))
    annotation (Placement(transformation(extent={{-7,42},{7,56}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurNord(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurNord,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=if not (renoMurExt) then paraMaisonRT.Mur.n else paraMaisonRenoRTExistant.Mur.n,
      m=if not (renoMurExt) then paraMaisonRT.Mur.m else paraMaisonRenoRTExistant.Mur.m,
      e=if not (renoMurExt) then paraMaisonRT.Mur.e else paraMaisonRenoRTExistant.Mur.e,
      mat=if not (renoMurExt) then paraMaisonRT.Mur.mat else paraMaisonRenoRTExistant.Mur.mat,
      positionIsolant=if not (renoMurExt) then paraMaisonRT.Mur.positionIsolant else paraMaisonRenoRTExistant.Mur.positionIsolant))
    annotation (Placement(transformation(extent={{-7,22},{7,36}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuest(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurOuest,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=if not (renoMurExt) then paraMaisonRT.Mur.n else paraMaisonRenoRTExistant.Mur.n,
      m=if not (renoMurExt) then paraMaisonRT.Mur.m else paraMaisonRenoRTExistant.Mur.m,
      e=if not (renoMurExt) then paraMaisonRT.Mur.e else paraMaisonRenoRTExistant.Mur.e,
      mat=if not (renoMurExt) then paraMaisonRT.Mur.mat else paraMaisonRenoRTExistant.Mur.mat,
      positionIsolant=if not (renoMurExt) then paraMaisonRT.Mur.positionIsolant else paraMaisonRenoRTExistant.Mur.positionIsolant))
    annotation (Placement(transformation(extent={{-7,2},{7,16}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSud,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsExtVert,
    hs_int=paraMaisonRT.hsIntVert,
    alpha_ext=paraMaisonRT.alphaExt,
    eps=paraMaisonRT.eps,
    caracParoi(
      n=if not (renoMurExt) then paraMaisonRT.Mur.n else paraMaisonRenoRTExistant.Mur.n,
      m=if not (renoMurExt) then paraMaisonRT.Mur.m else paraMaisonRenoRTExistant.Mur.m,
      e=if not (renoMurExt) then paraMaisonRT.Mur.e else paraMaisonRenoRTExistant.Mur.e,
      mat=if not (renoMurExt) then paraMaisonRT.Mur.mat else paraMaisonRenoRTExistant.Mur.mat,
      positionIsolant=if not (renoMurExt) then paraMaisonRT.Mur.positionIsolant else paraMaisonRenoRTExistant.Mur.positionIsolant))
    annotation (Placement(transformation(extent={{-7,-18},{7,-4}})));

// Internal vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurLNC(
    ParoiInterne=true,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurLNC3,
    Tp=Tp,
    InitType=InitType,
    RadInterne=not CLOintPlancher,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=if not (renoMurExt) then paraMaisonRT.Mur.n else paraMaisonRenoRTExistant.Mur.n,
      m=if not (renoMurExt) then paraMaisonRT.Mur.m else paraMaisonRenoRTExistant.Mur.m,
      e=if not (renoMurExt) then paraMaisonRT.Mur.e else paraMaisonRenoRTExistant.Mur.e,
      mat=if not (renoMurExt) then paraMaisonRT.Mur.mat else paraMaisonRenoRTExistant.Mur.mat,
      positionIsolant=if not (renoMurExt) then paraMaisonRT.Mur.positionIsolant else paraMaisonRenoRTExistant.Mur.positionIsolant))
    annotation (Placement(transformation(extent={{-7,-58},{7,-44}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Cloisons(
    ParoiInterne=true,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_Cloison,
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

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Refends(
    ParoiInterne=true,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_Refends,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Refends.n,
      m=paraMaisonRT.Refends.m,
      e=paraMaisonRT.Refends.e,
      mat=paraMaisonRT.Refends.mat,
      positionIsolant=paraMaisonRT.Refends.positionIsolant)) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={51,0})));

// Glazings
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageEst(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageEst,
    RadInterne=not CLOintPlancher,
    GLOext=GLOEXT,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageEst,
    useVolet=useVoletPF,
    useOuverture=useOuverturePF,
    k=if not (renoFenetre) then 1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert) else 1/(1/paraMaisonRenoRTExistant.UvitrageAF - 1/paraMaisonRenoRTExistant.hsExtVert - 1/paraMaisonRenoRTExistant.hsIntVert),
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
    r2=r21) annotation (Placement(transformation(extent={{-37,42},{-23,56}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageNord(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageNord,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageNord,
    useVolet=useVolet,
    useOuverture=useOuverture,
    k=if not (renoFenetre) then 1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert) else 1/(1/paraMaisonRenoRTExistant.UvitrageAF - 1/paraMaisonRenoRTExistant.hsExtVert - 1/paraMaisonRenoRTExistant.hsIntVert),
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
    annotation (Placement(transformation(extent={{-37,22},{-23,36}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageOuest(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageOuest,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageOuest,
    useVolet=useVoletPF,
    useOuverture=useOuverturePF,
    k=if not (renoFenetre) then 1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert) else 1/(1/paraMaisonRenoRTExistant.UvitrageAF - 1/paraMaisonRenoRTExistant.hsExtVert - 1/paraMaisonRenoRTExistant.hsIntVert),
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
    DifDirOut=false)
    annotation (Placement(transformation(extent={{-36,2},{-22,16}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageSudSF(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudSF,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageSudSF,
    useVolet=useVolet,
    k=if not (renoFenetre) then 1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert) else 1/(1/paraMaisonRenoRTExistant.UvitrageAF - 1/paraMaisonRenoRTExistant.hsExtVert - 1/paraMaisonRenoRTExistant.hsIntVert),
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
    annotation (Placement(transformation(extent={{-36,-18},{-22,-4}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageSudAF(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudAF,
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageSudAF,
    useVolet=useVoletPF,
    useOuverture=useOuverturePF,
    k=if not (renoFenetre) then 1/(1/paraMaisonRT.UvitrageAF - 1/paraMaisonRT.hsExtVert - 1/paraMaisonRT.hsIntVert) else 1/(1/paraMaisonRenoRTExistant.UvitrageAF - 1/paraMaisonRenoRTExistant.hsExtVert - 1/paraMaisonRenoRTExistant.hsIntVert),
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
    DifDirOut=false)
    annotation (Placement(transformation(extent={{-36,-38},{-22,-24}})));

// Thermal bridges
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

// Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if                     GLOEXT==true
    annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{20,100},{40,120}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    nf=5,
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageNord,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudSF,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageSudAF,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageEst,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageOuest},
    np=7,
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_ParoiSousCombles,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurNord,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurSud,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurEst,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurOuest,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherBas,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurLNC3}) if      not CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

// Base components
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle , Solar elevation angle"
      annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta)
    annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));
public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.VolumeMozart,
      Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{-120,0},{-100,20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tair annotation (
      Placement(transformation(extent={{80,-29},{100,-9}}), iconTransformation(
          extent={{37,-40},{57,-20}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.VolumeMozart)
    annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true "[m3/h]"
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{140,-20},{100,20}})));

  Modelica.Blocks.Interfaces.RealInput V[2] if useOuverture or useOuverturePF
    "Wind speed (m/s) and  direction (from 0° - North, 90° - East, 180° - South, 270 ° - West)"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[4] if useOuverture or useOuverturePF
    "Opening of north, south, east, west windows (true = open , false = closed)"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{-96,-30},{-74,-8}})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[4] if useVoletPF or useVolet
    "Closing of north, south, east, west shutters (0 = open , 1 = closed)"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{8,-14},{-14,8}})));
  BuildSysPro.BoundaryConditions.Weather.ZoneWind vENTzone(beta=beta) if
                                                                  useOuverture or useOuverturePF
    annotation (Placement(transformation(extent={{-92,-26},{-72,-6}})));
equation
  if CLOintPlancher==false then
    connect(multiSum.y, PintdistriRad.RayEntrant) annotation (Line(
      points={{-14,-73.02},{-14,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[1], VitrageNord.FluxAbsInt)
                                                   annotation (Line(
      points={{19,-80.8},{19,30.4},{-27.9,30.4}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[2], VitrageSudSF.FluxAbsInt)
                                                   annotation (Line(
      points={{19,-80.4},{19,-9.6},{-26.9,-9.6}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[3], VitrageSudAF.FluxAbsInt)
                                                     annotation (Line(
      points={{19,-80},{19,-29.6},{-26.9,-29.6}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[4], VitrageEst.FluxAbsInt)
                                                    annotation (Line(
      points={{19,-79.6},{19,50.4},{-27.9,50.4}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[5], VitrageOuest.FluxAbsInt)
                                                        annotation (Line(
      points={{19,-79.2},{19,10.4},{-26.9,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[1], ParoiSousCombles.FluxAbsInt)
                                                   annotation (Line(
      points={{19,-84.8571},{19,92.5},{2.1,92.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[2], MurNord.FluxAbsInt)
                                                   annotation (Line(
      points={{19,-84.5714},{19,32.5},{2.1,32.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[3], MurSud.FluxAbsInt)
                                                     annotation (Line(
      points={{19,-84.2857},{19,-7.5},{2.1,-7.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[4], MurEst.FluxAbsInt)
                                                    annotation (Line(
      points={{19,-84},{19,52.5},{2.1,52.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[5], MurOuest.FluxAbsInt)
                                                        annotation (Line(
      points={{19,-83.7143},{19,12},{2.1,12},{2.1,12.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[6], PlancherBas.FluxAbsInt) annotation (Line(
      points={{19,-83.4286},{19,-89.9},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
      connect(PintdistriRad.FLUXParois[7], MurLNC.FluxAbsInt)          annotation (Line(
      points={{19,-83.1429},{19,-47.5},{2.1,-47.5}},
      color={0,0,127},
      smooth=Smooth.None));

else
    connect(multiSum.y, PlancherBas.FluxAbsInt) annotation (Line(
      points={{-14,-73.02},{48,-73.02},{48,-89.9},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if GLOEXT==true then
    connect(Tciel, VitrageEst.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,42.7},{-36.3,42.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, VitrageNord.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,22.7},{-36.3,22.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, VitrageOuest.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,2.7},{-35.3,2.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, VitrageSudSF.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,-17.3},{-35.3,-17.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, VitrageSudAF.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,-37.3},{-35.3,-37.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurEst.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,42.7},{-6.3,42.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurNord.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,22.7},{-6.3,22.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurOuest.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,2.7},{-6.3,2.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurSud.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,-17.3},{-6.3,-17.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, Porte.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,61.75},{-6.3,61.75}},
      color={191,0,0},
      smooth=Smooth.None));
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
      points={{-100,-95},{-76,-95},{-76,33.9},{-36.3,33.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fermetureVolets[2], VitrageSudSF.fermeture_volet) annotation (
      Line(
      points={{-100,-85},{-76,-85},{-76,-6.1},{-35.3,-6.1}},
      color={0,0,127},
      smooth=Smooth.None));
end if;

if useVoletPF then
  connect(fermetureVolets[3], VitrageEst.fermeture_volet) annotation (Line(
      points={{-100,-75},{-76,-75},{-76,53.9},{-36.3,53.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fermetureVolets[4], VitrageOuest.fermeture_volet) annotation (
      Line(
      points={{-100,-65},{-76,-65},{-76,13.9},{-35.3,13.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fermetureVolets[2], VitrageSudAF.fermeture_volet) annotation (
      Line(
      points={{-100,-85},{-76,-85},{-76,-26.1},{-35.3,-26.1}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
end if;

if useOuverture then
  connect(ouvertureFenetres[1], VitrageNord.ouverture_fenetre) annotation (Line(
        points={{-100,-63},{-74,-63},{-74,29},{-32.1,29}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
end if;

if useOuverturePF then
  connect(ouvertureFenetres[3], VitrageEst.ouverture_fenetre) annotation (Line(
        points={{-100,-43},{-74,-43},{-74,49},{-32.1,49}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  connect(ouvertureFenetres[4], VitrageOuest.ouverture_fenetre) annotation (
      Line(
        points={{-100,-33},{-74,-33},{-74,9},{-31.1,9}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  connect(ouvertureFenetres[2], VitrageSudAF.ouverture_fenetre) annotation (
      Line(
        points={{-100,-53},{-74,-53},{-74,-31},{-31.1,-31}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
end if;

    connect(fLUXzone.FLUXNord, MurNord.FLUX) annotation (Line(
      points={{-65,70.2},{-44,70.2},{-44,32},{-10,32},{-10,35.3},{-2.1,35.3}},
      color={255,192,1},
      smooth=Smooth.None));
    connect(fLUXzone.FLUXSud, MurSud.FLUX) annotation (Line(
      points={{-65,66.4},{-44,66.4},{-44,-8},{-10,-8},{-10,-4.7},{-2.1,-4.7}},
      color={255,192,1},
      smooth=Smooth.None));
    connect(fLUXzone.FLUXEst, MurEst.FLUX) annotation (Line(
      points={{-65,62.4},{-44,62.4},{-44,52},{-10,52},{-10,55.3},{-2.1,55.3}},
      color={255,192,1},
      smooth=Smooth.None));
    connect(fLUXzone.FLUXouest, MurOuest.FLUX) annotation (Line(
      points={{-65,58.4},{-44,58.4},{-44,12},{-10,12},{-10,15.3},{-2.1,15.3}},
      color={255,192,1},
      smooth=Smooth.None));
    connect(fLUXzone.FLUXSud, Porte.FLUX) annotation (Line(
      points={{-65,66.4},{-44,66.4},{-44,75.25},{-2.1,75.25}},
      color={255,192,1},
      smooth=Smooth.None));
    connect(Text, MurEst.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,46.9},{-6.3,46.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, MurNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,26.9},{-6.3,26.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, MurOuest.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,6.9},{-6.3,6.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, MurSud.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-13.1},{-6.3,-13.1}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, Porte.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,66.25},{-6.3,66.25}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlafond.Tponder, ParoiSousCombles.T_ext) annotation (Line(
      points={{-43,89.8},{-6.3,89.8},{-6.3,86.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauLNC.Tponder, MurLNC.T_ext) annotation (Line(
      points={{-43,-50.2},{-6.3,-50.2},{-6.3,-53.1}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlancher.Tponder, PlancherBas.T_ext) annotation (Line(
      points={{-43,-90.2},{34,-90.2},{34,-98.3},{53.1,-98.3}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Cloisons.T_int, Cloisons.T_ext) annotation (Line(
      points={{52.8,25.4},{52.8,32},{64,32},{64,10},{52.8,10},{52.8,14.6}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(Refends.T_int, Refends.T_ext) annotation (Line(
      points={{52.8,5.4},{52.8,10},{64,10},{64,-10},{52.8,-10},{52.8,-5.4}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(Cloisons.T_ext, noeudAir.port_a) annotation (Line(
      points={{52.8,14.6},{52.8,10},{64,10},{64,22},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Refends.T_int, noeudAir.port_a) annotation (Line(
      points={{52.8,5.4},{52.8,10},{64,10},{64,22},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(ParoiSousCombles.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,86.9},{40,86.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(Porte.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,66.25},{40,66.25},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurEst.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,46.9},{40,46.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,26.9},{40,26.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,6.9},{40,6.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,-13.1},{40,-13.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(MurLNC.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,-53.1},{40,-53.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, VitrageNord.FLUX) annotation (Line(
      points={{-65,70.2},{-44,70.2},{-44,32.5},{-32.1,32.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, VitrageSudSF.FLUX) annotation (Line(
      points={{-65,66.4},{-44,66.4},{-44,-7.5},{-31.1,-7.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, VitrageEst.FLUX) annotation (Line(
      points={{-65,62.4},{-44,62.4},{-44,52.5},{-32.1,52.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest, VitrageOuest.FLUX) annotation (Line(
      points={{-65,58.4},{-44,58.4},{-44,12.5},{-31.1,12.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, VitrageSudAF.FLUX) annotation (Line(
      points={{-65,66.4},{-44,66.4},{-44,-27.5},{-31.1,-27.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, VitrageEst.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,46.9},{-36.3,46.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,26.9},{-36.3,26.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageOuest.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,6.9},{-35.3,6.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageSudSF.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-13.1},{-35.3,-13.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageSudAF.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-33.1},{-35.3,-33.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-87},{-57,-87}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauLNC.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-47},{-57,-47}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlafond.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,80},{-64,80},{-64,93},{-57,93}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageEst.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-23.7,52.5},{-10.64,52.5},{-10.64,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageNord.CLOTr, multiSum.u[2]) annotation (Line(
      points={{-23.7,32.5},{-12.32,32.5},{-12.32,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageOuest.CLOTr, multiSum.u[3]) annotation (Line(
      points={{-22.7,12.5},{-14,12.5},{-14,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageSudSF.CLOTr, multiSum.u[4]) annotation (Line(
      points={{-22.7,-7.5},{-15.68,-7.5},{-15.68,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageSudAF.CLOTr, multiSum.u[5]) annotation (Line(
      points={{-22.7,-27.5},{-17.36,-27.5},{-17.36,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tair) annotation (Line(
      points={{80,22},{80,-19},{90,-19}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, PontsThermiques.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-72.5},{-57.25,-72.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{71,-39.1},{71,-30},{40,-30},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TauPlancher.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,-93},{-60,-93},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},{
          80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauLNC.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,-53},{-60,-53},{-60,-98},{30,-98},{30,-60},{40,-60},{40,40},{
          80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TauPlafond.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,87},{-60,87},{-60,82},{40,82},{40,40},{80,40},{80,22}},
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
  connect(VitrageNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-23.7,26.9},{40,26.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(VitrageOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{-22.7,6.9},{40,6.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(VitrageSudSF.T_int, noeudAir.port_a) annotation (Line(
      points={{-22.7,-13.1},{40,-13.1},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(V, vENTzone.V) annotation (Line(
      points={{-120,-20},{-108,-20},{-108,-16.1},{-92.9,-16.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTNord, VitrageNord.V) annotation (Line(
      points={{-71,-11.8},{-66,-11.8},{-66,29},{-36.3,29}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTSud, VitrageSudAF.V) annotation (Line(
      points={{-71,-15.6},{-66,-15.6},{-66,-31},{-35.3,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTEst, VitrageEst.V) annotation (Line(
      points={{-71,-19.6},{-66,-19.6},{-66,49},{-36.3,49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTOuest, VitrageOuest.V) annotation (Line(
      points={{-71,-23.6},{-66,-23.6},{-66,9},{-35.3,9}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Polygon(
          points={{-100,20},{100,20},{0,98},{-100,20}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={226,98,12},
          fillPattern=FillPattern.Solid),
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
          textString="Mozart Monozone"),
        Ellipse(
          extent={{-99,119},{-39,63}},
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
          lineThickness=0.5)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i><b>Mozart Monozone individual housing</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Parameter <code>paramaisonRT</code> allows to define the date of construction of the building, the building envelope composition will be adapted according to the related RT (French building regulation).</p>
<p>Parameters <code>renoPlafond</code>, <code>renoPlancher</code>, <code>renoFenetre</code>, and <code>renoMurExt</code> allow to specify which element of the building have been renovated according to the RT Existing (French building regulation for renovation by element).</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>For dates of contruction from 1974 to 1989, insulating materials thicknesses in floors are different between building stock site and Clim 2000 (cf <a href=\"modelica://BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing\">Records.WallData.IndividualHousing</a> documentation).</p>
<p><u><b>Validations</b></u></p>
<p>Validated model by comparison of GV with Clim 2000 - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>", revisions="<html>
<p>Béatrice Suplice, Frédéric Gastiger 04/2016 : Possibilité de réaliser des rénovations de différents éléments indépendamment les uns des autres</p>
</html>"));
end MozartMonozone;
