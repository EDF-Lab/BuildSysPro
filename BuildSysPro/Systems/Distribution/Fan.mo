within BuildSysPro.Systems.Distribution;
model Fan

// INPUT VARIABLES :

// Input

  parameter Real  TypeFan= 1 "Fan configurations: 
1.Fan with tilt and 1 speed motor
2.Fan with tilt and 2 speed motor 
3.Speed variation with a frequency converter 
4.Characteristic identified on a manufacturer curve";

//Parameters

//  Weighting coefficients //RatioQ= C1*RatioDV^2+C2*RatioDV+C3"

  parameter Real C1=0                                                                                    annotation (Dialog(group="Coefficients de la caractéristique identifiée, égaux à zéro dans le cas de l'utilisation d'une courbe par défaut"));

  parameter Real C2=0                                                                                     annotation (Dialog(group="Coefficients de la caractéristique identifiée, égaux à zéro dans le cas de l'utilisation d'une courbe par défaut"));

  parameter Real C3=0                                                                                  annotation (Dialog(group="Coefficients de la caractéristique identifiée, égaux à zéro dans le cas de l'utilisation d'une courbe par défaut"));

// Nominal characteristics

  parameter Modelica.Units.SI.VolumeFlowRate DVanom=0.0063
    "Air volume flow at nominal point           "
    annotation (Dialog(group="Caractéristiques nominales"));

  parameter Modelica.Units.SI.Power Qfannom=1119 "Actual electrical power consumed by the fan
at nominal point (losses in the fan, transmission and motor included)"
    annotation (Dialog(group="Caractéristiques nominales"));

 // OUTPUT VARIABLES

 /* Modelica.Blocks.Interfaces.RealOutput Qfan "Puissance électrique réelle consommée par le ventilateur (pertes dans le ventilateur, transmission et moteur
incluses)";*/

protected
    Real RatioDV; //ratio of air flow to nominal flow (volume)  [%]
    Real RatioQ;//ratio of power to nominal power
    Real Flag; // airflow higher than the nominal airflow

public
  Modelica.Blocks.Interfaces.RealInput Te(start) "Inlet air temperature"
    annotation (Placement(transformation(extent={{-120,0},{-80,40}}),
        iconTransformation(extent={{-100,20},{-60,60}})));
public
  Modelica.Blocks.Interfaces.RealOutput Ts "Outlet temperature"
    annotation (Placement(transformation(extent={{70,-25},{104,9}}),
        iconTransformation(extent={{60,10},{100,50}})));
public
  Modelica.Blocks.Interfaces.RealOutput Qfan "Actual electric power consumed by the fan (losses in the fan, transmission and motor
included)"
    annotation (Placement(transformation(extent={{68,3},{102,37}}),
        iconTransformation(extent={{60,-34},{100,6}})));
public
  Modelica.Blocks.Interfaces.RealInput DVa(
                                          start)
    "Air volume flow [m3/h]"
    annotation (Placement(transformation(extent={{-120,-28},{-80,12}}),
        iconTransformation(extent={{-100,-36},{-60,4}})));
algorithm
//Determination of flow rate ratios

RatioDV :=(DVa/1000)/DVanom;

if (abs(RatioDV) < 0.000001) then
  RatioQ := 0;
elseif (RatioDV>1) then
  Flag :=1;
  RatioQ :=0;
end if;

if (TypeFan == 1.0) and (RatioDV<0.2) then
  // with tilter and 1-speed motor
  RatioQ :=0.5;
  //Calculated value for RatioDV = 0.2
elseif (TypeFan == 1.0) and (RatioDV>=0.2) then
  RatioQ:=0.875*RatioDV^2 - 0.425*RatioDV + 0.55;
end if;

if (TypeFan == 2) then
  //with tilter and 2-speed motor
  if (RatioDV<0.18) then
    RatioQ :=0.257;
    //Calculated value for RatioDV = 0.18
  elseif (RatioDV <0.75) then
    RatioQ :=0.5*RatioDV^2 - 0.1*RatioDV + 0.2583;
  else
    RatioQ :=0.875*RatioDV^2 - 0.425*RatioDV + 0.55;
  end if;
end if;

if (TypeFan == 3) and (RatioDV<0.4) then
  //with variable speed by frequency converter
  RatioQ :=0.250;
  //Calculated value for RatioDV = 0.40
elseif (TypeFan == 3) and (RatioDV<=0.4) then
  RatioQ :=2.0556*RatioDV^2 - 1.6278*RatioDV + 0.5722;
end if;

if (TypeFan == 4) then
  //characteristic identified on the manufacturer curve
  RatioQ :=C1*RatioDV^2 + C2*RatioDV + C3;
end if;

Qfan :=RatioQ*Qfannom;
Ts:=Te;

annotation (Placement(transformation(extent={{20,-4},{60,36}}),
        iconTransformation(extent={{-100,-10},{-60,30}})),
              Documentation(info="<html>
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
Copyright &copy; EDF 2009 - 2021<br>
BuildSysPro version 3.5.0<br>
Author : Sila FILFLI, EDF (2011)<br>
--------------------------------------------------------------</b></p></html>"), Icon(graphics={
        Rectangle(
          extent={{-60,60},{60,-40}},
          lineColor={0,0,255},
          fillColor={170,255,170},
          fillPattern=FillPattern.Solid),
                          Ellipse(extent={{10,10},{-10,-40}},lineColor={255,255,
              0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,0}),
                          Ellipse(extent={{10,60},{-10,10}}, lineColor={255,255,
              0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,0})}),
    Diagram(graphics));
end Fan;
