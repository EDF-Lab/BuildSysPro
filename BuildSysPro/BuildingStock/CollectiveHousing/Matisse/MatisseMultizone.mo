within BuildSysPro.BuildingStock.CollectiveHousing.Matisse;
model MatisseMultizone
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
  parameter Modelica.SIunits.Temperature Tp=293.15 "Initial temperature of walls"
    annotation(Dialog(tab="Walls"));
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

 // Protected parameters
protected
  parameter Boolean EmplacementEst= if EmplacementAppartement==3 or EmplacementAppartement==6 or EmplacementAppartement==9 then true else false;
  parameter Boolean EmplacementOuest= if EmplacementAppartement==1 or EmplacementAppartement==4 or EmplacementAppartement==7 then true else false;
  parameter Boolean EmplacementHaut= if EmplacementAppartement<=3 then true else false;
  parameter Boolean EmplacementBas= if EmplacementAppartement>=7 then true else false;

// Zones
  BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseZones.ZoneLiving zoneSejour(
    paraMaisonRT(
      PlancherMitoyen(
        n=paraMaisonRT.PlancherMitoyen.n,
        m=paraMaisonRT.PlancherMitoyen.m,
        e=paraMaisonRT.PlancherMitoyen.e,
        mat=paraMaisonRT.PlancherMitoyen.mat,
        positionIsolant=paraMaisonRT.PlancherMitoyen.positionIsolant),
      PlafondMitoyen(
        n=paraMaisonRT.PlafondMitoyen.n,
        m=paraMaisonRT.PlafondMitoyen.m,
        e=paraMaisonRT.PlafondMitoyen.e,
        mat=paraMaisonRT.PlafondMitoyen.mat,
        positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        e=paraMaisonRT.Porte.e,
        mat=paraMaisonRT.Porte.mat,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PorteInt(
        n=paraMaisonRT.PorteInt.n,
        m=paraMaisonRT.PorteInt.m,
        e=paraMaisonRT.PorteInt.e,
        mat=paraMaisonRT.PorteInt.mat,
        positionIsolant=paraMaisonRT.PorteInt.positionIsolant),
      MurExt(
        n=paraMaisonRT.MurExt.n,
        m=paraMaisonRT.MurExt.m,
        e=paraMaisonRT.MurExt.e,
        mat=paraMaisonRT.MurExt.mat,
        positionIsolant=paraMaisonRT.MurExt.positionIsolant),
      MurMitoyen(
        n=paraMaisonRT.MurMitoyen.n,
        m=paraMaisonRT.MurMitoyen.m,
        e=paraMaisonRT.MurMitoyen.e,
        mat=paraMaisonRT.MurMitoyen.mat,
        positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
      MurPalier(
        n=paraMaisonRT.MurPalier.n,
        m=paraMaisonRT.MurPalier.m,
        e=paraMaisonRT.MurPalier.e,
        mat=paraMaisonRT.MurPalier.mat,
        positionIsolant=paraMaisonRT.MurPalier.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        e=paraMaisonRT.Cloisons.e,
        mat=paraMaisonRT.Cloisons.mat,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      PlafondImmeuble(
        n=paraMaisonRT.PlafondImmeuble.n,
        m=paraMaisonRT.PlafondImmeuble.m,
        e=paraMaisonRT.PlafondImmeuble.e,
        mat=paraMaisonRT.PlafondImmeuble.mat,
        positionIsolant=paraMaisonRT.PlafondImmeuble.positionIsolant),
      PlancherImmeuble(
        n=paraMaisonRT.PlancherImmeuble.n,
        m=paraMaisonRT.PlancherImmeuble.m,
        e=paraMaisonRT.PlancherImmeuble.e,
        mat=paraMaisonRT.PlancherImmeuble.mat,
        positionIsolant=paraMaisonRT.PlancherImmeuble.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsExtHor=paraMaisonRT.hsExtHor,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      ValeursKPlafond=paraMaisonRT.ValeursKPlafond,
      TauPontsPlafond=paraMaisonRT.TauPontsPlafond,
      ValeursKPlancher=paraMaisonRT.ValeursKPlancher,
      TauPontsPlancher=paraMaisonRT.TauPontsPlancher,
      PontsTh_Generique=paraMaisonRT.PontsTh_Generique,
      PontsTh_Bas=paraMaisonRT.PontsTh_Bas,
      PontsTh_Haut=paraMaisonRT.PontsTh_Haut,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bPlafond=paraMaisonRT.bPlafond),
    EmplacementAppartement=EmplacementAppartement,
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
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPontsSejour,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{-70,-40},{-28,4}})));

  BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseZones.ZoneKitchen zoneCuisine(
    paraMaisonRT(
      PlancherMitoyen(
        n=paraMaisonRT.PlancherMitoyen.n,
        m=paraMaisonRT.PlancherMitoyen.m,
        e=paraMaisonRT.PlancherMitoyen.e,
        mat=paraMaisonRT.PlancherMitoyen.mat,
        positionIsolant=paraMaisonRT.PlancherMitoyen.positionIsolant),
      PlafondMitoyen(
        n=paraMaisonRT.PlafondMitoyen.n,
        m=paraMaisonRT.PlafondMitoyen.m,
        e=paraMaisonRT.PlafondMitoyen.e,
        mat=paraMaisonRT.PlafondMitoyen.mat,
        positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        e=paraMaisonRT.Porte.e,
        mat=paraMaisonRT.Porte.mat,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PorteInt(
        n=paraMaisonRT.PorteInt.n,
        m=paraMaisonRT.PorteInt.m,
        e=paraMaisonRT.PorteInt.e,
        mat=paraMaisonRT.PorteInt.mat,
        positionIsolant=paraMaisonRT.PorteInt.positionIsolant),
      MurExt(
        n=paraMaisonRT.MurExt.n,
        m=paraMaisonRT.MurExt.m,
        e=paraMaisonRT.MurExt.e,
        mat=paraMaisonRT.MurExt.mat,
        positionIsolant=paraMaisonRT.MurExt.positionIsolant),
      MurMitoyen(
        n=paraMaisonRT.MurMitoyen.n,
        m=paraMaisonRT.MurMitoyen.m,
        e=paraMaisonRT.MurMitoyen.e,
        mat=paraMaisonRT.MurMitoyen.mat,
        positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
      MurPalier(
        n=paraMaisonRT.MurPalier.n,
        m=paraMaisonRT.MurPalier.m,
        e=paraMaisonRT.MurPalier.e,
        mat=paraMaisonRT.MurPalier.mat,
        positionIsolant=paraMaisonRT.MurPalier.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        e=paraMaisonRT.Cloisons.e,
        mat=paraMaisonRT.Cloisons.mat,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      PlafondImmeuble(
        n=paraMaisonRT.PlafondImmeuble.n,
        m=paraMaisonRT.PlafondImmeuble.m,
        e=paraMaisonRT.PlafondImmeuble.e,
        mat=paraMaisonRT.PlafondImmeuble.mat,
        positionIsolant=paraMaisonRT.PlafondImmeuble.positionIsolant),
      PlancherImmeuble(
        n=paraMaisonRT.PlancherImmeuble.n,
        m=paraMaisonRT.PlancherImmeuble.m,
        e=paraMaisonRT.PlancherImmeuble.e,
        mat=paraMaisonRT.PlancherImmeuble.mat,
        positionIsolant=paraMaisonRT.PlancherImmeuble.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsExtHor=paraMaisonRT.hsExtHor,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      ValeursKPlafond=paraMaisonRT.ValeursKPlafond,
      TauPontsPlafond=paraMaisonRT.TauPontsPlafond,
      ValeursKPlancher=paraMaisonRT.ValeursKPlancher,
      TauPontsPlancher=paraMaisonRT.TauPontsPlancher,
      PontsTh_Generique=paraMaisonRT.PontsTh_Generique,
      PontsTh_Bas=paraMaisonRT.PontsTh_Bas,
      PontsTh_Haut=paraMaisonRT.PontsTh_Haut,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bPlafond=paraMaisonRT.bPlafond),
    EmplacementAppartement=EmplacementAppartement,
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
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPontsCuisine,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{-26,-28},{4,2}})));

  BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseZones.ZoneR1 zoneC1_1(
    paraMaisonRT(
      PlancherMitoyen(
        n=paraMaisonRT.PlancherMitoyen.n,
        m=paraMaisonRT.PlancherMitoyen.m,
        e=paraMaisonRT.PlancherMitoyen.e,
        mat=paraMaisonRT.PlancherMitoyen.mat,
        positionIsolant=paraMaisonRT.PlancherMitoyen.positionIsolant),
      PlafondMitoyen(
        n=paraMaisonRT.PlafondMitoyen.n,
        m=paraMaisonRT.PlafondMitoyen.m,
        e=paraMaisonRT.PlafondMitoyen.e,
        mat=paraMaisonRT.PlafondMitoyen.mat,
        positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        e=paraMaisonRT.Porte.e,
        mat=paraMaisonRT.Porte.mat,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PorteInt(
        n=paraMaisonRT.PorteInt.n,
        m=paraMaisonRT.PorteInt.m,
        e=paraMaisonRT.PorteInt.e,
        mat=paraMaisonRT.PorteInt.mat,
        positionIsolant=paraMaisonRT.PorteInt.positionIsolant),
      MurExt(
        n=paraMaisonRT.MurExt.n,
        m=paraMaisonRT.MurExt.m,
        e=paraMaisonRT.MurExt.e,
        mat=paraMaisonRT.MurExt.mat,
        positionIsolant=paraMaisonRT.MurExt.positionIsolant),
      MurMitoyen(
        n=paraMaisonRT.MurMitoyen.n,
        m=paraMaisonRT.MurMitoyen.m,
        e=paraMaisonRT.MurMitoyen.e,
        mat=paraMaisonRT.MurMitoyen.mat,
        positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
      MurPalier(
        n=paraMaisonRT.MurPalier.n,
        m=paraMaisonRT.MurPalier.m,
        e=paraMaisonRT.MurPalier.e,
        mat=paraMaisonRT.MurPalier.mat,
        positionIsolant=paraMaisonRT.MurPalier.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        e=paraMaisonRT.Cloisons.e,
        mat=paraMaisonRT.Cloisons.mat,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      PlafondImmeuble(
        n=paraMaisonRT.PlafondImmeuble.n,
        m=paraMaisonRT.PlafondImmeuble.m,
        e=paraMaisonRT.PlafondImmeuble.e,
        mat=paraMaisonRT.PlafondImmeuble.mat,
        positionIsolant=paraMaisonRT.PlafondImmeuble.positionIsolant),
      PlancherImmeuble(
        n=paraMaisonRT.PlancherImmeuble.n,
        m=paraMaisonRT.PlancherImmeuble.m,
        e=paraMaisonRT.PlancherImmeuble.e,
        mat=paraMaisonRT.PlancherImmeuble.mat,
        positionIsolant=paraMaisonRT.PlancherImmeuble.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsExtHor=paraMaisonRT.hsExtHor,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      ValeursKPlafond=paraMaisonRT.ValeursKPlafond,
      TauPontsPlafond=paraMaisonRT.TauPontsPlafond,
      ValeursKPlancher=paraMaisonRT.ValeursKPlancher,
      TauPontsPlancher=paraMaisonRT.TauPontsPlancher,
      PontsTh_Generique=paraMaisonRT.PontsTh_Generique,
      PontsTh_Bas=paraMaisonRT.PontsTh_Bas,
      PontsTh_Haut=paraMaisonRT.PontsTh_Haut,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bPlafond=paraMaisonRT.bPlafond),
    EmplacementAppartement=EmplacementAppartement,
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
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPontsC1,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{8,-28},{34,2}})));

  BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseZones.ZoneR2 zoneC2_1(
    paraMaisonRT(
      PlancherMitoyen(
        n=paraMaisonRT.PlancherMitoyen.n,
        m=paraMaisonRT.PlancherMitoyen.m,
        e=paraMaisonRT.PlancherMitoyen.e,
        mat=paraMaisonRT.PlancherMitoyen.mat,
        positionIsolant=paraMaisonRT.PlancherMitoyen.positionIsolant),
      PlafondMitoyen(
        n=paraMaisonRT.PlafondMitoyen.n,
        m=paraMaisonRT.PlafondMitoyen.m,
        e=paraMaisonRT.PlafondMitoyen.e,
        mat=paraMaisonRT.PlafondMitoyen.mat,
        positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        e=paraMaisonRT.Porte.e,
        mat=paraMaisonRT.Porte.mat,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PorteInt(
        n=paraMaisonRT.PorteInt.n,
        m=paraMaisonRT.PorteInt.m,
        e=paraMaisonRT.PorteInt.e,
        mat=paraMaisonRT.PorteInt.mat,
        positionIsolant=paraMaisonRT.PorteInt.positionIsolant),
      MurExt(
        n=paraMaisonRT.MurExt.n,
        m=paraMaisonRT.MurExt.m,
        e=paraMaisonRT.MurExt.e,
        mat=paraMaisonRT.MurExt.mat,
        positionIsolant=paraMaisonRT.MurExt.positionIsolant),
      MurMitoyen(
        n=paraMaisonRT.MurMitoyen.n,
        m=paraMaisonRT.MurMitoyen.m,
        e=paraMaisonRT.MurMitoyen.e,
        mat=paraMaisonRT.MurMitoyen.mat,
        positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
      MurPalier(
        n=paraMaisonRT.MurPalier.n,
        m=paraMaisonRT.MurPalier.m,
        e=paraMaisonRT.MurPalier.e,
        mat=paraMaisonRT.MurPalier.mat,
        positionIsolant=paraMaisonRT.MurPalier.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        e=paraMaisonRT.Cloisons.e,
        mat=paraMaisonRT.Cloisons.mat,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      PlafondImmeuble(
        n=paraMaisonRT.PlafondImmeuble.n,
        m=paraMaisonRT.PlafondImmeuble.m,
        e=paraMaisonRT.PlafondImmeuble.e,
        mat=paraMaisonRT.PlafondImmeuble.mat,
        positionIsolant=paraMaisonRT.PlafondImmeuble.positionIsolant),
      PlancherImmeuble(
        n=paraMaisonRT.PlancherImmeuble.n,
        m=paraMaisonRT.PlancherImmeuble.m,
        e=paraMaisonRT.PlancherImmeuble.e,
        mat=paraMaisonRT.PlancherImmeuble.mat,
        positionIsolant=paraMaisonRT.PlancherImmeuble.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsExtHor=paraMaisonRT.hsExtHor,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      ValeursKPlafond=paraMaisonRT.ValeursKPlafond,
      TauPontsPlafond=paraMaisonRT.TauPontsPlafond,
      ValeursKPlancher=paraMaisonRT.ValeursKPlancher,
      TauPontsPlancher=paraMaisonRT.TauPontsPlancher,
      PontsTh_Generique=paraMaisonRT.PontsTh_Generique,
      PontsTh_Bas=paraMaisonRT.PontsTh_Bas,
      PontsTh_Haut=paraMaisonRT.PontsTh_Haut,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bPlafond=paraMaisonRT.bPlafond),
    EmplacementAppartement=EmplacementAppartement,
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
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPontsC2,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{40,-28},{66,2}})));

  BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseZones.ZoneBathroom zoneSDB(
    paraMaisonRT(
      PlancherMitoyen(
        n=paraMaisonRT.PlancherMitoyen.n,
        m=paraMaisonRT.PlancherMitoyen.m,
        e=paraMaisonRT.PlancherMitoyen.e,
        mat=paraMaisonRT.PlancherMitoyen.mat,
        positionIsolant=paraMaisonRT.PlancherMitoyen.positionIsolant),
      PlafondMitoyen(
        n=paraMaisonRT.PlafondMitoyen.n,
        m=paraMaisonRT.PlafondMitoyen.m,
        e=paraMaisonRT.PlafondMitoyen.e,
        mat=paraMaisonRT.PlafondMitoyen.mat,
        positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        e=paraMaisonRT.Porte.e,
        mat=paraMaisonRT.Porte.mat,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PorteInt(
        n=paraMaisonRT.PorteInt.n,
        m=paraMaisonRT.PorteInt.m,
        e=paraMaisonRT.PorteInt.e,
        mat=paraMaisonRT.PorteInt.mat,
        positionIsolant=paraMaisonRT.PorteInt.positionIsolant),
      MurExt(
        n=paraMaisonRT.MurExt.n,
        m=paraMaisonRT.MurExt.m,
        e=paraMaisonRT.MurExt.e,
        mat=paraMaisonRT.MurExt.mat,
        positionIsolant=paraMaisonRT.MurExt.positionIsolant),
      MurMitoyen(
        n=paraMaisonRT.MurMitoyen.n,
        m=paraMaisonRT.MurMitoyen.m,
        e=paraMaisonRT.MurMitoyen.e,
        mat=paraMaisonRT.MurMitoyen.mat,
        positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
      MurPalier(
        n=paraMaisonRT.MurPalier.n,
        m=paraMaisonRT.MurPalier.m,
        e=paraMaisonRT.MurPalier.e,
        mat=paraMaisonRT.MurPalier.mat,
        positionIsolant=paraMaisonRT.MurPalier.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        e=paraMaisonRT.Cloisons.e,
        mat=paraMaisonRT.Cloisons.mat,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      PlafondImmeuble(
        n=paraMaisonRT.PlafondImmeuble.n,
        m=paraMaisonRT.PlafondImmeuble.m,
        e=paraMaisonRT.PlafondImmeuble.e,
        mat=paraMaisonRT.PlafondImmeuble.mat,
        positionIsolant=paraMaisonRT.PlafondImmeuble.positionIsolant),
      PlancherImmeuble(
        n=paraMaisonRT.PlancherImmeuble.n,
        m=paraMaisonRT.PlancherImmeuble.m,
        e=paraMaisonRT.PlancherImmeuble.e,
        mat=paraMaisonRT.PlancherImmeuble.mat,
        positionIsolant=paraMaisonRT.PlancherImmeuble.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsExtHor=paraMaisonRT.hsExtHor,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      ValeursKPlafond=paraMaisonRT.ValeursKPlafond,
      TauPontsPlafond=paraMaisonRT.TauPontsPlafond,
      ValeursKPlancher=paraMaisonRT.ValeursKPlancher,
      TauPontsPlancher=paraMaisonRT.TauPontsPlancher,
      PontsTh_Generique=paraMaisonRT.PontsTh_Generique,
      PontsTh_Bas=paraMaisonRT.PontsTh_Bas,
      PontsTh_Haut=paraMaisonRT.PontsTh_Haut,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bPlafond=paraMaisonRT.bPlafond),
    EmplacementAppartement=EmplacementAppartement,
    GLOEXT=GLOEXT,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPontsSDB,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{34,-74},{68,-34}})));

  BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseZones.ZoneEntrance zoneEntree(
    paraMaisonRT(
      PlancherMitoyen(
        n=paraMaisonRT.PlancherMitoyen.n,
        m=paraMaisonRT.PlancherMitoyen.m,
        e=paraMaisonRT.PlancherMitoyen.e,
        mat=paraMaisonRT.PlancherMitoyen.mat,
        positionIsolant=paraMaisonRT.PlancherMitoyen.positionIsolant),
      PlafondMitoyen(
        n=paraMaisonRT.PlafondMitoyen.n,
        m=paraMaisonRT.PlafondMitoyen.m,
        e=paraMaisonRT.PlafondMitoyen.e,
        mat=paraMaisonRT.PlafondMitoyen.mat,
        positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant),
      Porte(
        n=paraMaisonRT.Porte.n,
        m=paraMaisonRT.Porte.m,
        e=paraMaisonRT.Porte.e,
        mat=paraMaisonRT.Porte.mat,
        positionIsolant=paraMaisonRT.Porte.positionIsolant),
      PorteInt(
        n=paraMaisonRT.PorteInt.n,
        m=paraMaisonRT.PorteInt.m,
        e=paraMaisonRT.PorteInt.e,
        mat=paraMaisonRT.PorteInt.mat,
        positionIsolant=paraMaisonRT.PorteInt.positionIsolant),
      MurExt(
        n=paraMaisonRT.MurExt.n,
        m=paraMaisonRT.MurExt.m,
        e=paraMaisonRT.MurExt.e,
        mat=paraMaisonRT.MurExt.mat,
        positionIsolant=paraMaisonRT.MurExt.positionIsolant),
      MurMitoyen(
        n=paraMaisonRT.MurMitoyen.n,
        m=paraMaisonRT.MurMitoyen.m,
        e=paraMaisonRT.MurMitoyen.e,
        mat=paraMaisonRT.MurMitoyen.mat,
        positionIsolant=paraMaisonRT.MurMitoyen.positionIsolant),
      MurPalier(
        n=paraMaisonRT.MurPalier.n,
        m=paraMaisonRT.MurPalier.m,
        e=paraMaisonRT.MurPalier.e,
        mat=paraMaisonRT.MurPalier.mat,
        positionIsolant=paraMaisonRT.MurPalier.positionIsolant),
      Cloisons(
        n=paraMaisonRT.Cloisons.n,
        m=paraMaisonRT.Cloisons.m,
        e=paraMaisonRT.Cloisons.e,
        mat=paraMaisonRT.Cloisons.mat,
        positionIsolant=paraMaisonRT.Cloisons.positionIsolant),
      PlafondImmeuble(
        n=paraMaisonRT.PlafondImmeuble.n,
        m=paraMaisonRT.PlafondImmeuble.m,
        e=paraMaisonRT.PlafondImmeuble.e,
        mat=paraMaisonRT.PlafondImmeuble.mat,
        positionIsolant=paraMaisonRT.PlafondImmeuble.positionIsolant),
      PlancherImmeuble(
        n=paraMaisonRT.PlancherImmeuble.n,
        m=paraMaisonRT.PlancherImmeuble.m,
        e=paraMaisonRT.PlancherImmeuble.e,
        mat=paraMaisonRT.PlancherImmeuble.mat,
        positionIsolant=paraMaisonRT.PlancherImmeuble.positionIsolant),
      alphaExt=paraMaisonRT.alphaExt,
      eps=paraMaisonRT.eps,
      hsExtVert=paraMaisonRT.hsExtVert,
      hsIntVert=paraMaisonRT.hsIntVert,
      hsExtHor=paraMaisonRT.hsExtHor,
      hsIntHorHaut=paraMaisonRT.hsIntHorHaut,
      hsIntHorBas=paraMaisonRT.hsIntHorBas,
      UvitrageAF=paraMaisonRT.UvitrageAF,
      UvitrageSF=paraMaisonRT.UvitrageSF,
      transmissionMenuiserieFenetres=paraMaisonRT.transmissionMenuiserieFenetres,
      eps_vitrage=paraMaisonRT.eps_vitrage,
      renouvAir=paraMaisonRT.renouvAir,
      ValeursK=paraMaisonRT.ValeursK,
      TauPonts=paraMaisonRT.TauPonts,
      ValeursKPlafond=paraMaisonRT.ValeursKPlafond,
      TauPontsPlafond=paraMaisonRT.TauPontsPlafond,
      ValeursKPlancher=paraMaisonRT.ValeursKPlancher,
      TauPontsPlancher=paraMaisonRT.TauPontsPlancher,
      PontsTh_Generique=paraMaisonRT.PontsTh_Generique,
      PontsTh_Bas=paraMaisonRT.PontsTh_Bas,
      PontsTh_Haut=paraMaisonRT.PontsTh_Haut,
      bLNC=paraMaisonRT.bLNC,
      bPlancher=paraMaisonRT.bPlancher,
      bPlafond=paraMaisonRT.bPlafond),
    EmplacementAppartement=EmplacementAppartement,
    GLOEXT=GLOEXT,
    QVin=QVin,
    Tp=Tp,
    InitType=InitType,
    G_ponts=BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
        ValeursK=paraMaisonRT.ValeursK,
        LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPontsEntree,
        TauPonts=paraMaisonRT.TauPonts))
    annotation (Placement(transformation(extent={{-22,-68},{24,-20}})));

// Internal vertical walls
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegSejourCuisine)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=0,
        origin={-29.25,-17.25})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine1(
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
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegEntreeSejour)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=0,
        origin={-29.25,-33.25})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine2(
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegC1Cuisine)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=0,
        origin={2.75,-17.25})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine3(
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegC1C2)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=0,
        origin={36.75,-17.25})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine4(
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
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegC2SDB)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=-90,
        origin={58.75,-39.25})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine5(
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
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegEntreeC2)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=-90,
        origin={48.75,-39.25})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine6(
    ParoiInterne=true,
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
    RadInterne=false,
    RadExterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegEntreeSDB)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=0,
        origin={30.75,-45.25})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine7(
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
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegEntreeCuisine)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=-90,
        origin={-13.25,-33.25})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    CloisonChambre1Cuisine8(
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
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegEntreeC1)
    annotation (Placement(transformation(
        extent={{-2.75,-2.75},{2.75,2.75}},
        rotation=-90,
        origin={16.75,-35.25})));

// Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky if                     GLOEXT==true
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}}),
        iconTransformation(extent={{-120,-40},{-100,-20}})));

// Base components
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle"
      annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta)
    annotation (Placement(transformation(extent={{-86,36},{-66,56}})));

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext annotation (
      Placement(transformation(extent={{-100,10},{-80,30}}), iconTransformation(
          extent={{-120,0},{-100,20}})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true "[m3/h]"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealInput V[2] if useOuverture
    "Wind speed (m/s) and  direction (from 0° - North, 90° - East, 180° - South, 270 ° - West)"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,28},{-100,68}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_common
    "Temperature of adjacent housings" annotation (Placement(transformation(
          extent={{-64,68},{-56,76}}), iconTransformation(extent={{-108,-60},{-100,
            -52}})));

  Modelica.Blocks.Interfaces.BooleanInput ouvertureSejour[1] if   useOuverture
    "Opening of north windows"           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-60,100}), iconTransformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-65,51})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureCuisine[1] if  useOuverture
    "Opening of north windows"     annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-40,100}), iconTransformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-27,51})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureChambre1[1] if useOuverture
    "Opening of north windows"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-20,100}),
        iconTransformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={9,51})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureChambre2[1] if useOuverture
    "Opening of north windows"    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,100}), iconTransformation(extent={{5,-5},{-5,5}},
        rotation=90,
        origin={47,51})));
  Modelica.Blocks.Interfaces.RealInput fermetureSejour[1] if useVolet
    "Closing of north shutters"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-50,100}),
        iconTransformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-45,51})));
  Modelica.Blocks.Interfaces.RealInput fermetureCuisine[1] if
                                                             useVolet
    "Closing of north shutters"  annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-30,100}), iconTransformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={-17,51})));
  Modelica.Blocks.Interfaces.RealInput fermetureChambre1[1] if
                                                             useVolet
    "Closing of north shutters"  annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-10,100}), iconTransformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={19,51})));
  Modelica.Blocks.Interfaces.RealInput fermetureChambre2[1] if
                                                             useVolet
    "Closing of north shutters" annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={10,100}), iconTransformation(extent={{5,-5},{-5,5}},
        rotation=90,
        origin={57,51})));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_living
    annotation (Placement(transformation(extent={{-80,-110},{-70,-100}}),
        iconTransformation(extent={{-56,-4},{-48,4}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_kitchen
    annotation (Placement(transformation(extent={{-60,-110},{-50,-100}}),
        iconTransformation(extent={{-22,6},{-14,14}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_room1
    annotation (Placement(transformation(extent={{-40,-110},{-30,-100}}),
        iconTransformation(extent={{6,6},{14,14}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_room2
    annotation (Placement(transformation(extent={{-20,-110},{-10,-100}}),
        iconTransformation(extent={{42,6},{50,14}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_bathroom
    annotation (Placement(transformation(extent={{0,-110},{10,-100}}),
        iconTransformation(extent={{36,-28},{44,-20}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_entrance
    annotation (Placement(transformation(extent={{20,-110},{30,-100}}),
        iconTransformation(extent={{-20,-28},{-12,-20}})));
  BuildSysPro.BoundaryConditions.Weather.ZoneWind vENTzone(beta=beta) if
                                                                  useOuverture
    annotation (Placement(transformation(extent={{-94,-50},{-74,-30}})));
equation
  if CLOintPlancher == false then
connect(zoneSejour.FLUXcloisonCuisine, CloisonChambre1Cuisine.FluxAbsExt)
    annotation (Line(
      points={{-34.3,-16},{-32,-16},{-32,-15.875},{-30.075,-15.875}},
      color={0,0,127},
      smooth=Smooth.None));
connect(CloisonChambre1Cuisine.FluxAbsInt, zoneCuisine.FLUXcloisonEntree)
    annotation (Line(
      points={{-28.425,-15.875},{-26.2125,-15.875},{-26.2125,-14.3636},{-23.6,
            -14.3636}},
      color={0,0,127},
      smooth=Smooth.None));
connect(zoneSejour.FLUXcloisonEntree, CloisonChambre1Cuisine1.FluxAbsExt)
    annotation (Line(
      points={{-34.3,-32},{-30.075,-32},{-30.075,-31.875}},
      color={0,0,127},
      smooth=Smooth.Bezier));
connect(zoneCuisine.FLUXcloisonChambre1, CloisonChambre1Cuisine2.FluxAbsExt)
    annotation (Line(
      points={{-1.7,-14.3636},{0.15,-14.3636},{0.15,-15.875},{1.925,-15.875}},
      color={0,0,127},
      smooth=Smooth.Bezier));
connect(CloisonChambre1Cuisine2.FluxAbsInt, zoneC1_1.FLUXcloisonCuisine)
    annotation (Line(
      points={{3.575,-15.875},{7.7875,-15.875},{7.7875,-14.3636},{11.9,-14.3636}},
      color={0,0,127},
      smooth=Smooth.Bezier));
connect(CloisonChambre1Cuisine3.FluxAbsInt, zoneC2_1.FLUXcloisonChambre1)
    annotation (Line(
      points={{37.575,-15.875},{40.7875,-15.875},{40.7875,-14.3636},{43.9,
            -14.3636}},
      color={0,0,127},
      smooth=Smooth.None));
connect(zoneC1_1.FLUXcloisonEntree, CloisonChambre1Cuisine3.FluxAbsExt)
    annotation (Line(
      points={{30.1,-14.3636},{33.05,-14.3636},{33.05,-15.875},{35.925,-15.875}},
      color={0,0,127},
      smooth=Smooth.None));
connect(zoneC2_1.FLUXcloisonEntree, CloisonChambre1Cuisine5.FluxAbsExt)
    annotation (Line(
      points={{50.4,-28},{50.125,-28},{50.125,-38.425}},
      color={0,0,127},
      smooth=Smooth.None));
connect(zoneC2_1.FLUXcloisonSDB, CloisonChambre1Cuisine4.FluxAbsExt)
    annotation (Line(
      points={{58.2,-28},{60.125,-28},{60.125,-38.425}},
      color={0,0,127},
      smooth=Smooth.None));
connect(zoneCuisine.FLUXcloisonSejour, CloisonChambre1Cuisine7.FluxAbsExt)
    annotation (Line(
      points={{-12.5,-26.6364},{-12.5,-29.3182},{-11.875,-29.3182},{-11.875,
            -32.425}},
      color={0,0,127},
      smooth=Smooth.None));
connect(zoneC1_1.FLUXcloisonChambre2, CloisonChambre1Cuisine8.FluxAbsExt)
    annotation (Line(
      points={{19.7,-29.3636},{19.7,-31.6818},{18.125,-31.6818},{18.125,-34.425}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if GLOEXT==true then
    if EmplacementHaut then
  connect(T_sky,zoneEntree.T_sky)  annotation (Line(
      points={{-90,-10},{-76,-10},{-76,-76},{7.9,-76},{7.9,-65.8182}},
      color={191,0,0},
      smooth=Smooth.None));
    end if;
    if EmplacementHaut or EmplacementEst then
 connect(T_sky,zoneSDB.T_sky)  annotation (Line(
      points={{-90,-10},{-76,-10},{-76,20},{74,20},{74,-57.6364},{66.3,-57.6364}},
      color={191,0,0},
      smooth=Smooth.None));
    end if;
   connect(T_sky,zoneSejour.T_sky)  annotation (Line(
      points={{-90,-10},{-76,-10},{-76,20},{-34.3,20},{-34.3,2}},
      color={191,0,0},
      smooth=Smooth.None));
connect(T_sky,zoneCuisine.T_sky)  annotation (Line(
      points={{-90,-10},{-74,-10},{-74,20},{-0.5,20},{-0.5,0.636364}},
      color={191,0,0},
      smooth=Smooth.None));
connect(T_sky,zoneC1_1.T_sky)  annotation (Line(
      points={{-90,-10},{-76,-10},{-76,20},{30.1,20},{30.1,0.636364}},
      color={191,0,0},
      smooth=Smooth.None));
connect(T_sky,zoneC2_1.T_sky)  annotation (Line(
      points={{-90,-10},{-76,-10},{-76,20},{62.1,20},{62.1,0.636364}},
      color={191,0,0},
      smooth=Smooth.None));

  end if;

 connect(fLUXzone.G, G) annotation (Line(
      points={{-86.3,46.5},{-86.3,70},{-120,70}},
      color={0,0,127},
      smooth=Smooth.None));
  if QVin==true then
connect(RenouvAir, zoneSejour.RenouvAir) annotation (Line(
      points={{-100,-80},{-66,-80},{-66,-24.6},{-58.87,-24.6}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneEntree.RenouvAir) annotation (Line(
      points={{-100,-80},{12.04,-80},{12.04,-54.0364}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneSDB.RenouvAir) annotation (Line(
      points={{-100,-80},{44.71,-80},{44.71,-63.2727}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneC2_1.RenouvAir) annotation (Line(
      points={{-100,-80},{88,-80},{88,28},{50.01,28},{50.01,-5.22727}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneC1_1.RenouvAir) annotation (Line(
      points={{-100,-80},{88,-80},{88,28},{23.99,28},{23.99,-4.95455}},
      color={0,0,127},
      smooth=Smooth.None));
connect(RenouvAir, zoneCuisine.RenouvAir) annotation (Line(
      points={{-100,-80},{88,-80},{88,28},{-9.65,28},{-9.65,-5.22727}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  if useVolet then
   connect(fermetureSejour, zoneSejour.fermetureVolets) annotation (Line(
      points={{-50,100},{-50,80},{-45.01,80},{-45.01,-6.6}},
      color={0,0,127},
      smooth=Smooth.None));
connect(fermetureCuisine, zoneCuisine.fermetureVolets) annotation (Line(
      points={{-30,100},{-30,80},{-13.25,80},{-13.25,-5.22727}},
      color={0,0,127},
      smooth=Smooth.None));
connect(fermetureChambre1, zoneC1_1.fermetureVolets) annotation (Line(
      points={{-10,100},{-10,80},{20,80},{20,-4.95455},{19.83,-4.95455}},
      color={0,0,127},
      smooth=Smooth.None));
connect(fermetureChambre2, zoneC2_1.fermetureVolets) annotation (Line(
      points={{10,100},{10,80},{58.07,80},{58.07,-5.22727}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;
  if useOuverture then
connect(ouvertureSejour, zoneSejour.ouvertureFenetres) annotation (Line(
        points={{-60,100},{-60,80},{-51.73,80},{-51.73,-6.6}},
        color={255,0,255},
        smooth=Smooth.None));
connect(ouvertureCuisine, zoneCuisine.ouvertureFenetres) annotation (Line(
        points={{-40,100},{-40,80},{-15.95,80},{-15.95,-5.22727}},
        color={255,0,255},
        smooth=Smooth.None));
connect(ouvertureChambre1, zoneC1_1.ouvertureFenetres) annotation (Line(
        points={{-20,100},{-20,80},{18.01,80},{18.01,-4.95455}},
        color={255,0,255},
        smooth=Smooth.None));
connect(ouvertureChambre2, zoneC2_1.ouvertureFenetres) annotation (Line(
        points={{0,100},{0,80},{56.25,80},{56.25,-5.22727}},
        color={255,0,255},
        smooth=Smooth.None));
  end if;

  connect(fLUXzone.FluxIncExtRoof, zoneSejour.FluxIncExtRoof) annotation (Line(
      points={{-65,54.4},{-60,54.4},{-60,32},{-67.9,32},{-67.9,1.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, zoneSejour.FluxIncExtNorth) annotation (
      Line(
      points={{-65,50.2},{-60,50.2},{-60,32},{-62.86,32},{-62.86,1.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtWest, zoneSejour.FluxIncExtWest) annotation (Line(
      points={{-65,38.4},{-60,38.4},{-60,32},{-58.66,32},{-58.66,1.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, zoneCuisine.FluxIncExtRoof) annotation (Line(
      points={{-65,54.4},{-20,54.4},{-20,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, zoneCuisine.FluxIncExtNorth) annotation (
      Line(
      points={{-65,50.2},{-16.7,50.2},{-16.7,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, zoneC1_1.FluxIncExtRoof) annotation (Line(
      points={{-65,54.4},{13.2,54.4},{13.2,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, zoneC1_1.FluxIncExtNorth) annotation (Line(
      points={{-65,50.2},{16.06,50.2},{16.06,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, zoneC2_1.FluxIncExtRoof) annotation (Line(
      points={{-65,54.4},{42.6,54.4},{42.6,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, zoneC2_1.FluxIncExtNorth) annotation (Line(
      points={{-65,50.2},{45.46,50.2},{45.46,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, zoneC2_1.FluxIncExtEast) annotation (Line(
      points={{-65,42.4},{48.32,42.4},{48.32,0.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, zoneSDB.FluxIncExtRoof) annotation (Line(
      points={{-65,54.4},{82,54.4},{82,-41.4545},{65.96,-41.4545}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, zoneSDB.FluxIncExtEast) annotation (Line(
      points={{-65,42.4},{82,42.4},{82,-45.0909},{65.96,-45.0909}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, zoneEntree.FluxIncExtRoof) annotation (Line(
      points={{-65,54.4},{82,54.4},{82,-96},{-12.8,-96},{-12.8,-65.6}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_ext, zoneSejour.T_ext) annotation (Line(
      points={{-90,20},{-42.7,20},{-42.7,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, zoneCuisine.T_ext) annotation (Line(
      points={{-90,20},{-6.5,20},{-6.5,0.636364}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, zoneC1_1.T_ext) annotation (Line(
      points={{-90,20},{24.9,20},{24.9,0.636364}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, zoneC2_1.T_ext) annotation (Line(
      points={{-90,20},{56.9,20},{56.9,0.636364}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, zoneSDB.T_ext) annotation (Line(
      points={{-90,20},{74,20},{74,-50.3636},{66.3,-50.3636}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, zoneEntree.T_ext) annotation (Line(
      points={{-90,20},{-72,20},{-72,-76},{-1.3,-76},{-1.3,-65.8182}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_common, zoneSejour.T_int_common) annotation (Line(
      points={{-60,72},{-28.84,72},{-28.84,2}},
      color={128,0,255},
      smooth=Smooth.None));
  connect(T_int_common, zoneC1_1.T_int_common) annotation (Line(
      points={{-60,72},{33.48,72},{33.48,0.636364}},
      color={128,0,255},
      smooth=Smooth.None));
  connect(T_int_common, zoneC2_1.T_int_common) annotation (Line(
      points={{-60,72},{65.48,72},{65.48,0.363636}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_int_common, zoneCuisine.T_int_common) annotation (Line(
      points={{-60,72},{3.4,72},{3.4,0.636364}},
      color={128,0,255},
      smooth=Smooth.None));
  connect(T_int_common, zoneSDB.T_int_common) annotation (Line(
      points={{-60,72},{66.3,72},{66.3,-62.3636}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_int_common, zoneEntree.T_int_common) annotation (Line(
      points={{-60,72},{66,72},{66,-65.8182},{13.88,-65.8182}},
      color={128,0,255},
      smooth=Smooth.None));
  connect(zoneSejour.T_int_living, CloisonChambre1Cuisine.T_ext) annotation (
      Line(
      points={{-49.21,-30.8},{-38,-30.8},{-38,-18.075},{-31.725,-18.075}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine.T_int, zoneCuisine.T_int_kitchen) annotation (
      Line(
      points={{-26.775,-18.075},{-20.3875,-18.075},{-20.3875,-18.7273},{-12.35,
          -18.7273}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneSejour.T_int_living, CloisonChambre1Cuisine1.T_ext) annotation (
      Line(
      points={{-49.21,-30.8},{-38,-30.8},{-38,-34.075},{-31.725,-34.075}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(CloisonChambre1Cuisine1.T_int, zoneEntree.T_int_entrance) annotation (
     Line(
      points={{-26.775,-34.075},{-12,-34.075},{-12,-43.5636},{-10.27,-43.5636}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));

  connect(zoneCuisine.T_int_kitchen, CloisonChambre1Cuisine2.T_ext) annotation (
     Line(
      points={{-12.35,-18.7273},{-6.175,-18.7273},{-6.175,-18.075},{0.275,
          -18.075}},
      color={191,0,0},
      smooth=Smooth.Bezier,
      visible=false));
  connect(CloisonChambre1Cuisine2.T_int, zoneC1_1.T_int_room1) annotation (Line(
      points={{5.225,-18.075},{11.6125,-18.075},{11.6125,-20.6364},{19.83,
          -20.6364}},
      color={255,0,0},
      smooth=Smooth.Bezier,
      visible=false));
  connect(zoneC1_1.T_int_room1, CloisonChambre1Cuisine3.T_ext) annotation (Line(
      points={{19.83,-20.6364},{26.915,-20.6364},{26.915,-18.075},{34.275,
          -18.075}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine3.T_int, zoneC2_1.T_int_room2) annotation (Line(
      points={{39.225,-18.075},{46.6125,-18.075},{46.6125,-20.3636},{53.65,
          -20.3636}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneC2_1.T_int_room2, CloisonChambre1Cuisine4.T_ext) annotation (Line(
      points={{53.65,-20.3636},{53.65,-28.1818},{57.925,-28.1818},{57.925,
          -36.775}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine4.T_int, zoneSDB.T_int_bathroom) annotation (
      Line(
      points={{57.925,-41.725},{57.925,-51.8182},{48.11,-51.8182}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine5.T_ext, zoneC2_1.T_int_room2) annotation (Line(
      points={{47.925,-36.775},{47.925,-34},{53.65,-34},{53.65,-20.3636}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine5.T_int, zoneEntree.T_int_entrance) annotation (
     Line(
      points={{47.925,-41.725},{47.925,-43.5636},{-10.27,-43.5636}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine6.T_int, zoneSDB.T_int_bathroom) annotation (
      Line(
      points={{33.225,-46.075},{36,-46.075},{36,-51.8182},{48.11,-51.8182}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(zoneEntree.T_int_entrance, CloisonChambre1Cuisine6.T_ext) annotation (
     Line(
      points={{-10.27,-43.5636},{16,-43.5636},{16,-46.075},{28.275,-46.075}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine7.T_ext, zoneCuisine.T_int_kitchen) annotation (
     Line(
      points={{-14.075,-30.775},{-14.075,-25.3875},{-12.35,-25.3875},{-12.35,
          -18.7273}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine7.T_int, zoneEntree.T_int_entrance) annotation (
     Line(
      points={{-14.075,-35.725},{-14.075,-39.8625},{-10.27,-39.8625},{-10.27,
          -43.5636}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine8.T_ext, zoneC1_1.T_int_room1) annotation (Line(
      points={{15.925,-32.775},{15.925,-20.6364},{19.83,-20.6364}},
      color={191,0,0},
      smooth=Smooth.None,
      visible=false));
  connect(CloisonChambre1Cuisine8.T_int, zoneEntree.T_int_entrance) annotation (
     Line(
      points={{15.925,-37.725},{-10.27,-37.725},{-10.27,-43.5636}},
      color={255,0,0},
      smooth=Smooth.None,
      visible=false));

  connect(T_int_living, zoneSejour.T_int_living) annotation (Line(
      points={{-75,-105},{-75,-94},{-49.21,-94},{-49.21,-30.8}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(T_int_kitchen, zoneCuisine.T_int_kitchen) annotation (Line(
      points={{-55,-105},{-55,-94},{-12.35,-94},{-12.35,-18.7273}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(T_int_room1, zoneC1_1.T_int_room1) annotation (Line(
      points={{-35,-105},{-35,-94},{19.83,-94},{19.83,-20.6364}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(T_int_room2, zoneC2_1.T_int_room2) annotation (Line(
      points={{-15,-105},{-15,-94},{53.65,-94},{53.65,-20.3636}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(T_int_bathroom, zoneSDB.T_int_bathroom) annotation (Line(
      points={{5,-105},{5,-94},{48.11,-94},{48.11,-51.8182}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(T_int_entrance, zoneEntree.T_int_entrance) annotation (Line(
      points={{25,-105},{25,-94},{-10.27,-94},{-10.27,-43.5636}},
      color={191,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(V, vENTzone.V) annotation (Line(
      points={{-120,-40},{-108,-40},{-108,-40.1},{-94.9,-40.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTNord, zoneSejour.VENTNord) annotation (Line(
      points={{-73,-35.8},{-70,-35.8},{-70,16},{-51.1,16},{-51.1,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTNord, zoneCuisine.VENTNord) annotation (Line(
      points={{-73,-35.8},{-70,-35.8},{-70,16},{-12.5,16},{-12.5,0.636364}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTNord, zoneC1_1.VENTNord) annotation (Line(
      points={{-73,-35.8},{-70,-35.8},{-70,16},{19.7,16},{19.7,0.636364}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vENTzone.VENTNord, zoneC2_1.VENTNord) annotation (Line(
      points={{-73,-35.8},{-70,-35.8},{-70,16},{51.7,16},{51.7,0.636364}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Bitmap(extent={{-122,110},{120,-68}}, fileName="modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Matisse/Matisse.png"),
        Ellipse(
          extent={{-99,127},{-39,71}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-98,-66},{-70,-94}},
                                            lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-84,-50},
          rotation=360),
        Ellipse(
          extent={{-86,-78},{-82,-82}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-122,-136},
          rotation=180),
        Line(
          points={{-100,-70},{-84,-62},{-70,-70}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-70,-68},{-68,-72},{-72,-70},{-70,-68}},
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
          origin={-114,-80},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-84,-110},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-54,-80},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-99,-90},
          rotation=90),
        Text(
          extent={{-59,-55},{132,-79}},
          lineColor={0,0,0},
          textString="Matisse Multizone")}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p><i><b>Matisse Multizone collective housing</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Parameter <code>paraMaisonRT</code> allows the user to chose a specific French building regulation for the building, so that building envelope parameters (walls, windows, ventilation...) will be automatically filled with data from the choosen record.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model by comparison of GV with Clim 2000 - Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MatisseMultizone;
