within BuildSysPro.BuildingStock.CollectiveHousing.Gauguin;
model GauguinAssemblyCH
  "Gauguin apartment for complete collective housing assembly"

// Public parameters
replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataGAUGUIN.BuildingType
    paraMaisonRT "French building regulation to use"   annotation(choicesAllMatching=true, Dialog(group="Overall parameters"));
parameter Boolean GLOEXT=false
    "Integration of LW radiation (infrared) toward the environment and the sky"
    annotation(Dialog(tab="Advanced parameters"), choices(radioButtons=true));
  parameter Modelica.Units.SI.Temperature Tp=293.15
    "Initial temperature of walls"
    annotation (Dialog(tab="Advanced parameters"));
  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState
    "Type of initialization for walls"
    annotation (Dialog(tab="Advanced parameters"));
parameter Integer PositionEtage=2 "Floor position"
   annotation(Dialog(group="Overall parameters"),choices(
                choice=1 "Ground floor",
                choice=2 "Intermediate floor",
                choice=3 "Last floor",radioButtons=true));
 parameter Real beta=0
    "Correction of azimuth for vertical walls such as azimuth=beta+azimuth, {beta=0 : N=180,S=0,E=-90,O=90}"
 annotation(Dialog(group="Overall parameters"));

// Protected parameters

protected
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer HE=if GLOEXT == false
       then paraMaisonRT.Hsext else paraMaisonRT.Hsext - 5.15;
  parameter Boolean DifDir_out=false;
  parameter Modelica.Units.SI.ThermalConductance Gpontsthermiques=if
      PositionEtage == 1 then paraMaisonRT.PontsTh_Generique + paraMaisonRT.PontsTh_Bas
       elseif PositionEtage == 2 then paraMaisonRT.PontsTh_Generique else
      paraMaisonRT.PontsTh_Generique + paraMaisonRT.PontsTh_Haut;
  parameter Real ValeurQVconstant=paraMaisonRT.TauxRenouvAir*
      BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.VolumeGauguin
    "Default value if the air change rate is constant (m^3/h)"                         annotation (Dialog(group="Overall parameters"), enable=not QVin);

// Horizontal walls
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall ParoiSousCombles(
    caracParoi=paraMaisonRT.ParoiSousCombles,
    hs_ext=paraMaisonRT.HsParoiSousCombles,
    Tp=Tp,
    InitType=InitType,
    ParoiInterne=false,
    RadInterne=false,
    GLOext=GLOEXT,
    hs_int=paraMaisonRT.Hsint,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_ParoiSousCombles)
 if PositionEtage == 3
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,66})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    caracParoi=paraMaisonRT.PlancherBas,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.HsPlancherBas,
    Tp=Tp,
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_PlancherBas,
    hs_int=paraMaisonRT.Hsint,
    RadInterne=true) if PositionEtage == 1         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={14,-74})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherInterm(
    ParoiInterne=true,
    hs_ext=paraMaisonRT.HsPlancherBas,
    Tp=Tp,
    InitType=InitType,
    hs_int=paraMaisonRT.Hsint,
    RadInterne=true,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_PlancherInt,
    caracParoi=paraMaisonRT.PlancherInterm) if PositionEtage >= 2
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={54,-74})));

