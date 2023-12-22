within BuildSysPro.Systems.HVAC.Production.HeatPump.FixedSpeed.Examples;
model MozartMultizoneHeatingSystem
  "Multi-room building model with its heating system"
  extends Modelica.Icons.Example;
  // Weather et setpoint
  BuildSysPro.BoundaryConditions.Scenarios.ScenarioRT scenarioRT(Nadeq = 2, TconsChaud = 20, UtilApportThEclairage = false, UtilApportThOcc = false, UtilApportThUsageSpe = false, caloEclairage = 1.4, caloUsageSpe = 5.7, unite1 = 90) annotation (
    Placement(visible = true, transformation(extent = {{-298, 178}, {-258, 218}}, rotation = 0)));
  BuildSysPro.BoundaryConditions.Weather.Meteofile meteofile annotation (
    Placement(visible = true, transformation(extent = {{-300, 240}, {-260, 280}}, rotation = 0)));
  // Mozartmultizone
  BuildSysPro.BuildingStock.IndividualHousing.Mozart.MozartMultizone mozartMultizone(
      redeclare
      BuildSysPro.BuildingStock.Utilities.Records.BuildingData.IndividualHousing.BuildingDataMOZART.MozartBefore1974
      paraMaisonRT)                                                                                                                                                                                                         annotation (
    Placement(visible = true, transformation(origin = {150, 128.221}, extent = {{-148, -142.331}, {148, 170.797}}, rotation = 0)));
  // Heat pump
  Modelica.Blocks.Sources.BooleanTable booleanTable(startValue = true, table = {12096000, 23673600}) annotation (
    Placement(visible = true, transformation(origin={-210,-70},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HPHeatingAir2Water hPHeatingAir2Water annotation (Placement(visible=true,
        transformation(
        origin={-160,-120},
        extent={{-40,-40},{40,40}},
        rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor5 annotation (
    Placement(visible = true, transformation(origin={-227,-103},   extent={{-7,-7},
            {7,7}},                                                                             rotation = 0)));
  BuildSysPro.Systems.Distribution.DistributionPipe distributionPipe(U = 9999) annotation (
    Placement(visible = true, transformation(origin = {-242, -170}, extent = {{16, 16}, {-16, -16}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C = 4200 * 50, T(displayUnit = "K")) annotation (
    Placement(visible = true, transformation(origin={-282,-170},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  BuildSysPro.Systems.Controls.Deadband deadband(e=2)   annotation (
    Placement(visible = true, transformation(origin={-200,-20},    extent={{-20,-20},
            {20,20}},                                                                               rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TWaterReturn annotation (
    Placement(visible = true, transformation(origin = {-260, -146}, extent = {{6, -6}, {-6, 6}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression WaterLoopSetpoint(y=50 + 273.15)   annotation (
    Placement(visible = true, transformation(origin={-280,-18},    extent={{-20,-14},
            {20,14}},                                                                               rotation = 0)));
  // Living room
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TsensorLiving
    annotation (Placement(visible=true, transformation(extent={{52,-26},{40,-14}},
          rotation=0)));
  Modelica.Blocks.Continuous.LimPID PIDLiving(
    Td=600,
    Ti(displayUnit="s") = 1200,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.25,
    yMax=1,
    yMin=0) annotation (Placement(visible=true, transformation(extent={{4,-50},
            {24,-30}}, rotation=0)));
  BuildSysPro.Systems.HVAC.Emission.Radiator.HotWaterRadiatorRegulDistrib RadLiving(Pnom=2500)
                                                                                   annotation (
    Placement(visible = true, transformation(origin = {60, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  // Kitchen
  Modelica.Blocks.Continuous.LimPID PIDKitchen(
    Td=600,
    Ti(displayUnit="s") = 1200,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.25,
    yMax=1,
    yMin=0) annotation (Placement(visible=true, transformation(extent={{146,-60},
            {166,-40}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TsensorKitchen annotation (
    Placement(visible = true, transformation(extent = {{194, -36}, {182, -24}}, rotation = 0)));
  BuildSysPro.Systems.HVAC.Emission.Radiator.HotWaterRadiatorRegulDistrib RadKitchen annotation (
    Placement(visible = true, transformation(origin = {200, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  // Bathroom
  Modelica.Blocks.Continuous.LimPID PIDBathroom(
    Td=600,
    Ti(displayUnit="s") = 1200,
    controllerType=.Modelica.Blocks.Types.SimpleController.PI,
    k=0.25,
    yMax=1,
    yMin=0) annotation (Placement(visible=true, transformation(extent={{42,-150},
            {62,-130}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TsensBathroom annotation (
    Placement(visible = true, transformation(extent = {{84, -126}, {72, -114}}, rotation = 0)));
  BuildSysPro.Systems.HVAC.Emission.Radiator.HotWaterRadiatorRegulDistrib RadBathroom annotation (
    Placement(visible = true, transformation(origin = {85, -181}, extent = {{17, -19}, {-17, 19}}, rotation = 0)));
  // Bedroom number 3
  BuildSysPro.Systems.HVAC.Emission.Radiator.HotWaterRadiatorRegulDistrib RadBedroom3 annotation (
    Placement(visible = true, transformation(origin = {239, -181}, extent = {{17, -19}, {-17, 19}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TsensBedroom3 annotation (
    Placement(visible = true, transformation(extent = {{202, -126}, {190, -114}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID PIDBedroom3(
    Ti(displayUnit="s") = 1200,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.25,
    yMax=1,
    yMin=0) annotation (Placement(visible=true, transformation(extent={{160,-150},
            {180,-130}}, rotation=0)));
    // Annual provided heating and electric consumption
  Modelica.Units.SI.Energy ConsElec(start=0);
  Modelica.Units.SI.Energy Qtot(start=0);
equation
  der(ConsElec) = hPHeatingAir2Water.Qelec;
  der(Qtot) = hPHeatingAir2Water.Qfour;
  connect(scenarioRT.TconsigneChaud, PIDLiving.u_s) annotation (
    Line(points={{-259.333,198},{-154,198},{-154,-40},{2,-40}},      color = {0, 0, 127}));
  connect(TsensorLiving.T, PIDLiving.u_m) annotation (Line(points={{39.4,-20},{
          -7,-20},{-7,-58},{14.5,-58},{14.5,-52},{14,-52}},
                                                    color={0,0,127}));
  connect(meteofile.G, mozartMultizone.G) annotation (
    Line(points={{-262,256},{-99,256},{-99,270.552},{-27.6,270.552}},  color = {0, 0, 127}, thickness = 0.5));
  connect(mozartMultizone.T_ext, meteofile.T_dry) annotation (
    Line(points={{-12.8,142.454},{-134.5,142.454},{-134.5,266},{-262,266}},color = {191, 0, 0}));
  connect(TsensorLiving.port, mozartMultizone.T_int_living) annotation (Line(
        points={{52,-20},{83,-20},{83,44},{120,44},{120,113.988},{117.44,
          113.988}},
        color={191,0,0}));
  connect(PIDLiving.y, RadLiving.Regulation) annotation (
    Line(points = {{25, -40}, {32, -40}, {32, -50}, {42, -50}}, color = {0, 0, 127}));
  connect(RadLiving.Rad, TsensorLiving.port) annotation (Line(points={{56.8,-46},
          {62,-46},{62,-20},{52,-20}}, color={191,0,0}));
  connect(RadLiving.Conv, TsensorLiving.port) annotation (Line(points={{68.8,-46},
          {62,-46},{62,-20},{52,-20}}, color={191,0,0}));
  connect(PIDKitchen.y, RadKitchen.Regulation) annotation (
    Line(points = {{167, -50}, {182, -50}}, color = {0, 0, 127}));
  connect(RadKitchen.Conv, TsensorKitchen.port) annotation (
    Line(points={{208.8,-46},{202.6,-46},{202.6,-30},{194,-30}},        color = {191, 0, 0}));
  connect(TsensorKitchen.T, PIDKitchen.u_m) annotation (
    Line(points={{181.4,-30},{131,-30},{131,-68},{155.5,-68},{155.5,-62},{156,
          -62}},                                                                                color = {0, 0, 127}));
  connect(RadKitchen.Rad, TsensorKitchen.port) annotation (
    Line(points={{196.8,-46},{202.6,-46},{202.6,-30},{194,-30}},        color = {191, 0, 0}));
  connect(scenarioRT.TconsigneChaud, PIDKitchen.u_s) annotation (
    Line(points={{-259.333,198},{-154,198},{-154,-40},{-16,-40},{-16,-106},{120,
          -106},{120,-50},{144,-50}},                                                                                    color = {0, 0, 127}));
  connect(TsensBathroom.T, PIDBathroom.u_m) annotation (
    Line(points={{71.4,-120},{29,-120},{29,-158},{51.5,-158},{51.5,-152},{52,
          -152}},                                                                               color = {0, 0, 127}));
  connect(TsensBedroom3.T, PIDBedroom3.u_m) annotation (
    Line(points={{189.4,-120},{149,-120},{149,-160},{169.5,-160},{169.5,-152},{
          170,-152}},                                                                                 color = {0, 0, 127}));
  connect(RadLiving.WaterOut, RadKitchen.WaterIn) annotation (
    Line(points={{80.4,-74},{182,-74}},    color = {0, 0, 127}, thickness = 0.5));
  connect(RadKitchen.WaterOut, RadBedroom3.WaterIn) annotation (
    Line(points={{220.4,-74},{278,-74},{278,-194.3},{254.3,-194.3}},  color = {0, 0, 127}, thickness = 0.5));
  connect(RadBedroom3.WaterOut, RadBathroom.WaterIn) annotation (
    Line(points={{221.66,-194.3},{100.3,-194.3}},
                                              color = {0, 0, 127}, thickness = 0.5));
  connect(temperatureSensor5.T, hPHeatingAir2Water.T_ext) annotation (
    Line(points={{-219.3,-103},{-219.3,-104},{-196,-104}}, color = {0, 0, 127}));
  connect(temperatureSensor5.port, meteofile.T_dry) annotation (
    Line(points={{-234,-103},{-242,-103},{-242,266},{-262,266}},        color = {191, 0, 0}));
  connect(hPHeatingAir2Water.WaterOut, RadLiving.WaterIn) annotation (
    Line(points={{-119.2,-136},{-60,-136},{-60,-74},{42,-74}},                   color = {0, 0, 127}, thickness = 0.5));
  connect(mozartMultizone.T_int_kitchen, TsensorKitchen.port) annotation (
    Line(points={{167.76,156.687},{194,156.687},{194,-30},{194,-30}},
                                                                    color = {191, 0, 0}));
  connect(scenarioRT.TconsigneChaud, PIDBathroom.u_s) annotation (
    Line(points={{-259.333,198},{-154,198},{-154,-40},{-16,-40},{-16,-132},{-16,
          -132},{-16,-140},{40,-140},{40,-140}},                                                                                      color = {0, 0, 127}));
  connect(scenarioRT.TconsigneChaud, PIDBedroom3.u_s) annotation (
    Line(points={{-259.333,198},{-154,198},{-154,-40},{-16,-40},{-16,-106},{120,
          -106},{120,-140},{158,-140}},                                                                                    color = {0, 0, 127}));
  connect(PIDBedroom3.y, RadBedroom3.Regulation) annotation (
    Line(points={{181,-140},{266,-140},{266,-170},{266,-171.5},{254.3,-171.5}},      color = {0, 0, 127}));
  connect(PIDBathroom.y, RadBathroom.Regulation) annotation (
    Line(points={{63,-140},{110,-140},{110,-171.75},{100.3,-171.75},{100.3,-171.5}},        color = {0, 0, 127}));
  connect(RadBathroom.Rad, TsensBathroom.port) annotation (
    Line(points={{87.72,-167.7},{84,-167.7},{84,-120}}, color = {191, 0, 0}));
  connect(RadBathroom.Conv, TsensBathroom.port) annotation (
    Line(points={{77.52,-167.7},{84,-167.7},{84,-120}}, color = {191, 0, 0}));
  connect(mozartMultizone.T_int_bathroom, TsensBathroom.port) annotation (
    Line(points={{203.28,94.0615},{202,94.0615},{202,0},{100,0},{100,-120},{84,-120}},   color = {191, 0, 0}));
  connect(RadBathroom.WaterOut, distributionPipe.WaterIn) annotation (
    Line(points={{67.66,-194.3},{-240,-194.3},{-240,-184.4},{-240.4,-184.4}},
                                                                          color = {0, 0, 127}, thickness = 0.5));
  connect(distributionPipe.WaterOut, hPHeatingAir2Water.WaterIn) annotation (
    Line(points={{-240.4,-155.6},{-240.4,-136},{-196,-136}},  color = {0, 0, 127}, thickness = 0.5));
  connect(booleanTable.y, hPHeatingAir2Water.SaisonChauffe) annotation (
    Line(points={{-199,-70},{-188,-70},{-188,-84}},                     color = {255, 0, 255}));
  connect(deadband.OnOff, hPHeatingAir2Water.u) annotation (
    Line(points={{-180.4,-30},{-160,-30},{-160,-84}},                   color = {255, 0, 255}));
  connect(distributionPipe.T_int, TWaterReturn.port) annotation (
    Line(points={{-253.2,-170},{-260,-170},{-260,-152}},      color = {191, 0, 0}));
  connect(TWaterReturn.T, deadband.Variable) annotation (
    Line(points={{-260,-139.4},{-260,-30},{-219.2,-30},{-219.2,-30.4}},                color = {0, 0, 127}));
  connect( WaterLoopSetpoint.y, deadband.Setpoint) annotation (
    Line(points={{-258,-18},{-219.6,-18}},                              color = {0, 0, 127}));
  connect(TsensBedroom3.port, RadBedroom3.Conv) annotation (
    Line(points={{202,-120},{236,-120},{236,-166},{231.52,-166},{231.52,-167.7}},    color = {191, 0, 0}));
  connect(TsensBedroom3.port, RadBedroom3.Rad) annotation (
    Line(points={{202,-120},{236,-120},{236,-166},{241.72,-166},{241.72,-167.7}},    color = {191, 0, 0}));
  connect(mozartMultizone.T_int_room3, TsensBedroom3.port) annotation (
    Line(points={{250.64,105.448},{246,105.448},{246,-120},{202,-120},{202,-120}}, color = {191, 0, 0}));
  connect(heatCapacitor.port, distributionPipe.T_int) annotation (
    Line(points={{-282,-180},{-252,-180},{-252,-170},{-253.2,-170}},        color = {191, 0, 0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-300, -300}, {300, 300}})),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Example of the <span style=\"font-family: Courier New;\">MozartMultizone</span> model with a heating system including an air-to-water heating pump and 4 hot water radiators (one per room except for two rooms for simplification). </p>
<p>There is only one water loop (the heat pump and the four radiators are in series). </p>
<p>The production (heat pump) and the emission part (hot water radiators) of the heating system have their own control strategy:</p>
<ul>
<li>all-or-nothing regulation at thea heat pump with an hysteresis of +/- 2&deg;C around 50&deg;C</li>
<li>proportionnal integral control for the hot water radiator. </li>
</ul>
<p><br>The setting of a PI controller needs two values: </p>
<ul>
<li>the gain <span style=\"font-family: Courier New;\">k</span> assessing the proptionnal band between the controled value (radiator mass flow rate =&gt; heating power) and the mesured value (room temperature). Here the raditor must be off (=0) when the room temperature is two degree above the setpoint and fully opened (=1) when the temperature is two degree below it. The gain is worth to 0,25 (=(1-0)/(2+2&deg;C)).</li>
<li>the integrator time constant <span style=\"font-family: Courier New;\">T</span>i assessing the duration after which the integral part has an higher weight then the proportional part. This duration must be consistent with the inertia of the system. Here the thermal mass of a room could be assessed in first order to 20 minutes (the needed time you consider for an usual HVAC systems to reach a new setpoint). If the intagrator time constant is too short, the system will go up and down or diverge. In the default setting of this model, it could seem the case for many heating periods. But the up and down is not due to the radiator PI controler but due to the all-or-nothing control of the heat pump.</li>
</ul>
<p><br><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>The heat pump parameter <span style=\"font-family: Courier New;\">PumpOperation </span>is set to &quot;Independant control&quot; because its all-or-none control is on the water temperature outlet and so the water pump has to run all the time to let the heat pump know the heating needs at the emittors (here the hot water radiators).</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert BLERVAQUE 03/2021</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Hubert BLERVAQUE [prestation externe] (03/2021)<br>
--------------------------------------------------------------</b></p>
</html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false)),
    experiment(StartTime = 0, StopTime = 3.1536e+07, Tolerance = 1e-06, Interval = 3600));
end MozartMultizoneHeatingSystem;
