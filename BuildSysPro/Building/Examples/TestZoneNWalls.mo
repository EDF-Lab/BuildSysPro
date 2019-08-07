within BuildSysPro.Building.Examples;
model TestZoneNWalls
extends Modelica.Icons.Example;
  BuildSysPro.Building.Zones.HeatTransfer.ZoneNWalls zoneNparois(
    NF=4,
    SPlaf=14,
    hPlaf=10,
    hintPlaf=10,
    hintPlan=10,
    SPlan=14,
    Ufen={3,3,3,3},
    SFen={4,4,4,4},
    Vzone=52,
    SVert={10,10,10,10},
    azimutVert={0,90,180,-90},
    azimutFen={0,90,180,-90},
    DebitRenouv=53,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentCeiling caracPlaf,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentFloor caracPlanch,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall caracParoiVert)
    annotation (Placement(transformation(extent={{18,-90},{56,-52}})));

  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-90,-42},{-70,-22}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
    annotation (Placement(transformation(extent={{-84,-94},{-64,-74}})));
  BuildingEnvelope.HeatTransfer.Wall Plafond(
    S=14,
    hs_ext=10,
    hs_int=10,
    alpha_ext=0.5,
    RadInterne=true,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentCeiling caracParoi)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,80})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow
    SudVitrage(
    U=3,
    tau=0.5,
    g=0.6,
    S=4,
    hs_ext=25,
    RadInterne=true,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{10,52},{30,72}})));
  BuildingEnvelope.HeatTransfer.Wall Plancher(
    S=14,
    hs_int=10,
    alpha_ext=0.5,
    RadInterne=true,
    ParoiInterne=true,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentFloor caracParoi,
    hs_ext=100) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,-46})));
  BuildingEnvelope.HeatTransfer.Wall Sud(
    alpha_ext=0.5,
    RadInterne=true,
    S=10,
    hs_ext=25,
    hs_int=8.29,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall caracParoi)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,52})));
  BuildingEnvelope.HeatTransfer.Wall Est(
    alpha_ext=0.5,
    RadInterne=true,
    S=10,
    hs_ext=25,
    hs_int=8.29,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall caracParoi)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,-20})));
  BuildingEnvelope.HeatTransfer.Wall Nord(
    alpha_ext=0.5,
    RadInterne=true,
    S=10,
    hs_ext=25,
    hs_int=8.29,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall caracParoi)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,4})));
  BuildingEnvelope.HeatTransfer.Wall Ouest(
    alpha_ext=0.5,
    RadInterne=true,
    S=10,
    hs_ext=25,
    hs_int=8.29,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall caracParoi)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,28})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow
    OuestVitrage(
    U=3,
    tau=0.5,
    g=0.6,
    S=4,
    hs_ext=25,
    RadInterne=true,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{10,24},{30,44}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow
    NordVitrage(
    U=3,
    tau=0.5,
    g=0.6,
    S=4,
    hs_ext=25,
    RadInterne=true,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{10,-4},{30,16}})));
  BuildSysPro.Building.BuildingEnvelope.HeatTransfer.DoubleGlazingWindow
    EstVitrage(
    U=3,
    tau=0.5,
    g=0.6,
    S=4,
    hs_ext=25,
    RadInterne=true,
    DifDirOut=false)
    annotation (Placement(transformation(extent={{10,-32},{30,-12}})));
