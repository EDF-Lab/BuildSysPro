within BuildSysPro.BuildingStock.CollectiveHousing.Matisse.MatisseZones;
model ZoneKitchen

  // Choix de la RT
  replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
    paraMaisonRT "Réglementation thermique utilisée" annotation (
      __Dymola_choicesAllMatching=true, dialog(group="Choix de la RT"));

  // Orientation de la maison
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
      Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.LongueursPontsCuisine,
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
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient TauPlancher(b=
        paraMaisonRT.bPlancher)
    annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));

//Parois horizontales
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Plafond(
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
      positionIsolant=paraMaisonRT.PlafondMitoyen.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondCuisine) if
       not EmplacementHaut
    annotation (Placement(transformation(extent={{-7,87},{7,101}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlafondImmeuble(
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
    eps=paraMaisonRT.eps,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondCuisine) if
       EmplacementHaut
    annotation (Placement(transformation(extent={{-7,70},{7,84}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
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
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondCuisine) if
       not EmplacementBas annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBasImmeuble(
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
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondCuisine) if
       EmplacementBas annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={71,-92})));

//Parois verticales extérieures

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
      n=paraMaisonRT.MurExt.n,
      m=paraMaisonRT.MurExt.m,
      e=paraMaisonRT.MurExt.e,
      mat=paraMaisonRT.MurExt.mat,
      positionIsolant=paraMaisonRT.MurExt.positionIsolant),
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurNordCuisine)
    annotation (Placement(transformation(extent={{-7,16},{7,30}})));

//Parois verticales internes

//Vitrages

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageNord(
    GLOext=GLOEXT,
    RadInterne=not CLOintPlancher,
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
    useReduction=useReduction,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_VitrageNordCuisine,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.H_VitrageNordCuisine)
    annotation (Placement(transformation(extent={{-37,16},{-23,30}})));

//Ponts thermiques
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

//Composants pour prise en compte du rayonnement GLO/CLO
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{60,100},{80,120}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    np=6,
    nf=1,
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_VitrageNordCuisine},
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurNordCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegEntreeCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegC1Cuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_CloisonLegSejourCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondCuisine}) if
       not CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));

//Composants de base

