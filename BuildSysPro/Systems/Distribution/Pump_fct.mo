within BuildSysPro.Systems.Distribution;
function Pump_fct
  "Model of oriented pumps to calculate the consumption of air-conditioned buildings"

// INPUT VARIABLES :

// Input

  input Modelica.Units.SI.MassFlowRate Me=2.5 "Flow rate";
  input Modelica.Units.NonSI.Temperature_degC Te=12.8
    "Input fluid temperature";

//Parameters

// Weighting coefficients //FFLP = C0 + C1. PLR + C2. PLR 2 + C3.PLR3"

  input Real C0=0.350712                                                                                    annotation (Dialog(tab="Paramètres", group="Coefficients de régression des performances à charges partielles"));

  input Real C1=0.3085                                                                                     annotation (Dialog(tab="Paramètres", group="Coefficients de régression des performances à charges partielles"));

  input Real C2=-0.541370                                                                                  annotation (Dialog(tab="Paramètres", group="Coefficients de régression des performances à charges partielles"));

  input Real C3=0.8810                                                                                  annotation (Dialog(tab="Paramètres", group="Coefficients de régression des performances à charges partielles"));

// Nominal characteristics

  input Modelica.Units.SI.Efficiency etaM=0.85 "Motor efficiency"
    annotation (Dialog(tab="Paramètres", group="Caractéristiques nominales"));

  input Modelica.Units.SI.VolumeFlowRate Vrat=0.0063
    "Nominal volume flow"
    annotation (Dialog(tab="Paramètres", group="Caractéristiques nominales"));

  input Modelica.Units.SI.Power Wprat=1119 "Total nominal power"
    annotation (Dialog(tab="Paramètres", group="Caractéristiques nominales"));

  input Modelica.Units.SI.Pressure DPrat=89700
    "Nominal pressure difference"
    annotation (Dialog(tab="Paramètres", group="Caractéristiques nominales"));

// Fluid characteristics
  input Modelica.Units.SI.SpecificHeatCapacity CpLiq=4180
    "Heat capacity"
    annotation (Dialog(tab="Paramètres", group="Caractéristiques du fluide"));
  input Modelica.Units.SI.Density rhoLiq=998 "Density of fluid"
    annotation (Dialog(tab="Paramètres", group="Caractéristiques du fluide"));

  input Real fmloss "Transmitted energy to fluid" annotation (Dialog(tab="Paramètres", group="Caractéristiques nominales"));
 // OUTPUT VARIABLES

  output Modelica.Units.NonSI.Temperature_degC Ts
    "Output fluid temperature";
  output Modelica.Units.SI.Power Wp "Absorbed power by the motor";

  output Modelica.Units.SI.Power qLoss; // heat transfert to fluid stream

protected
  Modelica.Units.SI.Efficiency etaP;  //pump efficiency
  Modelica.Units.SI.Efficiency etaPM; //pump and motor efficiency
    Real FFLP; //fraction of full-load power
    Real PLR; //part-load flow ratio
  Modelica.Units.SI.Power Wshaft;  // shaft power

algorithm
// The both following lines are used to set internal parameters and is independent
//of component input values. In an hourly simulation, this block of code may
// be skipped after the first call.
        etaPM := Vrat*DPrat/Wprat;
        etaP := etaPM / etaM;

// Calculate the part load ratio based on rated flow
        PLR := abs(Me) / rhoLiq / Vrat;

// Calculate the fraction of full-load power based on rating point
        FFLP := C0+C1*PLR+C2*PLR^2+C3*PLR^3;

//Calculate the actual pump shaft power and motor power
        Wp :=Wprat*FFLP;
        Wshaft :=Wp*etaM;

// Calculate the leaving fluid conditions
        qLoss := Wshaft*(1-etaP) + (Wp-Wshaft)*fmloss;
        Ts := Te + qLoss/Me/CpLiq;

  annotation (Documentation(info="<html>
<p><u><b>Hypothesis and equations</b></u></p>
<p>none</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>none</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Sila Filfli - 01/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>"));
end Pump_fct;
