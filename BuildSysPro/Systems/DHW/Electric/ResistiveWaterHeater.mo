within BuildSysPro.Systems.DHW;
model ResistiveWaterHeater
  "Electric hot water tank with homogeneous temperature"
  parameter Modelica.SIunits.Volume V=0.200 "Volume"
    annotation(Dialog(group = "Tank"));
  parameter Modelica.SIunits.Length d=0.50 "Diameter"
    annotation(Dialog(group = "Tank"));
  parameter Modelica.SIunits.Power P=2500 "Max electric power"
    annotation(Dialog(group = "Regulation"));
  parameter Modelica.SIunits.Temperature T_sp=273.15+60 "Setpoint temperature"
    annotation(Dialog(group = "Regulation"));
  parameter Modelica.SIunits.TemperatureDifference dT=3 "Hysteresis band"
    annotation(Dialog(group = "Regulation"));
  parameter Modelica.SIunits.Length e=0.04 "Thickness"
    annotation(Dialog(group = "Insulating",tab="Other parameters"));
  parameter Modelica.SIunits.ThermalConductivity lambda=0.04
    "Thermal conductivity"
    annotation(Dialog(group = "Insulating",tab="Other parameters"));
  parameter Modelica.SIunits.Density rho=1000 "Density"
    annotation(Dialog(group = "Fluid",tab="Other parameters"));
  parameter Modelica.SIunits.SpecificHeatCapacity Cp=4185
    "Specific heat capacity"
    annotation(Dialog(group = "Fluid",tab="Other parameters"));
  //Modelica.SIunits.Temperature T "Water temperature in the tank";
  Integer Hyst(start=0) "Hysteresis";

  Real PertekWh "Energy loss through the tank envelope in kWh";
  Real EnergieCHkWh "Energy of tank water heating in kWh";

protected
  constant Real pi=Modelica.Constants.pi;
  constant Real coef36=1.0/3.6e6;
  constant Modelica.SIunits.CoefficientOfHeatTransfer he=10
    "Outside exchange coefficient";

  parameter Modelica.SIunits.Area Sb=pi*d*d/4 "Surface of the tank base";
  parameter Modelica.SIunits.Length H=V/Sb "Tank height";
  parameter Modelica.SIunits.Area St=pi*d*H+2*Sb "Total exchange surface";

  parameter Modelica.SIunits.CoefficientOfHeatTransfer h=1.0/(1/he+e/lambda)
    "Outside exchange coefficient";
  parameter Modelica.SIunits.ThermalConductance KS=(1.1+0.05/V)*h*St;
  parameter Modelica.SIunits.HeatCapacity C=rho*Cp*V;

public
  Modelica.Blocks.Interfaces.RealInput T_cold
    "Cold water temperature in degrees C" annotation (Placement(transformation(
          extent={{-120,-10},{-80,30}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-100})));
  Modelica.Blocks.Interfaces.RealInput debit "Drawing rate in kg/s"
    annotation (Placement(transformation(extent={{-120,-84},{-80,-44}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-100})));
  Modelica.Blocks.Interfaces.RealInput OnOff
    "Signal ON(1)/OFF(0) of the electrical resistance" annotation (
      Placement(transformation(extent={{-100,40},{-60,80}}), iconTransformation(
          extent={{-100,40},{-60,80}})));
  Modelica.Blocks.Interfaces.RealOutput Pelec "Electric power injected in W"
                                   annotation (Placement(transformation(
          extent={{60,60},{80,80}}), iconTransformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Interfaces.RealOutput Cons "Electric consumption in kWh"
    annotation (Placement(transformation(extent={{60,40},{80,60}}),
        iconTransformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b T_int "Air ambiant"
    annotation (Placement(transformation(extent={{60,-10},{80,10}}),
        iconTransformation(extent={{60,-10},{80,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor deperdition(G=KS)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,-14})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,-32})));
  Modelica.Thermal.HeatTransfer.Components.Convection ChauffageEau
                                                                 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-14,-32})));
  Modelica.Blocks.Math.Gain gain(k=Cp)
    annotation (Placement(transformation(extent={{-60,-74},{-40,-54}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,46})));
  Modelica.Blocks.Sources.RealExpression Puissance(y=Pelec)
    annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Eau(C=C)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={14,10})));
  Modelica.Blocks.Interfaces.RealOutput T_tank
    "Water temperature in the tank [K]" annotation (Placement(transformation(
          extent={{60,82},{80,102}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,90})));
