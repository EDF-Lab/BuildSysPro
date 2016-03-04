within BuildSysPro.Systems.DHW;
model WaterTank

  //import SI=Modelica.SIunits;

  parameter Integer nc=10 "Number of layers of the tank" annotation (Dialog(tab="Tank parameters"));
  parameter Integer ncInj=9 "Layer number of the electric power injection" annotation (Dialog(tab="Tank parameters"));
  parameter Integer ncSol=2 "Layer number of the solar power injection"
                                                                     annotation (Dialog(tab="Tank parameters"));

  parameter Modelica.SIunits.Volume Volume(displayUnit="l")=0.3 "Tank capacity"
                                                                                 annotation (Dialog(group="Thermodynamic tank characteristics"));
  parameter Modelica.SIunits.Length Hauteur=1.8 "Tank height"  annotation (Dialog(group="Caractéristiques du ballon thermodynamique"));
  parameter Modelica.SIunits.Power Pmax=1500 "Electrical resistance power"   annotation (Dialog(group="Thermodynamic tank characteristics"));
  parameter Modelica.SIunits.Temperature Tef=283.15 "Cold water temperature"     annotation (Dialog(group="Thermodynamic tank characteristics"));
  parameter Modelica.SIunits.Temperature Tcons=337.15 "Setpoint temperature"  annotation (Dialog(group="Thermodynamic tank characteristics"));

  parameter Modelica.SIunits.TemperatureDifference BP=3
    "Hysteresis on both sides of Tcons"                                                     annotation (Dialog(tab="Tank parameters"));

  parameter Modelica.SIunits.ThermalConductivity lambda=0.62
    "Water conductivity"                                                          annotation (Dialog(tab="Tank parameters"));
  parameter Modelica.SIunits.Density rho=1000 "Water density" annotation (Dialog(tab="Tank parameters"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp=4185
    "Water specific heat capacity"                                                       annotation (Dialog(tab="Tank parameters"));
  parameter Modelica.SIunits.SurfaceCoefficientOfHeatTransfer U=1
    "Transmission coefficient of the tank"                                                               annotation (Dialog(tab="Tank parameters"));
  parameter Real ku=1.5e6 "Higher convection coefficient" annotation (Dialog(tab="Tank parameters"));
  parameter Real kd=10 "Higher convection coefficient" annotation (Dialog(tab="Tank parameters"));

  discrete Integer Hyst(start=1);

  Real delta_t;
  Integer nMA(start=0);
  discrete Integer OnOffSol(start=1);
  Real heure=mod(time/3600,24);

protected
  Modelica.SIunits.Temperature T[nc](start=fill(Tcons,nc));
  Modelica.SIunits.Power puis[nc](start=fill(0,nc));
  Modelica.SIunits.Power perte[nc](start=fill(0,nc));
   Modelica.SIunits.Energy Conso;
  Real diametre=sqrt(4*Volume/(pi*Hauteur));
  Real dz=Hauteur/nc;
  //Integer ncInj=integer(hInj/dz)+1;
    //""Layer number of the power injection";
  Real dv=Volume/nc;
  Real pi=Modelica.Constants.pi;
  Real sint=pi*diametre*Hauteur+2*sbase;
  Real sbase=pi*diametre^2/4;
  Real rovcp= rho*dv*cp;
  Real MCp=debit/3600*cp;
  Boolean HC[3]={heure>=0 and heure<=6,heure>=12 and heure<=14, heure>=16 and heure<=18};
  //Integer OnOff=if HC[1] or HC[2] then 1 else 0;
  //Integer Mu=1;
  Real OnOffPmax=OnOff*Pmax;
  Real cond=lambda*sbase/dz;
  Real Slat[2];
  Real conv[nc];
  parameter Real coef36=1/3.6e6;

public
  Modelica.Blocks.Interfaces.RealInput debit(start=0) "Drawing rate in kg/h"
                                                                     annotation (
      Placement(transformation(extent={{-120,-90},{-80,-50}}),
        iconTransformation(extent={{-100,-70},{-80,-50}})));
public
  Modelica.Blocks.Interfaces.RealOutput P "Power"
    annotation (Placement(transformation(extent={{80,0},{100,20}}),
        iconTransformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Interfaces.RealOutput Perte "Tank losses"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,70}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-50})));
public
  Modelica.Blocks.Interfaces.RealInput Tamb(start=293.15)
    "Ambient temperature (K)"                                          annotation (
      Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-30,100}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,110})));
