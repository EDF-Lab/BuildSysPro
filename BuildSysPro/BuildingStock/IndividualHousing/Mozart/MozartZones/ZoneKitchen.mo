within BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartZones;
model ZoneKitchen

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
parameter Integer TypeFenetrePF=1 "Choice of type of window or French window"
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

  // Thermal bridges
  parameter Modelica.SIunits.ThermalConductance G_ponts=
      Utilities.Functions.CalculGThermalBridges(
      ValeursK=paraMaisonRT.ValeursK,
      LongueursPonts=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.LongueursPontsCuisine,
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondCuisine)
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondCuisine)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={51,-92})));

// Exterior vertical walls
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurNordCuisine)
    annotation (Placement(transformation(extent={{-7,22},{7,36}})));

// Internal vertical walls

// Glazings
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageNordCuisine,
    H=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.H_VitrageNordCuisine)
    annotation (Placement(transformation(extent={{-37,22},{-23,36}})));

// Thermal bridges
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor PontsThermiques(G=G_ponts)
    annotation (Placement(transformation(extent={{-58,-80},{-43,-65}})));

// Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tciel if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,0},{-80,20}}),
        iconTransformation(extent={{60,100},{80,120}})));
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib PintdistriRad(
    np=6,
    nf=1,
    Sf={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_VitrageNordCuisine},
    Sp={BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_MurNordCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegEntreeCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_CloisonLegC1Cuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_RefendSejourCuisine,
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondCuisine}) if
       not CLOintPlancher
    annotation (Placement(transformation(extent={{-2,-92},{18,-72}})));

// Base components
protected
  Modelica.Blocks.Math.MultiSum multiSum(nu=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,-66})));
