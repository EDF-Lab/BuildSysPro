within BuildSysPro.BuildingStock.CollectiveHousing.CollectiveHousingBuilding.Building34LC;
model Monozone34LC "Building 34 LC"

// General
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState;
parameter Real beta=0
    "azimuth correction of vertical walls (azimut=azimut{0,90,180,-90}+beta)";
  parameter Modelica.Units.SI.Temperature Tp=293.15
    "initial wall temperature";
  parameter Modelica.Units.SI.Temperature Ts=293.15 "ground temperature";
  parameter Modelica.Units.SI.Temperature Tair=293.15
    "initial temperature inside" annotation (Dialog(enable=not
          InitType == Utilitaires.Types.InitCond.SteadyState));
  parameter Modelica.Units.SI.Volume Vair=4851.82 "Volume intérieur";
 parameter Boolean ChoixPint=false
    "Consideration of radiative contributions in proportion to the surfaces" annotation (
      choices(choice=true "Oui",
      choice=false "Non",radioButtons=true));
 parameter Boolean ChoixGLOext=false
    "Consideration of GLO (infrared) radiation between the vertical walls and the sky"
    annotation(choices(choice=true
        "Oui : attention, hext purement convectifs",                            choice=false "Non", radioButtons=true));

// Ventilation and infiltration
parameter Real TauxRA(displayUnit="vol/h")=0.3
    "Air change rate vol/h"                                           annotation(Dialog(tab="Ventilation et infiltrations"));

// Thermal bridges
parameter Real PontsThermiques(displayUnit="W/K")=238.55
    "Thermal bridges W/K"                                                    annotation(Dialog(tab="Ponts thermiques"));

parameter Real Scvr(displayUnit="m²")=9.3+9.09+19.41+14.25
    "Surface of roller shutter boxes in m²"                                                    annotation(Dialog(tab="Coffres de volets roulants"));
parameter Real Ucvr(displayUnit="W/m²-K")=1.5
    "Transmission coefficient of roller shutter boxes in W/m²-K"                             annotation(Dialog(tab="Coffres de volets roulants"));

// Walls//
// Walls on the outside
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall caracVert
    "Characteristics of vertical walls" annotation (
      choicesAllMatching=true, Dialog(tab="Murs", group=
          "Murs extérieur"));

  parameter Modelica.Units.SI.Area S1nv=346.08
    "South wall surface (unglazed)"
    annotation (Dialog(tab="Murs", group="Murs extérieur"));
  parameter Modelica.Units.SI.Area S2nv=138.13
    "West wall surface (unglazed)"
    annotation (Dialog(tab="Murs", group="Murs extérieur"));
  parameter Modelica.Units.SI.Area S3nv=221.55
    "North wall surface (unglazed)"
    annotation (Dialog(tab="Murs", group="Murs extérieur"));
  parameter Modelica.Units.SI.Area S4nv=189.53
    "East wall surface (unglazed)"
    annotation (Dialog(tab="Murs", group="Murs extérieur"));

// Walls on unheated rooms
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracMursLNC "Characteristics of the walls on unheated rooms" annotation (
      choicesAllMatching=true, Dialog(tab="Murs", group=
          "Murs sur LNC"));

