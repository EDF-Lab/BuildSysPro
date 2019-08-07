within BuildSysPro.Systems.HVAC.Emission.Examples;
model MozartJoulePIControlled
extends Modelica.Icons.Example;
protected
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
    bCombles=0.1,
    bVS=0.1,
    Tair=291.15,
    Tp=291.15,
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
    annotation (Placement(transformation(extent={{-48,40},{12,80}})));

protected
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

public
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor
    temperatureSensor                                       annotation (Placement(
        transformation(
        origin={30,50},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.HeatFlowSensor mesureFlux
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,20})));
  BuildSysPro.Utilities.Analysis.TimeIntegral integraleHoraire(Dt=600)
    annotation (Placement(transformation(extent={{10,16},{30,24}})));
protected
  BuildSysPro.BoundaryConditions.Scenarios.ScenarioRT scenarioRT(pth=
        Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ScenarioRT2012.txt"))
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
public
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Math.UnitConversions.To_degC to_degC
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  BuildSysPro.Utilities.Time.TimeInDayHourMinute tempsenJourHeureMinute
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor Text
                                                            annotation (Placement(
        transformation(
        origin={-70,80},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  ElectricHeater.JouleHeatingPIControlled convThermPI(Pnom(displayUnit="W")=
      1500) annotation (Placement(transformation(extent={{-20,-30},{-40,-10}})));
equation
  connect(meteofile.T_dry, cas1aAvecFlux1.T_ext) annotation (Line(
      points={{-61,53},{-74,53},{-74,78},{-34,78}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(cas1aAvecFlux1.T_int, temperatureSensor.port) annotation (Line(
      points={{-2,49.6},{20,49.6},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mesureFlux.port_a, prescribedHeatFlow.port) annotation (Line(
      points={{-30,20},{-40,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cas1aAvecFlux1.G, meteofile.G) annotation (Line(
      points={{-34,70},{-72,70},{-72,48},{-61,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_degC.u, scenarioRT.TconsigneChaud) annotation (Line(
      points={{62,-10},{72,-10},{72,20},{59.3333,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mesureFlux.port_b, cas1aAvecFlux1.T_int) annotation (Line(
      points={{-10,20},{-2,20},{-2,49.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(integraleHoraire.u, mesureFlux.Q_flow) annotation (Line(
      points={{8,20},{0,20},{0,10},{-20,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Text.port, cas1aAvecFlux1.T_ext) annotation (Line(
      points={{-60,80},{-34,80},{-34,78}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convThermPI.Pelec, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{-41,-20},{-74,-20},{-74,20},{-60,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convThermPI.T_sp, to_degC.y) annotation (Line(
      points={{-19,-18},{0,-18},{0,-10},{39,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convThermPI.T_int, temperatureSensor.T) annotation (Line(
      points={{-19,-22},{80,-22},{80,50},{40,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),       graphics),
    experiment(StopTime=3.1536e+007, Interval=30),
    experimentSetupOutput(events=false),
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
end MozartJoulePIControlled;
