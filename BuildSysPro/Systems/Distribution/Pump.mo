within BuildSysPro.Systems.Distribution;
model Pump "Pump"

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
  Modelica.Blocks.Interfaces.RealOutput Sortie[2]
    "Vector containing 1-output fluid temperature (K), 2-output volume flow (m3/s)"
    annotation (Placement(transformation(extent={{80,-10},{120,30}}),
        iconTransformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Interfaces.RealInput Entree[2]
    "Vector containing 1-input fluid temperature (K), 2-input volume flow (m3/s)"
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

// Volume flow conservation : Entree[2]=Sortie[2]
  Debit=Entree[2];

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
  Sortie[1] = Entree[1] + qLoss/Debit/CpLiq;

  connect(Entree[2], Sortie[2]) annotation (Line(
      points={{-100,20},{100,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>Model of pump for a distribution system.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Sila Filfli 07/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2.0.0<br>
Author : Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>"), Diagram(graphics),
    Icon(graphics={Ellipse(extent={{-80,90},{80,-70}}, lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),                                  Line(
          points={{-40,80},{-40,-60},{80,10},{-40,80}},
          color={0,0,0},
          smooth=Smooth.None)}));
end Pump;