public
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondCuisine
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart, Tair=293.15)
    annotation (Placement(transformation(extent={{70,16},{90,36}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text annotation (
      Placement(transformation(extent={{-100,30},{-80,50}}), iconTransformation(
          extent={{20,100},{40,120}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a TCuisine
    annotation (Placement(transformation(extent={{80,-29},{100,-9}}),
        iconTransformation(extent={{-25,18},{-5,38}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(
      use_Qv_in=QVin, Qv=paraMaisonRT.renouvAir*BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.Surf_PlancherPlafondCuisine
        *BuildSysPro.BuildingStock.Utilities.Records.Geometry.IndividualHousing.SettingsMozart.HauteurMozart) annotation (
     Placement(transformation(
        extent={{11,-11},{-11,11}},
        rotation=270,
        origin={71,-49})));
Modelica.Blocks.Interfaces.RealInput RenouvAir if         QVin==true
    annotation (Placement(transformation(extent={{120,-98},{80,-58}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={25,79})));

  Modelica.Blocks.Interfaces.RealInput VENTNord if
                                               useOuverture annotation (
      Placement(transformation(extent={{-112,-24},{-88,0}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.BooleanInput ouvertureFenetres[1] if useOuverture
    "Opening of north window"
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}}),
        iconTransformation(extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-21,79})));
  Modelica.Blocks.Interfaces.RealInput fermetureVolets[1] if useVolet
    "Closing of north shutters"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}}),
        iconTransformation(extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-5,79})));
  BuildSysPro.BoundaryConditions.Solar.Interfaces.SolarFluxInput FluxNord[3]
    annotation (Placement(transformation(extent={{-112,76},{-88,100}}),
        iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={-40,108})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonEntree if not CLOintPlancher
    annotation (Placement(transformation(extent={{84,80},{104,100}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput FLUXcloisonC1 if not CLOintPlancher
    annotation (Placement(transformation(extent={{84,60},{104,80}}),
        iconTransformation(extent={{60,10},{80,30}})));
  Modelica.Blocks.Interfaces.RealOutput FLUXrefendSejour if not CLOintPlancher
    annotation (Placement(transformation(extent={{84,40},{104,60}}),
        iconTransformation(extent={{-60,10},{-80,30}})));
equation
  if CLOintPlancher==false then
    connect(multiSum.y, PintdistriRad.RayEntrant) annotation (Line(
      points={{-14,-73.02},{-14,-82},{-1,-82}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXFenetres[1], VitrageNord.FluxAbsInt) annotation (
      Line(
      points={{19,-80},{22,-80},{22,30.4},{-27.9,30.4}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[1], ParoiSousCombles.FluxAbsInt) annotation (
     Line(
      points={{19,-84.8333},{22,-84.8333},{22,92.5},{2.1,92.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[2], MurNord.FluxAbsInt) annotation (Line(
      points={{19,-84.5},{22,-84.5},{22,32.5},{2.1,32.5}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[3], FLUXcloisonEntree) annotation (Line(
      points={{19,-84.1667},{22,-84.1667},{22,90},{94,90}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[4], FLUXcloisonC1) annotation (Line(
      points={{19,-83.8333},{22,-83.8333},{22,70},{94,70}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(PintdistriRad.FLUXParois[5], FLUXrefendSejour) annotation (Line(
      points={{19,-83.5},{22,-83.5},{22,50},{94,50}},
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
    connect(Tciel, VitrageNord.T_ciel) annotation (Line(
      points={{-90,10},{-64,10},{-64,22.7},{-36.3,22.7}},
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

  if useVolet then
connect(fermetureVolets[1], VitrageNord.fermeture_volet) annotation (
      Line(
      points={{-100,-80},{-76,-80},{-76,33.9},{-36.3,33.9}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  end if;

  if useOuverture then
    connect(ouvertureFenetres[1], VitrageNord.ouverture_fenetre)
      annotation (Line(
        points={{-100,-48},{-74,-48},{-74,29},{-32.1,29}},
        color={255,0,255},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end if;

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
    connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
      points={{6.3,26.9},{40,26.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
    connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{53.1,-85.7},{53.1,-60},{40,-60},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Text, VitrageNord.T_ext) annotation (Line(
      points={{-90,40},{-52,40},{-52,26.9},{-36.3,26.9}},
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
  connect(VitrageNord.CLOTr, multiSum.u[1]) annotation (Line(
      points={{-23.7,32.5},{-14,32.5},{-14,-60}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Text, renouvellementAir.port_a) annotation (Line(
      points={{-90,40},{-52,40},{-52,-46},{-64,-46},{-64,-102},{71,-102},{71,-58.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(noeudAir.port_a, TCuisine) annotation (Line(
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

  connect(VitrageNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-23.7,26.9},{40,26.9},{40,40},{80,40},{80,22}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(FluxNord, VitrageNord.FLUX) annotation (Line(
      points={{-100,88},{-70,88},{-70,32.5},{-32.1,32.5}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(FluxNord, MurNord.FLUX) annotation (Line(
      points={{-100,88},{-70,88},{-70,35.3},{-2.1,35.3}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(VENTNord, VitrageNord.V) annotation (Line(
      points={{-100,-12},{-66,-12},{-66,29},{-36.3,29}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}}),
graphics={
        Bitmap(extent={{-98,72},{86,-72}}, fileName="modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Mozart/Cuisine.png"),
        Ellipse(extent={{12,68},{40,40}},   lineColor={0,0,0}),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={26,84},
          rotation=360),
        Ellipse(
          extent={{24,56},{28,52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-52,-48},{-40,-38},{-22,-46}},
          color={0,0,255},
          smooth=Smooth.Bezier,
          origin={-12,-2},
          rotation=180),
        Line(
          points={{10,64},{26,72},{40,64}},
          color={0,0,255},
          smooth=Smooth.Bezier),
        Polygon(
          points={{40,66},{42,62},{38,64},{40,66}},
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
          origin={-4,54},
          rotation=90),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={26,24},
          rotation=180),
        Polygon(
          points={{-4,-18},{4,-18},{0,-30},{-4,-18}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={56,54},
          rotation=270),
        Polygon(
          points={{0,-2},{2,2},{-2,0},{0,-2}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={11,44},
          rotation=90)}),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<p><i><b>Zone kitchen Mozart</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Alexandre Hautefeuille, Gilles Plessis, Amy Lindsay 04/2014</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Alexandre HAUTEFEUILLE, Gilles PLESSIS, Amy LINDSAY, EDF (2014)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ZoneKitchen;
