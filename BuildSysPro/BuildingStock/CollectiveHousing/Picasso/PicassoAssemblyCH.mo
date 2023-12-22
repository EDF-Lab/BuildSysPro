within BuildSysPro.BuildingStock.CollectiveHousing.Picasso;
model PicassoAssemblyCH
  "Picasso apartment for complete collective housing assembly"

// Public parameters
replaceable parameter
    BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO.BuildingType
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
      BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.VolumePicasso
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
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_ParoiSousCombles)
 if PositionEtage == 3
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-2,68})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherBas(
    caracParoi=paraMaisonRT.PlancherBas,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.HsPlancherBas,
    Tp=Tp,
    InitType=InitType,
    hs_int=paraMaisonRT.Hsint,
    RadInterne=true,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_PlancherBas)
 if PositionEtage == 1                             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-26,-90})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PlancherInterm(
    ParoiInterne=true,
    hs_ext=paraMaisonRT.HsPlancherBas,
    Tp=Tp,
    InitType=InitType,
    hs_int=paraMaisonRT.Hsint,
    RadInterne=true,
    caracParoi=paraMaisonRT.PlancherInterm,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_PlancherInt)
 if PositionEtage >= 2                             annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-90})));

// Exterior vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurSud(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    RadExterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_MurSud)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,-38})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuestExt(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_MurOuestExt)
    annotation (Placement(transformation(extent={{60,18},{40,38}})));

  // Common vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Porte(
    ParoiInterne=true,
    caracParoi=paraMaisonRT.Porte,
    hs_ext=paraMaisonRT.Hsint,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_PorteEntree)
    annotation (Placement(transformation(extent={{-72,-12},{-52,8}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurNord(
    ParoiInterne=true,
    caracParoi=paraMaisonRT.MurPalier,
    hs_ext=paraMaisonRT.Hsint,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_MurNord)
    annotation (Placement(transformation(extent={{-72,18},{-52,38}})));

  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurOuestLNC(
    ParoiInterne=true,
    hs_ext=paraMaisonRT.Hsint,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    RadInterne=false,
    caracParoi=paraMaisonRT.MurExt,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_MurOuestLNC)
    annotation (Placement(transformation(extent={{-72,-60},{-52,-40}})));

  // Internal vertical walls
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall Cloisons(
    hs_int=paraMaisonRT.Hsint,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.Hsint,
    caracParoi=paraMaisonRT.Cloisons,
    Tp=Tp,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_Cloison)
    annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-14,-50})));

  // Glazings
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Window VitrageSud(
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    k=1/(1/paraMaisonRT.UvitrageAF - 1/HE - 1/paraMaisonRT.Hsint),
    GLOext=GLOEXT,
    RadInterne=false,
    DifDirOut=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_VitrageSud)
    annotation (Placement(transformation(extent={{60,-74},{40,-54}})));

  // Thermal bridges
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor
    PontsThermiques(G=Gpontsthermiques) annotation (Placement(
        transformation(
        extent={{9.5,9.5},{-9.5,-9.5}},
        rotation=90,
        origin={23.5,39.5})));
  // Components for LW/SW radiations
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_sky   if GLOEXT
     == true annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

  // Solar fluxes
Modelica.Blocks.Interfaces.RealInput G[10]
    "DIFH, DIRN, DIRH, GLOH, t0, CosDir[1:3], solar azimuth angle, solar elevation angle"
      annotation (Placement(transformation(extent={{-148,52},{-108,92}}),
        iconTransformation(extent={{-132,68},{-108,92}})));
protected
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXzone fLUXzone(beta=
       beta)
    annotation (Placement(transformation(extent={{-106,52},{-86,72}})));

  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(Tair=Tp, V=
        BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.VolumePicasso)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal renouvellementAir(Qv=
        ValeurQVconstant, use_Qv_in=false) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-24,40})));