// Exterior vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurNord(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    RadExterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_MurNord)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-42,54})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuest(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_MurOuest)
    annotation (Placement(transformation(extent={{-52,16},{-32,36}})));

  // Common vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Porte(
    ParoiInterne=true,
    caracParoi=paraMaisonRT.Porte,
    hs_ext=paraMaisonRT.Hsint,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_PorteEntree)
    annotation (Placement(transformation(extent={{68,-10},{48,10}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEstCage(
    ParoiInterne=true,
    hs_ext=paraMaisonRT.Hsint,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_MurEstCage,
    caracParoi=paraMaisonRT.MurCage)
    annotation (Placement(transformation(extent={{68,-40},{48,-20}})));

  // Internal vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Cloisons(
    hs_int=paraMaisonRT.Hsint,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.Hsint,
    caracParoi=paraMaisonRT.Cloisons,
    Tp=Tp,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_Cloison)
    annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-12,-30})));

  // Glazings
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageNord(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_VitrageNord,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/HE - 1/paraMaisonRT.Hsint),
    GLOext=GLOEXT,
    RadInterne=false,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{-52,-40},{-32,-20}})));

  // Thermal bridges
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    PontsThermiques(G=Gpontsthermiques) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={34,42})));
  // Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky   if GLOEXT
     == true annotation (Placement(transformation(extent={{-100,40},{-80,60}}),
        iconTransformation(extent={{-100,40},{-80,60}})));

  // Solar fluxes
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle"
      annotation (Placement(transformation(extent={{-120,-98},{-80,-58}}),
        iconTransformation(extent={{-100,-90},{-76,-66}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=
       beta)
    annotation (Placement(transformation(extent={{-88,-96},{-68,-76}})));

  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(Tair=Tp, V=
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.VolumeGauguin)
    annotation (Placement(transformation(extent={{0,-14},{20,6}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(Qv=
        ValeurQVconstant, use_Qv_in=false) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-12,42})));

// Temperatures of interest
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Exterior temperature" annotation (Placement(transformation(extent={{-80,80},
            {-60,100}}), iconTransformation(extent={{-80,80},{-60,100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_landing
    "Landing temperature" annotation (Placement(transformation(extent={{80,0},{
            100,20}}), iconTransformation(extent={{80,-28},{100,-8}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_inf
    "Lower floor temperature" annotation (Placement(transformation(extent={{80,
            -100},{100,-80}}), iconTransformation(extent={{80,-100},{100,-80}})));

protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PortesInt(
    hs_int=paraMaisonRT.Hsint,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.Hsint,
    Tp=Tp,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_PorteSeparations,
    caracParoi=paraMaisonRT.PorteInt) annotation (choicesAllMatching=
        true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={32,-30})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    RadExterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_MurSud)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-42,-2})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageSud(
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/HE - 1/paraMaisonRT.Hsint),
    GLOext=GLOEXT,
    RadInterne=false,
    DifDirOut=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_VitrageSud)
    annotation (Placement(transformation(extent={{-52,-68},{-32,-48}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEstPalier(
    ParoiInterne=true,
    hs_ext=paraMaisonRT.Hsint,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_MurEstPal,
    caracParoi=paraMaisonRT.MurPalier)
    annotation (Placement(transformation(extent={{68,16},{48,36}})));

protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Refends(
    hs_int=paraMaisonRT.Hsint,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.Hsint,
    Tp=Tp,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin.Surf_Refends,
    caracParoi=paraMaisonRT.Refends) annotation (choicesAllMatching=
        true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-30})));

public
Modelica.Blocks.Math.Add Transmission(k1=1, k2=1)                  annotation (Placement(transformation(extent={{-14,-56},
            {-4,-46}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Gauguin
    "Air temperature" annotation (Placement(transformation(extent={{0,6},{20,26}}),
        iconTransformation(extent={{-7,-40},{13,-20}})));
equation
  connect(fLUXzone.G, G) annotation (Line(
      points={{-88.3,-85.5},{-88.3,-78},{-100,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Porte.T_ext, T_int_landing) annotation (Line(
      points={{67,-3},{72,-3},{72,10},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurEstPalier.T_ext, T_int_landing) annotation (Line(
      points={{67,23},{72,23},{72,10},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, ParoiSousCombles.FluxIncExt) annotation (
      Line(
      points={{-67,-77.6},{-66,-77.6},{-66,69},{19,69}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, MurNord.FluxIncExt) annotation (Line(
      points={{-67,-81.8},{-64,-81.8},{-64,63},{-45,63}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtNorth, VitrageNord.FluxIncExt) annotation (Line(
      points={{-67,-81.8},{-64,-81.8},{-64,-25},{-45,-25}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, MurSud.FluxIncExt) annotation (Line(
      points={{-67,-85.6},{-62,-85.6},{-62,7},{-45,7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, VitrageSud.FluxIncExt) annotation (Line(
      points={{-67,-85.6},{-62,-85.6},{-62,-53},{-45,-53}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtWest, MurOuest.FluxIncExt) annotation (Line(
      points={{-67,-93.6},{-67,-94},{-60,-94},{-60,35},{-45,35}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(T_sky, VitrageSud.T_sky) annotation (Line(
      points={{-90,50},{-90,-67},{-51,-67}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, VitrageNord.T_sky) annotation (Line(
      points={{-90,50},{-90,-39},{-51,-39}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, MurSud.T_sky) annotation (Line(
      points={{-90,50},{-90,-11},{-51,-11}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, MurOuest.T_sky) annotation (Line(
      points={{-90,50},{-90,17},{-51,17}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, T_sky) annotation (Line(
      points={{-90,50},{-90,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, MurNord.T_sky) annotation (Line(
      points={{-90,50},{-84,50},{-84,45},{-51,45}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_sky, ParoiSousCombles.T_sky) annotation (Line(
      points={{-90,50},{-90,75},{1,75}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, ParoiSousCombles.T_ext) annotation (Line(
      points={{-70,90},{7,90},{7,75}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, PontsThermiques.port_a) annotation (Line(
      points={{-70,90},{34,90},{34,51}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, renouvellementAir.port_a) annotation (Line(
      points={{-70,90},{-12,90},{-12,51}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, MurNord.T_ext) annotation (Line(
      points={{-70,90},{-70,51},{-51,51}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, MurOuest.T_ext) annotation (Line(
      points={{-70,90},{-70,23},{-51,23}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, MurSud.T_ext) annotation (Line(
      points={{-70,90},{-70,-5},{-51,-5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, VitrageNord.T_ext) annotation (Line(
      points={{-70,90},{-70,-33},{-51,-33}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_ext, VitrageSud.T_ext) annotation (Line(
      points={{-70,90},{-70,-61},{-51,-61}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageNord.CLOTr, Transmission.u1) annotation (Line(
      points={{-33,-25},{-24,-25},{-24,-48},{-15,-48}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageSud.CLOTr, Transmission.u2) annotation (Line(
      points={{-33,-53},{-15,-53},{-15,-54}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(Transmission.y, PlancherBas.FluxAbsInt) annotation (Line(
      points={{-3.5,-51},{9,-51},{9,-71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Transmission.y, PlancherInterm.FluxAbsInt) annotation (Line(
      points={{-3.5,-51},{49,-51},{49,-71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PlancherInterm.T_ext, T_int_inf) annotation (Line(
      points={{57,-83},{57,-90},{90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PlancherBas.T_ext, T_int_inf) annotation (Line(
      points={{17,-83},{17,-90},{90,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurEstCage.T_ext, T_int_landing) annotation (Line(
      points={{67,-33},{72,-33},{72,10},{90,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{34,33},{34,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurEstPalier.T_int, noeudAir.port_a) annotation (Line(
      points={{49,23},{32,23},{32,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Porte.T_int, noeudAir.port_a) annotation (Line(
      points={{49,-3},{32,-3},{32,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurEstCage.T_int, noeudAir.port_a) annotation (Line(
      points={{49,-33},{44,-33},{44,-4},{32,-4},{32,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PortesInt.T_int, noeudAir.port_a) annotation (Line(
      points={{41,-33},{44,-33},{44,-4},{32,-4},{32,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PortesInt.T_ext, noeudAir.port_a) annotation (Line(
      points={{23,-33},{23,-8},{10,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Refends.T_int, noeudAir.port_a) annotation (Line(
      points={{19,-33},{19,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Refends.T_ext, noeudAir.port_a) annotation (Line(
      points={{1,-33},{1,-8},{10,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Cloisons.T_int, noeudAir.port_a) annotation (Line(
      points={{-3,-33},{-3,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cloisons.T_ext, noeudAir.port_a) annotation (Line(
      points={{-21,-33},{-21,-8},{10,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-33,-5},{-16,-5},{-16,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{-33,23},{-16,23},{-16,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-33,51},{-26,51},{-26,24},{-16,24},{-16,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{-12,33},{-12,22},{-16,22},{-16,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_int_Gauguin, noeudAir.port_a) annotation (Line(
      points={{10,16},{10,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ParoiSousCombles.T_int, noeudAir.port_a) annotation (Line(
      points={{7,57},{7,28},{-12,28},{-12,22},{-16,22},{-16,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{17,-65},{17,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherInterm.T_int, noeudAir.port_a) annotation (Line(
      points={{57,-65},{57,-46},{44,-46},{44,-4},{32,-4},{32,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(VitrageNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-33,-33},{-28,-33},{-28,-6},{-16,-6},{-16,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(VitrageSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-33,-61},{-28,-61},{-28,-6},{-16,-6},{-16,-8},{10,-8}},
      color={255,0,0},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Bitmap(extent={{100,100},{
              -100,-100}},      fileName=
              "modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Gauguin/Gauguin.png",
          origin={0,0},
          rotation=180),
        Ellipse(
          extent={{-98,-53},{-48,-100}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i>Gauguin apartment</i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pure thermal modelled Gauguin monozone apartment.</p>
<p>To be complete, the model should be connected to a Matisse apartment, which contains common wall model.</p>
<p>Height under ceiling : 2.5m.</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of building stock library</p>
<p>Notes H-E10-1996-02908-FR and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>Wall and glazing surfaces come from <a href=\"BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsGauguin\"><code>SettingsGauguin</code></a> record.</p>
<p>To change a surface value, prefer to modify it in the record rather than in the assembly.</p>
<p>Parameters depending on RT (French building regulation) are stored in <a href=\"BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataGAUGUIN\"><code>BuildingDataGAUGUIN</code></a> records.</p>
<p>When one of these records is selectied thanks to <code>paraMaisonRT</code>, building envelope parameters (walls, windows, ventilation...) will take the values stored in the selected record.</p>
<p>Available parameters are listed below :</p>
<ul><li><code>paraMaisonRT</code> : choice of the RT (French building regulation)</li>
<li><code>GLOext</code> : integration of LW radiation (infrared) toward the environment and the sky</li>
<li><code>beta</code> : allows to choose the orientation of the apartment, by default if beta=0, windows will be on north/south</li>
<li><code>PositionEtage</code> : 1 if ground floor, 2 if intermediat floore, 3 if last floor. it is possible to assembly a n floor building with a numbering such as : 1 - 2 - .... - 2 - 3</li></ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p>See note H-E13-2014-00591-FR for validation</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
end GauguinAssemblyCH;
