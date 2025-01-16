within BuildSysPro.Utilities.Analysis.Examples;
model RestartDiscomfort
  "Calculation of discomfort due to restart within the model"
extends Modelica.Icons.Example;
  BuildSysPro.Building.Zones.HeatTransfer.ZoneSlab MISansRelance(
    Vair=100,
    S1nv=10,
    S2nv=10,
    S3nv=10,
    S4nv=10,
    hextv=20,
    hintv=8,
    Splaf=10,
    Splanch=10,
    hplaf=10,
    hintplaf=10,
    hplanch=10,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall CaracParoiVert,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentCeiling CaracPlaf,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentFloor CaracPlanch)
    annotation (Placement(transformation(extent={{-84,32},{-48,56}})));

  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile
    annotation (Placement(transformation(extent={{-116,-12},{-96,8}})));
  BuildSysPro.Building.Zones.HeatTransfer.ZoneSlab MIAvecRelance(
    Vair=100,
    S1nv=10,
    S2nv=10,
    S3nv=10,
    S4nv=10,
    hextv=20,
    hintv=8,
    Splaf=10,
    Splanch=10,
    hplaf=10,
    hintplaf=10,
    hplanch=10,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentExtWall CaracParoiVert,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentCeiling CaracPlaf,
    redeclare BuildSysPro.Utilities.Data.WallData.RecentFloor CaracPlanch)
    annotation (Placement(transformation(extent={{-84,-94},{-48,-70}})));

  BuildSysPro.BoundaryConditions.Scenarios.ScenarioRT scenarioRT(
      TconsChaudInf48Red=19, TconsChaudSup48Red=19) annotation (Placement(
        transformation(
        extent={{-15,-15},{15,15}},
        rotation=180,
        origin={85,93})));
  BuildSysPro.BoundaryConditions.Scenarios.ScenarioRT scenarioRT1 annotation (
      Placement(transformation(
        extent={{-15,-15},{15,15}},
        rotation=180,
        origin={89,-45})));
  BuildSysPro.Utilities.Analysis.ThDiscomfort mesureInconfortSansRelance(
      SeuilInconfort=3, UsePresence=true)
    annotation (Placement(transformation(extent={{136,50},{156,70}})));
  Modelica.Blocks.Continuous.LimPID PI1(
    Ni=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=0.,
    yMin=0.,
    Ti=0.06,
    k=600,
    yMax=120,
    initType=Modelica.Blocks.Types.Init.SteadyState) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={18,82})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor ThermoAmbiance
    annotation (Placement(transformation(
        origin={-32,84},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow ChauffageEtClim(T_ref=
        292.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-4,68})));
  BuildSysPro.BaseClasses.HeatTransfer.Sensors.TemperatureSensor ThermoAmbiance1
    annotation (Placement(transformation(
        origin={-32,-48},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Modelica.Blocks.Continuous.LimPID PI2(
    Ni=0.1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=0.,
    yMin=0.,
    Ti=0.06,
    k=600,
    yMax=120,
    initType=Modelica.Blocks.Types.Init.SteadyState) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={24,-54})));
  BuildSysPro.BaseClasses.HeatTransfer.Sources.PrescribedHeatFlow ChauffageEtClim1(T_ref=
        292.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-16,-60})));
  ThDiscomfort mesureInconfortAvecRelance(SeuilInconfort=3, UsePresence=true)
    annotation (Placement(transformation(extent={{128,-84},{148,-64}})));
  Modelica.Blocks.Math.Add InconfortFroid(k1=-1)
    annotation (Placement(transformation(extent={{180,-28},{200,-8}})));
  Modelica.Blocks.Math.Add inconfortChaud(k1=-1)
    annotation (Placement(transformation(extent={{180,8},{200,28}})));
