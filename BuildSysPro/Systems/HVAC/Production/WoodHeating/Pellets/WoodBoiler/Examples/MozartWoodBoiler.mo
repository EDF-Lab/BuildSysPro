within BuildSysPro.Systems.HVAC.Production.WoodHeating.Pellets.WoodBoiler.Examples;
model MozartWoodBoiler

  Modelica.Units.NonSI.Time_day day=time/24/3600;
  Modelica.Units.NonSI.Time_hour hour=time/3600;

public
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-220,60},{-180,100}})));
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
    annotation (Placement(transformation(extent={{-138,32},{-18,112}})));

  Modelica.Blocks.Continuous.LimPID PID(
    yMax=1,
    k=0.5,
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti(displayUnit="min") = 300,
    Td(displayUnit="min") = 60,
    yMin=0)
    annotation (Placement(transformation(extent={{-30,-2},{-18,-14}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
    temperatureSensor
    annotation (Placement(transformation(extent={{-4,-4},{4,4}},
        rotation=0,
        origin={-34,8})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor1
    annotation (Placement(transformation(extent={{-58,150},{-50,158}})));
  BuildSysPro.BoundaryConditions.Scenarios.ScenarioRT scenarioRT(TconsChaud=20,
      TconsChaudInf48Red=16) annotation (Placement(transformation(
        extent={{19,20},{-19,-20}},
        rotation=180,
        origin={-189,-18})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=true)
    annotation (Placement(transformation(extent={{0,150},{20,170}})));
  WoodBoiler ChCond(
    Veau(displayUnit="l") = 0.03,
    Debit=0.02,
    Pcombmax=1800,
    Pcombmin=500)
    annotation (Placement(transformation(extent={{0,34},{86,122}})));
  BuildSysPro.Systems.Distribution.StorageTankFloatingSection Decouplage(Vtot(
        displayUnit="l") = 0.005)
    annotation (Placement(transformation(extent={{100,-4},{160,56}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=50)
            annotation (Placement(transformation(extent={{-76,120},{-64,132}})));
  Emission.Radiator.HotWaterRadiatorRegulDistrib
                                     radiateurResHydroDecouple
    annotation (Placement(transformation(extent={{0,-100},{60,-40}})));
  Distribution.WaterCirculator moteur
    annotation (Placement(transformation(extent={{82,-102},{106,-80}})));
equation
  connect(meteofile.T_dry, Int.T_ext) annotation (Line(
      points={{-182,86},{-159.4,86},{-159.4,108},{-110,108}},
      color={255,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));
  connect(meteofile.G, Int.G) annotation (Line(
      points={{-182,76},{-148,76},{-148,92},{-110,92}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));
  connect(meteofile.T_dry, temperatureSensor1.port) annotation (Line(
      points={{-182,86},{-160,86},{-160,154},{-58,154}},
      color={255,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));
  connect(temperatureSensor.T,PID. u_m) annotation (Line(
      points={{-29.6,8},{-24,8},{-24,-0.8}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(scenarioRT.TconsigneChaud,PID. u_s) annotation (Line(
      points={{-171.267,-18},{-102,-18},{-102,-8},{-31.2,-8}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));
  connect(Int.T_int, temperatureSensor.port) annotation (Line(
      points={{-46,51.2},{-46,8},{-38,8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Int.T_ext, thermalConductor.port_a) annotation (Line(
      points={{-110,108},{-110,126},{-76,126}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, Int.T_int) annotation (Line(
      points={{-64,126},{-46,126},{-46,51.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(booleanExpression.y, ChCond.SaisonChauff) annotation (Line(
      points={{21,160},{42.5,160},{42.5,122},{43,122}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(temperatureSensor1.T, ChCond.T_ext) annotation (Line(
      points={{-49.6,154},{-24,154},{-24,100},{3.58333,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, radiateurResHydroDecouple.Regulation) annotation (Line(
      points={{-17.4,-8},{-10,-8},{-10,-55},{3,-55}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(radiateurResHydroDecouple.Rad, Int.T_int) annotation (Line(
      points={{25.2,-49},{25.2,-26},{-46,-26},{-46,51.2}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiateurResHydroDecouple.Conv, Int.T_int) annotation (Line(
      points={{43.2,-49},{43.2,-26},{-46,-26},{-46,51.2}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Decouplage.PrimaireFroid, ChCond.WaterIn) annotation (Line(
      points={{103,11},{-12,11},{-12,41.3333},{3.58333,41.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ChCond.WaterOut, Decouplage.PrimaireChaud) annotation (Line(
      points={{82.4167,41.3333},{92.2083,41.3333},{92.2083,41},{103,41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Decouplage.SecondaireChaud, radiateurResHydroDecouple.WaterIn)
    annotation (Line(
      points={{157,41},{200,41},{200,-120},{-20,-120},{-20,-91},{3,-91}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radiateurResHydroDecouple.WaterOut, moteur.WaterIn) annotation (Line(
      points={{60.6,-91},{83.2,-91}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(moteur.WaterOut, Decouplage.SecondaireFroid) annotation (Line(
      points={{104.8,-91},{180,-91},{180,11},{157,11}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-220,-200},{220,200}},
          preserveAspectRatio=false), graphics),
    Icon(coordinateSystem(extent={{-220,-200},{220,200}})),
    experiment(StopTime=3.1e+007, Interval=600),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<p>Benoît Charrier 05/2015 : Suppression des connecteurs T &amp; m_flow.</p>
</html>", info="<html>
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
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MozartWoodBoiler;
