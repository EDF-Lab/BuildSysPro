﻿within BuildSysPro.BaseClasses.HeatTransfer.Components;
model HomogeneousConduction "1-D thermal conduction for homogeneous medium"

  parameter Integer n=1 "Number of states";
  parameter Modelica.Units.SI.Area S=1 "Surface of the element";
  parameter BuildSysPro.Utilities.Records.GenericSolid mat
    "material of the element"
    annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Length e=0.2
    "Thickness of the element (in the direction of the T gradient)";

  parameter BuildSysPro.Utilities.Types.InitCond InitType=BuildSysPro.Utilities.Types.InitCond.SteadyState;

  final parameter Modelica.Units.SI.Density rho=mat.rho;
  final parameter Modelica.Units.SI.SpecificHeatCapacity Cp=mat.c;
  final parameter Modelica.Units.SI.ThermalConductivity lambda=mat.lambda;
final parameter Real[2*n] r1=(fill(1, 2*n)*S*lambda*2*n)/e;
final parameter Real[n] r2=(rho*Cp*e*S)/n*fill(1, n);

public
  BuildSysPro.BaseClasses.HeatTransfer.Components.ThermalConductor[2*n] Ri(G=r1);
  BuildSysPro.BaseClasses.HeatTransfer.Components.HeatCapacitor[n] Ci(C=r2);

public
  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_a port_a annotation (
     Placement(transformation(extent={{-100,-8},{-80,12}}, rotation=0)));

  BuildSysPro.BaseClasses.HeatTransfer.Interfaces.HeatPort_b port_b annotation (
     Placement(transformation(extent={{80,-10},{100,10}}, rotation=0)));

initial equation
  if InitType == BuildSysPro.Utilities.Types.InitCond.SteadyState then

  for i in 1:n loop
der(Ci[i].port.T)=0;
end for;

end if;

equation
  for i in 1:(2*n - 1) loop
    connect(Ri[i].port_b,Ri[i + 1].port_a);
  end for;
  for i in 1:n loop
    connect(Ci[i].port,Ri[2*i-1].port_b);
  end for;
  connect(Ri[1].port_a,port_a);
   connect(Ri[2*n].port_b,port_b);
  annotation (Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(extent={{-80,60},{80,-60}},
            lineColor={0,0,0})}),
      DymolaStoredErrors,
    Diagram(graphics),
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
<p>Validated model - Emmanuel Amy de la Bretèque 06/2010</p>
<p><b>--------------------------------------------------------------<br>
Licensed by EDF under a 3-clause BSD-license<br>
Copyright &copy; EDF2009 - 2024<br>
BuildSysPro version 3.7.0<br>
Author : Emmanuel AMY DE LA BRETEQUE, EDF (2010)<br>
--------------------------------------------------------------</b></p>
</html>",
  revisions="<html>
<p>Gilles Plessis 03/2011 - Ajout d'une liste déroulante pour le choix des matériaux via l'annotation annotation(choicesAllMatching=true)</p>
</html>"));
end HomogeneousConduction;
