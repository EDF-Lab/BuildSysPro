within BuildSysPro.BuildingStock.CollectiveHousing.Matisse;
model MatisseAssemblyCH
  "Matisse apartment for complete collective housing assembly"

// Public parameters
replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE.BuildingType
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
       then paraMaisonRT.hsExtVert else paraMaisonRT.hsExtVert - 5.15;
  parameter Boolean DifDir_out=false;
  parameter Real Gpontsthermiques = if PositionEtage==1 then paraMaisonRT.PontsTh_Generique+paraMaisonRT.PontsTh_Bas elseif PositionEtage==2 then paraMaisonRT.PontsTh_Generique else paraMaisonRT.PontsTh_Generique+paraMaisonRT.PontsTh_Haut;
  parameter Real ValeurQVconstant=paraMaisonRT.renouvAir*
      BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.VolumeMatisse
    "Default value if the air change rate is constant (m^3/h)"                         annotation (Dialog(group="Overall parameters"), enable=not QVin);

// Horizontal walls
protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall ParoiSousCombles(
    caracParoi=paraMaisonRT.PlafondImmeuble,
    hs_ext=paraMaisonRT.hsIntHorHaut,
    Tp=Tp,
    InitType=InitType,
    ParoiInterne=false,
    RadInterne=false,
    GLOext=GLOEXT,
    hs_int=paraMaisonRT.hsIntVert,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlafondHaut)
 if PositionEtage == 3
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-22,42})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    caracParoi=paraMaisonRT.PlancherImmeuble,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    Tp=Tp,
    InitType=InitType,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherBas,
    hs_int=paraMaisonRT.hsIntVert,
    RadInterne=true) if PositionEtage == 1         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={6,-60})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherInterm(
    ParoiInterne=true,
    hs_ext=paraMaisonRT.hsIntHorBas,
    Tp=Tp,
    InitType=InitType,
    hs_int=paraMaisonRT.hsIntVert,
    RadInterne=true,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PlancherBas,
    caracParoi=paraMaisonRT.PlancherMitoyen) if PositionEtage >= 2
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={46,-60})));

// Exterior vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurNord(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.hsIntVert,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    RadExterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurNord)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={46,6})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEst(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.hsIntVert,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurOuest)
    annotation (Placement(transformation(extent={{80,-28},{60,-8}})));

  // Common vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Porte(
    ParoiInterne=true,
    caracParoi=paraMaisonRT.Porte,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    Tp=Tp,
    InitType=InitType,
    GLOext=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PorteEntree)
    annotation (Placement(transformation(extent={{-80,-36},{-60,-16}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    ParoiInterne=true,
    caracParoi=paraMaisonRT.MurPalier,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    Tp=Tp,
    InitType=InitType,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurSud)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuest(
    ParoiInterne=true,
    hs_ext=paraMaisonRT.hsIntVert,
    hs_int=paraMaisonRT.hsIntVert,
    Tp=Tp,
    InitType=InitType,
    RadInterne=false,
    caracParoi=paraMaisonRT.MurMitoyen,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_MurEst)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  // Internal vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Cloisons(
    hs_int=paraMaisonRT.hsIntVert,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.hsIntVert,
    caracParoi=paraMaisonRT.Cloisons,
    Tp=Tp,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_Cloison)
    annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-14,-26})));

  // Glazings
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageNord(
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_VitrageNord,
    hs_ext=HE,
    hs_int=paraMaisonRT.hsIntVert,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/HE - 1/paraMaisonRT.hsIntVert),
    GLOext=GLOEXT,
    RadInterne=false,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{56,22},{36,42}})));

  // Thermal bridges
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    PontsThermiques(G=Gpontsthermiques) annotation (Placement(
        transformation(
        extent={{9.5,9.5},{-9.5,-9.5}},
        rotation=90,
        origin={17.5,39.5})));
  // Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky   if GLOEXT
     == true annotation (Placement(transformation(extent={{120,26},{140,46}}),
        iconTransformation(extent={{120,20},{140,40}})));

  // Solar fluxes
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle"
      annotation (Placement(transformation(extent={{-156,36},{-116,76}}),
        iconTransformation(extent={{-140,52},{-116,76}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=
       beta)
    annotation (Placement(transformation(extent={{-106,52},{-86,72}})));

  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(Tair=Tp, V=
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.VolumeMatisse)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(Qv=
        ValeurQVconstant, use_Qv_in=false) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={70,-42})));

