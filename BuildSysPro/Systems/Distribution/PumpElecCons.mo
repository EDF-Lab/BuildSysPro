within BuildSysPro.Systems.Distribution;
model PumpElecCons "Electric consumption of a pump"

//  input Modelica.SIunits.MassFlowRate Me = 2.5 "Fluid mass flow";
//  input Modelica.SIunits.Temp_C Te = 12.8 "Input temperature of the fluid";
  import SI = Modelica.SIunits;

// Weighting coefficients //FFLP = C0 + C1. PLR + C2. PLR 2 + C3.PLR3"
  parameter Real C0=0.350712 annotation (Dialog(group="Regression coefficients of partial load performances"));
  parameter Real C1=0.3085     annotation (Dialog(group="Regression coefficients of partial load performances"));
  parameter Real C2=-0.541370 annotation (Dialog(group="Regression coefficients of partial load performances"));
  parameter Real C3=0.8810   annotation (Dialog(group="Regression coefficients of partial load performances"));

// Rated parameters
  parameter SI.Efficiency etaM = 0.85 "Motor efficiency" annotation (Dialog(group="Rated parameters"));
  parameter SI.VolumeFlowRate Vrat = 0.0001 "Volume flow rate" annotation (Dialog(group="Rated parameters"));
  parameter SI.Power Wprat = 20 "Total rated power" annotation (Dialog(group="Rated parameters"));
  parameter SI.Pressure DPrat = 89700 "Rated pression difference" annotation (Dialog(group="Rated parameters"));
  parameter SI.VolumeFlowRate VratMin=Vrat/10 "Minimum volume flow" annotation (Dialog(group="Rated parameters"));

// Fluid characteristics
  parameter SI.SpecificHeatCapacity CpLiq=4180 "Fluid specific heat capacity" annotation (Dialog(group="Fluid characteristics"));
  parameter SI.Density rhoLiq=998 "Fluid density" annotation (Dialog(group="Fluid characteristics"));
  parameter Real fmloss=0.5
    "Part of energy transmitted from the motor to the fluid"                          annotation (Dialog(group="Fluid characteristics"));

protected
  SI.MassFlowRate Debit "Fluid mass flow";
  SI.Efficiency etaP "Pump efficiency";
  SI.Efficiency etaPM "Pump and motor efficiency";
  Real FFLP "Fraction of full-load power";
  Real PLR "Part-load flow ratio";
  SI.Power Wshaft "Shaft power";
  SI.Power qLoss "Heat transfert to fluid stream";

public
  Modelica.Blocks.Interfaces.RealOutput WaterOut[2]
    "Vector containing 1-output fluid temperature (K), 2-output fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{80,-10},{120,30}}),
        iconTransformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Interfaces.RealInput WaterIn[2]
    "Vector containing 1-input fluid temperature (K), 2-input fluid flow rate (kg/s)"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput Pelec
    "Electric power consumed by the pump"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,-80}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-90})));
// -----------------------------------------------------------------------------------
equation

// Volume flow conservation : WaterIn[2]=WaterOut[2]
  Debit=WaterIn[2];

// The both following lines are used to set internal parameters and are independent
// of component input values. In an hourly simulation, this block of code may
// be skipped after the first call.
  etaPM =  Vrat*DPrat/Wprat;
  etaP =  etaPM / etaM;

// Calculate the part load ratio based on rated flow
  PLR =  abs(Debit) / rhoLiq / Vrat;

// Calculate the fraction of full-load power based on rating point
  FFLP =  C0+C1*PLR+C2*PLR^2+C3*PLR^3;

// Calculate the actual pump shaft power and motor power
  if Debit>VratMin*rhoLiq then
    Pelec = Wprat*FFLP;
    Wshaft = Pelec*etaM;
  else
    Pelec=0;
    Wshaft=0;
  end if;

// Calculate the leaving fluid conditions
  qLoss =  Wshaft*(1-etaP) + (Pelec-Wshaft)*fmloss;
  WaterOut[1] = WaterIn[1] + qLoss/Debit/CpLiq;

  connect(WaterIn[2], WaterOut[2]) annotation (Line(
      points={{-100,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p><u><b>tHypothesis and equations</b></u></p>
<p>This model calculates the power and leaving temperature for pump using simple part load characteristics.</p>
<p>Three types of pumps are represented :
<ul><li>Case 1 : fixed speed pumps, the control of flow rate is realized by a three way valve</li>
<li>Case 2 : fixed speed pumps without control</li>
<li>Case 3 : variable speed pumps</li></ul><p>
<p>For the variable speed configuration, the electric consumption is calculated by using a part load ratio as function of flow rate.
The increase of temperature at the outlet is calculated as a function of the power of the pump considering constant efficiency of the motor.</p>
<p>Case 1 :
The performance are those of the rating conditions.</p>
<p>Case 2 :
When thermal loads decrease, water flow rate is bypassed and the operating conditions of the pump are stable as the flow rate in the emitter would vary.</p>
<p>Case 3 :
The pump is characterized by a rating operating point. Making the hypothesis that the efficiency of the motor is constant, the power on the shaft is calculated as a cubic form of the rotational speed if the flow rate is proportional to the speed.
For an increase of the pressure delivered by the pump, the flow rate and the power are the two variables used to calculate the consumption of the pump at the operating point. A part load ratio (PLR) is used.
At a non-rating operating point, the PLR is defined as the ratio between the actual volumetric flow rate and the operating one.
Consumption at partial load is represented as a fraction of the rating power. At a lower flow rate, this fraction (FFLP fraction of full-load power) is determined by using a polynomial curve as a function of partial load.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>The user needs to have a characteristics of the pump at partial load (FFLP as function of PLR thus the Ci coefficients), otherwise default coefficients are used. In the case of identification of pump characteristics, the sum of coefficients (Ci) should be verified (equal to 1). 
The efficiency of the pump can be determined as the ratio between total efficiency of the pump and the efficiency of the motor.</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p style=\"color:red;\">Warning : this model does not impose any flow on the hydraulic circuit ! It only calculates the electric consumption of a pump and its effect on the temperature.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Sila Filfli 07/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF 2009 - 2020<br>
BuildSysPro version 3.4.0<br>
Author : Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>"), Diagram(graphics),
    Icon(graphics={Ellipse(extent={{-80,90},{80,-70}}, lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),                                  Line(
          points={{-40,80},{-40,-60},{80,10},{-40,80}},
          color={0,0,0},
          smooth=Smooth.None)}));
end PumpElecCons;