parameter Real bMursLNC = 0.75 "weighting coefficient" annotation(Dialog(tab="Murs",group= "Murs sur LNC"));
  parameter Modelica.Units.SI.Area SMursLNC=180.2 " wall surface of unheated rooms"
    annotation (Dialog(tab="Murs", group="Murs sur LNC"));

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hextv=25
    annotation (Dialog(tab="Murs"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hintv=7.7
    annotation (Dialog(tab="Murs"));
parameter Real albedo=0.2 "environmental albedo" annotation(Dialog(tab="Murs"));
parameter Real alpha= 0.6
    "absorption coefficient of the outer surface. in the visible"                       annotation(Dialog(tab="Murs"));

// Roof
// Roof terrace
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracTerrasse "Characteristics of the flat roof" annotation (
      choicesAllMatching=true, Dialog(tab="Toiture", group=
          "Toiture terrasse"));

  parameter Modelica.Units.SI.Area STerrasse=204.69 "Surface Terrasses"
    annotation (Dialog(tab="Toiture", group="Toiture terrasse"));

// false ceiling in the attic
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracFauxPlafond "Characteristics of the false ceiling in the attic"
    annotation (choicesAllMatching=true, Dialog(tab="Toiture",
        group="Faux-plafond"));

  parameter Modelica.Units.SI.Area SFauxPlafond=265.75 "Area"
    annotation (Dialog(tab="Toiture", group="Faux-plafond"));
parameter Real bFauxPlafond=1
    "Floor and ceiling temperature weighting factor"                         annotation(Dialog(tab="Toiture", group="Faux-plafond"));

// Low floor
// Low floor on unheated rooms
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracPlanchLNC "Characteristics of low floors on unheated rooms" annotation (
     choicesAllMatching=true, Dialog(tab="Planchers bas", group=
          "Plancher bas sur LNC"));

  parameter Modelica.Units.SI.Area SPlanchLNC=469.74 "floor area"
    annotation (Dialog(tab="Planchers bas", group="Plancher bas sur LNC"));
parameter Real bPlanchLNC=0.75
    "Floor temperature weighting coefficient on unheated rooms"   annotation (Dialog(tab="Planchers bas", group="Plancher bas sur LNC"));

// Interior walls
// Shear walls
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracRefends "Characteristics of shear walls" annotation (
      choicesAllMatching=true, Dialog(tab="Parois intérieures",
        group="Murs de refends"));

  parameter Modelica.Units.SI.Area SRefends=1115*4851.8/10662.5
    "shear wall surface"
    annotation (Dialog(tab="Parois intérieures", group="Murs de refends"));

// Partitions
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracCloisons "Characteristics of partitions" annotation (
      choicesAllMatching=true, Dialog(tab="Parois intérieures",
        group="Cloisons"));

  parameter Modelica.Units.SI.Area SCloisons=1115*2*4851.8/10662.5
    "partition surface"
    annotation (Dialog(tab="Parois intérieures", group="Cloisons"));

// Intermediate floors
  replaceable parameter BuildSysPro.Utilities.Records.GenericWall
    caracPlanchInter "Characteristics of intermediate floors"
    annotation (choicesAllMatching=true, Dialog(tab=
          "Parois intérieures", group="Planchers intermédiaires"));

  parameter Modelica.Units.SI.Area SPlanchInter=1409.22 "floor area"
    annotation (Dialog(tab="Parois intérieures", group=
          "Planchers intermédiaires"));

 //Windows//
  parameter Modelica.Units.SI.Area S1v=90.23 "glazed area of ​​the south wall"
    annotation (Dialog(tab="Fenetres"));
  parameter Modelica.Units.SI.Area S2v=55.8 "glazed area of ​​the west wall"
    annotation (Dialog(tab="Fenetres"));
  parameter Modelica.Units.SI.Area S3v=118.22
    "glazed area of ​​the north wall" annotation (Dialog(tab="Fenetres"));
  parameter Modelica.Units.SI.Area S4v=55.76 "glazed area of ​​the east wall"
    annotation (Dialog(tab="Fenetres"));

parameter Real U=1.5 "thermal conductivity of glazing" annotation(Dialog(tab="Fenetres"));
parameter Real tau=0.312 "glazing transmission coefficient" annotation(Dialog(tab="Fenetres"));
parameter Real g=0.336 "glazing solar factor"
                                             annotation(Dialog(tab="Fenetres"));

//Components//
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherLNC(
    InitType=InitType,
    Tp=Tp,
    S=SPlanchLNC,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    ParoiInterne=true,
    caracParoi=caracPlanchLNC)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={77,-53})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient
    coefficient_b_PlanchLNC(b=bPlanchLNC) annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={79,-69})));

  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=Vair, Tair(
        displayUnit="K") = Tair)
    annotation (Placement(transformation(extent={{6,-2},{26,18}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Sud(
    InitType=InitType,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    S=S1nv,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    RadExterne=false,
    caracParoi=caracVert)
    annotation (Placement(transformation(extent={{-34,-22},{-20,-8}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Ouest(
    InitType=InitType,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    S=S2nv,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    RadExterne=false,
    caracParoi=caracVert)
    annotation (Placement(transformation(extent={{-32,-58},{-20,-46}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Nord(
    InitType=InitType,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    S=S3nv,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    RadExterne=false,
    caracParoi=caracVert)
    annotation (Placement(transformation(extent={{-32,48},{-20,60}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Est(
    InitType=InitType,
    Tp=Tp,
    hs_ext=hextv,
    hs_int=hintv,
    alpha_ext=alpha,
    ParoiInterne=false,
    S=S4nv,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    RadExterne=false,
    caracParoi=caracVert)
    annotation (Placement(transformation(extent={{-32,14},{-22,24}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=
        beta, albedo=albedo)
    annotation (Placement(transformation(extent={{-76,80},{-56,100}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall ToitureTerrasse(
    InitType=InitType,
    Tp=Tp,
    alpha_ext=alpha,
    S=STerrasse,
    incl=0,
    hs_ext=hextv,
    hs_int=hintv,
    ParoiInterne=false,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    RadExterne=false,
    caracParoi=caracTerrasse)
    annotation (Placement(transformation(extent={{-32,84},{-20,96}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurLNC(
    InitType=InitType,
    Tp=Tp,
    S=SMursLNC,
    ParoiInterne=true,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    caracParoi=caracMursLNC) annotation (
      Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={55,-53})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow
    FenSud(
    S=S1v,
    hs_ext=hextv,
    hs_int=hintv,
    U=U,
    tau=tau,
    g=g) annotation (Placement(transformation(extent={{-34,-4},{-20,10}})));
  Modelica.Blocks.Sources.Constant TauxRenouvellementAir(k=TauxRA)
    "Ventilation et infiltrations"
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=90,
        origin={42,-94})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall
    PlancherIntermediaire(
    InitType=InitType,
    Tp=Tp,
    S=SPlanchInter,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    ParoiInterne=true,
    caracParoi=caracPlanchInter)
    annotation (Placement(transformation(extent={{48,6},{60,18}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Refends(
    InitType=InitType,
    Tp=Tp,
    S=SRefends,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    ParoiInterne=true,
    caracParoi=caracRefends)
    "Murs de refends"
    annotation (Placement(transformation(extent={{48,22},{60,34}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Cloisons(
    InitType=InitType,
    Tp=Tp,
    S=SCloisons,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    ParoiInterne=true,
    caracParoi=caracCloisons)
    "Cloisons"
    annotation (Placement(transformation(extent={{48,38},{60,50}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall FauxPlafond(
    InitType=InitType,
    Tp=Tp,
    S=SFauxPlafond,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    ParoiInterne=true,
    caracParoi=caracFauxPlafond) annotation (
     Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={97,-53})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient
    coefficient_bFauxPlafond(b=bFauxPlafond) annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={99,-69})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=false, Qv=TauxRA*Vair) annotation (Placement(transformation(
        extent={{8,-11},{-8,11}},
        rotation=270,
        origin={35,-58})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.B_Coefficient
    coefficient_b_MurLNC(b=bMursLNC) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={59,-69})));
  Modelica.Blocks.Math.Sum sum1(nin=4)
    annotation (Placement(transformation(extent={{8,54},{16,62}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={32,34})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalResistance
    Ponts_Thermiques(R=1/PontsThermiques) annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={16,-70})));

  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib pintDistribRad(
    np=11,
    Sp={STerrasse,S3nv,S4nv,S1nv,S2nv,SCloisons,SRefends,SPlanchInter,
        SMursLNC,SPlanchLNC,SFauxPlafond},
    nf=4,
    Sf={S1v,S2v,S3v,S4v}) if ChoixPint
                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,76})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow
    FenOuest(
    hs_ext=hextv,
    hs_int=hintv,
    S=S2v,
    U=U,
    tau=tau,
    g=g,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{-34,-40},{-20,-26}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow
    FenEst(
    hs_ext=hextv,
    hs_int=hintv,
    S=S4v,
    U=U,
    tau=tau,
    g=g,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{-34,28},{-20,42}})));
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalResistance
    Coffre_Volets_Roulants(R=1/(Ucvr*Scvr)) annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={0,-70})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow
    FenNord(
    U=U,
    tau=tau,
    g=g,
    S=S3v,
    hs_ext=hextv,
    hs_int=hintv,
    RadInterne=ChoixPint,
    GLOext=ChoixGLOext,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{-32,66},{-20,80}})));

//Doors//
 Modelica.Blocks.Interfaces.RealInput G[10]
    "Results : {DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], Azimut, Hauteur}"
    annotation (Placement(transformation(extent={{-120,70},{-80,110}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={22,70})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext annotation (
      Placement(transformation(extent={{-98,-96},{-78,-76}}),
        iconTransformation(extent={{-88,-8},{-68,12}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int annotation (
      Placement(transformation(extent={{82,-6},{102,14}}), iconTransformation(
          extent={{70,-8},{90,12}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky
 if ChoixGLOext annotation (Placement(transformation(extent={{-120,0},{-100,20}}),
        iconTransformation(extent={{-88,20},{-68,40}})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput Pint
 if ChoixPint "Internal radiative gains"
                                 annotation (Placement(transformation(
          extent={{140,56},{100,96}}), iconTransformation(extent={{62,34},{
            50,46}})));
equation

  connect(G, fLUXzone.G) annotation (Line(
      points={{-100,90},{-88.45,90},{-88.45,90.5},{-76.3,90.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Nord.FluxIncExt, fLUXzone.FluxIncExtNorth) annotation (Line(
      points={{-27.8,59.4},{-40,59.4},{-40,94.2},{-55,94.2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, FenSud.FluxIncExt) annotation (Line(
      points={{-55,90.4},{-36,90.4},{-36,6.5},{-29.1,6.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, Sud.FluxIncExt) annotation (Line(
      points={{-55,90.4},{-36,90.4},{-36,-8.7},{-29.1,-8.7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, Est.FluxIncExt) annotation (Line(
      points={{-55,86.4},{-40,86.4},{-40,23.5},{-28.5,23.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtWest, Ouest.FluxIncExt) annotation (Line(
      points={{-55,82.4},{-42,82.4},{-42,-46.6},{-27.8,-46.6}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, ToitureTerrasse.FluxIncExt) annotation (Line(
      points={{-55,98.4},{-46,98.4},{-46,95.4},{-27.8,95.4}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(ToitureTerrasse.T_ext, T_ext) annotation (Line(
      points={{-31.4,88.2},{-50,88.2},{-50,74},{-88,74},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Nord.T_ext, T_ext) annotation (Line(
      points={{-31.4,52.2},{-88,52.2},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FenSud.T_ext, T_ext) annotation (Line(
      points={{-33.3,0.9},{-88,0.9},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Sud.T_ext, T_ext) annotation (Line(
      points={{-33.3,-17.1},{-88,-17.1},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Est.T_ext, T_ext) annotation (Line(
      points={{-31.5,17.5},{-88,17.5},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ouest.T_ext, T_ext) annotation (Line(
      points={{-31.4,-53.8},{-88.7,-53.8},{-88.7,-86},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_a, T_ext) annotation (Line(
      points={{35,-65.2},{35,-86},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bFauxPlafond.port_ext, T_ext) annotation (Line(
      points={{96.2,-74.6},{96.2,-86},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_b_PlanchLNC.port_ext, T_ext) annotation (Line(
      points={{76.2,-74.6},{76.2,-86},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_b_PlanchLNC.port_int, noeudAir.port_a) annotation (Line(
      points={{81.8,-74.6},{81.8,-98},{118,-98},{118,-28},{16,-28},{16,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_bFauxPlafond.port_int, noeudAir.port_a)      annotation (
      Line(
      points={{101.8,-74.6},{101.8,-98},{118,-98},{118,-28},{16,-28},{16,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{35,-50.8},{35,-44.4},{16,-44.4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, T_int) annotation (Line(
      points={{16,4},{92,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_b_MurLNC.port_ext, T_ext) annotation (Line(
      points={{56.2,-74.6},{56.2,-86},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(coefficient_b_MurLNC.port_int, noeudAir.port_a) annotation (Line(
      points={{61.8,-74.6},{61.8,-98},{118,-98},{118,-28},{16,-28},{16,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ToitureTerrasse.T_int, noeudAir.port_a) annotation (Line(
      points={{-20.6,88.2},{-14,88.2},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ouest.T_int, noeudAir.port_a) annotation (Line(
      points={{-20.6,-53.8},{-14,-53.8},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Nord.T_int, noeudAir.port_a) annotation (Line(
      points={{-20.6,52.2},{-14,52.2},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Sud.T_int, noeudAir.port_a) annotation (Line(
      points={{-20.7,-17.1},{-14,-17.1},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Est.T_int, noeudAir.port_a) annotation (Line(
      points={{-22.5,17.5},{-14,17.5},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_int, T_int) annotation (Line(
      points={{92,4},{92,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FenOuest.FluxIncExt, fLUXzone.FluxIncExtWest) annotation (Line(
      points={{-29.1,-29.5},{-29.1,-29.75},{-55,-29.75},{-55,82.4}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenOuest.T_ext, T_ext) annotation (Line(
      points={{-33.3,-35.1},{-88,-35.1},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FenOuest.Ts_int, noeudAir.port_a) annotation (Line(
      points={{-24.9,-35.1},{-14,-35.1},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ponts_Thermiques.port_a, noeudAir.port_a) annotation (Line(
      points={{16,-62.8},{16,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ponts_Thermiques.port_b, T_ext) annotation (Line(
      points={{16,-77.2},{16,-86},{-88,-86}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, Coffre_Volets_Roulants.port_a) annotation (Line(
      points={{16,4},{0,4},{0,-62.8},{1.32262e-015,-62.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Coffre_Volets_Roulants.port_b, T_ext) annotation (Line(
      points={{-1.32262e-015,-77.2},{-1.32262e-015,-86},{-88,-86}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenEst.FluxIncExt, fLUXzone.FluxIncExtEast) annotation (Line(
      points={{-29.1,38.5},{-29.1,38.25},{-55,38.25},{-55,86.4}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Cloisons.T_ext, noeudAir.port_a) annotation (Line(
      points={{48.6,42.2},{44,42.2},{44,4},{16,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Refends.T_ext, noeudAir.port_a) annotation (Line(
      points={{48.6,26.2},{44,26.2},{44,4},{16,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PlancherIntermediaire.T_ext, noeudAir.port_a) annotation (Line(
      points={{48.6,10.2},{44,10.2},{44,4},{16,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Cloisons.T_int, T_int) annotation (Line(
      points={{59.4,42.2},{72,42.2},{72,4},{92,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Refends.T_int, T_int) annotation (Line(
      points={{59.4,26.2},{72,26.2},{72,4},{92,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherIntermediaire.T_int, T_int) annotation (Line(
      points={{59.4,10.2},{72,10.2},{72,4},{92,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[1], ToitureTerrasse.FluxAbsInt) annotation (
     Line(
      points={{71,78.9091},{-10,78.9091},{-10,93},{-24.2,93}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Nord.FluxAbsInt, pintDistribRad.FLUXParois[2]) annotation (Line(
      points={{-24.2,57},{-10.1,57},{-10.1,78.7273},{71,78.7273}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Sud.FluxAbsInt, pintDistribRad.FLUXParois[4]) annotation (Line(
      points={{-24.9,-11.5},{-10,-11.5},{-10,78.3636},{71,78.3636}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Ouest.FluxAbsInt, pintDistribRad.FLUXParois[5]) annotation (Line(
      points={{-24.2,-49},{-10,-49},{-10,78.1818},{71,78.1818}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(MurLNC.T_ext, coefficient_b_MurLNC.Tponder) annotation (Line(
      points={{57.1,-59.3},{57.1,-61.7},{59,-61.7},{59,-66.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurLNC.T_int, noeudAir.port_a) annotation (Line(
      points={{57.1,-46.7},{57.1,-28},{16,-28},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherLNC.T_int, noeudAir.port_a) annotation (Line(
      points={{79.1,-46.7},{79.1,-28},{16,-28},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherLNC.T_ext, coefficient_b_PlanchLNC.Tponder) annotation (Line(
      points={{79.1,-59.3},{79.1,-60.75},{79,-60.75},{79,-66.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FauxPlafond.T_int, noeudAir.port_a) annotation (Line(
      points={{99.1,-46.7},{99.1,-28},{16,-28},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FauxPlafond.T_ext, coefficient_bFauxPlafond.Tponder)      annotation (
     Line(
      points={{99.1,-59.3},{99.1,-62.7},{99,-62.7},{99,-66.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Cloisons.FluxAbsInt, pintDistribRad.FLUXParois[6]) annotation (Line(
      points={{55.8,47},{60,47},{60,78},{71,78}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Refends.FluxAbsInt, pintDistribRad.FLUXParois[7]) annotation (Line(
      points={{55.8,31},{60,31},{60,77.8182},{71,77.8182}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(PlancherIntermediaire.FluxAbsInt, pintDistribRad.FLUXParois[8])
    annotation (Line(
      points={{55.8,15},{60,15},{60,77.6364},{71,77.6364}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[10], PlancherLNC.FluxAbsInt) annotation (
      Line(
      points={{71,77.2727},{56,77.2727},{56,-46},{73.5,-46},{73.5,-50.9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FauxPlafond.FluxAbsInt, pintDistribRad.FLUXParois[11]) annotation (
      Line(
      points={{93.5,-50.9},{93.5,-46},{62,-46},{62,77.0909},{71,77.0909}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(MurLNC.FluxAbsInt, pintDistribRad.FLUXParois[9]) annotation (Line(
      points={{51.5,-50.9},{51.5,-46},{60,-46},{60,77.4545},{71,77.4545}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-20.7,0.9},{-14,0.9},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(FenOuest.CLOTr, sum1.u[4]) annotation (Line(
      points={{-20.7,-29.5},{-6,-29.5},{-6,58.6},{7.2,58.6}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenEst.CLOTr, sum1.u[2]) annotation (Line(
      points={{-20.7,38.5},{-6,38.5},{-6,57.8},{7.2,57.8}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenSud.CLOTr, sum1.u[1]) annotation (Line(
      points={{-20.7,6.5},{-6,6.5},{-6,57.4},{7.2,57.4}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(sum1.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{16.4,58},{32,58},{32,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, noeudAir.port_a) annotation (Line(
      points={{32,26},{32,4},{16,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Est.FluxAbsInt, pintDistribRad.FLUXParois[3]) annotation (Line(
      points={{-25.5,21.5},{-8,21.5},{-8,78.5455},{71,78.5455}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenEst.T_ext, T_ext) annotation (Line(
      points={{-33.3,32.9},{-88,32.9},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FenEst.T_int, noeudAir.port_a) annotation (Line(
      points={{-20.7,32.9},{-14,32.9},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, FenNord.FluxIncExt) annotation (Line(
      points={{-55,94.2},{-36,94.2},{-36,76.5},{-27.8,76.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenNord.CLOTr, sum1.u[3]) annotation (Line(
      points={{-20.6,76.5},{-12,76.5},{-12,58.2},{7.2,58.2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenNord.T_ext, T_ext) annotation (Line(
      points={{-31.4,70.9},{-88,70.9},{-88,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(FenNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-20.6,70.9},{-14,70.9},{-14,4},{16,4}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(T_sky, ToitureTerrasse.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,74},{-50,74},{-50,84.6},{-31.4,84.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, FenNord.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,66.7},{-31.4,66.7}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, Nord.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,48.6},{-31.4,48.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, FenEst.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,28.7},{-33.3,28.7}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, Est.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,14.5},{-31.5,14.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, FenSud.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,-3.3},{-33.3,-3.3}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, Sud.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,-21.3},{-33.3,-21.3}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, FenOuest.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,-39.3},{-33.3,-39.3}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, Ouest.T_sky) annotation (Line(
      points={{-110,10},{-88,10},{-88,-57.4},{-31.4,-57.4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXFenetres[3], FenNord.FluxAbsInt) annotation (Line(
      points={{71,73.75},{49.15,73.75},{49.15,74.85},{25.3,74.85},{25.3,75.1},{-24.2,
          75.1}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenEst.FluxAbsInt, pintDistribRad.FLUXFenetres[4]) annotation (Line(
      points={{-24.9,37.1},{-8,37.1},{-8,73.25},{71,73.25}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenSud.FluxAbsInt, pintDistribRad.FLUXFenetres[1]) annotation (Line(
      points={{-24.9,5.1},{-6,5.1},{-6,74.75},{71,74.75}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FenOuest.FluxAbsInt, pintDistribRad.FLUXFenetres[3]) annotation (Line(
      points={{-24.9,-30.9},{-4,-30.9},{-4,73.75},{71,73.75}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.RayEntrant, Pint) annotation (Line(
      points={{91,76},{120,76}},
      color={255,192,1},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-120,-120},
            {120,120}}),
                   graphics={
        Rectangle(
          extent={{-58,-18},{62,-38}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-54,-32},{-8,-34}},
          pattern=LinePattern.None,
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,-22},{-46,-32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,-22},{-30,-32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-22},{-14,-32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-32},{60,-34}},
          pattern=LinePattern.None,
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,-22},{22,-32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,-22},{38,-32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,-22},{54,-32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-22},{4,-26}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-38},{62,-40}},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,4},{62,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-54,-10},{-8,-12}},
          pattern=LinePattern.None,
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,0},{-46,-10}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,0},{-30,-10}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,0},{-14,-10}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-10},{60,-12}},
          pattern=LinePattern.None,
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,0},{22,-10}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,0},{38,-10}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,0},{54,-10}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,0},{4,-4}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-16},{62,-18}},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,26},{62,6}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-54,12},{-8,10}},
          pattern=LinePattern.None,
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,22},{-46,12}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,22},{-30,12}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,22},{-14,12}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,12},{60,10}},
          pattern=LinePattern.None,
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,22},{22,12}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,22},{38,12}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,22},{54,12}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,22},{4,18}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,6},{62,4}},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,28},{62,26}},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-44,52},{-58,28},{62,28},{46,52},{-44,52}},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-40,46},{-8,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-40,32},{-8,30}},
          pattern=LinePattern.None,
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,42},{-30,32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,42},{-14,32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,46},{44,28}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{12,32},{44,30}},
          pattern=LinePattern.None,
          fillColor={127,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,42},{22,32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,42},{38,32}},
          pattern=LinePattern.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,-40},{62,-58}},
          pattern=LinePattern.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0}),
        Ellipse(
          extent={{32,106},{10,84}},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,0},
          lineColor={0,0,0}),
        Rectangle(extent={{-58,26},{62,-38}}, lineColor={0,0,0})}),
                                Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-120,-120},{120,120}})),
    Documentation(info="<html>
<p><i>Complete R+5 collective housing building model (34 apartments)</i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pure thermal modelled collective housing building in monozone.</p>
<p><u><b>Bibliography</b></u></p>
<p>Pouget Consultants (Guillaume Moigno) for \"GT applicateurs RT 2012\".</p>
<p><i><a href=\"modelica://BuildSysPro/Resources/Documentation/ground_plane_building_34LC.pdf\">Building ground plane</a></i></p>
<p><u><b>Instructions for use</b></u></p>
<p>As there is no French building regulation records for this model, all building envelope parameters (walls, windows, ventilation...) have to be filled by the user.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Céline Ilias 12/2016</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Vincent MAGNAUDEIX, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>",
          revisions="<html>
<p>Aur&eacute;lie Kaemmerlen 07/2012 : Changement du mod&egrave;le de paroi avec reparam&eacute;trage</p>
<p>Bertin Technologies 09/2013 : Changement du mod&egrave;le de fen&ecirc;tre, ajout des options GLOext et Pint</p>
</html>"));
end Monozone34LC;
