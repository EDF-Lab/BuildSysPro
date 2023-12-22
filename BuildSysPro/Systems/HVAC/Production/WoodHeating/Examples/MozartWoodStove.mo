within BuildSysPro.Systems.HVAC.Production.WoodHeating.Examples;
model MozartWoodStove
extends Modelica.Icons.Example;
  Modelica.Units.NonSI.Time_day day=time/24/3600 "Day";

  Modelica.Blocks.Sources.Constant const(k=291)
    annotation (Placement(transformation(extent={{-20,4},{0,24}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=false)
                                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,74})));
  Modelica.Blocks.Sources.RealExpression Temps_s1(
                                                 y=time) "Time in hour"
    annotation (Placement(transformation(extent={{-56,64},{-36,84}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=19)
    annotation (Placement(transformation(extent={{2,64},{22,84}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazed cas1aAvecFlux1(
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
    Tair=293.15,
    CaracParoiVert(
      n=3,
      e={0.2,0.15,0.01},
      m={4,3,1},
      mat={BuildSysPro.Utilities.Data.Solids.Concrete(),
          BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene30(),
          BuildSysPro.Utilities.Data.Solids.PlasterBoard()}),
    CaracPlaf(
      n=2,
      e={0.25,0.01},
      m={5,1},
      mat={BuildSysPro.Utilities.Data.Solids.InsulationMaterialAndJoists(),
          BuildSysPro.Utilities.Data.Solids.PlasterBoard()}),
    CaracPlanch(
      n=3,
      m={4,4,1},
      e={0.16,0.4,0.01},
      mat={BuildSysPro.Utilities.Data.Solids.ExpandedPolystyrene30(),
          BuildSysPro.Utilities.Data.Solids.Concrete(),
          BuildSysPro.Utilities.Data.Solids.FloorTile()}))
    annotation (Placement(transformation(extent={{-68,-80},{22,-20}})));

  Modelica.Blocks.Tables.CombiTable1Ds Table3(
    tableOnFile=true,
    columns={2},
    tableName="data2",
    fileName=
        Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ConsigneChauffageRT2012.txt"))
      "Table 1 (N lignes and 2 columns with  column 1 : time in hour, column 2 = 1:N)"
    annotation (Placement(transformation(extent={{-26,64},{-6,84}})));
  BuildSysPro.Systems.HVAC.Production.WoodHeating.Logs.LogStoveControlled
    poelAvecRegulation
    annotation (Placement(transformation(extent={{24,-30},{74,48}})));
equation

  connect(meteofile.T_dry, cas1aAvecFlux1.T_ext) annotation (Line(
      points={{-81,-7},{-70,-7},{-70,-23},{-47,-23}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, cas1aAvecFlux1.G) annotation (Line(
      points={{-81,-12},{-72,-12},{-72,-35},{-47,-35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Temps_s1.y, Table3.u) annotation (Line(
      points={{-35,74},{-28,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Table3.y[1], realToBoolean.u) annotation (Line(
      points={{-5,74},{0,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realToBoolean.y, poelAvecRegulation.presence) annotation (Line(
      points={{23,74},{34,74},{34,44.1},{42.5,44.1}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanExpression1.y, poelAvecRegulation.forced_start)
    annotation (Line(
      points={{79,74},{68,74},{68,44.1},{57.5,44.1}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(const.y, poelAvecRegulation.T_consigne) annotation (Line(
      points={{1,14},{14,14},{14,16.8},{27,16.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cas1aAvecFlux1.T_int, poelAvecRegulation.Heat_Stove) annotation (Line(
      points={{1,-65.6},{1,-51.4},{71,-51.4},{71,16.8}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=3.1536e+007, Interval=1200),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Detailed model in H-E14-2011-01955-FR documentation.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque 07/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Hubert BLERVAQUE, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MozartWoodStove;
