within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.WoodStove.Examples;
model MozartWoodStove

public
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazed Int(
    Vair=252.15,
    hextv=25,
    hintv=7.7,
    Splaf=100.86,
    hplaf=10,
    hintplaf=10,
    Splanch=100.86,
    hplanch=5.88,
    hintplanch=5.88,
    albedo=0.2,
    alpha=0.6,
    S2nv=18.5,
    S3nv=26.75,
    S4nv=16.5,
    S1v=5,
    S2v=2,
    S3v=4,
    S4v=4,
    U=1.43,
    tau=0.544,
    S1nv=25.75,
    bCombles=0.1,
    bVS=0.1,
    CaracParoiVert(
      n=3,
      m={4,3,1},
      e={0.2,0.15,0.01},
      mat={BuildSysPro.Utilities.Data.Solids.Concrete(),
          BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene30(),
          BuildSysPro.Utilities.Data.Solids.PlasterBoard()}),
    CaracPlaf(
      n=2,
      m={5,1},
      e={0.25,0.01},
      mat={BuildSysPro.Utilities.Data.Solids.InsulationMaterialAndJoists(),
          BuildSysPro.Utilities.Data.Solids.PlasterBoard()}),
    CaracPlanch(
      n=3,
      m={4,4,1},
      e={0.16,0.2,0.01},
      mat={BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene30(),
          BuildSysPro.Utilities.Data.Solids.Concrete(),
          BuildSysPro.Utilities.Data.Solids.FloorTile()}))
    annotation (Placement(transformation(extent={{-58,12},{62,92}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(
      G=20) annotation (Placement(transformation(extent={{4,100},{16,
            112}})));
  BuildSysPro.BoundaryConditions.Scenarios.ScenarioRT scenarioRT(TconsChaud=20,
      TconsChaudInf48Red=16) annotation (Placement(transformation(
        extent={{19,-20},{-19,20}},
        rotation=180,
        origin={-101,-20})));
  WoodStove                                                            poeleBois
    annotation (Placement(transformation(extent={{58,-100},{140,0}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-58,-20},{-38,0}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=true)
    annotation (Placement(transformation(extent={{82,32},{102,52}})));
equation
  connect(meteofile.T_dry, Int.T_ext) annotation (Line(
      points={{-102,66},{-79.4,66},{-79.4,88},{-30,88}},
      color={255,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));
  connect(meteofile.G, Int.G) annotation (Line(
      points={{-102,56},{-68,56},{-68,72},{-30,72}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));
  connect(Int.T_ext, thermalConductor.port_a) annotation (Line(
      points={{-30,88},{-30,106},{4,106}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, Int.T_int) annotation (Line(
      points={{16,106},{34,106},{34,31.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scenarioRT.TconsigneChaud, poeleBois.T_consigne) annotation (
      Line(
      points={{-83.2667,-20},{-31.9165,-20},{-31.9165,-30},{62.1,-30}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(poeleBois.Heat_Stove, Int.T_int) annotation (Line(
      points={{99,-95},{34,-95},{34,31.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scenarioRT.Presence, realToBoolean.u) annotation (Line(
      points={{-83.2667,-1.77636e-15},{-72,-1.77636e-15},{-72,-10},{-60,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realToBoolean.y, poeleBois.presence) annotation (Line(
      points={{-37,-10},{64,-10},{64,16},{86.7,16},{86.7,-2}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanExpression.y, poeleBois.etatON) annotation (Line(
      points={{103,42},{112,42},{112,-2},{111.3,-2}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-120},{140,140}},
          preserveAspectRatio=false), graphics),
    Icon(coordinateSystem(extent={{-140,-120},{140,140}})));
end MozartWoodStove;