equation
  connect(MISansRelance.T_int, ThermoAmbiance.port) annotation (Line(
      points={{-56.4,40.16},{-56.4,49.08},{-32,49.08},{-32,74}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ThermoAmbiance.T, PI1.u_m) annotation (Line(
      points={{-32,94},{18,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT.TconsigneChaud, PI1.u_s) annotation (Line(
      points={{71,93},{56,93},{56,82},{30,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI1.y, ChauffageEtClim.Q_flow) annotation (Line(
      points={{7,82},{10,82},{10,69.4},{5,69.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ChauffageEtClim.port, MISansRelance.T_int) annotation (Line(
      points={{-15,69.4},{-15,68.7},{-56.4,68.7},{-56.4,40.16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ThermoAmbiance1.port, MIAvecRelance.T_int) annotation (Line(
      points={{-32,-58},{-32,-85.84},{-56.4,-85.84}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ThermoAmbiance1.T, PI2.u_m) annotation (Line(
      points={{-32,-38},{24,-38},{24,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT1.TconsigneChaud, PI2.u_s) annotation (Line(
      points={{75,-45},{58,-45},{58,-54},{36,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ChauffageEtClim1.Q_flow, PI2.y) annotation (Line(
      points={{-7,-58.6},{1.5,-58.6},{1.5,-54},{13,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ChauffageEtClim1.port, MIAvecRelance.T_int) annotation (Line(
      points={{-27,-58.6},{-27,-68.3},{-56.4,-68.3},{-56.4,-85.84}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mesureInconfortAvecRelance.Tint, MIAvecRelance.T_int) annotation (
      Line(
      points={{129,-74},{51.5,-74},{51.5,-85.84},{-56.4,-85.84}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mesureInconfortSansRelance.Tint, MISansRelance.T_int) annotation (
      Line(
      points={{137,60},{62.5,60},{62.5,40.16},{-56.4,40.16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(scenarioRT1.Presence, mesureInconfortAvecRelance.Presence)
    annotation (Line(
      points={{75,-30},{98,-30},{98,-42},{138,-42},{138,-65.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT.Presence, mesureInconfortSansRelance.Presence)
    annotation (Line(
      points={{71,108},{146,108},{146,68.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mesureInconfortSansRelance.OutInconfordChaud, inconfortChaud.u1)
    annotation (Line(
      points={{157,65},{164,65},{164,24},{178,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mesureInconfortAvecRelance.OutInconfordChaud, inconfortChaud.u2)
    annotation (Line(
      points={{149,-69},{166,-69},{166,12},{178,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mesureInconfortSansRelance.OutInconfortFroid, InconfortFroid.u1)
    annotation (Line(
      points={{157,55},{160,55},{160,-12},{178,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mesureInconfortAvecRelance.OutInconfortFroid, InconfortFroid.u2)
    annotation (Line(
      points={{149,-79},{162,-79},{162,-24},{178,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.T_dry, MISansRelance.T_ext) annotation (Line(
      points={{-97,1},{-75.6,1},{-75.6,54.8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, MISansRelance.G) annotation (Line(
      points={{-97,-4},{-97,-1.5},{-75.6,-1.5},{-75.6,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(meteofile.T_dry, MIAvecRelance.T_ext) annotation (Line(
      points={{-97,1},{-82,1},{-82,-71.2},{-75.6,-71.2}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(meteofile.G, MIAvecRelance.G) annotation (Line(
      points={{-97,-4},{-97,-4.5},{-75.6,-4.5},{-75.6,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT1.TconsigneChaud, mesureInconfortAvecRelance.TconsigneChauf)
    annotation (Line(
      points={{75,-45},{64,-45},{64,-80.6},{129.4,-80.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT1.TconsigneRef, mesureInconfortAvecRelance.TconsigneRef)
    annotation (Line(
      points={{75,-41.25},{76,-41.25},{76,-67.4},{129.4,-67.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(scenarioRT.TconsigneRef, mesureInconfortSansRelance.TconsigneRef)
    annotation (Line(
      points={{71,96.75},{68,96.75},{68,66.6},{137.4,66.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mesureInconfortSansRelance.TconsigneChauf, scenarioRT.TconsigneChaud)
    annotation (Line(
      points={{137.4,53.4},{56,53.4},{56,93},{71,93}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),      graphics={
        Rectangle(
          extent={{-42,98},{48,48}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-40,-36},{50,-86}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{56,100},{186,36}},
          lineColor={0,0,0},
          fillColor={127,255,7},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{48,38},{192,46}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid,
          textString="Scénario et inconfort sans relance"),
        Text(
          extent={{-42,-78},{54,-86}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid,
          textString="Régulation et chauffage"),
        Text(
          extent={{-42,56},{54,48}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid,
          textString="Régulation et chauffage"),
        Rectangle(
          extent={{56,-40},{198,-102}},
          lineColor={0,0,0},
          fillColor={127,255,7},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{62,-98},{196,-90}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid,
          textString="Scénario et inconfort avec relance"),
        Rectangle(
          extent={{78,34},{212,-34}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{70,-8},{166,2}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid,
          textString="Comparaison
Inconfort")}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=3.1536e+007, Interval=3600),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><i><b>Model to estimate the impact on the thermal comfort of low setpoints and restarts.</b></i></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>2 buildings are modelled, one having a heating system controlled by a PID and taking into account low temperature setpoints, the other one does not taking low temperature setpoints into account. Thermal discomfort is evaluated in each case.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>Simulate then plot blocks <i>inconfortChaud</i> and <i>inconfortFroid</i> outputs describing the difference between thermal discomforts. These values are to be compared to the discomfort values over the year of each system+built couples. </p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Gilles Plessis 06/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Gilles PLESSIS, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>",                                                                    revisions="<html>
<p>Gilles Plessis 03/2012 : Modification du modèle d'inconfort thermique pour prendre en compte les 2 températures de consignes (rafraichissement et chauffage).</p>
</html>"));
end RestartDiscomfort;