public
  Modelica.Blocks.Interfaces.RealInput OnOff(start=1) "OnOff"           annotation (
      Placement(transformation(extent={{-120,30},{-80,70}}),
        iconTransformation(extent={{-100,50},{-80,70}})));
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a SolaireThermique
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Modelica.Blocks.Interfaces.RealOutput C "Consumption"
    annotation (Placement(transformation(extent={{80,-42},{100,-22}}),
        iconTransformation(extent={{80,24},{100,44}})));
equation
  delta_t=if debit>0 then Hauteur/(debit*coef36/sbase) else 0;
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
  Hyst=if T[ncInj]<=Tcons-BP then 1 else (if T[ncInj]>= Tcons+BP then 0 else pre(Hyst));
  OnOffSol=if T[ncSol]<=Tcons-0.2 then 1 else (if T[ncSol+1]>= Tcons+BP then 0 else pre(OnOffSol));

// Distribution of powers transferred to the water per layer
  for i in 1:nc loop
    if i==ncInj then
      puis[i]=OnOffPmax*Hyst;
    elseif i==ncSol then
      puis[i]=OnOffSol*max(0,-SolaireThermique.Q_flow);
    else
      puis[i]=0;
    end if;
  end for;

// Heat balance on the layer 1 after setting exchanges with the room (loss) and with upper and lower layers (conv)
  perte[1]=U*Slat[2]*(T[1]-Tamb);
  if nc>=2 then
    conv[1]=(if T[1]>T[2] then ku else kd)*(T[2]-T[1]);
  else
    conv[1]=0;
  end if;
  rovcp*der(T[1]) = puis[1] - perte[1] + MCp*(Tef-T[1]) + conv[1] + (if nc==1 then 0 else cond*(T[2]-T[1]));

  if nc>1 then
// Heat balance on intermediate layers
  for i in 2:nc-1 loop
    perte[i]=U*Slat[1]*(T[i]-Tamb);
    conv[i]=(if T[i]>T[i+1] then ku else kd)*(T[i+1]-T[i]);
    rovcp*der(T[i]) = puis[i] - perte[i] + MCp *(T[i-1]-T[i]) + conv[i]-conv[i-1] + cond*(T[i-1]+T[i+1]-2*T[i]);
  end for;

// Heat balance on the upper layer
  perte[nc]=U*Slat[2]*(T[nc]-Tamb);
  conv[nc]=0;//*(if T[nc-1]>T[nc] then ku else kd)*(T[nc-1]-T[nc]);
  rovcp*der(T[nc]) = puis[nc] - perte[nc] + MCp*(T[nc-1]-T[nc]) + 0 - conv[nc-1] + cond*(T[nc-1]-T[nc]);

  end if;

// Heat transfer fluid of the solar sensor exits the tank with the temperature of the layer ncSol
  SolaireThermique.T=T[ncSol];

// Analysis data
  Perte=sum(perte);
  P=puis[ncInj];
  der(Conso)=P;
  C = Conso;
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
<p>Hubert Blervaque - 06/2012 :</p>
<p><ul>
<li>Suppresion des variables propres au modèle de ballon thermodynamique modélisé initialement &QUOT;ECS_Thermo_M324&QUOT; par Hassan Bouia</li>
<li>Variables devenues dimensionnelles</li>
<li>MAJ de la documentation BuildSysPro</li>
</ul></p>
<p><br>Sila Filfli - 07/2012 : correction du signe de la chaleur solaire récupérée et rajout du connecteur donnant la consommation</p>
<p>Sila Filfli - 09/2012 : correction dv et diametre où le Volume était divisé par erreur par 1000</p>
</html>",
        info="<html>
<p>Electric hot water tank allowing a connection with a solar sensor.</p>
<p><u><b>Hypothesis and equations</b></u></p>
<p>This model allows a solar gain in the low floors of the thermodynamic tank.</p>
<p>The tank is modelled by a superimposed horizontal layers discretization. It is possible to indicate in which layer the thermal power from a solar sensor is injected.</p>
<p><u><b>Bibliography</b></u></p>
<p>none</p>
<p><u><b>Instructions for use</b></u></p>
<p>none</p>
<p><u><b>Known limits / Use precautions</b></u></p>
<p>Take care to respect the units of inputs such as the drawing scenario rate in kg/h.</p>
<p><u><b>Validations</b></u></p>
<p>Validated model - Hubert Blervaque, Hassan Bouia 06/2011</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under the Modelica License 2<br>
Copyright &copy; EDF 2009 - 2016<br>
BuildSysPro version 2015.12<br>
Author : Hubert BLERVAQUE, Hassan BOUIA, EDF (2011)<br>
--------------------------------------------------------------</b></p>
</html>"));
end WaterTank;
