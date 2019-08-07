within BuildSysPro.Systems.HVAC.Emission.Examples;
model MozartRFBoiler
extends Modelica.Icons.Example;
  Production.Boiler.Boiler boi
    annotation (Placement(transformation(extent={{-138,-140},{-58,-60}})));
  Modelica.Blocks.Continuous.LimPID PID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    Ti(displayUnit="s") = 60,
    Td=0,
    yMax=100,
    k=100/4)
    annotation (Placement(transformation(extent={{-146,-32},{-126,-12}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    temperatureSensor annotation (Placement(transformation(extent={{-82,-46},
            {-94,-34}})));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-200,100},{-160,140}})));
  BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazed Int(
    Vair=252.15,
    hextv=25,
    hintv=7.7,
    Splaf=100.86,
    hplaf=10,
    hintplaf=10,
    Splanch=100.86,
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
    PlancherActif=2,
    hplanch=12,
    hintplanch=12,
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
    annotation (Placement(transformation(extent={{-20,0},{100,80}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(
      G=20) annotation (Placement(transformation(extent={{34,100},{54,
            120}})));
  Modelica.Blocks.Sources.BooleanTable booleanTable(startValue=true, table(
        displayUnit="d") = {12096000,23673600})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,-50})));
  BuildSysPro.BoundaryConditions.Scenarios.ScenarioRT scenarioRT(
    TconsChaud=20,
    Nadeq=2,
    unite1=90,
    caloEclairage=1.4,
    caloUsageSpe=5.7,
    UtilApportThOcc=false,
    UtilApportThUsageSpe=false,
    UtilApportThEclairage=false)
    annotation (Placement(transformation(extent={{-200,40},{-160,80}})));
equation

  connect(Int.T_ext, thermalConductor.port_a) annotation (Line(
      points={{8,76},{8,110},{34,110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, Int.T_int) annotation (Line(
      points={{54,110},{72,110},{72,19.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Int.T_int, temperatureSensor.port) annotation (Line(
      points={{72,19.2},{72,-40},{-82,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, PID1.u_m) annotation (Line(
      points={{-94,-40},{-136,-40},{-136,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID1.y, boi.PLR) annotation (Line(
      points={{-125,-22},{-98,-22},{-98,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boi.T_int, Int.T_int) annotation (Line(
      points={{-74,-68},{-74,-40},{72,-40},{72,19.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Int.T_ext, meteofile.T_dry) annotation (Line(
      points={{8,76},{-34,76},{-34,126},{-162,126}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, Int.G) annotation (Line(
      points={{-162,116},{-42,116},{-42,60},{8,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT.TconsigneChaud, PID1.u_s) annotation (Line(
      points={{-161.333,60},{-154,60},{-154,-22},{-148,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanTable.y, boi.SaisonChauffe) annotation (Line(
      points={{-179,-50},{-126,-50},{-126,-64}},
      color={255,0,255},
      smooth=Smooth.None));

  connect(Int.WaterOut, boi.WaterIn) annotation (Line(
      points={{88,0},{120,0},{120,-160},{-182,-160},{-182,-116},{-138,-116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boi.WaterOut, Int.WaterIn) annotation (Line(
      points={{-57.2,-116},{-20,-116},{-20,0},{0,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-200,-180},{200,
            180}}),      graphics),
    experiment(StopTime=3.1e+007, Interval=600),
    __Dymola_experimentSetupOutput,
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
<p>Validated model</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2019<br>
BuildSysPro version 3.3.0<br>
Author : EDF<br>
--------------------------------------------------------------</b></p>
</html>"));
end MozartRFBoiler;
