within BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones;
model ZoneR2

  // Choix de la RT
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.BuildingType
    paraMaisonRT "Réglementation thermique utilisée" annotation (
      choicesAllMatching=true, Dialog(group="Choix de la RT"));

  // Flux thermiques
parameter Boolean GLOEXT=false
    "Prise en compte de rayonnement GLO vers l'environnement et le ciel"                            annotation(Dialog(tab="Flux thermiques"));
parameter Boolean CLOintPlancher=true
    "True : tout le flux est absorbé par le plancher; False : le flux est absorbé par toutes les parois au prorata des surfaces"
                                                                                                        annotation(Dialog(tab="Flux thermiques"));
parameter Boolean QVin=false
    "True : commande du débit de renouvellement d'air ; False : débit constant"
                                                                                                annotation(Dialog(tab="Flux thermiques"));

  // Parois
parameter Modelica.SIunits.Temperature Tp=293.15
    "Température initiale des parois"
    annotation(Dialog(tab="Parois"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Initialisation en régime stationnaire dans les parois"
    annotation (Dialog(tab="Parois"));

  // Portes fenêtres
parameter Boolean useVoletPF=false "true si présence d'un volet, false sinon" annotation(Dialog(tab="Portes Fenêtres"));
parameter Boolean useOuverturePF=false
    "true si l'ouverture de fenêtre peut être commandée, false sinon" annotation(Dialog(tab="Portes Fenêtres"));
parameter Boolean useReduction1=false
    "Prise en compte ou non des facteurs de reduction"
    annotation (Dialog(tab="Portes Fenêtres"));
parameter Integer TypeFenetrePF1=1
    "Choix du type de fenetre ou porte-fenetre (PF)"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"),
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
parameter Real voilage1=0.95 "Voilage : = 0.95 si oui et = 1 sinon"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"));
parameter Real position1=0.90
    "Position du vitrage : = 0.9 si interieure et = 1 si exterieure"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"));
parameter Real rideaux1=0.85 "Presence de rideaux : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"));
parameter Real ombrages1=0.85
    "Ombrage d'obstacles (vegetation, voisinage) : = 0.85 si oui et = 1 sinon"
    annotation (Dialog(tab="Portes Fenêtres",enable=useReduction1,group="Paramètres"));
parameter Real r11=paraMaisonRT.transmissionMenuiseriePortesFenetres
    "Coef. réducteur pour le direct si useReduction1 = false"
    annotation (Dialog(tab="Portes Fenêtres",enable=not useReduction1,group="Coefficients de réduction si useReduction1 = false"));
parameter Real r21=paraMaisonRT.transmissionMenuiseriePortesFenetres
    "Coef. réducteur pour le diffus si useReduction1 = false"
    annotation (Dialog(tab="Portes Fenêtres",enable=not useReduction1,group="Coefficients de réduction si useReduction1 = false"));

  // Ponts thermiques
  parameter Modelica.SIunits.ThermalConductance G_ponts=
      Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsC2,
      TauPonts=paraMaisonRT.TauPonts) "Ponts thermiques"
    annotation (Dialog(tab="Ponts thermiques"));

    //Coefficients de pondération
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(b=
        paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlafond(b=
        paraMaisonRT.bSousCombles)
    annotation (Placement(transformation(extent={{-58,80},{-38,100}})));

//Parois horizontales
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC2)
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC2)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

//Parois verticales extérieures
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurEstC2)
    annotation (Placement(transformation(extent={{-7,42},{7,56}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurNord(
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurNordC2)
    annotation (Placement(transformation(extent={{-7,22},{7,36}})));

//Parois verticales internes

//Vitrages
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageEstC2,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageEstC2)
    annotation (Placement(transformation(extent={{-37,42},{-23,56}})));

//Ponts thermiques
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

//Composants pour prise en compte du rayonnement GLO/CLO
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{80,-60},{100,-40}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    np=6,
    nf=1,
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC2,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurNordC2,BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeC2,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurEstC2,BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegC1C2,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC2},
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageEstC2}) if not
    CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