protected
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a Text
    annotation (Placement(transformation(extent={{-54,22},{-44,32}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b Tint
    annotation (Placement(transformation(extent={{56,26},{66,36}})));
public
  BuildSysPro.BoundaryConditions.Radiation.PintRadDistrib pintDistribRad(
    np=6,
    nf=4,
    Sp={10,10,10,10,14,14},
    Sf={4,4,4,4}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={66,-8})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=4) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={58,14})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf(azimut=0,
      incl=0) annotation (Placement(transformation(extent={{-42,84},{-30,96}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf1(azimut=0,
      incl=90)
    annotation (Placement(transformation(extent={{-42,54},{-30,66}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf2(incl=90,
      azimut=90)
    annotation (Placement(transformation(extent={{-42,30},{-30,42}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf3(incl=90,
      azimut=180)
    annotation (Placement(transformation(extent={{-46,6},{-34,18}})));
  BuildSysPro.BoundaryConditions.Solar.Irradiation.FLUXsurf fLUXsurf4(incl=90,
      azimut=-90)
    annotation (Placement(transformation(extent={{-48,-16},{-36,-4}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirNode noeudAir(V=52, Tair=293.15)
    annotation (Placement(transformation(extent={{62,46},{82,66}})));
  BuildSysPro.Building.AirFlow.HeatTransfer.AirRenewal RenouvellementAir(Qv=53)
    annotation (Placement(transformation(extent={{12,84},{32,104}})));
equation

  // Multizone
  connect(meteofile.T_dry, zoneNparois.T_ext) annotation (Line(
      points={{-71,-29},{-46,-29},{-46,-69.1},{19.9,-69.1}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, zoneNparois.G) annotation (Line(
      points={{-71,-34},{-48.5,-34},{-48.5,-59.6},{18,-59.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port,zoneNparois.T_ground)  annotation (Line(
      points={{-64,-84},{-38,-84},{-38,-90},{25.6,-90}},
      color={191,0,0},
      smooth=Smooth.None));

  // Models assembling
    //Connection outer thermal port
  connect(Plafond.T_ext, Text) annotation (Line(
      points={{-17,77},{-17,26.5},{-49,26.5},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Sud.T_ext, Text) annotation (Line(
      points={{-17,49},{-16.5,49},{-16.5,27},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ouest.T_ext, Text) annotation (Line(
      points={{-17,25},{-17.5,25},{-17.5,27},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Nord.T_ext, Text) annotation (Line(
      points={{-17,1},{-16.5,1},{-16.5,27},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Est.T_ext, Text) annotation (Line(
      points={{-17,-23},{-17,27.5},{-49,27.5},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(SudVitrage.T_ext, Text) annotation (Line(
      points={{11,59},{-20.5,59},{-20.5,27},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(OuestVitrage.T_ext, Text) annotation (Line(
      points={{11,31},{-20.5,31},{-20.5,27},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(NordVitrage.T_ext, Text) annotation (Line(
      points={{11,3},{-17.5,3},{-17.5,27},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(EstVitrage.T_ext, Text) annotation (Line(
      points={{11,-25},{-17.5,-25},{-17.5,27},{-49,27}},
      color={191,0,0},
      smooth=Smooth.None));

  // Connection inner thermal port
  connect(SudVitrage.T_int, Tint) annotation (Line(
      points={{29,59},{28.5,59},{28.5,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(OuestVitrage.T_int, Tint) annotation (Line(
      points={{29,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(NordVitrage.T_int, Tint) annotation (Line(
      points={{29,3},{29.5,3},{29.5,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(EstVitrage.T_int, Tint) annotation (Line(
      points={{29,-25},{29,30.5},{61,30.5},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plancher.T_int, Tint) annotation (Line(
      points={{1,-49},{1,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Sud.T_int, Tint) annotation (Line(
      points={{1,49},{0.5,49},{0.5,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Est.T_int, Tint) annotation (Line(
      points={{1,-23},{0.5,-23},{0.5,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Nord.T_int, Tint) annotation (Line(
      points={{1,1},{0.5,1},{0.5,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Ouest.T_int, Tint) annotation (Line(
      points={{1,25},{1.5,25},{1.5,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Plafond.T_int, Tint) annotation (Line(
      points={{1,77},{1.5,77},{1.5,31},{61,31}},
      color={255,0,0},
      smooth=Smooth.None));

  //Sum of SWR to distribute
  connect(pintDistribRad.RayEntrant, multiSum.y) annotation (Line(
      points={{66,1},{66,14},{65.02,14}},
      color={255,192,1},
      smooth=Smooth.None));

  // Meteo data to Text
  connect(meteofile.T_dry, Text) annotation (Line(
      points={{-71,-29},{-60,-29},{-60,27},{-49,27}},
      color={255,0,0},
      smooth=Smooth.None));
  // Connection floor temperature
  connect(Plancher.Ts_ext, fixedTemperature.port) annotation (Line(
      points={{-11,-49},{-10.5,-49},{-10.5,-84},{-64,-84}},
      color={191,0,0},
      smooth=Smooth.None));

  //Solar flux to walls
  connect(fLUXsurf.FluxIncExt, Plafond.FluxIncExt) annotation (Line(
      points={{-29.4,89.94},{-28.7,89.94},{-28.7,89},{-11,89}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf.G, meteofile.G) annotation (Line(
      points={{-42.6,90},{-58,90},{-58,-34},{-71,-34}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(Sud.FluxIncExt, fLUXsurf1.FluxIncExt) annotation (Line(
      points={{-11,61},{-19.5,61},{-19.5,59.94},{-29.4,59.94}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf1.G, meteofile.G) annotation (Line(
      points={{-42.6,60},{-56,60},{-56,-34},{-71,-34}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(fLUXsurf2.FluxIncExt, Ouest.FluxIncExt) annotation (Line(
      points={{-29.4,35.94},{-22.7,35.94},{-22.7,37},{-11,37}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf2.G, meteofile.G) annotation (Line(
      points={{-42.6,36},{-56,36},{-56,-34},{-71,-34}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(fLUXsurf3.FluxIncExt, Nord.FluxIncExt) annotation (Line(
      points={{-33.4,11.94},{-25.7,11.94},{-25.7,13},{-11,13}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf3.G, meteofile.G) annotation (Line(
      points={{-46.6,12},{-58,12},{-58,-34},{-71,-34}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(fLUXsurf4.FluxIncExt, Est.FluxIncExt) annotation (Line(
      points={{-35.4,-10.06},{-27.7,-10.06},{-27.7,-11},{-11,-11}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(fLUXsurf4.G, meteofile.G) annotation (Line(
      points={{-48.6,-10},{-62,-10},{-62,-34},{-71,-34}},
      color={0,0,127},
      smooth=Smooth.None));
   // Solar flux to glazings
  connect(fLUXsurf4.FluxIncExt, EstVitrage.FluxIncExt) annotation (Line(
      points={{-35.4,-10.06},{8.3,-10.06},{8.3,-17},{17,-17}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(NordVitrage.FluxIncExt, fLUXsurf3.FluxIncExt) annotation (Line(
      points={{17,11},{-8.5,11},{-8.5,11.94},{-33.4,11.94}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(OuestVitrage.FluxIncExt, fLUXsurf2.FluxIncExt) annotation (Line(
      points={{17,39},{-6.5,39},{-6.5,35.94},{-29.4,35.94}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(SudVitrage.FluxIncExt, fLUXsurf1.FluxIncExt) annotation (Line(
      points={{17,67},{-6.5,67},{-6.5,59.94},{-29.4,59.94}},
      color={255,192,1},
      smooth=Smooth.None));

  // Distri SWR to wall
  connect(pintDistribRad.FLUXParois[1], Sud.FluxAbsInt) annotation (Line(
      points={{63.1667,-19},{32,-19},{32,57},{-5,57}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[2], Ouest.FluxAbsInt) annotation (Line(
      points={{63.5,-19},{32,-19},{32,33},{-5,33}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[3], Nord.FluxAbsInt) annotation (Line(
      points={{63.8333,-19},{32,-19},{32,9},{-5,9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[4], Est.FluxAbsInt) annotation (Line(
      points={{64.1667,-19},{32,-19},{32,-15},{-5,-15}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[5], Plancher.FluxAbsInt) annotation (Line(
      points={{64.5,-19},{32,-19},{32,-41},{-5,-41}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXParois[6], Plafond.FluxAbsInt) annotation (Line(
      points={{64.8333,-19},{34,-19},{34,85},{-5,85}},
      color={255,192,1},
      smooth=Smooth.None));
  //Distri SWR to glazing
  connect(pintDistribRad.FLUXFenetres[1], SudVitrage.FluxAbsInt) annotation (
      Line(
      points={{67.25,-19},{48,-19},{48,65},{23,65}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXFenetres[2], OuestVitrage.FluxAbsInt) annotation (
      Line(
      points={{67.75,-19},{46,-19},{46,37},{23,37}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXFenetres[3], NordVitrage.FluxAbsInt) annotation (
      Line(
      points={{68.25,-19},{46,-19},{46,9},{23,9}},
      color={255,192,1},
      smooth=Smooth.None));
  connect(pintDistribRad.FLUXFenetres[4], EstVitrage.FluxAbsInt) annotation (
      Line(
      points={{68.75,-19},{23,-19}},
      color={255,192,1},
      smooth=Smooth.None));

  connect(noeudAir.port_a, Tint) annotation (Line(
      points={{72,52},{66,52},{66,31},{61,31}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(multiSum.u[1], SudVitrage.CLOTr) annotation (Line(
      points={{52,17.15},{42,17.15},{42,67},{29,67}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[2], OuestVitrage.CLOTr) annotation (Line(
      points={{52,15.05},{40,15.05},{40,39},{29,39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[3], NordVitrage.CLOTr) annotation (Line(
      points={{52,12.95},{40,12.95},{40,11},{29,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSum.u[4], EstVitrage.CLOTr) annotation (Line(
      points={{52,10.85},{40,10.85},{40,-17},{29,-17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(RenouvellementAir.port_b, noeudAir.port_a) annotation (Line(
      points={{31,94},{72,94},{72,52}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(RenouvellementAir.port_a, meteofile.T_dry) annotation (Line(
      points={{13,94},{-66,94},{-66,-29},{-71,-29}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=3.1536e+007, Interval=1800),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Simulation time : 183 seconds.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles PLESSIS</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : Gilles PLESSIS, EDF<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Gilles PLESSIS 02/2012 : Modification du modèle de renouvellement d'air.</p>
<p>Gilles PLESSIS 06/2012 : Changement du modèle de parois avec paramétrage par composition de parois types. Les résultats sont différents avec la précédente version BuildSysPro car les composition des parois ont été modifiées. En revanche le modèle zoneNparois a exactement le même comportement que la modélisation par assemblage.</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end TestZoneNWalls;
