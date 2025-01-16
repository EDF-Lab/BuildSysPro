within BuildSysPro.Systems.Solar.Thermal.SolarWall;
model ParallelTubesActiveSolarWall
  "a tube height in the solar active wall"
  parameter Modelica.Units.NonSI.Temperature_degC Tstart=25;
  parameter Integer n=10 "number of meshes according to the direction of the tube";

  parameter Modelica.Units.SI.Area Stot=9 "solar collection surface";
  parameter Modelica.Units.SI.MassFlowRate q=Stot*30/3600
    "total mass flow";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=3200
    "specific heat of the coolant";

parameter Integer n_isol_f=5 "number of front face meshes";
parameter Integer n_stock=5 "number of stock meshes";
parameter Integer n_isol_b=3 "number of back side meshes";
  parameter Modelica.Units.SI.Length e_isol_f=0.16
    "front face insulation thickness";
  parameter Modelica.Units.SI.Length e_isol_b=0.03
     "back face insulation thickness";
  parameter Modelica.Units.SI.Length e_stock=0.2 "stock thickness";

  Modelica.Units.SI.Temperature T[n]
    "vector of fluid temperatures on the capture surface side";
  Modelica.Units.SI.Temperature Tem[n]
    "vector of fluid temepratures on the emission side";

protected
ElementXAxis[n] Tubes(
    S=Stot/n*fill(1, n),
    Tstart=Tstart*fill(1, n),
    n_isol_f=n_isol_f*fill(1, n),
    n_isol_b=n_isol_b*fill(1, n),
    n_stock=n_stock*fill(1, n),
    e_isol_f=e_isol_f*fill(1, n),
    e_isol_b=e_isol_b*fill(1, n),
    e_stock=e_stock*fill(1, n));

public
  Modelica.Blocks.Interfaces.RealInput G annotation (Placement(
        transformation(extent={{-108,50},{-68,90}}),
        iconTransformation(extent={{-108,50},{-82,76}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_a Tf "front panel temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  BaseClasses.HeatTransfer.Interfaces.HeatPort_b Tb
    "back panel temperature"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Interfaces.BooleanInput ON annotation (Placement(
        transformation(extent={{-106,-60},{-68,-22}})));

equation
  // connection dof the pipe sections to each other via the flow rates;

for i in 1:n loop
T[i] = Tubes[i].Tfluide.T;
Tem[i] = Tubes[i].Temetteur.T;
end for;

Tubes[1].debit_s = if ON then q*cp*(Tubes[1].Temetteur.T-Tubes[1].Tfluide.T) else 0;
for i in 2:n loop
Tubes[i].debit_s = if ON then q*cp*(Tubes[i-1].Tfluide.T-Tubes[i].Tfluide.T) else 0;
end for;

for i in 1:n-1 loop
Tubes[1].debit_e = if ON then q*cp*(Tubes[i+1].Temetteur.T-Tubes[i].Temetteur.T) else 0;
end for;

Tubes[n].debit_e = if ON then q*cp*(Tubes[n].Tfluide.T-Tubes[n].Temetteur.T) else 0;

for i in 1:n loop
 Tubes[i].G = G*Stot/n;
 connect(Tubes[i].Tf,Tf);
connect(Tubes[i].Tb,Tb);
end for;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics), Icon(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(extent={{-80,100},{-20,-100}}, lineColor={215,215,
              215}),
        Rectangle(extent={{-80,100},{-20,-100}}, lineColor={170,213,
              255}),
        Rectangle(
          extent={{-20,100},{0,-100}},
          lineColor={170,213,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,100},{0,-100}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,100},{80,-100}},
          lineColor={255,255,170},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid)}),
    DymolaStoredErrors,
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
<p>none</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright © EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Emmanuel AMY DE LA BRETEQUE, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>"));
end ParallelTubesActiveSolarWall;