//Composants de base
protected
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));
public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC2
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart, Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{80,-20},{100,0}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a TC2 annotation (
      Placement(transformation(extent={{80,-29},{100,-9}}), iconTransformation(
          extent={{-21,-28},{-1,-8}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondC2
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart) annotation (
     Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-21,87})));

  Modelica.Blocks.Interfaces.RealInput VENTEst if
                                               useOuverturePF annotation (
      Placement(transformation(extent={{-114,-26},{-86,2}}), iconTransformation(
          extent={{100,10},{80,30}})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[1] if useOuverturePF
    "ouverture des fenêtres Est"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{52,24},{40,36}})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[1] if useVoletPF
    "fermeture des volets Est"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{52,10},{40,22}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxNord[3]
    annotation (Placement(transformation(extent={{-108,76},{-84,100}}),
        iconTransformation(extent={{100,68},{76,92}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxEst[3]
    annotation (Placement(transformation(extent={{-108,56},{-84,80}}),
        iconTransformation(extent={{100,48},{76,72}})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonEntree if not CLOintPlancher
    annotation (Placement(transformation(extent={{86,78},{106,98}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-70})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonC1 if not CLOintPlancher
    annotation (Placement(transformation(extent={{86,60},{106,80}}),
        iconTransformation(extent={{-60,10},{-80,30}})));
equation
  if CLOintPlancher==false then
    connect(multiSum.y, PintdistriRad.RayEntrant) annotation (Line(
      points={{-14,-73.02},{-14,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[1], VitrageEst.FluxAbsInt) annotation (
      Line(
      points={{19,-80},{26,-80},{26,50.4},{-27.9,50.4}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[1], ParoiSousCombles.FluxAbsInt) annotation (
     Line(
      points={{19,-84.8333},{26,-84.8333},{26,92.5},{2.1,92.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[2], MurNord.FluxAbsInt) annotation (Line(
      points={{19,-84.5},{26,-84.5},{26,32.5},{2.1,32.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[3], FLUXcloisonEntree) annotation (Line(
      points={{19,-84.1667},{26,-84.1667},{26,88},{96,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[4], MurEst.FluxAbsInt) annotation (Line(
      points={{19,-83.8333},{26,-83.8333},{26,52.5},{2.1,52.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[5], FLUXcloisonC1) annotation (Line(
      points={{19,-83.5},{26,-83.5},{26,70},{96,70}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[6], PlancherBas.FluxAbsInt) annotation (Line(
      points={{19,-83.1667},{47.5,-83.1667},{47.5,-89.9}},
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
    connect(Tciel, MurEst.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,42.7},{-6.3,42.7}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Tciel, MurNord.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,22.7},{-6.3,22.7}},
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
    connect(fermetureVolets[1], VitrageEst.fermeture_volet)
      annotation (Line(
      points={{-100,-80},{-76,-80},{-76,53.9},{-36.3,53.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  end if;

  if useOuverturePF then
    connect(ouvertureFenetres[1], VitrageEst.ouverture_fenetre)
      annotation (Line(
        points={{-100,-48},{-74,-48},{-74,49},{-32.1,49}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;

    connect(Text, MurEst.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,46.9},{-6.3,46.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(Text, MurNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,26.9},{-6.3,26.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlafond.Tponder, ParoiSousCombles.T_ext) annotation (Line(
      points={{-43,89.8},{-6.3,89.8},{-6.3,86.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(TauPlancher.Tponder, PlancherBas.T_ext) annotation (Line(
      points={{-43,-90.2},{34,-90.2},{34,-98.3},{53.1,-98.3}},
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
    connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,26.9},{40,26.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageEst.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,46.9},{-36.3,46.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-87},{-57,-87}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlafond.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,80},{-64,80},{-64,93},{-57,93}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageEst.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-23.7,52.5},{-14,52.5},{-14,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, TC2) annotation (Line(
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
  connect(TauPlafond.port_int, noeudAir.port_a) annotation (Line(
      points={{-57,87},{-60,87},{-60,82},{40,82},{40,40},{80,40},{80,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{-43.75,-72.5},{-36,-72.5},{-36,-98},{30,-98},{30,-60},{40,-60},{40,
          40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(VitrageEst.T_int, noeudAir.port_a) annotation (Line(
      points={{-23.7,46.9},{40,46.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(FluxNord, MurNord.FLUX) annotation (Line(
      points={{-96,88},{-68,88},{-68,35.3},{-2.1,35.3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxEst, VitrageEst.FLUX) annotation (Line(
      points={{-96,68},{-68,68},{-68,52.5},{-32.1,52.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxEst, MurEst.FLUX) annotation (Line(
      points={{-96,68},{-68,68},{-68,55.3},{-2.1,55.3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VENTEst, VitrageEst.V) annotation (Line(
      points={{-100,-12},{-70,-12},{-70,49},{-36.3,49}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Bitmap(extent={{-56,80},{42,-52}}, fileName="modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Mozart/Chambre2.png"),
        Ellipse(extent={{-34,66},{-6,38}},  lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-20,82},
          rotation=360),
        Ellipse(
          extent={{-22,54},{-18,50}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-58,-4},
          rotation=180),
        Line(
          points={{-36,62},{-20,70},{-6,62}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-6,64},{-4,60},{-8,62},{-6,64}},
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
          origin={-50,52},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={-20,22},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={10,52},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-35,42},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i><b>Zone chambre 2 Mozart</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ZoneR2;