// Temperatures of interest
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Exterior temperature" annotation (Placement(transformation(extent={{80,60},
            {100,80}}), iconTransformation(extent={{80,60},{100,80}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_landing
    "Landing temperature" annotation (Placement(transformation(extent={{-60,-60},
            {-40,-40}}), iconTransformation(extent={{-36,-80},{-16,-60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_inf
    "Lower floor temperature" annotation (Placement(transformation(extent={{120,
            -80},{140,-60}}), iconTransformation(extent={{120,-80},{140,-60}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_Gauguin
    "Adjacent Gauguin apartment temperature" annotation (Placement(
        transformation(extent={{-140,4},{-120,24}}), iconTransformation(extent=
            {{-140,-10},{-120,10}})));

protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PortesInt(
    hs_int=paraMaisonRT.hsIntVert,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.hsIntVert,
    Tp=Tp,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse.Surf_PorteSeparations,
    caracParoi=paraMaisonRT.PorteInt) annotation (choicesAllMatching=
        true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={16,-26})));

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Matisse
    "Air temperature" annotation (Placement(transformation(extent={{-10,6},{10,
            26}}), iconTransformation(extent={{3,-6},{23,14}})));
equation
  connect(MurSud.T_ext, T_int_landing) annotation (Line(
      points={{-79,-3},{-79,-50},{-50,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Porte.T_ext, T_int_landing) annotation (Line(
      points={{-79,-29},{-79,-50},{-50,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_Gauguin, MurOuest.T_ext) annotation (Line(
      points={{-130,14},{-105,14},{-105,27},{-79,27}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherInterm.T_ext, T_int_inf) annotation (Line(
      points={{49,-69},{49,-70},{130,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PlancherBas.T_ext, T_int_inf) annotation (Line(
      points={{9,-69},{9,-70},{130,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_sky, T_sky) annotation (Line(
      points={{79,-27},{130,-27},{130,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_ext, T_ext) annotation (Line(
      points={{79,-21},{90,-21},{90,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_a, T_ext) annotation (Line(
      points={{79,-42},{90,-42},{90,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurNord.T_sky, T_sky) annotation (Line(
      points={{55,-3},{130,-3},{130,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageNord.T_sky, T_sky) annotation (Line(
      points={{55,23},{130,23},{130,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageNord.T_ext, T_ext) annotation (Line(
      points={{55,29},{90,29},{90,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurNord.T_ext, T_ext) annotation (Line(
      points={{55,3},{90,3},{90,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_a, T_ext) annotation (Line(
      points={{17.5,48.05},{90,48.05},{90,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ParoiSousCombles.T_sky, T_sky) annotation (Line(
      points={{-13,51},{130,51},{130,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ParoiSousCombles.T_ext, T_ext) annotation (Line(
      points={{-19,51},{-19,70},{90,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageNord.CLOTr, PlancherInterm.FluxAbsInt) annotation (Line(
      points={{37,37},{34,37},{34,-46},{41,-46},{41,-57}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageNord.CLOTr, PlancherBas.FluxAbsInt) annotation (Line(
      points={{37,37},{34,37},{34,-46},{1,-46},{1,-57}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, ParoiSousCombles.FluxIncExt) annotation (
      Line(
      points={{-85,70.4},{-31,70.4},{-31,45}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageNord.FluxIncExt, fLUXzone.FluxIncExtNorth) annotation (Line(
      points={{49,37},{56,37},{56,66.2},{-85,66.2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(MurNord.FluxIncExt, fLUXzone.FluxIncExtNorth) annotation (Line(
      points={{49,15},{56,15},{56,66.2},{-85,66.2}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.G, G) annotation (Line(
      points={{-106.3,62.5},{-106.3,56},{-136,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, MurEst.FluxIncExt) annotation (Line(
      points={{-85,58.4},{82,58.4},{82,-9},{73,-9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(noeudAir.port_a, T_int_Matisse) annotation (Line(
      points={{0,-6},{0,16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Cloisons.T_int, noeudAir.port_a) annotation (Line(
      points={{-5,-29},{0,-29},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PortesInt.T_ext, noeudAir.port_a) annotation (Line(
      points={{7,-29},{0,-29},{0,-6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PortesInt.T_int, noeudAir.port_a) annotation (Line(
      points={{25,-29},{28,-29},{28,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cloisons.T_ext, noeudAir.port_a) annotation (Line(
      points={{-23,-29},{-26,-29},{-26,-6},{0,-6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{-61,-3},{-26,-3},{-26,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Porte.T_int, noeudAir.port_a) annotation (Line(
      points={{-61,-29},{-26,-29},{-26,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurOuest.T_int, noeudAir.port_a) annotation (Line(
      points={{-61,27},{-26,27},{-26,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ParoiSousCombles.T_int, noeudAir.port_a) annotation (Line(
      points={{-19,33},{-19,28},{-26,28},{-26,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{17.5,30.95},{17.5,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(VitrageNord.T_int, noeudAir.port_a) annotation (Line(
      points={{37,29},{37,14},{18,14},{18,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
      points={{37,3},{37,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherInterm.T_int, noeudAir.port_a) annotation (Line(
      points={{49,-51},{49,-20},{28,-20},{28,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_int, noeudAir.port_a) annotation (Line(
      points={{61,-21},{48,-21},{48,-20},{28,-20},{28,-6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{9,-51},{9,-40},{0,-40},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{61,-42},{48,-42},{48,-20},{44,-20},{44,-20},{28,-20},{28,
          -6},{0,-6}},
      color={255,0,0},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -80},{140,80}})),
Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-80},{140,80}}),   graphics={Bitmap(extent={{145,80},{
              -145,-80}},     fileName="modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Matisse/Matisse.png",
          origin={-1,0},
          rotation=180),
        Ellipse(
          extent={{-136,81},{-86,34}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i>Matisse apartment</i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pure thermal modelled Matisse monozone apartment.</p>
<p>Height under ceiling : 2.5m.</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of building stock library</p>
<p>Notes H-E10-1996-02908-FR and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>Wall and glazing surfaces come from <a href=\"BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsMatisse\"><code>SettingsMatisse</code></a> record.</p>
<p>To change a surface value, prefer to modify it in the record rather than in the assembly.</p>
<p>Parameters depending on RT (French building regulation) are stored in <a href=\"BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataMATISSE\"><code>BuildingDataMATISSE</code></a> records.</p>
<p>When one of these records is selectied thanks to <code>paraMaisonRT</code>, building envelope parameters (walls, windows, ventilation...) will take the values stored in the selected record.</p>
<p>Available parameters are listed below :</p>
<ul><li><code>paraMaisonRT</code> : choice of the RT (French building regulation)</li>
<li><code>GLOext</code> : integration of LW radiation (infrared) toward the environment and the sky</li>
<li><code>beta</code> : allows to choose the orientation of the apartment, by default if beta=0, windows will be on north</li>
<li><code>PositionEtage</code> : 1 if ground floor, 2 if intermediat floore, 3 if last floor. it is possible to assembly a n floor building with a numbering such as : 1 - 2 - .... - 2 - 3</li></ul>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Frédéric Gastiger 01/2014</p>
<p>See note H-E13-2014-00591-FR for validation</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Frédéric GASTIGER, EDF (2014)<br>
--------------------------------------------------------------</b></p></html>"));
end MatisseAssemblyCH;