// Temperatures of interest
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext
    "Exterior temperature" annotation (Placement(transformation(extent={{60,80},
            {80,100}}), iconTransformation(extent={{60,80},{80,100}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_landing
    "Landing temperature" annotation (Placement(transformation(extent={{-120,0},
            {-100,20}}), iconTransformation(extent={{-120,-20},{-100,0}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b T_int_inf
    "Lower floor temperature" annotation (Placement(transformation(extent={{100,
            -120},{120,-100}}), iconTransformation(extent={{100,-120},{120,-100}})));

protected
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall MurEst(
    caracParoi=paraMaisonRT.MurExt,
    hs_ext=HE,
    hs_int=paraMaisonRT.Hsint,
    Tp=Tp,
    InitType=InitType,
    GLOext=GLOEXT,
    RadInterne=false,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_MurEst)
    annotation (Placement(transformation(extent={{60,-12},{40,8}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.Wall PortesInt(
    hs_int=paraMaisonRT.Hsint,
    ParoiInterne=true,
    hs_ext=paraMaisonRT.Hsint,
    Tp=Tp,
    caracParoi=paraMaisonRT.PorteInt,
    S=BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso.Surf_PorteSeparations)
    annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={14,-50})));
public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_int_Picasso
    "Air temperature" annotation (Placement(transformation(extent={{-10,-4},{10,
            16}}), iconTransformation(extent={{-13,-32},{7,-12}})));
equation
  connect(fLUXzone.G, G) annotation (Line(
      points={{-106.3,62.5},{-106.3,72},{-128,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(MurNord.T_ext, T_int_landing) annotation (Line(
      points={{-71,25},{-86,25},{-86,10},{-110,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Porte.T_ext, T_int_landing) annotation (Line(
      points={{-71,-5},{-86,-5},{-86,10},{-110,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurOuestExt.T_sky, T_sky) annotation (Line(
      points={{59,19},{110,19},{110,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageSud.T_sky, T_sky) annotation (Line(
      points={{59,-73},{110,-73},{110,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurSud.T_sky, T_sky) annotation (Line(
      points={{59,-47},{110,-47},{110,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_sky, T_sky) annotation (Line(
      points={{59,-11},{110,-11},{110,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ParoiSousCombles.T_sky, T_sky) annotation (Line(
      points={{7,77},{110,77},{110,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurOuestExt.T_ext, T_ext) annotation (Line(
      points={{59,25},{70,25},{70,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageSud.T_ext, T_ext) annotation (Line(
      points={{59,-67},{70,-67},{70,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurSud.T_ext, T_ext) annotation (Line(
      points={{59,-41},{70,-41},{70,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_ext, T_ext) annotation (Line(
      points={{59,-5},{70,-5},{70,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ParoiSousCombles.T_ext, T_ext) annotation (Line(
      points={{1,77},{1,90},{70,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtRoof, ParoiSousCombles.FluxIncExt) annotation (
      Line(
      points={{-85,70.4},{-85,78},{-11,78},{-11,71}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(PontsThermiques.port_a, T_ext) annotation (Line(
      points={{23.5,48.05},{23.5,52},{70,52},{70,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_a, T_ext) annotation (Line(
      points={{-24,49},{-24,52},{70,52},{70,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PlancherInterm.T_ext, T_int_inf) annotation (Line(
      points={{23,-99},{23,-110},{110,-110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PlancherBas.T_ext, T_int_inf) annotation (Line(
      points={{-23,-99},{-23,-110},{110,-110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(VitrageSud.CLOTr, PlancherBas.FluxAbsInt) annotation (Line(
      points={{41,-59},{34,-59},{34,-74},{-31,-74},{-31,-87}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(VitrageSud.CLOTr, PlancherInterm.FluxAbsInt) annotation (Line(
      points={{41,-59},{34,-59},{34,-74},{15,-74},{15,-87}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtEast, MurEst.FluxIncExt) annotation (Line(
      points={{-85,58.4},{82,58.4},{82,7},{53,7}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, MurSud.FluxIncExt) annotation (Line(
      points={{-85,62.4},{88,62.4},{88,-29},{53,-29}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtSouth, VitrageSud.FluxIncExt) annotation (Line(
      points={{-85,62.4},{88,62.4},{88,-59},{53,-59}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXzone.FluxIncExtWest, MurOuestExt.FluxIncExt) annotation (Line(
      points={{-85,54.4},{76,54.4},{76,37},{53,37}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(MurOuestLNC.T_ext, T_int_landing) annotation (Line(
      points={{-71,-53},{-86,-53},{-86,10},{-110,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(renouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{-24,31},{-24,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PontsThermiques.port_b, noeudAir.port_a) annotation (Line(
      points={{23.5,30.95},{23.5,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurOuestExt.T_int, noeudAir.port_a) annotation (Line(
      points={{41,25},{24,25},{24,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurEst.T_int, noeudAir.port_a) annotation (Line(
      points={{41,-5},{24,-5},{24,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurSud.T_int, noeudAir.port_a) annotation (Line(
      points={{41,-41},{24,-41},{24,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PortesInt.T_int, noeudAir.port_a) annotation (Line(
      points={{23,-53},{23,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PortesInt.T_ext, noeudAir.port_a) annotation (Line(
      points={{5,-53},{0,-53},{0,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Cloisons.T_int, noeudAir.port_a) annotation (Line(
      points={{-5,-53},{0,-53},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Cloisons.T_ext, noeudAir.port_a) annotation (Line(
      points={{-23,-53},{-24,-53},{-24,-24},{0,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(MurOuestLNC.T_int, noeudAir.port_a) annotation (Line(
      points={{-53,-53},{-24,-53},{-24,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Porte.T_int, noeudAir.port_a) annotation (Line(
      points={{-53,-5},{-24,-5},{-24,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(MurNord.T_int, noeudAir.port_a) annotation (Line(
      points={{-53,25},{-24,25},{-24,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherBas.T_int, noeudAir.port_a) annotation (Line(
      points={{-23,-81},{-23,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(PlancherInterm.T_int, noeudAir.port_a) annotation (Line(
      points={{23,-81},{23,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(VitrageSud.T_int, noeudAir.port_a) annotation (Line(
      points={{41,-67},{24,-67},{24,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ParoiSousCombles.T_int, noeudAir.port_a) annotation (Line(
      points={{1,59},{1,26},{24,26},{23.5,-24},{0,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(T_int_Picasso, T_int_Picasso) annotation (Line(
      points={{0,6},{0,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_int_Picasso, noeudAir.port_a) annotation (Line(
      points={{0,6},{0,-24}},
      color={191,0,0},
      smooth=Smooth.None));
annotation (Placement(transformation(extent={{-12,-50},{8,-25}})),
           Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,100}})),
Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-120},{120,100}}), graphics={Bitmap(extent={{118,122},{
              -118,-122}},      fileName=
              "modelica://BuildSysPro/Resources/Images/Batiments/Batiments types/Picasso/Picasso.png",
          origin={2,-8},
          rotation=180),
        Ellipse(
          extent={{-126,91},{-76,44}},
          lineColor={255,255,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><i>Picasso apartment</i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Pure thermal modelled Picasso monozone apartment.</p>
<p>Height under ceiling : 2.5m.</p>
<p><u><b>Bibliography</b></u></p>
<p>Site of building stock library</p>
<p>Notes H-E10-1996-02908-FR and H-E13-2014-00591-FR</p>
<p><u><b>Instructions for use</b></u></p>
<p>Wall and glazing surfaces come from <a href=\"BuildSysPro.BuildingStock.Utilities.Records.Geometry.CollectiveHousing.SettingsPicasso\"><code>SettingsPicasso</code></a> record.</p>
<p>To change a surface value, prefer to modify it in the record rather than in the assembly.</p>
<p>Parameters depending on RT (French building regulation) are stored in <a href=\"BuildSysPro.BuildingStock.Utilities.Records.BuildingData.CollectiveHousing.BuildingDataPICASSO\"><code>BuildingDataPICASSO</code></a> records.</p>
<p>When one of these records is selectied thanks to <code>paraMaisonRT</code>, building envelope parameters (walls, windows, ventilation...) will take the values stored in the selected record.</p>
<p>Available parameters are listed below :</p>
<ul><li><code>paraMaisonRT</code> : choice of the RT (French building regulation)</li>
<li><code>GLOext</code> : integration of LW radiation (infrared) toward the environment and the sky</li>
<li><code>beta</code> : allows to choose the orientation of the apartment, by default if beta=0, windows will be on south</li>
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
end PicassoAssemblyCH;
