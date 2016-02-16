within BuildSysPro.Systems.Distribution;
model Pump
  "Modèle de Pompes Orientées Calcul des Consommations des Bâtiments Climatisés"

//  input Modelica.SIunits.MassFlowRate Me = 2.5 "Débit du fluide";
//  input Modelica.SIunits.Temp_C Te = 12.8 "Température d'entrée de fluide";
  import SI = Modelica.SIunits;

// Coefficients de pondération //FFLP = C0 + C1. PLR + C2. PLR 2 + C3.PLR3"
  parameter Real C0=0.350712 annotation (Dialog(group="Coefficients de régression des performances à charges partielles"));
  parameter Real C1=0.3085     annotation (Dialog(group="Coefficients de régression des performances à charges partielles"));
  parameter Real C2=-0.541370 annotation (Dialog(group="Coefficients de régression des performances à charges partielles"));
  parameter Real C3=0.8810   annotation (Dialog(group="Coefficients de régression des performances à charges partielles"));

// Caractéristiques nominales
  parameter SI.Efficiency etaM = 0.85 "Rendement du moteur" annotation (Dialog(group="Caractéristiques nominales"));
  parameter SI.VolumeFlowRate Vrat = 0.0001 "Débit volumétrique nominal" annotation (Dialog(group="Caractéristiques nominales"));
  parameter SI.Power Wprat = 20 "Puissance totale nominale" annotation (Dialog(group="Caractéristiques nominales"));
  parameter SI.Pressure DPrat = 89700 "Différence de pression nominale" annotation (Dialog(group="Caractéristiques nominales"));
  parameter SI.VolumeFlowRate VratMin=Vrat/10 "Debit volumétrique minimale" annotation (Dialog(group="Caractéristiques nominales"));

// caractéristiques du fluide
  parameter SI.SpecificHeatCapacity CpLiq=4180 "Chaleur massique du fluide" annotation (Dialog(group="Caractéristiques du fluide"));
  parameter SI.Density rhoLiq=998 "Masse volumique du fluide" annotation (Dialog(group="Caractéristiques du fluide"));
  parameter Real fmloss=0.5
    "Part de l'énergie transmise au fluide au niveau du moteur"                          annotation (Dialog(group="Caractéristiques nominales"));

protected
  SI.MassFlowRate Debit "Débit massique du fluide";
  SI.Efficiency etaP; //pump efficiency
  SI.Efficiency etaPM;//pump and motor efficiency
  Real FFLP; //fraction of full-load power
  Real PLR; //part-load flow ratio
  SI.Power Wshaft; // shaft power
  SI.Power qLoss;  // heat transfert to fluid stream

public
  Modelica.Blocks.Interfaces.RealOutput Sortie[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit (m3/s)"
    annotation (Placement(transformation(extent={{80,-10},{120,30}}),
        iconTransformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Interfaces.RealInput Entree[2]
    "Vecteur contenant 1-la témperature du fluide (K), 2-le débit(m3/s)"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput Pelec
    "Puissance électrique consommée par la pompe"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,-80}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-90})));
// -----------------------------------------------------------------------------------
equation

// Il y a conservation du débit : Entrée[2]=Sortie[2]
  Debit=Entree[2];

// The both following lines are used to set internal parameters and is independent
// of component input values. In an hourly simulation, this block of code may
// be skipped after the first call.
  etaPM =  Vrat*DPrat/Wprat;
  etaP =  etaPM / etaM;

// Calculate the part load ratio based on rated flow
  PLR =  abs(Debit) / rhoLiq / Vrat;

// Calculate the fraction of full-load power based on rating point
  FFLP =  C0+C1*PLR+C2*PLR^2+C3*PLR^3;

//Calculate the actual pump shaft power and motor power
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
<p>Modèle validé - Sila Filfli 07/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>"), Diagram(graphics),
    Icon(graphics={Ellipse(extent={{-80,90},{80,-70}}, lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),                                  Line(
          points={{-40,80},{-40,-60},{80,10},{-40,80}},
          color={0,0,0},
          smooth=Smooth.None)}));
end Pump;
