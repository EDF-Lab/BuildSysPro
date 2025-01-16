﻿within BuildSysPro.Systems.DHW.Electric;
model WaterTank

  //import SI=Modelica.SIunits;

 // Outlet mixed water temperature
  parameter Boolean mitigeur=true
    "withdrawal after mixer = true ; before mixer = false";
  parameter Modelica.Units.SI.Temperature Tmit=313.15
    "Desired mixed water temperature at outlet (draw; default 40°C)";

  parameter Integer nc=10 "Number of layers of the tank" annotation (Dialog(tab="Tank parameters"));
  parameter Integer ncInj=9 "Layer number of the electric power injection" annotation (Dialog(tab="Tank parameters"));
  parameter Integer ncSol=2 "Layer number of the solar power injection"
                                                                     annotation (Dialog(tab="Tank parameters"));

  parameter Modelica.Units.SI.Volume Volume(displayUnit="l") = 0.3
    "Tank capacity"
    annotation (Dialog(group="Thermodynamic tank characteristics"));
  parameter Modelica.Units.SI.Length Hauteur=1.8 "Tank height"
    annotation (Dialog(group="Caractéristiques du ballon thermodynamique"));
  parameter Modelica.Units.SI.Power Pmax=1500 "Electrical resistance power"
    annotation (Dialog(group="Thermodynamic tank characteristics"));
  parameter Boolean type_T_cold=false "Prescribed or fixed cold water temperature"   annotation(Evaluate=true,HideResult=true,Dialog(group="Thermodynamic tank characteristics"),choices(choice=true
        "Prescribed",                                                                       choice=false "Fixed",   radioButtons=true));
  parameter Modelica.Units.SI.Temperature T_cold_fixed=283.15
    "Cold water temperature" annotation (Dialog(group=
          "Thermodynamic tank characteristics", enable=not type_T_cold));
  parameter Modelica.Units.SI.Temperature T_sp=337.15 "Setpoint temperature"
    annotation (Dialog(group="Thermodynamic tank characteristics"));

  parameter Modelica.Units.SI.TemperatureDifference BP=3
    "Hysteresis on both sides of T_sp"
    annotation (Dialog(tab="Tank parameters"));

  parameter Modelica.Units.SI.ThermalConductivity lambda=0.62
    "Water conductivity" annotation (Dialog(tab="Tank parameters"));
  parameter Modelica.Units.SI.Density rho=1000 "Water density"
    annotation (Dialog(tab="Tank parameters"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=4185
    "Water specific heat capacity" annotation (Dialog(tab="Tank parameters"));
  parameter Modelica.Units.SI.SurfaceCoefficientOfHeatTransfer U=1
    "Transmission coefficient of the tank"
    annotation (Dialog(tab="Tank parameters"));
  parameter Real ku=1.5e6 "Higher convection coefficient" annotation (Dialog(tab="Tank parameters"));
  parameter Real kd=10 "Higher convection coefficient" annotation (Dialog(tab="Tank parameters"));

  discrete Integer Hyst(start=1);

  Real delta_t;
  Integer nMA(start=0);
  discrete Integer OnOffSol(start=1);
  Real heure=mod(time/3600,24);

protected
  Modelica.Blocks.Interfaces.RealInput T_cold_internal "Internal connector for optional configuration";
  Modelica.Units.SI.Temperature T[nc](start=fill(T_sp, nc));
  Modelica.Units.SI.Power puis[nc](start=fill(0, nc));
  Modelica.Units.SI.Power perte[nc](start=fill(0, nc));
  Modelica.Units.SI.Energy Conso;
  Modelica.Units.SI.MassFlowRate debit_reel
    "actual drawing flow at DHW temperature";
  Real pourcentage_eau_chaude;
  Real diametre=sqrt(4*Volume/(pi*Hauteur));
  Real dz=Hauteur/nc;
  //Integer ncInj=integer(hInj/dz)+1;
    //""Layer number of the power injection";
  Real dv=Volume/nc;
  Real pi=Modelica.Constants.pi;
  Real sint=pi*diametre*Hauteur+2*sbase;
  Real sbase=pi*diametre^2/4;
  Real rovcp= rho*dv*cp;
  Real MCp;
  Boolean HC[3]={heure>=0 and heure<=6,heure>=12 and heure<=14, heure>=16 and heure<=18};
  //Integer OnOff=if HC[1] or HC[2] then 1 else 0;
  //Integer Mu=1;
  Real OnOffPmax=OnOff*Pmax;
  Real cond=lambda*sbase/dz;
  Real Slat[2];
  Real conv[nc];
  parameter Real coef36=1/3.6e6;

public
  Modelica.Blocks.Interfaces.RealInput debit_mitige(start=0) "Mixer flow in kg/h"
                                                                     annotation (
      Placement(transformation(extent={{-120,-90},{-80,-50}}),
        iconTransformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Blocks.Interfaces.RealInput T_cold(start=0) if type_T_cold "Cold water temperature (K)"
                                                                     annotation (
      Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-30,-100}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
public
  Modelica.Blocks.Interfaces.RealOutput Pelec "Power" annotation (Placement(
        transformation(extent={{80,0},{100,20}}), iconTransformation(extent={{80,
            0},{100,20}})));
  Modelica.Blocks.Interfaces.RealOutput Perte "Tank losses"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,70}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-50})));
public
  Modelica.Blocks.Interfaces.RealInput T_int(start=293.15)
    "Ambient temperature (K)" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-80,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,110})));
