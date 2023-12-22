within BuildSysPro.Systems.DHW.HeatPump;
model HPWaterHeaterPoly_Uniform

  // Draw-off scenario parameters
  parameter Real gain=1 "Mutliplying factor of energy consumption" annotation(Dialog(group = "Draw-off scenario"));
  parameter Real T_repeat=86400 "Repeat period [s]" annotation(Dialog(group = "Draw-off scenario"));
  parameter String fileName=Modelica.Utilities.Files.loadResource("modelica://BuildSysPro/Resources/Donnees/Scenarios/Profil_S.csv") "Name of file to read" annotation (Dialog(group = "Draw-off scenario",
        loadSelector(filter="CSV files (*.csv)", caption=
            "Name of file to read")));

  // Tank parameters
  parameter Modelica.Units.SI.Temperature initialTemperature=10 + 273.15
    "Initial water temperature in the tank [K]" annotation (Dialog(group="Tank"));
  parameter Modelica.Units.SI.Volume tankVolume=0.2 "Tank volume [m3]"
    annotation (Dialog(group="Tank"));
  parameter Modelica.Units.SI.ThermalConductance UA=2.2
    "Insulating heat transfer coefficient [W/m]" annotation (Dialog(group="Tank"));
  parameter Modelica.Units.SI.Temperature T_amb=20 + 273.15
    "Ambient air temperature [K]" annotation (Dialog(group="Tank"));
  parameter Modelica.Units.SI.Power auxiliaryPower=1800
    "Fixed heating power of the auxiliary heater [W]"
    annotation (Dialog(group="Tank"));

  // Heat pump parameters
  parameter Modelica.Units.SI.Power Pe_max=670
    "Maximum absorbed power by the heat pump unit at 7°C external air,
    50Hz and a water temperature of 55°C [K]"
    annotation (Dialog(group="Heat pump"));
  parameter Modelica.Units.SI.Time t_heating=25750
    "Heat-up time at 7°C external air for 10->55°C in tank [s]"
    annotation (Dialog(group="Heat pump"));
  parameter Modelica.Units.SI.Volume V_tank=0.2
    "Heat-up time at 7°C external air for 10->55°C in tank [m3]"
    annotation (Dialog(group="Heat pump"));
  parameter Real n_inverter=1 "Inverter compressor efficiency" annotation(Dialog(group = "Heat pump"));

  // Controller parameters
  parameter Modelica.Units.SI.Temperature T_set=55 + 273.15
    "HPWH setpoint temperature [K]" annotation (Dialog(group="Controller"));
  parameter Boolean activateTOU=false "Activate time of use prioritization" annotation(Dialog(group = "Controller"),choices(choice=true "True",choice=false "False",radioButtons=true));
  parameter Boolean HP_only=false "HP only mode (no auxiliary back up)" annotation(Dialog(group = "Controller"),choices(choice=true "True",choice=false "False",radioButtons=true));
  parameter Boolean manualOnOff=false "Activate external manual on/Off signal" annotation(Dialog(group = "Controller"),choices(choice=true "True",choice=false "False",radioButtons=true));
  parameter Modelica.Units.SI.Temperature T_set_low=45 + 273.15
    "HPWH setpoint temperature outside TOU period [K]"
    annotation (Dialog(group="Controller", enable=(activateTOU)));
  parameter Modelica.Units.SI.TemperatureDifference delta_T=15
    "Temperature hysteresis [K]" annotation (Dialog(group="Controller"));
  parameter Modelica.Units.SI.Temperature T_min_HP=273.15 - 5
    "Minimal HPWH operating condition [K]" annotation (Dialog(group="Controller"));
  parameter Real compSpeed=50 "Compressor operating speed [Hz]" annotation(Dialog(group = "Controller"));

  Modelica.Blocks.Interfaces.RealInput T_in "Inlet cold water temperature [K]"
                                            annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={32,-100}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-122})));
  Modelica.Blocks.Interfaces.BooleanInput OnOff if manualOnOff annotation (Placement(
        transformation(extent={{-120,80},{-80,120}}), iconTransformation(extent={{-140,80},
            {-100,120}})));
  Modelica.Blocks.Interfaces.RealOutput T_tank
    "Water temperature in the tank [K]"
    annotation (Placement(
        transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},
            {140,20}})));
  Components.MixedWaterTank mixedWaterTank(
    initialTemperature=initialTemperature,
    tankVolume=tankVolume,
    UA=UA,
    T_amb=T_amb,
    auxiliaryPower=auxiliaryPower)
    annotation (Placement(transformation(extent={{40,2},{74,50}})));
  BoundaryConditions.Scenarios.DrawOffScenario.DrawOff drawOffScenario(
    gain=gain,
    T_repeat=T_repeat,
    fileName=fileName) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-50})));
  Components.WaterHeaterHeatPumpController waterHeaterHeatPumpController(
    T_set=T_set,
    activateTOU=activateTOU,
    HP_only=HP_only,
    manualOnOff=manualOnOff,
    T_set_low=T_set_low,
    delta_T=delta_T,
    T_min_HP=T_min_HP,
    compSpeed=compSpeed)
    annotation (Placement(transformation(extent={{-38,40},{-8,72}})));
  Components.WaterHeaterHeatPumpPoly waterHeaterHeatPump(
    Pe_max=Pe_max,
    t_heating=t_heating,
    V_tank=V_tank,
    n_inverter=n_inverter)
    annotation (Placement(transformation(extent={{-42,-40},{-12,-10}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_ext "Exterior temperature"
    annotation (Placement(transformation(extent={{-116,-10},{-96,10}}),
        iconTransformation(extent={{-160,140},{-140,160}})));
protected
  BaseClasses.HeatTransfer.Sensors.TemperatureSensor T_ext_K
    annotation (Placement(transformation(extent={{-92,-6},{-80,6}})));
  Modelica.Blocks.Sources.RealExpression outletWaterTemperature(y=
        mixedWaterTank.T_tank)
    annotation (Placement(transformation(extent={{-48,-74},{-12,-46}})));
public
  Modelica.Blocks.Interfaces.RealOutput P_elec_hp
    "Heat pump electric power [W]"
    annotation (Placement(transformation(extent={{100,110},{140,150}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Modelica.Blocks.Interfaces.RealOutput COP_hp "Heat pump COP"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
      iconTransformation(extent={{100,100},{140,140}})));

equation
  P_elec_hp=waterHeaterHeatPump.Pe_tot;
  COP_hp=waterHeaterHeatPump.COP_tot;
  connect(drawOffScenario.drawoff_flow_rate, mixedWaterTank.m_flow) annotation (
     Line(points={{40,-50},{47.5556,-50},{47.5556,-2}},       color={0,0,127}));
  connect(T_in, drawOffScenario.T_cold) annotation (Line(points={{32,-100},{32,
          -70},{8,-70},{8,-44},{20,-44}},
                                     color={0,0,127}));
  connect(T_in, mixedWaterTank.T_in) annotation (Line(points={{32,-100},{32,-70},
          {66.4444,-70},{66.4444,-2}}, color={0,0,127}));
  connect(waterHeaterHeatPumpController.OnOff, waterHeaterHeatPump.OnOff)
    annotation (Line(points={{-27,39.0303},{-27,-7}},                     color=
         {255,0,255}));
  connect(waterHeaterHeatPumpController.OnOffAuxiliary, mixedWaterTank.onOffAuxiliary)
    annotation (Line(points={{-18.9,38.9333},{-18.9,14},{36.2222,14}},
                                                                    color={255,
          0,255}));
  connect(waterHeaterHeatPumpController.freq, waterHeaterHeatPump.speed)
    annotation (Line(points={{-7,49.697},{-4,49.697},{-4,30},{-54,30},{-54,-34},
          {-45,-34}},          color={0,0,127}));
  connect(T_ext_K.port, T_ext)
    annotation (Line(points={{-92,0},{-106,0}},color={191,0,0}));
  connect(outletWaterTemperature.y, drawOffScenario.T_hot) annotation (Line(
        points={{-10.2,-60},{0,-60},{0,-56},{20,-56}},   color={0,0,127}));
  connect(OnOff, waterHeaterHeatPumpController.onOffSwitch) annotation (Line(
        points={{-100,100},{-22.8,100},{-22.8,72.9697}}, color={255,0,255}));
  connect(T_ext_K.T, waterHeaterHeatPump.T_air) annotation (Line(points={{-80,0},
          {-60,0},{-60,-25},{-45,-25}}, color={0,0,127}));
  connect(waterHeaterHeatPump.Pq_cond, mixedWaterTank.heatInput) annotation (
      Line(points={{-10.5,-13},{20,-13},{20,30},{36.2222,30}},         color={0,
          0,127}));
  connect(T_ext_K.T, waterHeaterHeatPumpController.T_air) annotation (Line(
        points={{-80,0},{-60,0},{-60,48},{-50,48},{-50,51.6364},{-39,51.6364}},
        color={0,0,127}));
  connect(mixedWaterTank.T_sensor, T_tank) annotation (Line(points={{75.8889,28},
          {90,28},{90,0},{120,0}},         color={0,0,127}));
  connect(mixedWaterTank.T_sensor, waterHeaterHeatPumpController.T_water)
    annotation (Line(points={{75.8889,28},{90,28},{90,80},{-66,80},{-66,63.2727},
          {-39,63.2727}},            color={0,0,127}));
  connect(mixedWaterTank.T_sensor, waterHeaterHeatPump.T_water) annotation (
      Line(points={{75.8889,28},{90,28},{90,80},{-66,80},{-66,-16},{-45,-16}},
                   color={0,0,127}));
  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-80,-100},{100,140}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-80,52},{100,-102}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-80,140},{100,-8}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-34,-8},{58,-8}},
          color={255,85,85},
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-114,170},{-24,82}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Ellipse(
          extent={{-107,164},{-30,88}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-76,128},{-62,164}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-76,88},{-62,124}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-7,-18},{7,18}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-89,126},
          rotation=90),
        Ellipse(
          extent={{-7,-18},{7,18}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-49,126},
          rotation=90)}), Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-80,-100},{100,140}},
        initialScale=0.1)),
    Documentation(info="<html>
<p>Air source heat pump water heater (ASHPWH) with mantle heat exchanger including both fixed and variable speed compressor, associated with uniform water tank.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Polynomial model extrapolatable to various ASHPWH sizes using linear extrapolation based on manufacturer data : heating time, maximum compressor power and tank volume.</p>
<p>Quasi-steady state model based on air temperature, tank water temperature and compressor speed.</p>
<p>Built upon a detailed model neglecting :
<ul><li>Oil circulation and accumulation</li>
<li>Frost growth (shown to be neglegible for ASHPWHs - K. R. Deutz 2018)</li>
<li>Compressor inertia (quasi-steady state heat pump)</li></ul></p>
<p>System reference configuration :
<ul><li>200L water tank</li>
<li>Maximum compressor reference power = 670W</li>
<li>Heating time = 25750s </li>
<li>13cm3 variable speed compressor</li>
<li>Mantle heat exchanger condenser</li></ul></p>
<p><u><b>Bibliography</b></u></p>
<p>K. R. Deutz PhD Thesis 04/2018</p>
<p><a href=\"modelica://BuildSysPro/Resources/Documentation/Modeling%20and%20Experimental%20Study%20of%20a%20Heat%20Pump%20Water%20Heater%20Cycle.pdf\">Modeling and Experimental Study of a Heat Pump Water Heater Cycle</a> - Purdue Conference - K. R. Deutz 2016</p>
<p><a href=\"modelica://BuildSysPro/Resources/Documentation/Second%20Order%20Polynomial%20Regression%20for%20a%20standard%20Heat%20Pump%20Water%20Heater%20thermal%20Capacity%20Control%20Algorithm.pdf\">Second Order Polynomial Regression for a standard Heat Pump Water Heater thermal Capacity Control Algorithm</a> - K. R. Deutz 2017</p>
<p>Detailed and dynamic air source heat pump water heater model : combining a zonal tank model approach with a grey box heat pump model - Applied Energy - K. R. Deutz 2018</p>
<p><u><b>Instructions for use</b></u></p>
<p><ol><li>Take constructor catalogue and fill in the required parameters (tank, heat pump and control characteristics)</li>
<li>Fill in draw-off scenario parameters</li>
<li>Couple with a weather file for the external air temperature</li>
<li>Couple with boolean on/off signal (if manual on/off choosen)</li></ol></p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Guaranteed validity range :
<ul><li>Air temperatures : from -5&deg;C to 25&deg;C</li>
<li>Water temperatures : from 25&deg;C to 55&deg;C</li>
<li>Compressor speeds : from 30Hz to 120Hz</li></ul></p>
<p>Watch for simulation results outside the validity range and extrapolation</p>
<p><u><b>Validations</b></u></p>
<p>COP, electric power and thermal capacity validated model according to air/water HP.</p>
<p>COP, electric power and thermal capacity validated experimentally on air temperatures ranging from -3&deg;C to 20&deg;C and compressor speeds ranging from 30Hz to 120Hz.</p>
<p>Validated model - Kévin Deutz 08/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2023<br>
BuildSysPro version 3.6.0<br>
Author : Kévin DEUTZ, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>"));
end HPWaterHeaterPoly_Uniform;
