within BuildSysPro.BuildingStock.CollectiveHousing.Matisse;
model MatisseMonozone
  import BuildSysPro;

  // Choix de la RT
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    paraMaisonRT "Réglementation thermique utilisée" annotation (
      __Dymola_choicesAllMatching=true, dialog(group="Choix de la RT"));

  // Orientation de la maison
parameter Real beta=0
    "Orientation de la maison (ex. beta=90 le mur Nord est en réalité à l'Est, le mur Est au Sud etc.)";
parameter Integer EmplacementAppartement=5
    "de 1 à 9, désigne la position de l'appartement : 1 à 3 dernier étage - 4 à 6 étage intermed - 7 à 9 : rez-de-chaussée (d'Ouest à Est)";

  // Flux thermiques
parameter Boolean GLOEXT=false
    "Prise en compte de rayonnement GLO vers l'environnement et le ciel"                            annotation(dialog(tab="Flux thermiques"));
parameter Boolean CLOintPlancher=true
    "True : tout le flux est absorbé par le plancher; False : le flux est absorbé par toutes les parois au prorata des surfaces"
                                                                                                        annotation(dialog(tab="Flux thermiques"));
parameter Boolean QVin=false
    "True : commande du débit de renouvellement d'air ; False : débit constant"
                                                                                                annotation(dialog(tab="Flux thermiques"));

  // Parois
parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale des parois"
    annotation(dialog(tab="Parois"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Initialisation en régime stationnaire dans les parois"
    annotation (dialog(tab="Parois"));

  // Fenêtres
parameter Boolean useVolet=false "true si présence d'un volet, false sinon" annotation(dialog(tab="Fenêtres"));
parameter Boolean useOuverture=false
    "true si l'ouverture de fenêtre peut être commandée, false sinon" annotation(dialog(tab="Fenêtres"));
parameter Boolean useReduction=false
    "Prise en compte ou non des facteurs de reduction"
    annotation (Dialog(tab="Fenêtres"));
parameter Integer TypeFenetrePF=1
    "Choix du type de fenetre ou porte-fenetre (PF)"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"),
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
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"));
parameter Real position=0.90
    "Position du vitrage : = 0.9 si interieure et = 1 si exterieure"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"));
parameter Real rideaux=0.85 "Presence de rideaux : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"));
parameter Real ombrages=0.85
    "Ombrage d'obstacles (vegetation, voisinage) : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Fenêtres",enable=useReduction,group="Paramètres"));
parameter Real r1=paraMaisonRT.transmissionMenuiserieFenetres
    "Coef. réducteur pour le direct si useReduction = false"
    annotation (Dialog(tab="Fenêtres",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));
parameter Real r2=paraMaisonRT.transmissionMenuiserieFenetres
    "Coef. réducteur pour le diffus si useReduction = false"
    annotation (Dialog(tab="Fenêtres",enable=not useReduction,group="Coefficients de réduction si useReduction = false"));

  // Ponts thermiques
  parameter Modelica.SIunits.ThermalConductance G_ponts=
      BuildSysPro.BuildingStock.Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPonts,
      TauPonts=paraMaisonRT.TauPonts)
    annotation (dialog(tab="Ponts thermiques"));

 // Paramètres protégés
protected
  parameter Boolean EmplacementEst= if EmplacementAppartement==3 or EmplacementAppartement==6 or EmplacementAppartement==9 then true else false;
  parameter Boolean EmplacementOuest= if EmplacementAppartement==1 or EmplacementAppartement==4 or EmplacementAppartement==7 then true else false;
  parameter Boolean EmplacementHaut= if EmplacementAppartement<=3 then true else false;
  parameter Boolean EmplacementBas= if EmplacementAppartement>=7 then true else false;

//Coefficients de pondération
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(
      b=paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauLNC(b=
        paraMaisonRT.bLNC)
    annotation (Placement(transformation(extent={{-58,-60},{-38,-40}})));

//Parois horizontales
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
    eps=paraMaisonRT.eps) if     EmplacementHaut
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

//Parois verticales extérieures
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

//Parois verticales internes

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
    hs_ext=paraMaisonRT.hsIntVert) if
                     not EmplacementEst
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
    hs_ext=paraMaisonRT.hsIntVert) if
                     not EmplacementOuest
    annotation (Placement(transformation(extent={{-7,-2},{7,12}})));

//Vitrages

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

//Ponts thermiques
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

//Composants pour prise en compte du rayonnement GLO/CLO
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if                     GLOEXT==true
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
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_VitrageNord}) if
                                                                                            not CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));

//Composants de base
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut, Hauteur"
      annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=beta)
    annotation (Placement(transformation(extent={{-86,56},{-66,76}})));