public
  Modelica.Blocks.Interfaces.RealInput OnOff(start=1) "OnOff"           annotation (
      Placement(transformation(extent={{-120,30},{-80,70}}),
        iconTransformation(extent={{-100,50},{-80,70}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a T_solar
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Modelica.Blocks.Interfaces.RealOutput Cons "Consumption" annotation (
      Placement(transformation(extent={{80,-42},{100,-22}}), iconTransformation(
          extent={{80,24},{100,44}})));
  Modelica.Blocks.Interfaces.RealOutput T_out "Output water temperature (K)"    annotation (Placement(transformation(extent={{80,38},
            {100,58}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,90})));
equation

  connect(T_cold, T_cold_internal);
  if not type_T_cold then
    T_cold_internal= T_cold_fixed;
  end if;

  T_out=T[nc];

  pourcentage_eau_chaude =if mitigeur then (if noEvent(T_out > Tmit) then (Tmit -
    T_cold_internal)/(T_out - T_cold_internal) else 1) else 1;
  debit_reel = pourcentage_eau_chaude*debit_mitige;
  MCp = debit_reel*cp;

  delta_t=if debit_reel>0 then Hauteur/(debit_reel*coef36/sbase) else 0;
  when initial() then
    if nc==1 then
      Slat[1]=sint;
      Slat[2]=sint;
    else
      Slat[1]=pi*diametre*dz;
      Slat[2]=Slat[1]+sbase;
    end if;
  end when;

  when Hyst<>pre(Hyst) then
      nMA=pre(nMA)+1;
  end when;

// Regulation
  Hyst=if T[ncInj]<=T_sp-BP then 1 else (if T[ncInj]>= T_sp+BP then 0 else pre(Hyst));
  OnOffSol=if T[ncSol]<=T_sp-0.2 then 1 else (if T[ncSol+1]>= T_sp+BP then 0 else pre(OnOffSol));

// Distribution of powers transferred to the water per layer
  for i in 1:nc loop
    if i==ncInj then
      puis[i]=OnOffPmax*Hyst;
    elseif i==ncSol then
      puis[i]=OnOffSol*max(0, -T_solar.Q_flow);
    else
      puis[i]=0;
    end if;
  end for;

// Heat balance on the layer 1 after setting exchanges with the room (loss) and with upper and lower layers (conv)
  perte[1]=U*Slat[2]*(T[1] - T_int);
  if nc>=2 then
    conv[1]=(if T[1]>T[2] then ku else kd)*(T[2]-T[1]);
  else
    conv[1]=0;
  end if;
  rovcp*der(T[1]) = puis[1] - perte[1] + MCp*(T_cold_internal-T[1]) + conv[1] + (if nc==1 then 0 else cond*(T[2]-T[1]));

  if nc>1 then
// Heat balance on intermediate layers
  for i in 2:nc-1 loop
    perte[i]=U*Slat[1]*(T[i] - T_int);
    conv[i]=(if T[i]>T[i+1] then ku else kd)*(T[i+1]-T[i]);
    rovcp*der(T[i]) = puis[i] - perte[i] + MCp *(T[i-1]-T[i]) + conv[i]-conv[i-1] + cond*(T[i-1]+T[i+1]-2*T[i]);
  end for;

// Heat balance on the upper layer
  perte[nc]=U*Slat[2]*(T[nc] - T_int);
  conv[nc]=0;//*(if T[nc-1]>T[nc] then ku else kd)*(T[nc-1]-T[nc]);
  rovcp*der(T[nc]) = puis[nc] - perte[nc] + MCp*(T[nc-1]-T[nc]) + 0 - conv[nc-1] + cond*(T[nc-1]-T[nc]);

  end if;

// Heat transfer fluid of the solar sensor exits the tank with the temperature of the layer ncSol
  T_solar.T = T[ncSol];

// Analysis data
  Perte=sum(perte);
  Pelec = puis[ncInj];
  der(Conso)=Pelec;
  Cons = Conso;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-50,100},{50,-100}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-50,100},{50,20}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-50,20},{50,20}},
          color={255,85,85},
          smooth=Smooth.None)}),         Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-60,80},{0,-80}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-60,80},{0,20}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-60,20},{0,20}},
          color={255,85,85},
          thickness=0.5,
          smooth=Smooth.None)}),
    Documentation(revisions="<html>
<p>Hubert Blervaque 06/2012 : Suppresion des variables propres au modèle de ballon thermodynamique modélisé initialement <code>ECS_Thermo_M324</code> par Hassan Bouia. Variables devenues dimensionnelles.</p>
<p>Hubert Blervaque 07/2012 : Correction du signe de la chaleur solaire récupérée et rajout du connecteur donnant la consommation.</p>
<p>Hubert Blervaque 09/2012 : Correction <code>dv</code> et <code>diametre</code> où le volume était divisé par erreur par 1000.</p>
<p>Benoît Charrier 01/2018 : Added <code>T_out</code> (output water temperature). Added choice between prescribed or fixed for the cold water temperature.</p>
</html>",
        info="<html>
<p>Electric hot water tank allowing a connection with a solar thermal collector.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows solar heat gains (from thermal collector) to be injected in the low part of the water tank.</p>
<p>The tank is modelled considering horizontal layers discretization. It is possible to indicate in which layer the solar heat gains from the thermal collector are injected.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Take care to respect the units of inputs such as the drawing scenario rate in kg/h.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque, Hassan Bouia 06/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Hubert BLERVAQUE, Hassan BOUIA, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end WaterTank;
