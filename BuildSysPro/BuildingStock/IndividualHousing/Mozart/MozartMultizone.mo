within BuildSysPro.BuildingStock.IndividualHousing.Mozart;
model MozartMultizone
  import BuildSysPro;

  // Choice of RT (French building regulation)
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    paraMaisonRT "French building regulation to use" annotation (
      choicesAllMatching=true, Dialog(group="Choice of RT"));

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
    annotation (Dialog(tab="Windows",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));
parameter Real r2=paraMaisonRT.transmissionMenuiserieFenetres
    "Reduction factor for diffuse radiation if useReduction = false"
    annotation (Dialog(tab="Windows",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));

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

// Zones
protected
  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones.ZoneLiving zoneSejour3_1(
    paraMaisonRT(
      ParoiSousCombles(
        n=paraMaisonRT.ParoiSousCombles.n,
        m=paraMaisonRT.ParoiSousCombles.m,
        mat=paraMaisonRT.ParoiSousCombles.mat,
        e=paraMaisonRT.ParoiSousCombles.e,
        positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        mat=paraMaisonRT.Porte.mat,
        e=paraMaisonRT.Porte.e,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PlancherBas(
        n=paraMaisonRT.PlancherBas.n,
        m=paraMaisonRT.PlancherBas.m,
        mat=paraMaisonRT.PlancherBas.mat,
        e=paraMaisonRT.PlancherBas.e,
        positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
      Mur(
        n=paraMaisonRT.Mur.n,
        m=paraMaisonRT.Mur.m,
        mat=paraMaisonRT.Mur.mat,
        e=paraMaisonRT.Mur.e,
        positionIsolant=paraMaisonRT.Mur.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        mat=paraMaisonRT.Cloisons.mat,
        e=paraMaisonRT.Cloisons.e,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      Refends(
        n=paraMaisonRT.Refends.n,
        m=paraMaisonRT.Refends.m,
        mat=paraMaisonRT.Refends.mat,
        e=paraMaisonRT.Refends.e,
        positionIsolant=paraMaisonRT.Refends.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      transmissionMenuiseriePortesFenetres=paraMaisonRT.transmissionMenuiseriePortesFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bSousCombles=paraMaisonRT.bSousCombles),
    GLOEXT=GLOEXT,
    CLOintPlancher=CLOintPlancher,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    useVoletPF=useVoletPF,
    useOuverturePF=useOuverturePF,
    useReduction1=useReduction1,
    TypeFenetrePF1=TypeFenetrePF1,
    voilage1=voilage1,
    position1=position1,
    rideaux1=rideaux1,
    ombrages1=ombrages1,
    r11=r11,
    r21=r21,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsSejour,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{-54,-28},{-6,30}})));

  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones.ZoneKitchen zoneCuisine3_1(
    paraMaisonRT(
      ParoiSousCombles(
        n=paraMaisonRT.ParoiSousCombles.n,
        m=paraMaisonRT.ParoiSousCombles.m,
        mat=paraMaisonRT.ParoiSousCombles.mat,
        e=paraMaisonRT.ParoiSousCombles.e,
        positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        mat=paraMaisonRT.Porte.mat,
        e=paraMaisonRT.Porte.e,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PlancherBas(
        n=paraMaisonRT.PlancherBas.n,
        m=paraMaisonRT.PlancherBas.m,
        mat=paraMaisonRT.PlancherBas.mat,
        e=paraMaisonRT.PlancherBas.e,
        positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
      Mur(
        n=paraMaisonRT.Mur.n,
        m=paraMaisonRT.Mur.m,
        mat=paraMaisonRT.Mur.mat,
        e=paraMaisonRT.Mur.e,
        positionIsolant=paraMaisonRT.Mur.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        mat=paraMaisonRT.Cloisons.mat,
        e=paraMaisonRT.Cloisons.e,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      Refends(
        n=paraMaisonRT.Refends.n,
        m=paraMaisonRT.Refends.m,
        mat=paraMaisonRT.Refends.mat,
        e=paraMaisonRT.Refends.e,
        positionIsolant=paraMaisonRT.Refends.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      transmissionMenuiseriePortesFenetres=paraMaisonRT.transmissionMenuiseriePortesFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bSousCombles=paraMaisonRT.bSousCombles),
    GLOEXT=GLOEXT,
    CLOintPlancher=CLOintPlancher,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    useVolet=useVolet,
    useOuverture=useOuverture,
    useReduction=useReduction,
    TypeFenetrePF=TypeFenetrePF,
    voilage=voilage,
    position=position,
    rideaux=rideaux,
    ombrages=ombrages,
    r1=r1,
    r2=r2,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsCuisine,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{-9,-6},{25,28}})));

  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones.ZoneR1 zoneC1_3_1(
    paraMaisonRT(
      ParoiSousCombles(
        n=paraMaisonRT.ParoiSousCombles.n,
        m=paraMaisonRT.ParoiSousCombles.m,
        mat=paraMaisonRT.ParoiSousCombles.mat,
        e=paraMaisonRT.ParoiSousCombles.e,
        positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        mat=paraMaisonRT.Porte.mat,
        e=paraMaisonRT.Porte.e,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PlancherBas(
        n=paraMaisonRT.PlancherBas.n,
        m=paraMaisonRT.PlancherBas.m,
        mat=paraMaisonRT.PlancherBas.mat,
        e=paraMaisonRT.PlancherBas.e,
        positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
      Mur(
        n=paraMaisonRT.Mur.n,
        m=paraMaisonRT.Mur.m,
        mat=paraMaisonRT.Mur.mat,
        e=paraMaisonRT.Mur.e,
        positionIsolant=paraMaisonRT.Mur.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        mat=paraMaisonRT.Cloisons.mat,
        e=paraMaisonRT.Cloisons.e,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      Refends(
        n=paraMaisonRT.Refends.n,
        m=paraMaisonRT.Refends.m,
        mat=paraMaisonRT.Refends.mat,
        e=paraMaisonRT.Refends.e,
        positionIsolant=paraMaisonRT.Refends.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      transmissionMenuiseriePortesFenetres=paraMaisonRT.transmissionMenuiseriePortesFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bSousCombles=paraMaisonRT.bSousCombles),
    GLOEXT=GLOEXT,
    CLOintPlancher=CLOintPlancher,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    useVolet=useVolet,
    useOuverture=useOuverture,
    useReduction=useReduction,
    TypeFenetrePF=TypeFenetrePF,
    voilage=voilage,
    position=position,
    rideaux=rideaux,
    ombrages=ombrages,
    r1=r1,
    r2=r2,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsC1,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{24,-6},{56,30}})));

  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones.ZoneR2 zoneC2_3_1(
    paraMaisonRT(
      ParoiSousCombles(
        n=paraMaisonRT.ParoiSousCombles.n,
        m=paraMaisonRT.ParoiSousCombles.m,
        mat=paraMaisonRT.ParoiSousCombles.mat,
        e=paraMaisonRT.ParoiSousCombles.e,
        positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        mat=paraMaisonRT.Porte.mat,
        e=paraMaisonRT.Porte.e,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PlancherBas(
        n=paraMaisonRT.PlancherBas.n,
        m=paraMaisonRT.PlancherBas.m,
        mat=paraMaisonRT.PlancherBas.mat,
        e=paraMaisonRT.PlancherBas.e,
        positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
      Mur(
        n=paraMaisonRT.Mur.n,
        m=paraMaisonRT.Mur.m,
        mat=paraMaisonRT.Mur.mat,
        e=paraMaisonRT.Mur.e,
        positionIsolant=paraMaisonRT.Mur.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        mat=paraMaisonRT.Cloisons.mat,
        e=paraMaisonRT.Cloisons.e,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      Refends(
        n=paraMaisonRT.Refends.n,
        m=paraMaisonRT.Refends.m,
        mat=paraMaisonRT.Refends.mat,
        e=paraMaisonRT.Refends.e,
        positionIsolant=paraMaisonRT.Refends.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      transmissionMenuiseriePortesFenetres=paraMaisonRT.transmissionMenuiseriePortesFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bSousCombles=paraMaisonRT.bSousCombles),
    GLOEXT=GLOEXT,
    CLOintPlancher=CLOintPlancher,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    useVoletPF=useVoletPF,
    useOuverturePF=useOuverturePF,
    useReduction1=useReduction1,
    TypeFenetrePF1=TypeFenetrePF1,
    voilage1=voilage1,
    position1=position1,
    rideaux1=rideaux1,
    ombrages1=ombrages1,
    r11=r11,
    r21=r21,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsC2,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{56,-9},{90,27}})));

  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones.ZoneR3 zoneC3_3_1(
    paraMaisonRT(
      ParoiSousCombles(
        n=paraMaisonRT.ParoiSousCombles.n,
        m=paraMaisonRT.ParoiSousCombles.m,
        mat=paraMaisonRT.ParoiSousCombles.mat,
        e=paraMaisonRT.ParoiSousCombles.e,
        positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        mat=paraMaisonRT.Porte.mat,
        e=paraMaisonRT.Porte.e,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PlancherBas(
        n=paraMaisonRT.PlancherBas.n,
        m=paraMaisonRT.PlancherBas.m,
        mat=paraMaisonRT.PlancherBas.mat,
        e=paraMaisonRT.PlancherBas.e,
        positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
      Mur(
        n=paraMaisonRT.Mur.n,
        m=paraMaisonRT.Mur.m,
        mat=paraMaisonRT.Mur.mat,
        e=paraMaisonRT.Mur.e,
        positionIsolant=paraMaisonRT.Mur.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        mat=paraMaisonRT.Cloisons.mat,
        e=paraMaisonRT.Cloisons.e,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      Refends(
        n=paraMaisonRT.Refends.n,
        m=paraMaisonRT.Refends.m,
        mat=paraMaisonRT.Refends.mat,
        e=paraMaisonRT.Refends.e,
        positionIsolant=paraMaisonRT.Refends.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      transmissionMenuiseriePortesFenetres=paraMaisonRT.transmissionMenuiseriePortesFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bSousCombles=paraMaisonRT.bSousCombles),
    GLOEXT=GLOEXT,
    CLOintPlancher=CLOintPlancher,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    useVoletPF=useVoletPF,
    useOuverturePF=useOuverturePF,
    useReduction1=useReduction1,
    TypeFenetrePF1=TypeFenetrePF1,
    voilage1=voilage1,
    position1=position1,
    rideaux1=rideaux1,
    ombrages1=ombrages1,
    r11=r11,
    r21=r21,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsC3,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{58,-87},{86,-57}})));

  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones.ZoneBathroom zoneSDB3_1(
    paraMaisonRT(
      ParoiSousCombles(
        n=paraMaisonRT.ParoiSousCombles.n,
        m=paraMaisonRT.ParoiSousCombles.m,
        mat=paraMaisonRT.ParoiSousCombles.mat,
        e=paraMaisonRT.ParoiSousCombles.e,
        positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        mat=paraMaisonRT.Porte.mat,
        e=paraMaisonRT.Porte.e,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PlancherBas(
        n=paraMaisonRT.PlancherBas.n,
        m=paraMaisonRT.PlancherBas.m,
        mat=paraMaisonRT.PlancherBas.mat,
        e=paraMaisonRT.PlancherBas.e,
        positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
      Mur(
        n=paraMaisonRT.Mur.n,
        m=paraMaisonRT.Mur.m,
        mat=paraMaisonRT.Mur.mat,
        e=paraMaisonRT.Mur.e,
        positionIsolant=paraMaisonRT.Mur.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        mat=paraMaisonRT.Cloisons.mat,
        e=paraMaisonRT.Cloisons.e,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      Refends(
        n=paraMaisonRT.Refends.n,
        m=paraMaisonRT.Refends.m,
        mat=paraMaisonRT.Refends.mat,
        e=paraMaisonRT.Refends.e,
        positionIsolant=paraMaisonRT.Refends.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      transmissionMenuiseriePortesFenetres=paraMaisonRT.transmissionMenuiseriePortesFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bSousCombles=paraMaisonRT.bSousCombles),
    GLOEXT=GLOEXT,
    CLOintPlancher=CLOintPlancher,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    useVolet=useVolet,
    useReduction=useReduction,
    TypeFenetrePF=TypeFenetrePF,
    voilage=voilage,
    position=position,
    rideaux=rideaux,
    ombrages=ombrages,
    r1=r1,
    r2=r2,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsSDB,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{25,-87},{49,-61}})));

  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones.ZoneEntrance zoneEntree3_1(
    paraMaisonRT(
      ParoiSousCombles(
        n=paraMaisonRT.ParoiSousCombles.n,
        m=paraMaisonRT.ParoiSousCombles.m,
        mat=paraMaisonRT.ParoiSousCombles.mat,
        e=paraMaisonRT.ParoiSousCombles.e,
        positionIsolant=paraMaisonRT.ParoiSousCombles.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        mat=paraMaisonRT.Porte.mat,
        e=paraMaisonRT.Porte.e,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PlancherBas(
        n=paraMaisonRT.PlancherBas.n,
        m=paraMaisonRT.PlancherBas.m,
        mat=paraMaisonRT.PlancherBas.mat,
        e=paraMaisonRT.PlancherBas.e,
        positionIsolant=paraMaisonRT.PlancherBas.positionIsolant),
      Mur(
        n=paraMaisonRT.Mur.n,
        m=paraMaisonRT.Mur.m,
        mat=paraMaisonRT.Mur.mat,
        e=paraMaisonRT.Mur.e,
        positionIsolant=paraMaisonRT.Mur.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        mat=paraMaisonRT.Cloisons.mat,
        e=paraMaisonRT.Cloisons.e,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      Refends(
        n=paraMaisonRT.Refends.n,
        m=paraMaisonRT.Refends.m,
        mat=paraMaisonRT.Refends.mat,
        e=paraMaisonRT.Refends.e,
        positionIsolant=paraMaisonRT.Refends.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      transmissionMenuiseriePortesFenetres=paraMaisonRT.transmissionMenuiseriePortesFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bSousCombles=paraMaisonRT.bSousCombles),
    GLOEXT=GLOEXT,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsEntree,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{2,-54},{50,-6}})));

// Internal vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall CloisonEntreeCuisine(
    ParoiInterne=true,
    RadInterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeCuisine,
    RadExterne=false) annotation (Placement(transformation(
        extent={{-3,-2.5},{3,2.5}},
        rotation=90,
        origin={4.5,-11})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall CloisonEntreeChambre1(
    ParoiInterne=true,
    RadInterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeC1,
    RadExterne=false) annotation (Placement(transformation(
        extent={{-3,-2.5},{3,2.5}},
        rotation=90,
        origin={38.5,-11})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall CloisonEntreeChambre2(
    ParoiInterne=true,
    RadInterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeC2,
    RadExterne=false) annotation (Placement(transformation(
        extent={{-3,-2.5},{3,2.5}},
        rotation=90,
        origin={70.5,-11})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine(
    ParoiInterne=true,
    RadInterne=not CLOintPlancher,
    RadExterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegC1Cuisine)
    annotation (Placement(transformation(
        extent={{-3,-2.5},{3,2.5}},
        rotation=0,
        origin={22.5,1})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Chambre2(
    ParoiInterne=true,
    RadInterne=not CLOintPlancher,
    RadExterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegC1C2)
    annotation (Placement(transformation(
        extent={{-3,-2.5},{3,2.5}},
        rotation=0,
        origin={56.5,1})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall CloisonChambre3SDB(
    ParoiInterne=true,
    RadInterne=not CLOintPlancher,
    RadExterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegC3SDB)
    annotation (Placement(transformation(
        extent={{-3,-2.5},{3,2.5}},
        rotation=0,
        origin={52.5,-69})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall CloisonEntreeChambre3(
    ParoiInterne=true,
    RadExterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeC3,
    RadInterne=false) annotation (Placement(transformation(
        extent={{-3,-2.5},{3,2.5}},
        rotation=90,
        origin={68.5,-53})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall CloisonEntreeSDB(
    ParoiInterne=true,
    RadExterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Cloisons.n,
      m=paraMaisonRT.Cloisons.m,
      e=paraMaisonRT.Cloisons.e,
      mat=paraMaisonRT.Cloisons.mat,
      positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeSDB,
    RadInterne=false) annotation (Placement(transformation(
        extent={{-3,-2.5},{3,2.5}},
        rotation=90,
        origin={42.5,-41})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall RefendSejourCuisine(
    ParoiInterne=true,
    RadInterne=not CLOintPlancher,
    RadExterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Refends.n,
      m=paraMaisonRT.Refends.m,
      e=paraMaisonRT.Refends.e,
      mat=paraMaisonRT.Refends.mat,
      positionIsolant=paraMaisonRT.Refends.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_RefendSejourCuisine)
    annotation (Placement(transformation(
        extent={{-2.5,-3},{2.5,3}},
        rotation=0,
        origin={-9.5,7})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall RefendEntreeSejour(
    ParoiInterne=true,
    RadExterne=not CLOintPlancher,
    Tp=Tp,
    InitType=InitType,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    caracParoi(
      n=paraMaisonRT.Refends.n,
      m=paraMaisonRT.Refends.m,
      e=paraMaisonRT.Refends.e,
      mat=paraMaisonRT.Refends.mat,
      positionIsolant=paraMaisonRT.Refends.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_RefendEntreeSejour,
    RadInterne=false) annotation (Placement(transformation(
        extent={{-2.5,-3},{2.5,3}},
        rotation=0,
        origin={-9.5,-25})));

// Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if                     GLOEXT==true
    annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{-120,-40},{-100,-20}})));

// Base components
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Solar azimuth angle , Solar elevation angle"
      annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta)
    annotation (Placement(transformation(extent={{-86,56},{-66,76}})));
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{-120,0},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput V[2] if useOuverture or useOuverturePF
    "Wind speed (m/s) and  direction (from 0° - North, 90° - East, 180° - South, 270 ° - West)"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true "[m3/h]"
    annotation (Placement(transformation(extent={{-120,-80},{-80,-40}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tsejour
    annotation (Placement(transformation(extent={{-80,-110},{-70,-100}}),
        iconTransformation(extent={{-26,-14},{-18,-6}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tcuisine
    annotation (Placement(transformation(extent={{-60,-110},{-50,-100}}),
        iconTransformation(extent={{8,16},{16,24}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tchambre1
    annotation (Placement(transformation(extent={{-40,-110},{-30,-100}}),
        iconTransformation(extent={{34,32},{42,40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tchambre2
    annotation (Placement(transformation(extent={{-20,-110},{-10,-100}}),
        iconTransformation(extent={{64,32},{72,40}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tchambre3
    annotation (Placement(transformation(extent={{0,-110},{10,-100}}),
        iconTransformation(extent={{64,-20},{72,-12}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a TsalleDeBain
    annotation (Placement(transformation(extent={{20,-110},{30,-100}}),
        iconTransformation(extent={{32,-28},{40,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tentree
    annotation (Placement(transformation(extent={{40,-110},{50,-100}}),
        iconTransformation(extent={{6,-18},{14,-10}})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureSejour[2] if   useOuverturePF
    "Opening of south, west windows (true = open, false = closed)"
                                         annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-60,100}), iconTransformation(extent={{-54,34},{-44,44}})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureCuisine[1] if  useOuverture
    "Opening of north windows (true = open, false = closed)"
                                   annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-40,100}), iconTransformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={9,51})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureChambre1[1] if useOuverture
    "Opening of north windows (true = open, false = closed)"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-20,100}),
        iconTransformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={33,51})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureChambre2[1] if useOuverturePF
    "Opening of east windows (true = open, false = closed)"
                                  annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,100}), iconTransformation(extent={{92,26},{82,36}})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureChambre3[2] if useOuverturePF
    "Opening of south, east windows (true = open, false = closed)"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={20,100}),
        iconTransformation(extent={{-5,-5},{5,5}},
        rotation=90,
        origin={59,-41})));
  Modelica.Blocks.Interfaces.RealInput fermetureSejour[2] if useVoletPF
    "Closing of south, west shutters (0 - open, 1 - closed)"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-50,100}),
        iconTransformation(extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-49,29})));
  Modelica.Blocks.Interfaces.RealInput fermetureCuisine[1] if
                                                             useVolet
    "Closing of north shutters (0 - open, 1 - closed)"
                                annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-30,100}), iconTransformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={19,51})));
  Modelica.Blocks.Interfaces.RealInput fermetureChambre1[1] if
                                                             useVolet
    "Closing of north shutters (0 - open, 1 - closed)"
                                annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-10,100}), iconTransformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={43,51})));
  Modelica.Blocks.Interfaces.RealInput fermetureChambre2[1] if
                                                             useVoletPF
    "Closing of east shutters (0 - open, 1 - closed)"
                               annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={10,100}), iconTransformation(extent={{92,16},{82,26}})));
  Modelica.Blocks.Interfaces.RealInput fermetureChambre3[2] if
                                                             useVoletPF
    "Closing of south, east shutters (0 - open, 1 - closed)"
                                    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={30,100}), iconTransformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={67,-41})));
  Modelica.Blocks.Interfaces.RealInput fermetureSDB[1] if    useVolet
    "Closing of south shutters (0 - open, 1 - closed)"
                               annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={50,100}), iconTransformation(
        extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={33,-43})));
  BuildSysPro.BoundaryConditions.Weather.ZoneWind vENTzone(beta=beta) if
                                                                  useOuverture or useOuverturePF
    annotation (Placement(transformation(extent={{-96,-36},{-76,-16}})));
equation
  if CLOintPlancher==false then
  connect(zoneSejour3_1.FLUXrefendCuisine, RefendSejourCuisine.FluxAbsExt)
    annotation (Line(
      points={{-13.2,14.1818},{-13.2,11.0909},{-10.25,11.0909},{-10.25,8.5}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(zoneCuisine3_1.FLUXrefendSejour, RefendSejourCuisine.FluxAbsInt)
    annotation (Line(
      points={{-3.9,12.5455},{-3.9,10.2728},{-8.75,10.2728},{-8.75,8.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneSejour3_1.FLUXrefendEntree, RefendEntreeSejour.FluxAbsExt)
    annotation (Line(
      points={{-13.2,-12.1818},{-13.2,-18.0909},{-10.25,-18.0909},{-10.25,-23.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneCuisine3_1.FLUXcloisonEntree, CloisonEntreeCuisine.FluxAbsInt)
    annotation (Line(
      points={{8,-4.45455},{8,-6},{3.25,-6},{3.25,-10.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneCuisine3_1.FLUXcloisonC1, CloisonChambre1Cuisine.FluxAbsExt)
    annotation (Line(
      points={{19.9,12.5455},{19.9,7.27275},{21.6,7.27275},{21.6,2.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneC1_3_1.FLUXcloisonCuisine, CloisonChambre1Cuisine.FluxAbsInt)
    annotation (Line(
      points={{28.8,10.3636},{28.8,6.1818},{23.4,6.1818},{23.4,2.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneC1_3_1.FLUXcloisonC2, CloisonChambre1Chambre2.FluxAbsExt)
    annotation (Line(
      points={{51.2,10.3636},{51.2,6.1818},{55.6,6.1818},{55.6,2.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneC2_3_1.FLUXcloisonC1, CloisonChambre1Chambre2.FluxAbsInt)
    annotation (Line(
      points={{61.1,10.6364},{61.1,6.3182},{57.4,6.3182},{57.4,2.25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneC2_3_1.FLUXcloisonEntree, CloisonEntreeChambre2.FluxAbsInt)
    annotation (Line(
      points={{71.3,-4.09091},{71.3,-7.04546},{69.25,-7.04546},{69.25,-10.1}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(zoneC3_3_1.FLUXcloisonEntree, CloisonEntreeChambre3.FluxAbsExt)
    annotation (Line(
      points={{72,-61.0909},{70,-61.0909},{70,-60},{67.25,-60},{67.25,-53.9}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(zoneSDB3_1.FLUXcloisonC3, CloisonChambre3SDB.FluxAbsExt)
    annotation (Line(
      points={{47.8,-72.8182},{47.8,-70.4091},{51.6,-70.4091},{51.6,-67.75}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(zoneC3_3_1.FLUXcloisonSDB, CloisonChambre3SDB.FluxAbsInt)
    annotation (Line(
      points={{59.4,-73.3636},{56.7,-73.3636},{56.7,-67.75},{53.4,-67.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneSDB3_1.FLUXcloisonEntree, CloisonEntreeSDB.FluxAbsExt)
    annotation (Line(
      points={{37,-62.1818},{41.25,-62.1818},{41.25,-41.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneC1_3_1.FLUXcloisonEntree, CloisonEntreeChambre1.FluxAbsInt)
    annotation (Line(
      points={{40,-4.36364},{40,-6},{37.25,-6},{37.25,-10.1}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if GLOEXT==true then
  connect(Tciel, zoneSejour3_1.Tciel) annotation (Line(
      points={{-90,10},{-78,10},{-78,-14.8182},{-51.6,-14.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tciel, zoneEntree3_1.Tciel) annotation (Line(
      points={{-90,10},{-78,10},{-78,-58},{38,-58},{38,-51.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tciel, zoneSDB3_1.Tciel) annotation (Line(
      points={{-90,10},{-78,10},{-78,-90},{45.4,-90},{45.4,-85.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tciel, zoneC3_3_1.Tciel) annotation (Line(
      points={{-90,10},{-78,10},{-78,-90},{81.8,-90},{81.8,-85.6364}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tciel, zoneCuisine3_1.Tciel) annotation (Line(
      points={{-90,10},{-78,10},{-78,40},{19.9,40},{19.9,26.4545}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(Tciel, zoneC1_3_1.Tciel) annotation (Line(
      points={{-90,10},{-78,10},{-78,40},{51.2,40},{51.2,28.3636}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tciel, zoneC2_3_1.Tciel) annotation (Line(
      points={{-90,10},{-78,10},{-78,40},{100,40},{100,-0.818182},{88.3,
            -0.818182}},
      color={191,0,0},
      smooth=Smooth.None));
  end if;

 connect(fLUXzone.G, G) annotation (Line(
      points={{-86.3,66.5},{-86.3,90},{-120,90}},
      color={0,0,127},
      smooth=Smooth.None));
  if QVin==true then
connect(RenouvAir, zoneSejour3_1.RenouvAir) annotation (Line(
      points={{-100,-60},{-46,-60},{-46,5.48182},{-41.28,5.48182}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneEntree3_1.RenouvAir) annotation (Line(
      points={{-100,-60},{-46,-60},{-46,-42},{26,-42},{26,-37.4182}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneSDB3_1.RenouvAir) annotation (Line(
      points={{-100,-60},{-46,-60},{-46,-82},{42,-82},{42,-80},{42.16,-80},{
            42.16,-80.5}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneC3_3_1.RenouvAir) annotation (Line(
      points={{-100,-60},{-46,-60},{-46,-82},{86,-82},{86,-75.1364},{81.94,
            -75.1364}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneCuisine3_1.RenouvAir) annotation (Line(
      points={{-100,-60},{-46,-60},{-46,50},{12.25,50},{12.25,21.6636}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneC1_3_1.RenouvAir) annotation (Line(
      points={{-100,-60},{-46,-60},{-46,50},{44.48,50},{44.48,21.1636}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneC2_3_1.RenouvAir) annotation (Line(
      points={{-100,-60},{-46,-60},{-46,50},{69.43,50},{69.43,21.6}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useVolet then
connect(fermetureCuisine, zoneCuisine3_1.fermetureVolets) annotation (Line(
      points={{-30,100},{-30,80},{7.15,80},{7.15,21.6636}},
      color={0,0,127},
      smooth=Smooth.None));
connect(fermetureChambre1, zoneC1_3_1.fermetureVolets) annotation (Line(
      points={{-10,100},{-10,80},{39.36,80},{39.36,21.1636}},
      color={0,0,127},
      smooth=Smooth.None));
connect(fermetureSDB, zoneSDB3_1.fermetureVolets) annotation (Line(
      points={{50,100},{50,80},{84,80},{84,-80.5},{38.32,-80.5}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useVoletPF then
   connect(fermetureSejour, zoneSejour3_1.fermetureVolets) annotation (Line(
      points={{-50,100},{-50,80},{-41.28,80},{-41.28,11.2818}},
      color={0,0,127},
      smooth=Smooth.None));
connect(fermetureChambre3, zoneC3_3_1.fermetureVolets) annotation (Line(
      points={{30,100},{30,80},{84,80},{84,-79.6364},{72.28,-79.6364}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useOuverture then
connect(ouvertureCuisine, zoneCuisine3_1.ouvertureFenetres) annotation (Line(
        points={{-40,100},{-40,80},{4.43,80},{4.43,21.6636}},
        color={255,0,255},
        smooth=Smooth.None));
connect(ouvertureChambre1, zoneC1_3_1.ouvertureFenetres) annotation (Line(
        points={{-20,100},{-20,80},{36.8,80},{36.8,21.1636}},
        color={255,0,255},
        smooth=Smooth.None));
  end if;

  if useOuverturePF then
connect(ouvertureChambre2, zoneC2_3_1.ouvertureFenetres) annotation (Line(
        points={{0,100},{0,80},{84,80},{84,12.2727},{80.82,12.2727}},
        color={255,0,255},
        smooth=Smooth.None));
connect(ouvertureChambre3, zoneC3_3_1.ouvertureFenetres) annotation (Line(
        points={{20,100},{20,80},{84,80},{84,-79.6364},{70.32,-79.6364}},
        color={255,0,255},
        smooth=Smooth.None));
  end if;

  connect(fLUXzone.FLUXNord, zoneSejour3_1.FluxNord) annotation (Line(
      points={{-65,70.2},{-51.12,70.2},{-51.12,24.9909}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, zoneSejour3_1.FluxSud) annotation (Line(
      points={{-65,66.4},{-51.12,66.4},{-51.12,19.1909}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXouest, zoneSejour3_1.FluxOuest) annotation (Line(
      points={{-65,58.4},{-51.12,58.4},{-51.12,13.9182}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, zoneCuisine3_1.FluxNord) annotation (Line(
      points={{-65,70.2},{1.2,70.2},{1.2,26.1455}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, zoneC1_3_1.FluxNord) annotation (Line(
      points={{-65,70.2},{33.6,70.2},{33.6,28.0364}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXNord, zoneC2_3_1.FluxNord) annotation (Line(
      points={{-65,70.2},{87.96,70.2},{87.96,20.4545}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, zoneC2_3_1.FluxEst) annotation (Line(
      points={{-65,62.4},{87.96,62.4},{87.96,17.1818}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, zoneEntree3_1.FluxSud) annotation (Line(
      points={{-65,66.4},{-62,66.4},{-62,-52},{11.12,-52},{11.12,-51.3818}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, zoneEntree3_1.FluxEst) annotation (Line(
      points={{-65,62.4},{-62,62.4},{-62,-51.3818},{16.4,-51.3818}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, zoneSDB3_1.FluxSud) annotation (Line(
      points={{-65,66.4},{-62,66.4},{-62,-85.5818},{31.24,-85.5818}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXSud, zoneC3_3_1.FluxSud) annotation (Line(
      points={{-65,66.4},{-62,66.4},{-62,-85.3636},{63.6,-85.3636}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FLUXEst, zoneC3_3_1.FluxEst) annotation (Line(
      points={{-65,62.4},{-62,62.4},{-62,-85.3636},{66.4,-85.3636}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(Text, zoneSejour3_1.Text) annotation (Line(
      points={{-90,40},{-74,40},{-74,-4.27273},{-51.6,-4.27273}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, zoneEntree3_1.Text) annotation (Line(
      points={{-90,40},{-74,40},{-74,-58},{28.4,-58},{28.4,-51.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, zoneSDB3_1.Text) annotation (Line(
      points={{-90,40},{-74,40},{-74,-90},{-12,-90},{-12,-90},{40,-90},{40,-90},
          {40,-86},{40,-85.8182},{40.6,-85.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, zoneC3_3_1.Text) annotation (Line(
      points={{-90,40},{-74,40},{-74,-90},{76.2,-90},{76.2,-85.6364}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, zoneCuisine3_1.Text) annotation (Line(
      points={{-90,40},{13.1,40},{13.1,26.4545}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, zoneC1_3_1.Text) annotation (Line(
      points={{-90,40},{44.8,40},{44.8,28.3636}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, zoneC2_3_1.Text) annotation (Line(
      points={{-90,40},{100,40},{100,5.72727},{88.3,5.72727}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(CloisonEntreeCuisine.T_int, zoneCuisine3_1.TCuisine) annotation (Line(
      points={{5.25,-8.3},{5.25,2.85},{5.45,2.85},{5.45,13.7818}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonEntreeCuisine.T_ext, zoneEntree3_1.TEntree) annotation (Line(
      points={{5.25,-13.7},{5.25,-21.85},{10.4,-21.85},{10.4,-28.6909}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneCuisine3_1.TCuisine, CloisonChambre1Cuisine.T_ext) annotation (
      Line(
      points={{5.45,13.7818},{5.45,0.25},{19.8,0.25}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine.T_int, zoneC1_3_1.TC1) annotation (Line(
      points={{25.2,0.25},{39.2,0.25},{39.2,3.81818}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneC1_3_1.TC1, CloisonEntreeChambre1.T_int) annotation (Line(
      points={{39.2,3.81818},{39.2,-2.09091},{39.25,-2.09091},{39.25,-8.3}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonEntreeChambre1.T_ext, zoneEntree3_1.TEntree) annotation (Line(
      points={{39.25,-13.7},{39.25,-28.6909},{10.4,-28.6909}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneC1_3_1.TC1, CloisonChambre1Chambre2.T_ext) annotation (Line(
      points={{39.2,3.81818},{46,3.81818},{46,0.25},{53.8,0.25}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Chambre2.T_int, zoneC2_3_1.TC2) annotation (Line(
      points={{59.2,0.25},{62,0.25},{62,4.41818},{71.13,4.41818}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneC2_3_1.TC2, CloisonEntreeChambre2.T_int) annotation (Line(
      points={{71.13,4.41818},{71.13,-1.79091},{71.25,-1.79091},{71.25,-8.3}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonEntreeChambre2.T_ext, zoneEntree3_1.TEntree) annotation (Line(
      points={{71.25,-13.7},{71.25,-28.6909},{10.4,-28.6909}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneEntree3_1.TEntree, CloisonEntreeChambre3.T_int) annotation (Line(
      points={{10.4,-28.6909},{69.25,-28.6909},{69.25,-50.3}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonEntreeChambre3.T_ext, zoneC3_3_1.TC3) annotation (Line(
      points={{69.25,-55.7},{69.25,-62.85},{70.18,-62.85},{70.18,-68.1818}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneSDB3_1.TSDB, CloisonChambre3SDB.T_ext) annotation (Line(
      points={{37.84,-72.5818},{40,-72.5818},{40,-69.75},{49.8,-69.75}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre3SDB.T_int, zoneC3_3_1.TC3) annotation (Line(
      points={{55.2,-69.75},{63.6,-69.75},{63.6,-68.1818},{70.18,-68.1818}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneEntree3_1.TEntree, CloisonEntreeSDB.T_int) annotation (Line(
      points={{10.4,-28.6909},{43.25,-28.6909},{43.25,-38.3}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonEntreeSDB.T_ext, zoneSDB3_1.TSDB) annotation (Line(
      points={{43.25,-43.7},{43.25,-58.85},{37.84,-58.85},{37.84,-72.5818}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneSejour3_1.TSejour, RefendSejourCuisine.T_ext) annotation (Line(
      points={{-29.28,-7.96364},{-29.28,6.1},{-11.75,6.1}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(RefendSejourCuisine.T_int, zoneCuisine3_1.TCuisine) annotation (Line(
      points={{-7.25,6.1},{5.45,6.1},{5.45,13.7818}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneSejour3_1.TSejour, RefendEntreeSejour.T_ext) annotation (Line(
      points={{-29.28,-7.96364},{-29.28,-25.9},{-11.75,-25.9}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(RefendEntreeSejour.T_int, zoneEntree3_1.TEntree) annotation (Line(
      points={{-7.25,-25.9},{2.375,-25.9},{2.375,-28.6909},{10.4,-28.6909}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));

  connect(Tsejour, zoneSejour3_1.TSejour) annotation (Line(
      points={{-75,-105},{-75,-96},{-29.28,-96},{-29.28,-7.96364}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(Tcuisine, zoneCuisine3_1.TCuisine) annotation (Line(
      points={{-55,-105},{-55,-96},{5.45,-96},{5.45,13.7818}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(Tchambre1, zoneC1_3_1.TC1) annotation (Line(
      points={{-35,-105},{-35,-100},{-36,-100},{-36,-96},{108,-96},{108,56},{
          39.2,56},{39.2,3.81818}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(Tchambre2, zoneC2_3_1.TC2) annotation (Line(
      points={{-15,-105},{-15,-96},{108,-96},{108,56},{71.13,56},{71.13,4.41818}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(Tchambre3, zoneC3_3_1.TC3) annotation (Line(
      points={{5,-105},{5,-96},{70.18,-96},{70.18,-68.1818}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(TsalleDeBain, zoneSDB3_1.TSDB) annotation (Line(
      points={{25,-105},{25,-96},{37.84,-96},{37.84,-72.5818}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(Tentree, zoneEntree3_1.TEntree) annotation (Line(
      points={{45,-105},{45,-96},{10.4,-96},{10.4,-28.6909}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(fermetureChambre2, zoneC2_3_1.fermetureVolets) annotation (Line(
      points={{10,100},{10,80},{84,80},{84,10},{80,10},{80,9.98182},{80.82,
          9.98182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ouvertureSejour, zoneSejour3_1.ouvertureFenetres) annotation (Line(
      points={{-60,100},{-60,80},{-44,80},{-44,15.5},{-41.28,15.5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(V, vENTzone.V) annotation (Line(
      points={{-120,-20},{-110,-20},{-110,-26.1},{-96.9,-26.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTSud, zoneSejour3_1.VENTSud) annotation (Line(
      points={{-75,-25.6},{-66,-25.6},{-66,7.32727},{-51.12,7.32727}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTOuest, zoneSejour3_1.VENTOuest) annotation (Line(
      points={{-75,-33.6},{-66,-33.6},{-66,2.05455},{-51.12,2.05455}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTSud, zoneC3_3_1.VENTSud) annotation (Line(
      points={{-75,-25.6},{-66,-25.6},{-66,-92},{69.48,-92},{69.48,-85.6364}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTNord, zoneCuisine3_1.VENTNord) annotation (Line(
      points={{-75,-21.8},{-66,-21.8},{-66,34},{8,34},{8,26.4545}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTNord, zoneC1_3_1.VENTNord) annotation (Line(
      points={{-75,-21.8},{-66,-21.8},{-66,34},{40,34},{40,28.3636}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTEst, zoneC2_3_1.VENTEst) annotation (Line(
      points={{-75,-29.6},{-66,-29.6},{-66,34},{96,34},{96,10.6364},{88.3,
          10.6364}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(vENTzone.VENTEst, zoneC3_3_1.VENTEst) annotation (Line(
      points={{-75,-29.6},{-66,-29.6},{-66,-92},{72,-92},{72,-85.6364}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Bitmap(extent={{-100,78},{102,-62}}, fileName=
              "modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Mozart/Mozart.png"),
        Text(
          extent={{-69,-67},{122,-91}},
          lineColor={0,0,0},
          textString="Mozart Multizone"),
        Ellipse(
          extent={{-101,127},{-41,71}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-100,-66},{-72,-94}},
                                            lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-86,-50},
          rotation=360),
        Ellipse(
          extent={{-88,-78},{-84,-82}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-124,-136},
          rotation=180),
        Line(
          points={{-102,-70},{-86,-62},{-72,-70}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-72,-68},{-70,-72},{-74,-70},{-72,-68}},
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
          origin={-116,-80},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-86,-110},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-56,-80},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-101,-90},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i><b>Mozart Multizone individual housing</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Parameter <code>paraMaisonRT</code> allows the user to chose a specific French building regulation for the building, so that building envelope parameters (walls, windows, ventilation...) will be automatically filled with data from the choosen record.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>For dates of contruction from 1974 to 1989, insulating materials thicknesses in floors are different between building stock site and Clim 2000 (cf <a href=\"modelica://BuildSysPro.BuildingStock.Utilities.Records.WallData.IndividualHousing\">Records.WallData.IndividualHousing</a> documentation).</p>
<p><u><b>Validations</b></u></p>
<p>Validated model by comparison of GV with Clim 2000 - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 2.1.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MozartMultizone;
