within BuildSysPro.Systems.HVAC.Production.HeatPump.FixedSpeed.Examples;
model MozartAAHPHeating
extends Modelica.Icons.Example;
//  Modelica.SIunits.Conversions.NonSIunits.Time_day day=time/24/3600;
  Modelica.SIunits.Conversions.NonSIunits.Time_hour hour=time/3600;
//  Modelica.SIunits.Conversions.NonSIunits.Time_minute minute=time/60;
  Modelica.SIunits.Energy CONSO;
  Modelica.SIunits.Energy ChaleurFournie;

  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-182,50},{-142,90}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor1
    annotation (Placement(transformation(extent={{-76,-30},{-56,-10}})));
  Modelica.Blocks.Tables.CombiTable1Ds Table1(
    tableOnFile=true,
    columns={2},
    tableName="data2",
    fileName=
        Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/ConsigneChauffageRT2012.txt"))
    "Table 1 (N lignes et 2 colonnes avec  colonne 1 : Temps en heure, colonne2 = 1:N)"
    annotation (Placement(transformation(extent={{-130,130},{-110,150}})));
  Modelica.Blocks.Sources.RealExpression Temps_s(y=time) "Temps en heure"
    annotation (Placement(transformation(extent={{-172,130},{-152,150}})));

  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{180,12},{160,32}})));

  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor temperatureSensor2
    annotation (Placement(transformation(extent={{46,-66},{66,-46}})));
  BuildSysPro.Building.Zones.HeatTransfer.ZoneCrawlSpaceGlazed cas1aAvecFlux1(
    hextv=25,
    hintv=7.7,
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
          BuildSysPro.Utilities.Data.Solids.FloorTile()}),
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
    Vair=4*252.15,
    bCombles=0.1,
    bVS=0.1) annotation (Placement(transformation(extent={{-100,40},{20,120}})));

  BuildSysPro.Systems.HVAC.Production.HeatPump.FixedSpeed.HPHeatingAir2Air
    pACch(
    Qnom=4000,
    Choix=3,
    TauOn=30,
    dtminOn(displayUnit="min"),
    dtminOff(displayUnit="min"))
    annotation (Placement(transformation(extent={{90,-68},{150,-8}})));
  BuildSysPro.Systems.Controls.Deadband zoneMorte
    annotation (Placement(transformation(extent={{64,118},{104,158}})));
  Modelica.Blocks.Sources.BooleanTable booleanTable(startValue=true, table(
        displayUnit="d") = {10368000,23328000})
    annotation (Placement(transformation(extent={{-7,-7},{7,7}},
        rotation=0,
        origin={67,7})));
equation
  der(CONSO)=pACch.Qelec;
  der(ChaleurFournie)=pACch.Qfour;

  connect(meteofile.T_dry, temperatureSensor1.port) annotation (Line(
      points={{-144,76},{-120,76},{-120,-20},{-76,-20}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(Temps_s.y,Table1. u) annotation (Line(
      points={{-151,140},{-132,140}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));
  connect(cas1aAvecFlux1.T_int, temperatureSensor.port) annotation (Line(
      points={{-8,59.2},{18,59.2},{18,60},{20,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, cas1aAvecFlux1.G) annotation (Line(
      points={{-144,66},{-118.4,66},{-118.4,100},{-72,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.T_dry, cas1aAvecFlux1.T_ext) annotation (Line(
      points={{-144,76},{-120,76},{-120,116},{-72,116}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, cas1aAvecFlux1.T_int) annotation (Line(
      points={{159,20.6},{20.5,20.6},{20.5,59.2},{-8,59.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cas1aAvecFlux1.T_int, temperatureSensor2.port) annotation (Line(
      points={{-8,59.2},{-8,60},{20,60},{20,-56},{46,-56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor2.T, pACch.T_int) annotation (Line(
      points={{66,-56},{90,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor1.T, pACch.T_ext) annotation (Line(
      points={{-56,-20},{90,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pACch.Qfour, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{151.2,-38},{190,-38},{190,20.6},{179,20.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSensor.T, zoneMorte.Variable) annotation (Line(
      points={{40,60},{52,60},{52,127.6},{64.8,127.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneMorte.OnOff, pACch.u) annotation (Line(
      points={{103.6,128},{120,128},{120,-11}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(Table1.y[1],zoneMorte.Setpoint)  annotation (Line(
      points={{-109,140},{64.4,140}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanTable.y, pACch.SaisonChauffe) annotation (Line(
      points={{74.7,7},{89.35,7},{89.35,-10.4},{102.6,-10.4}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -200},{200,200}}),      graphics),
    experiment(StopTime=3.1536e+007, Interval=60),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<p>This example describes how to connect the <a href=\"BuildSysPro.Systems.HVAC.Production.HeatPump.FixedSpeed.HPHeatingAir2Air\"><code>HPHeatingAir2Air</code></a> model to a building.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque, Sila Filfli 05/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Hubert BLERVAQUE, Sila FILFLI, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MozartAAHPHeating;