equation
  Hyst=if T_tank < T_sp - dT then 1 elseif T_tank > T_sp + dT then 0 else pre(
     Hyst);
  Pelec=OnOff*P*Hyst;
  T_tank = Eau.T;
  der(Cons) = Pelec*coef36;
  der(EnergieCHkWh)=ChauffageEau.solid.Q_flow*coef36;
  der(PertekWh)=deperdition.port_a.Q_flow*coef36;
initial equation
//  der(T)=0.0;
  T_tank = T_sp;
  EnergieCHkWh=0.0;
  PertekWh=0.0;




equation
  connect(deperdition.port_b, T_int) annotation (Line(
      points={{52,0},{70,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(toKelvin.Celsius, T_cold) annotation (Line(
      points={{-70,-2},{-70,10},{-100,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toKelvin.Kelvin, prescribedTemperature.T) annotation (Line(
      points={{-70,-25},{-70,-32},{-56,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, ChauffageEau.fluid)
                                                        annotation (Line(
      points={{-34,-32},{-24,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(debit, gain.u) annotation (Line(
      points={{-100,-64},{-62,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, ChauffageEau.Gc)
                                 annotation (Line(
      points={{-39,-64},{-14,-64},{-14,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Puissance.y, prescribedHeatFlow.Q_flow)      annotation (Line(
      points={{-27,60},{1.83697e-015,60},{1.83697e-015,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, Eau.port) annotation (Line(
      points={{-1.83697e-015,36},{0,36},{0,0},{14,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(deperdition.port_a, Eau.port) annotation (Line(
      points={{32,0},{14,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ChauffageEau.solid, Eau.port) annotation (Line(
      points={{-4,-32},{14,-32},{14,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Icon(graphics={Rectangle(
          extent={{-60,80},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid), Text(
          extent={{-60,20},{60,-20}},
          lineColor={0,0,255},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          textString="DHW
homogeneous"),
        Text(
          extent={{-30,74},{30,54}},
          lineColor={0,0,255},
          textString="Twater")}),
    Documentation(info="<html>
<p><b>Electric hot water tank with a single temperature node: the temperature is assumed to be homogeneous (no stratification).</b></p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>The tank is supposed cylindrical: diameter d and height H.</p>
<p>The insulator (conductivity lambda and thickness e) is uniformly distributed on the outer surface of the tank.</p>
<p>The mass of water is supposed to be at homogeneous temperature T_tank.</p>
<p>The heat storage in the tank results from the superposition of three heat flows:</p>
<ul>
<li>the electric power injected into the water with a Pelec power resistance to maintain the setpoint T_sp according to an ON/OFF signal </li>
<p>- It is a hysteresis regulation with a half-band dT on both sides of the setpoint: Hyst = if T_sp+dT then 0 else pre(Hyst)</p>
<p>- The electric power injected into the water is equal to: Pelec = OnOff.P.Hyst </p>
<li>the power participating in heating the drawing rate that enters in the tank with a temperature T_cold (cold water) and exits at temperature T_tank,</li>
<p>- The water heating power is equal to: debit.Cp.(T_tank - T_cold)</p>
<li>tank losses through its envelope are calculated by reference [1]:</li>
<p>- An average coefficient of outside exchange is assumed: he = 10 W / (m&sup2;.K)</p>
<p>- With a first approximation, the loss coefficient is equal  to: KS = (1,1 +0,05/V).h.S avec 1/h = 1/he + e/lambda, S = pi.d.(H + d/2) et V = pi.d&sup2;.H/4 </p></ul>
<p><u><b>Bibliography</b></u></p>
<p>[1] : E.C.S. : hot water in residential and tertiary buildings</p>
<p>Design and computation of facilities</p>
<p>Collection of AICVF guides, pyc edition, first edition 1991</p>
<p><u><b>Instructions for use</b></u></p>
<p>See example <a href=\"BuildSysPro.Systems.DHW.Examples.DHWResistiveWaterHeater\">DHWResistiveWaterHeater</a>.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>This model is very simple to implement in a study and enables a low computation time.</p>
<p>It is very sufficient and accurate to deal with consumption problems over a long period (1 year for example).</p>
<p>But for studies on power demands, it is advisable to use tank models taking into account the thermal stratification.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hassan Bouia 10/2012</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2017<br>
BuildSysPro version 3.0.0<br>
Author : Hassan BOUIA, EDF (2012)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ResistiveWaterHeater;
