within BuildSysPro.Systems.DHW.HeatPump.Components;
model MixedWaterTank
  "Uniform water tank"

  //Initialization
  parameter Modelica.Units.SI.Temperature initialTemperature=10 + 273.15
    "Initial water temperature in the tank";

  // Tank geometry
  parameter Modelica.Units.SI.Volume tankVolume=0.2 "Tank volume";
  parameter Boolean UA_userdefined=true
    "If true, user defines UA else based normative test sequence" annotation(choices(choice=true "True",choice=false "False",radioButtons=true));
  parameter Modelica.Units.SI.ThermalConductance UA=1
    "Insulating heat transfer coefficient"
    annotation (Dialog(enable=(UA_userdefined)));
  parameter Modelica.Units.SI.Power standbyPower=25 "Standby power"
    annotation (Dialog(enable=(not UA_userdefined)));
  // Boundary conditions
  parameter Modelica.Units.SI.Temperature T_amb=20 + 273.15
    "Ambient temperature";

  // Auxiliary Element
  parameter Modelica.Units.SI.Power auxiliaryPower=1800
    "Fixed heating power of the auxiliary heater";

  // Tank unknowns

  Modelica.Units.SI.Temperature T_tank(start=initialTemperature, fixed=true);
  Modelica.Units.SI.Energy E_stored(start=0);
  Modelica.Units.SI.Power P_loss(start=0);

protected
  Modelica.Units.SI.ThermalConductance UAcalc;

  Modelica.Units.SI.Power electricPower;

  // Water thermo-hydraulic properties
  constant Modelica.Units.SI.Density rho_water=1000 "Water density";
  constant Modelica.Units.SI.SpecificHeatCapacityAtConstantPressure cp=4185
    "Water specific heat capacity";
  constant Modelica.Units.SI.Temperature T_en_base_tank=10 + 273.15
    "Base temperature for energy calculation";

public
  Modelica.Blocks.Interfaces.RealInput m_flow annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-22,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-120})));
  Modelica.Blocks.Interfaces.RealInput T_in annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={32,-98}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={50,-120})));

  Modelica.Blocks.Interfaces.BooleanInput onOffAuxiliary
    annotation (Placement(transformation(extent={{-118,-60},{-78,-20}})));
public
  Modelica.Blocks.Interfaces.RealInput heatInput annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-98,32}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,38})));
  Modelica.Blocks.Interfaces.RealOutput T_sensor
    annotation (Placement(transformation(extent={{100,18},{120,38}})));
equation

  // 52.5+273.15 corresponds to an average temperature in the tank during standby test hypothesis
  UAcalc=if UA_userdefined then UA else standbyPower/(52.5+273.15-T_amb);

electricPower=if onOffAuxiliary then auxiliaryPower else 0;
der(T_tank) =(-heatInput+electricPower+m_flow*cp*(T_in-T_tank)+P_loss)/(cp*rho_water*tankVolume);

// Analysis data
P_loss=UAcalc*(T_amb-T_tank);
E_stored=tankVolume*rho_water*cp*(T_tank-T_en_base_tank);
T_sensor=T_tank;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-100},
            {100,140}})),                 Icon(coordinateSystem(extent={{-80,-100},
            {100,140}}, preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-80,54},{100,-100}},
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
          points={{-36,-8},{56,-8}},
          color={255,85,85},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Fully mixed thermal storage tank equivalent to a RC model</p>
<p>Used in <a href=\"BuildSysPro.Systems.DHW.HeatPump.HPWaterHeaterPoly_Uniform\"><code>HPWaterHeaterPoly_Uniform</code></a> model.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Kévin Deutz 08/2017</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Kévin DEUTZ, EDF (2017)<br>
--------------------------------------------------------------</b></p>
</html>"));
end MixedWaterTank;