public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondCuisine
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.HauteurMatisse, Tair=
        293.15) annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{20,100},{40,120}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a TCuisine
    annotation (Placement(transformation(extent={{80,-29},{100,-9}}),
        iconTransformation(extent={{-19,-42},{1,-22}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherPlafondCuisine
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.HauteurMatisse)
    annotation (Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={9,67})));

  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[1] if useOuverture
    "ouverture des fenêtres Nord"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-33,67})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[1] if useVolet
    "fermeture des volets Nord"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-15,67})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Tmit
    "température des logements mitoyens" annotation (Placement(transformation(
          extent={{-64,88},{-56,96}}), iconTransformation(extent={{92,106},{100,
            114}})));

  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonEntree if not CLOintPlancher
    annotation (Placement(transformation(extent={{88,80},{108,100}}),
        iconTransformation(extent={{-74,-10},{-94,10}})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonChambre1 if
                                                             not CLOintPlancher
    annotation (Placement(transformation(extent={{88,60},{108,80}}),
        iconTransformation(extent={{52,-10},{72,10}})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonSejour if not CLOintPlancher
    annotation (Placement(transformation(extent={{88,40},{108,60}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-90})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxPlafond[3]
    annotation (Placement(transformation(extent={{-108,74},{-84,98}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={-60,109})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxNord[3]
    annotation (Placement(transformation(extent={{-108,58},{-84,82}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={-38,109})));
  Modelica.Blocks.Interfaces.RealInput VENTNord if
                                               useOuverture annotation (
      Placement(transformation(extent={{-114,-28},{-86,0}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,110})));
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
      connect(PintdistriRad.FLUXParois[6], PlancherBasImmeuble.FluxAbsInt)
    annotation (Line(
      points={{19,-83.1667},{67.5,-83.1667},{67.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
    else
      connect(PintdistriRad.FLUXParois[6], PlancherBas.FluxAbsInt)
        annotation (Line(
      points={{19,-83.1667},{47.5,-83.1667},{47.5,-89.9}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
    if EmplacementHaut==true then
      connect(PintdistriRad.FLUXParois[1], PlafondImmeuble.FluxAbsInt)
        annotation (
      Line(
      points={{19,-84.8333},{32,-84.8333},{32,80.5},{2.1,80.5}},
      color={0,0,127},
      smooth=Smooth.None));
    else
      connect(PintdistriRad.FLUXParois[1], Plafond.FluxAbsInt)
        annotation (Line(
      points={{19,-84.8333},{26,-84.8333},{26,-85},{32,-85},{32,97.5},{2.1,97.5}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;
  connect(PintdistriRad.FLUXParois[2], MurNord.FluxAbsInt) annotation (Line(
      points={{19,-84.5},{32,-84.5},{32,26.5},{2.1,26.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PintdistriRad.FLUXParois[3], FLUXcloisonEntree) annotation (Line(
      points={{19,-84.1667},{32,-84.1667},{32,90},{98,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PintdistriRad.FLUXParois[4], FLUXcloisonChambre1) annotation (Line(
      points={{19,-83.8333},{32,-83.8333},{32,70},{98,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PintdistriRad.FLUXParois[5], FLUXcloisonSejour) annotation (Line(
      points={{19,-83.5},{32,-83.5},{32,50},{98,50}},
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
      connect(Tciel, MurNord.T_ciel) annotation (Line(
          points={{-90,10},{-64,10},{-64,16.7},{-6.3,16.7}},
          color={191,0,0},
          smooth=Smooth.None));
    if EmplacementHaut==true then
        connect(Tciel, PlafondImmeuble.T_ciel) annotation (Line(
            points={{-90,10},{-64,10},{-64,70.7},{-6.3,70.7}},
            color={191,0,0},
            smooth=Smooth.None));
    end if;
  end if;

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

    connect(Text, MurNord.T_ext) annotation (Line(
        points={{-90,40},{-52,40},{-52,20.9},{-6.3,20.9}},
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
    connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
        points={{6.3,20.9},{40,20.9},{40,40},{80,40},{80,22}},
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

  connect(Text, VitrageNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,20.9},{-36.3,20.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Text, TauPlancher.port_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-87},{-57,-87}},
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
  connect(noeudAir.port_a, TCuisine) annotation (Line(
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
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{-43.75,-72.5},{-36,-72.5},{-36,-98},{30,-98},{30,-60},{40,-60},{40,
          40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(VitrageNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-23.7,20.9},{40,20.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FluxPlafond, PlafondImmeuble.FLUX) annotation (Line(
      points={{-96,86},{-52,86},{-52,83.3},{-2.1,83.3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxNord, VitrageNord.FLUX) annotation (Line(
      points={{-96,70},{-70,70},{-70,26.5},{-32.1,26.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxNord, MurNord.FLUX) annotation (Line(
      points={{-96,70},{-70,70},{-70,29.3},{-2.1,29.3}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VENTNord, VitrageNord.V) annotation (Line(
      points={{-100,-14},{-68,-14},{-68,23},{-36.3,23}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}}),
graphics={
        Bitmap(extent={{-72,60},{52,-62}}, fileName=
              "modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Matisse/Cuisine.png"),
        Ellipse(extent={{-6,52},{22,24}},   lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={8,68},
          rotation=360),
        Ellipse(
          extent={{6,40},{10,36}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-30,-18},
          rotation=180),
        Line(
          points={{-8,48},{8,56},{22,48}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{22,50},{24,46},{20,48},{22,50}},
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
          origin={-22,38},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={8,8},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={38,38},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-7,28},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i><b>Zone cuisine Matisse</b></i></p>
<p><u><b>Hypothèses et équations</b></u></p>
<p>néant</p>
<p><u><b>Bibliographie</b></u></p>
<p>néant</p>
<p><u><b>Mode d'emploi</b></u></p>
<p>néant</p>
<p><u><b>Limites connues du modèle / Précautions d'utilisation</b></u></p>
<p>néant</p>
<p><u><b>Validations effectuées</b></u></p>
<p>Modèle validé - Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ZoneKitchen;