public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.VolumeMatisse,
      Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{-20,100},{0,120}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tair annotation (
      Placement(transformation(extent={{80,-29},{100,-9}}), iconTransformation(
          extent={{37,-40},{57,-20}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.VolumeMatisse)
    annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true "[m3/h]"
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{140,-16},{100,24}})));

  Modelica.Blocks.Interfaces.RealInput V[2] if useOuverture
    "1- vitesse du vent (m/s) 2- direction du vent (provenance 0° - Nord, 90° - Est, 180° - Sud, 270° - Ouest)"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[1] if useOuverture
    "ouverture des fenêtres Nord (true = ouvert, false=fermé)"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{-96,-30},{-74,-8}})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[1] if useVolet
    "fermeture des volets Nord (0 - ouvert , 1 - fermé)"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{8,-14},{-14,8}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Tmit
    "température des logements mitoyens" annotation (Placement(transformation(
          extent={{-64,88},{-56,96}}), iconTransformation(extent={{-4,34},{4,42}})));

  BuildSysPro.BoundaryConditions.Weather.ZoneWind vENTzone(beta=beta) if
                                                                  useOuverture
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
    connect(Tciel, VitrageNord.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,16.7},{-36.3,16.7}},
      color={191,0,0},
      smooth=Smooth.None));
    if EmplacementEst==true then
        connect(Tciel, MurEstExt.T_ciel) annotation (Line(
            points={{-90,10},{-64,10},{-64,34.7},{-6.3,34.7}},
            color={191,0,0},
            smooth=Smooth.None));
    end if;
      connect(Tciel, MurNord.T_ciel) annotation (Line(
          points={{-90,10},{-64,10},{-64,16.7},{-6.3,16.7}},
          color={191,0,0},
          smooth=Smooth.None));
    if EmplacementOuest==true then
        connect(Tciel, MurOuestExt.T_ciel) annotation (Line(
            points={{-90,10},{-64,10},{-64,-19.3},{-6.3,-19.3}},
            color={191,0,0},
            smooth=Smooth.None));
    end if;
    if EmplacementHaut==true then
        connect(Tciel, PlafondImmeuble.T_ciel) annotation (Line(
            points={{-90,10},{-64,10},{-64,70.7},{-6.3,70.7}},
            color={191,0,0},
            smooth=Smooth.None));
    end if;
  end if;

 connect(fLUXzone.G, G) annotation (Line(
      points={{-86.9,65.9},{-86.9,90},{-120,90}},
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

    connect(fLUXzone.FLUXNord, MurNord.FLUX) annotation (Line(
        points={{-65,70.2},{-44,70.2},{-44,26},{-10,26},{-10,29.3},{-2.1,29.3}},
        color={255,192,1},
        smooth=Smooth.None));
    connect(Text, MurNord.T_ext) annotation (Line(
        points={{-90,40},{-52,40},{-52,20.9},{-6.3,20.9}},
        color={191,0,0},
        smooth=Smooth.None));
if EmplacementEst==true then
      connect(fLUXzone.FLUXEst, MurEstExt.FLUX) annotation (Line(
          points={{-65,62.4},{-44,62.4},{-44,46},{-10,46},{-10,47.3},{-2.1,47.3}},
          color={255,192,1},
          smooth=Smooth.None));
      connect(Text, MurEstExt.T_ext) annotation (Line(
          points={{-90,40},{-52,40},{-52,38.9},{-6.3,38.9}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(MurEstExt.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,38.9},{40,38.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
else
      connect(Tmit, MurEst.T_ext) annotation (Line(
          points={{-60,92},{-20,92},{-20,56.9},{-6.3,56.9}},
          color={128,0,255},
          smooth=Smooth.None));
      connect(MurEst.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,56.9},{40,56.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
end if;
if EmplacementOuest==true then
      connect(fLUXzone.FLUXouest, MurOuestExt.FLUX) annotation (Line(
          points={{-65,58.4},{-44,58.4},{-44,-6.7},{-2.1,-6.7}},
          color={255,192,1},
          smooth=Smooth.None));
      connect(Text, MurOuestExt.T_ext) annotation (Line(
          points={{-90,40},{-52,40},{-52,-15.1},{-6.3,-15.1}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(MurOuestExt.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,-15.1},{40,-15.1},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
else
      connect(Tmit, MurOuest.T_ext) annotation (Line(
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
if EmplacementHaut==true then
      connect(Text, PlafondImmeuble.T_ext) annotation (Line(
          points={{-90,40},{-52,40},{-52,74.9},{-6.3,74.9}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(PlafondImmeuble.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,74.9},{40,74.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(fLUXzone.FLUXPlafond, PlafondImmeuble.FLUX) annotation (Line(
          points={{-65,74.4},{-64,74.4},{-64,83.3},{-2.1,83.3}},
          color={255,192,1},
          smooth=Smooth.None));
else
      connect(Plafond.T_int, noeudAir.port_a) annotation (Line(
          points={{6.3,91.9},{40,91.9},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
 connect(Tmit, Plafond.T_ext) annotation (Line(
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
          points={{-43,-90.2},{28,-90.2},{28,-104},{73.1,-104},{73.1,-98.3}},
          color={191,0,0},
          smooth=Smooth.None));
else
      connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
          points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
          color={255,0,0},
          smooth=Smooth.None));
      connect(Tmit, PlancherBas.T_ext) annotation (Line(
          points={{-60,92},{-20,92},{-20,-100},{54,-100},{54,-98.3},{53.1,-98.3}},
          color={128,0,255},
          smooth=Smooth.None));
end if;
    connect(TauLNC.Tponder, MurSudLNC.T_ext) annotation (Line(
        points={{-43,-50.2},{-24.5,-50.2},{-24.5,-33.1},{-6.3,-33.1}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(TauLNC.Tponder, Porte.T_ext) annotation (Line(
        points={{-43,-50.2},{-24.5,-50.2},{-24.5,-51.75},{-6.3,-51.75}},
        color={191,0,0},
        smooth=Smooth.None));

  connect(fLUXzone.FLUXNord, VitrageNord.FLUX) annotation (Line(
      points={{-65,70.2},{-44,70.2},{-44,26.5},{-32.1,26.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, VitrageNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,20.9},{-36.3,20.9}},
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
  connect(VitrageNord.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-23.7,26.5},{-14,26.5},{-14,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Tair) annotation (Line(
      points={{80,22},{80,2},{80,-19},{90,-19}},
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
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i><b>Matisse Monozone</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé par comparaison des GV avec Clim 2000 - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MatisseMonozone;
